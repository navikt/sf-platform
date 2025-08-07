@IsTest
private class OauthCodeFlowServiceTest {
    @TestSetup
    static void makeData() {
        BaseTestFactory.insertEncryptionKey();
    }

    @IsTest
    private static void shouldGeAuthorizationUrl() {
        //Arrange
        //define custom settings
        AzureAdAuthorizationCode__c azureAdConfig = new AzureAdAuthorizationCode__c();
        azureAdConfig.AuthorizeUrl__c = 'https://auth.url';
        azureAdConfig.RedirectUrl__c = 'https://redirect.url';
        azureAdConfig.ConsumerKey__c = 'testKey';
        azureAdConfig.Scope__c = 'offline_access%20user.read';
        insert azureAdConfig;

        String expectedUrl =
            'https://auth.url?client_id=testKey&response_type=code&redirect_uri=https://redirect.url&response_mode=query' +
            '&scope=offline_access%20user.read&state=testState';

        //Acct
        System.Test.startTest();
        String actualUrl = new OauthCodeFlowService()
            .generateAuthorizationUrl('testState');

        //Assert
        System.Test.stopTest();
        Assert.areEqual(expectedUrl, actualUrl);
    }

    @IsTest
    private static void shouldGetAccessAndRefreshTokens() {
        //Arrqnge
        Test.setMock(
            HttpCalloutMock.class,
            new AzureAdMockHttpResponseGenerator()
        );

        //Act
        Test.startTest();
        Map<String, String> tokenByType = new OauthCodeFlowService()
            .getTokensFromAuthorizationCode('code');
        Test.stopTest();

        //Assert
        Assert.areEqual(2, tokenByType.size());
        Assert.areEqual('testToken', tokenByType.get('access'));
        Assert.areEqual('refreshToken', tokenByType.get('refresh'));
    }
}
