@IsTest
private class SlackCalloutServiceTest {
    @IsTest
    static void shouldPostMessageSuccessfully() {
        Test.setMock(HttpCalloutMock.class, new SlackSuccessMock());
        SlackCalloutService service = new SlackCalloutService();
        SlackMessage msg = new SlackMessage('Hello!');
        Test.startTest();
        service.postMessage('NamedCred', null, msg);
        Test.stopTest();
        // No exception means success
    }

    @IsTest
    static void shouldThrowExceptionOnSlackFailure() {
        Test.setMock(HttpCalloutMock.class, new SlackFailureMock());
        SlackCalloutService service = new SlackCalloutService();
        SlackMessage msg = new SlackMessage('fail');
        Boolean thrown = false;
        Test.startTest();
        try {
            service.postMessage(
                null,
                'https://hooks.slack.com/services/abc',
                msg
            );
        } catch (Exception e) {
            thrown = true;
            System.assert(
                e.getMessage().contains('Slack callout failed'),
                'Should throw on failure'
            );
        }
        Test.stopTest();
        System.Assert.isTrue(thrown, 'Exception should be thrown');
    }

    @IsTest
    static void shouldUseNamedCredentialEndpoint() {
        SlackCalloutService service = new SlackCalloutService();
        String endpoint = service.getSlackHook('MyNamedCred', null);
        System.assertEquals('callout:MyNamedCred', endpoint);
    }

    @IsTest
    static void shouldUseDirectHookEndpoint() {
        SlackCalloutService service = new SlackCalloutService();
        String endpoint = service.getSlackHook(
            null,
            'https://hooks.slack.com/services/abc'
        );
        System.Assert.areEqual(
            'https://hooks.slack.com/services/abc',
            endpoint
        );
    }

    private class SlackSuccessMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('ok');
            return res;
        }
    }

    private class SlackFailureMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(400);
            res.setBody('error');
            return res;
        }
    }
}
