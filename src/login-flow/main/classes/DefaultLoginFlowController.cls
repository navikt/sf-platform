/**
 * @description
 * Controller for handling the custom login flow, integrating Azure AD and Microsoft Graph authentication.
 * Manages state, cookies, token exchange, user group synchronization, and error handling.
 * Designed for use with the DefaultLoginFlow Visualforce page.
 */
public without sharing class DefaultLoginFlowController {
    /**
     * @description Cookie storing the return URL for post-login redirection.
     */
    private Cookie retUrlCookie;
    /**
     * @description Cookie storing the login flow state for CSRF protection.
     */
    private Cookie stateCookie;
    /**
     * @description Cookie tracking login flow retries.
     */
    private Cookie retryCookie;
    /**
     * @description Return URL for post-login redirection.
     */
    private String retUrl;
    /**
     * @description Logger utility for error and event publishing.
     */
    private LoggerUtility logger = new LoggerUtility(
        CRM_ApplicationDomain.Domain.PLATFORCE,
        'LoginFlow'
    );
    /**
     * @description Repository for user data and access checks.
     */
    UserRepository userRepository = new UserRepository();
    /**
     * @description Domain object representing the current user.
     */
    UserDomain currentUser = UserRepository.fetchCurrentUser();
    /**
     * @description Service for handling OAuth authorization code flow.
     */
    OauthCodeFlowService oauthCodeFlowService = new OauthCodeFlowService();
    /**
     * @description Service for saving refresh tokens.
     */
    RefreshTokenService refreshTokenService = new RefreshTokenService();
    /**
     * @description Stores the refresh token for the current session.
     */
    private String refreshToken;

    /**
     * @description
     * Main entry point for the login flow. Handles authentication, token exchange, group sync, and redirects.
     * @return PageReference for the next step in the login flow.
     */
    // prettier-ignore
    public PageReference redirect() { // NOPMD - Cylomatic complexity is acceptable here due to the nature of the login flow
        try {
            Boolean isMobile = UserInfo.getUiThemeDisplayed() == 'Theme4t';
            if (isMobile) {
                return Auth.SessionManagement.finishLoginFlow();
            }

            String stateParam = apexpages.currentPage()
                .getParameters()
                .get('state');
            String codeParam = apexpages.currentPage()
                .getParameters()
                .get('code');

            String state = stateParam != null
                ? EncodingUtil.urlEncode(stateParam, 'UTF-8')
                : null;
            String code = codeParam != null
                ? EncodingUtil.urlEncode(codeParam, 'UTF-8')
                : null;

            // refresh with added state if there is none
            if (code == null || state == null) {
                return initiateAuthCodeFlow();
            }

            if (!verifyState(state)) {
                //If the state in the query parameter does not match the state stored in the cookie, retry the login flow
                retryCookie = ApexPages.currentPage().getCookies().get('retry');
                if (retryCookie != null && retryCookie.getValue() == '0') {
                    return initiateAuthCodeFlow();
                }
                //Only allow one retry
                logger.errorAndPublish('States do not match');
                return Auth.SessionManagement.finishLoginFlow();
            }

            String accessTokenForSalesforceAzureApp = getAccessTokenForSalesforceAzureApp(
                code
            );

            if (accessTokenForSalesforceAzureApp == null) {
                return Auth.SessionManagement.finishLoginFlow();
            }

            String accessTokenForMicrosoftGraph = getAccessTokenForMicrosoftGraph(
                accessTokenForSalesforceAzureApp
            );

            MicrosoftGraphService.MicrosoftGraphResponse microsoftGraphResponse = checkMicrosoftGraphAccess(
                accessTokenForMicrosoftGraph
            );

            if (MicrosoftGraphResponse == null) {
                return Auth.SessionManagement.finishLoginFlow();
            }

            UserRepository.checkAccessToFortroligAndSkjermetByAdGroups(
                currentUser,
                microsoftGraphResponse.groupIds
            );

            System.enqueueJob(
                new AdGroupSyncQueueable(
                    microsoftGraphResponse.groupIds,
                    currentUser
                )
            );
            refreshTokenService.saveRefreshToken(refreshToken);

            if (String.isNotBlank(currentUser.navId)) {
                System.enqueueJob(new AvvikAccess(currentUser.navId));
            }

            //finnish login flow
            retUrlCookie = ApexPages.currentPage().getCookies().get('retUrl');
            retUrl = retUrlCookie.getValue();

            if (retUrl != null) {
                return Auth.SessionManagement.finishLoginFlow(retUrl);
            }
            logger.warningAndPublish(
                'Cookie with return-URL found, but value is null'
            );
            return Auth.SessionManagement.finishLoginFlow();
        } catch (Exception e) {
            logger.errorAndPublish(e.getMessage());
            return Auth.SessionManagement.finishLoginFlow();
        }
    }
    /**
     * @description
     * Initiates a new OAuth authorization code flow, sets cookies, and redirects to the authorization URL.
     * @return PageReference for the authorization URL.
     */
    private PageReference initiateAuthCodeFlow() {
        String state = StringUtil.generateRandomString(500);
        stateCookie = new Cookie('state', state, null, 180, true);
        String retUrlParam = ApexPages.currentPage()
            .getParameters()
            .get('retURL');
        retUrl = retUrlParam != null
            ? EncodingUtil.urlEncode(retUrlParam, 'UTF-8')
            : null;
        retUrlCookie = new Cookie('retUrl', retURL, null, 180, true);

        retryCookie = ApexPages.currentPage().getCookies().get('retry');

        Integer numberOfRetries = 0;
        if (retryCookie != null) {
            //we only allow one retry
            numberOfRetries = 1;
        }
        retryCookie = new Cookie(
            'retry',
            numberOfRetries.toString(),
            null,
            30,
            true
        );

        ApexPages.currentPage()
            .setCookies(
                new List<Cookie>{ stateCookie, retUrlCookie, retryCookie }
            );
        String initiateUrl = oauthCodeFlowService.generateAuthorizationUrl(
            state
        );

        pageReference pg = new pageReference(initiateUrl); // NOPMD - Fetching and redirecting to the authorization URL is the intended behavior here
        return pg.setRedirect(true);
    }

    /**
     * @description
     * Exchanges the authorization code for access and refresh tokens.
     * @param code The authorization code received from Azure AD.
     * @return The access token for Salesforce Azure App, or null if unsuccessful.
     */
    private String getAccessTokenForSalesforceAzureApp(String code) {
        Map<String, String> tokenByType = oauthCodeFlowService.getTokensFromAuthorizationCode(
            code
        );
        // "access", "refresh"
        if (tokenByType.size() != 2) {
            logger.warningAndPublish(
                'Failed to fetch access and refresh token'
            );
            return null;
        }
        refreshToken = tokenByType.get('refresh');
        return tokenByType.get('access');
    }

    /**
     * @description
     * Exchanges the Salesforce access token for a Microsoft Graph access token.
     * @param accessTokenForSalesforceApp The access token for Salesforce Azure App.
     * @return The access token for Microsoft Graph.
     */
    private String getAccessTokenForMicrosoftGraph(
        String accessTokenForSalesforceApp
    ) {
        String service = 'MicrosoftGraph';

        return AzureAccessTokenService.getTokenForOtherService(
            accessTokenForSalesforceApp,
            service
        );
    }

    /**
     * @description
     * Checks Microsoft Graph access and parses group membership response.
     * @param accessTokenForMicrosoftGraph The access token for Microsoft Graph.
     * @return MicrosoftGraphResponse containing group IDs and status.
     */
    private MicrosoftGraphService.MicrosoftGraphResponse checkMicrosoftGraphAccess(
        String accessTokenForMicrosoftGraph
    ) {
        MicrosoftGraphService.MicrosoftGraphResponse microsoftGraphResponse = new MicrosoftGraphService()
            .getMyMemberGroups(accessTokenForMicrosoftGraph);

        if (!microsoftGraphResponse.success) {
            logger.warningAndPublish('Unsuccessful microsoft graph response');
            return null;
        }
        return microsoftGraphResponse;
    }

    /**
     * @description
     * Verifies that the state parameter matches the value stored in the cookie.
     * @param stateFromUrl The state value from the URL parameter.
     * @return True if the state matches, false otherwise.
     */
    private Boolean verifyState(String stateFromUrl) {
        stateCookie = ApexPages.currentPage().getCookies().get('state');

        String stateFromCookie = stateCookie.getValue();
        if (stateFromUrl == stateFromCookie) {
            return true;
        }
        return false;
    }
}
