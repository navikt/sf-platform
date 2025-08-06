@IsTest
private class DefaultLoginFlowControllerTest {
    @TestSetup
    private static void makeData() {
        AzureAdAuthorizationCode__c setting = new AzureAdAuthorizationCode__c();
        setting.Name = 'Test';
        setting.AuthorizeUrl__c = 'https://test.com/auth';
        setting.ConsumerKey__c = 'abc';
        setting.RedirectUrl__c = 'https://test.com/default';
        setting.Scope__c = 'default';
        insert setting;

        BaseTestFactory.insertEncryptionKey();
    }

    @IsTest
    private static void shouldGenerateAuthorizationCodeUrl() {
        Test.startTest();
        DefaultLoginFlowController controller = new DefaultLoginFlowController();
        String nextPage = controller.redirect().getUrl();
        Test.stopTest();

        String expectedUrl = 'https://test.com/auth?client_id=abc&redirect_uri=https%3A%2F%2Ftest.com%2Fdefault&response_mode=query&response_type=code&scope=default&state=';

        Assert.isTrue(
            nextPage.startsWith(expectedUrl),
            'The return URL is expected to be the same as the expected URL, except that the state is different'
        );
        Assert.isTrue(
            nextPage.length() > expectedUrl.length(),
            'The state is expected to have a value in the actual URL'
        );
    }

    @IsTest
    private static void shouldGetAccessToken() {
        Test.setMock(
            HttpCalloutMock.class,
            new AzureAdMockHttpResponseGenerator()
        );
        String body = '{"@odata.context": "https://graph.microsoft.com/v1.0/$metadata#Collection(Edm.String)","value": ["dec3ee50-b683-4644-9507-520e8f054ac2","fb8ffc82-b404-4dd4-86d2-94c2a97ed229","928636f4-fd0d-4149-978e-a6fb68bb19de","1b961619-2a3c-45d6-8ca1-0ae12b3c935f"]}';
        SingleRequestMock httpMock = new SingleRequestMock(
            200,
            'Success',
            body,
            null
        );

        Pagereference pageRef = Page.DefaultLoginFlow;

        //set cookies
        Cookie retUrlCookie = new Cookie(
            'retUrl',
            'https://test.com',
            null,
            -1,
            true
        );
        Cookie stateCookie = new Cookie('state', 'state', null, -1, true);
        pageRef.setCookies(new List<Cookie>{ stateCookie, retUrlCookie });

        Test.setMock(
            HttpCalloutMock.class,
            new AzureAdMockHttpResponseGenerator()
        );

        Test.startTest();
        test.setCurrentPage(pageRef);
        pageRef.getParameters().put('code', 'abc');
        pageRef.getParameters().put('state', 'state');
        DefaultLoginFlowController controller = new DefaultLoginFlowController();
        String nextPage = controller.redirect().getUrl();
        Test.stopTest();

        String expectedUrl = 'https://test.com';
        System.assertEquals(
            expectedUrl,
            nextPage,
            'Expected redirect url to be getched in the retUrl cookie'
        );
    }

    @IsTest
    private static void shouldInitiateNewAuthorizationCodeUrlWhenStatesAreInvalid() {
        Pagereference pageRef = Page.DefaultLoginFlow;
        //set cookies
        Cookie retUrlCookie = new Cookie(
            'retUrl',
            'https://test.com',
            null,
            -1,
            true
        );
        Cookie stateCookie = new Cookie('state', 'state', null, -1, true);
        Cookie retryCookie = new Cookie('retry', '0', null, -1, true);
        pageRef.setCookies(
            new List<Cookie>{ stateCookie, retUrlCookie, retryCookie }
        );

        Test.startTest();
        test.setCurrentPage(pageRef);
        pageRef.getParameters().put('code', 'abc');
        pageRef.getParameters().put('state', 'invalidState');
        DefaultLoginFlowController controller = new DefaultLoginFlowController();
        String nextPage = controller.redirect().getUrl();
        Test.stopTest();

        String expectedUrl = 'https://test.com/auth?client_id=abc&redirect_uri=https%3A%2F%2Ftest.com%2Fdefault&response_mode=query&response_type=code&scope=default&state=';

        Assert.isTrue(
            nextPage.startsWith(expectedUrl),
            'The return URL is expected to be the same as the expected URL, except that the state is different'
        );
        Assert.isTrue(
            nextPage.length() > expectedUrl.length(),
            'The state is expected to have a value in the actual URL'
        );
    }

    @IsTest
    private static void shouldExitLoginFlowWhenStateIsInvalidForSecondTime() {
        Pagereference pageRef = Page.DefaultLoginFlow;
        //set cookies
        Cookie retUrlCookie = new Cookie(
            'retUrl',
            'https://test.com',
            null,
            -1,
            true
        );
        Cookie stateCookie = new Cookie('state', 'state', null, -1, true);
        Cookie retryCookie = new Cookie('retry', '1', null, -1, true);
        pageRef.setCookies(
            new List<Cookie>{ stateCookie, retUrlCookie, retryCookie }
        );

        Test.startTest();
        test.setCurrentPage(pageRef);
        pageRef.getParameters().put('code', 'abc');
        pageRef.getParameters().put('state', 'invalidState');
        DefaultLoginFlowController controller = new DefaultLoginFlowController();
        String nextPage = controller.redirect().getUrl();
        Test.stopTest();

        Assert.areEqual('/', nextPage);
    }
}
