/**
 * @description
 * Service class for integrating with Microsoft Graph API to fetch group memberships for the active user.
 * Handles authentication, API requests, pagination, error handling, and response parsing.
 * @see https://learn.microsoft.com/en-us/graph/api/user-getmembergroups
 */
public with sharing class MicrosoftGraphService {
    /**
     * @description API Config name to set when using the ApiController.
     */
    public static final String API_CONFIG_NAME = 'Microsoft_Graph_API';

    /**
     * @description
     * Fetches group memberships for the active user from Microsoft Graph API.
     * Handles pagination and error responses.
     *
     * @param accessToken OAuth access token for Microsoft Graph API.
     * @return MicrosoftGraphResponse containing group IDs and status.
     */
    public MicrosoftGraphResponse getMyMemberGroups(String accessToken) {
        MicrosoftGraphResponse resp = new MicrosoftGraphResponse();

        ApiController apiCtrl = new ApiController();

        apiCtrl.initRequest(API_CONFIG_NAME, 'GET_MEMBER_GROUPS', null);

        apiCtrl.addHeader('Authorization', 'Bearer ' + accessToken);
        apiCtrl.addHeader('Content-Type', 'application/json');
        apiCtrl.addHeader('Accept', '*/*');
        apiCtrl.addUrlParam('$securityEnabled', 'true');
        apiCtrl.addUrlParam('$top', '100');
        apiCtrl.addUrlParam('$select', 'id');
        apiCtrl.doCallout();

        Integer statusCode = apiCtrl.getResponse().getStatusCode();
        String bodyString = apiCtrl.getResponse().getBody();
        bodyString = bodyString.replaceAll('\n', '\\\\r\\\\n');

        if (statusCode == 200) {
            resp.success = true;
            resp.parse(bodyString);

            if (resp.nextlink != null) {
                resp = getMoreGroupsWithUseOfSkipToken(apiCtrl, resp);
            }
        } else {
            resp = getErrors(statusCode, apiCtrl.getResponse(), resp);
        }

        return resp;
    }

    /**
     * @description
     * Handles pagination for group membership requests using skip tokens.
     *
     * @param apiCtrl Initialized ApiController for Microsoft Graph.
     * @param resp MicrosoftGraphResponse to update with additional group IDs.
     * @return Updated MicrosoftGraphResponse with all group IDs.
     */
    private MicrosoftGraphResponse getMoreGroupsWithUseOfSkipToken(
        ApiController apiCtrl,
        MicrosoftGraphResponse resp
    ) {
        for (Integer i = 0; i < 50; i++) {
            apiCtrl.setEndpoint(resp.nextlink);
            resp.nextlink = null; //Make sure we don't get the same nextlink again
            apiCtrl.doCallout();

            Integer statusCode = apiCtrl.getResponse().getStatusCode();
            String bodyString = apiCtrl.getResponse().getBody();
            bodyString = bodyString.replaceAll('\n', '\\\\r\\\\n');

            if (statusCode == 200) {
                resp.success = true;
                resp.parse(bodyString);
                if (resp.nextlink == null) {
                    break;
                }
            } else {
                resp = getErrors(statusCode, apiCtrl.getResponse(), resp);
            }
        }

        return resp;
    }

    /**
     * @description
     * Handles error responses from Microsoft Graph API and logs details.
     *
     * @param statusCode HTTP status code from API response.
     * @param responseFromApiCtrl HttpResponse object from ApiController.
     * @param resp MicrosoftGraphResponse to update with error message.
     * @return Updated MicrosoftGraphResponse with error details.
     */
    private MicrosoftGraphResponse getErrors(
        Integer statusCode,
        HttpResponse responseFromApiCtrl,
        MicrosoftGraphResponse resp
    ) {
        String errorRef = logError(
            responseFromApiCtrl,
            'Error from MicrosoftGraphService.getMyMemberGroups'
        );
        resp.errorMessage =
            'Kunne ikke hente gruppemedlemskap fra Microsoft Graph. Referanse til feil: ' +
            errorRef;

        if (statusCode == 404) {
            resp.errorMessage =
                'Kunne ikke finne endepunkt. Referanse til feil: ' + errorRef;
        } else if (statusCode == 500) {
            resp.errorMessage =
                'Noe gikk galt ved henting av gruppemedlemskap. Referanse til feil: ' +
                errorRef;
        }
        return resp;
    }

    /**
     * @description
     * Logs error details using LoggerUtility and returns a unique error reference.
     *
     * @param resp HttpResponse object containing error details.
     * @param message Custom error message for logging.
     * @return Unique error reference string for troubleshooting.
     */
    private String logError(HttpResponse resp, String message) {
        String errorRef = '';

        LoggerUtility logger = new LoggerUtility(
            CRM_ApplicationDomain.Domain.PLATFORCE,
            'MicrosoftGraph'
        );
        logger.error(
            message +
                '\n ' +
                'Status: ' +
                resp.getStatus() +
                '\n' +
                'Body: ' +
                resp.getBody(),
            null
        );
        errorRef = logger.peek().UUID__c; //Unique error reference for troubleshooting
        logger.publishSynch();

        return errorRef;
    }

    /**
     * @description
     * DTO for Microsoft Graph API group membership response.
     */
    public class MicrosoftGraphResponse {
        /**
         * @description Indicates if the API call was successful.
         */
        public Boolean success;
        /**
         * @description Next link for paginated results from Microsoft Graph API.
         */
        public String nextlink;
        /**
         * @description List of group IDs returned from Microsoft Graph API.
         */
        public List<String> groupIds;
        /**
         * @description Error message if the API call failed.
         */
        public String errorMessage;

        /**
         * @description Initializes a new MicrosoftGraphResponse.
         */
        public MicrosoftGraphResponse() {
            this.success = false;
            this.groupIds = new List<String>();
            this.errorMessage = null;
        }

        /**
         * @description
         * Parses the JSON response from Microsoft Graph API and extracts group IDs and next link.
         *
         * @param jsonResponse JSON string from Microsoft Graph API.
         */
        public void parse(String jsonResponse) {
            Map<String, Object> jsonMap = (Map<String, Object>) JSON.deserializeUntyped(
                jsonResponse
            );
            if (jsonMap.containsKey('@odata.nextLink')) {
                this.nextlink = (String) jsonMap.get('@odata.nextLink');
            }
            if (jsonMap.containsKey('value')) {
                List<Object> values = (List<Object>) jsonMap.get('value');
                for (Object valueObj : values) {
                    Map<String, Object> valueMap = (Map<String, Object>) valueObj;
                    groupIds.add((String) valueMap.get('id'));
                }
            }
        }
    }
}
