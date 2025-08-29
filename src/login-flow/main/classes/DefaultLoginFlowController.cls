public without sharing class DefaultLoginFlowController {
    private Cookie retUrlCookie;
    private Cookie stateCookie;
    private Cookie retryCookie;
    private String retUrl;
    private LoggerUtility logger = new LoggerUtility(
        CRM_ApplicationDomain.Domain.PLATFORCE,
        'LoginFlow'
    );
    UserRepository userRepository = new UserRepository();
    UserDomain currentUser = UserRepository.fetchCurrentUser();
    OauthCodeFlowService oauthCodeFlowService = new OauthCodeFlowService();
    RefreshTokenService refreshTokenService = new RefreshTokenService();
    private String refreshToken;

    public PageReference redirect() {
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

            String state = stateParam;
            String code = codeParam;

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

    private PageReference initiateAuthCodeFlow() {
        String state = StringUtil.generateRandomString(500);
        stateCookie = new Cookie('state', state, null, 180, true);
        String retUrlParam = ApexPages.currentPage()
            .getParameters()
            .get('retURL');
        retUrl = retUrlParam;
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

        pageReference pg = new pageReference(initiateUrl);
        return pg.setRedirect(true);
    }

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

    private String getAccessTokenForMicrosoftGraph(
        String accessTokenForSalesforceApp
    ) {
        String service = 'MicrosoftGraph';

        return AzureAccessTokenService.getTokenForOtherService(
            accessTokenForSalesforceApp,
            service
        );
    }

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

    private Boolean verifyState(String stateFromUrl) {
        stateCookie = ApexPages.currentPage().getCookies().get('state');

        String stateFromCookie = stateCookie.getValue();
        if (stateFromUrl == stateFromCookie) {
            return true;
        }
        return false;
    }
}
