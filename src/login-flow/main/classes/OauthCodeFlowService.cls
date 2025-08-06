public with sharing class OauthCodeFlowService {
    private LoggerUtility logger = new LoggerUtility('OAuthCodeFlow');

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

    public Map<String, String> getTokensFromAuthorizationCode(
        String code
    ) {
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
