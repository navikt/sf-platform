public with sharing class SlackCalloutService {
    public void postMessage(
        String namedCredential,
        String slackHook,
        SlackMessage message
    ) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(getSlackHook(namedCredential, slackHook));
        request.setBody(JSON.serialize(message));

        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 200) {
            // Throw a custom exception if the Slack callout fails
            throw new SlackCalloutException(
                'Slack callout failed with status code: ' +
                    response.getStatusCode() +
                    ', body: ' +
                    response.getBody()
            );
        }
    }

    @TestVisible
    private String getSlackHook(String namedCredential, String slackHook) {
        if (String.isNotBlank(namedCredential)) {
            return 'callout:' + namedCredential;
        }
        return slackHook;
    }
}
