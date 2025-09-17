/**
 * @description
 * Service class for handling OAuth authorization code flow with Azure AD.
 * Generates authorization URLs and exchanges authorization codes for access and refresh tokens.
 * Integrates with AzureAdAuthorizationCode__c custom metadata for configuration.
 * Designed for use in login flows and authentication integrations.
 */
public with sharing class OauthCodeFlowService {
    /**
     * @description Logger utility for error and event publishing.
     */
    private LoggerUtility logger = new LoggerUtility('OAuthCodeFlow');

    /**
     * @description
     * Generates the Azure AD authorization URL for the OAuth code flow.
     * Uses configuration from AzureAdAuthorizationCode__c custom metadata.
     *
     * @param state The state parameter for CSRF protection.
     * @return The full authorization URL for Azure AD.
     */
    public String generateAuthorizationUrl(String state) {
        AzureAdAuthorizationCode__c azureAdConfig = AzureAdAuthorizationCode__c.getOrgDefaults();
        String baseUrl = azureAdConfig.AuthorizeUrl__c;
        String key = azureAdConfig.ConsumerKey__c;
        String redirectUrl = azureAdConfig.RedirectUrl__c;
        String scope = azureAdConfig.Scope__c;

        return baseUrl +
            '?client_id=' +
            key +
            '&response_type=code&redirect_uri=' +
            redirectUrl +
            '&response_mode=query&scope=' +
            scope +
            '&state=' +
            state;
    }

    /**
     * @description
     * Exchanges an authorization code for access and refresh tokens from Azure AD.
     * Sends a POST request to the Azure AD token endpoint using Named Credentials.
     * Parses the response and returns tokens in a map.
     *
     * @param code The authorization code received from Azure AD.
     * @return Map with keys 'access' and 'refresh' for the respective tokens.
     */
    public Map<String, String> getTokensFromAuthorizationCode(String code) {
        Map<String, String> tokenByType = new Map<String, String>();
        AzureAdAuthorizationCode__c azureAdConfig = AzureAdAuthorizationCode__c.getOrgDefaults();
        String scope = azureAdConfig.Scope__c;
        String redirectUrl = azureAdConfig.RedirectUrl__c;

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:AzureAd');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        req.setHeader('Accept', 'application/json');
        req.setBody(
            'grant_type=authorization_code&scope=' +
                scope +
                '&redirect_uri=' +
                redirectUrl +
                '&client_id={!$Credential.UserName}&client_secret={!$Credential.Password}&code=' +
                code
        );
        HttpResponse res = h.send(req);
        if (res.getStatusCode() == 200) {
            String accessToken = AzureAccessTokenService.getTokenValueFromResponse(
                res.getBody(),
                'access_token'
            );
            String refreshToken = AzureAccessTokenService.getTokenValueFromResponse(
                res.getBody(),
                'refresh_token'
            );
            tokenByType.put('access', accessToken);
            tokenByType.put('refresh', refreshToken);
        } else {
            logger.errorAndPublish(
                errorLogEntry(
                    res,
                    'Error from AzureAccessTokenService.getTokensFromAuthorizationCode'
                )
            );
        }
        return tokenByType;
    }

    /**
     * @description
     * Formats error details for logging when token exchange fails.
     *
     * @param resp The HttpResponse object from the failed request.
     * @param message Custom error message for context.
     * @return Formatted error log entry string.
     */
    private String errorLogEntry(HttpResponse resp, String message) {
        return message +
            '\n ' +
            'Status: ' +
            resp.getStatus() +
            '\n' +
            'User: ' +
            UserInfo.getUserId() +
            '\n' +
            'Body: ' +
            resp.getBody();
    }
}
