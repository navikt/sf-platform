@SuppressWarnings('PMD')
public without sharing class LoggerUtility extends CRM_ApplicationDomain {
    public enum LogLevel {
        INFO,
        API_TRANSACTION,
        WARNING,
        ERROR,
        CRITICAL
    }

    public static Map<LogLevel, String> levelMap = new Map<LogLevel, String>{
        LogLevel.ERROR => 'Error',
        LogLevel.WARNING => 'Warning',
        LogLevel.INFO => 'Info',
        LogLevel.API_TRANSACTION => 'API Transaction',
        LogLevel.CRITICAL => 'Critical'
    };

    public static Map<String, LogLevel> inverseLevelMap = new Map<String, LogLevel>{
        'Error' => LogLevel.ERROR,
        'Warning' => LogLevel.WARNING,
        'Info' => LogLevel.INFO,
        'API Transaction' => LogLevel.API_TRANSACTION,
        'Critical' => LogLevel.CRITICAL
    };

    private List<Application_Event__e> logs = new List<Application_Event__e>();
    public String category { public get; private set; } // Category stored on the logs for easier filtering
    public String domain { public get; private set; } // Domain stored on the logs for easier filtering

    @AuraEnabled(cacheable=true)
    public static void singleLog(
        String category,
        String domain,
        String logLevel,
        String payload,
        String message,
        String recordId
    ) {
        LoggerUtility logger = new LoggerUtility(category);
        LogLevel logLvl = inverseLevelMap.get(logLevel);
        Id id = null;
        if (!String.isBlank(recordId)) {
            try {
                id = (Id) recordId;
            } catch (StringException exp) {
                id = null;
            }
        }
        String objectName = id?.getSobjectType()?.getDescribe()?.getName();
        Domain dom = logger.domainNameMap.get(domain);
        logger.logMessage(
            logLvl,
            (string) id,
            objectName,
            message,
            payload,
            null,
            dom
        );
        logger.publish();
    }

    public LoggerUtility() {
        this.category = '';
    }

    public LoggerUtility(String category) {
        this.category = category;
    }

    /**
     * @description Allows specifying the domain immediately.
     * @param domain
     * @param category
     */
    public LoggerUtility(CRM_ApplicationDomain.Domain domain, String category) {
        this.category = category;
        this.domain = domainMap.get(domain);
    }

    public LoggerUtility setCategory(String category) {
        this.category = category;
        return this;
    }

    public void logMessage(
        LogLevel logLevel,
        String referenceId,
        String referenceInfo,
        String logMessage,
        String payLoad,
        long timeTaken,
        Domain domain
    ) {
        logMessage(
            logLevel,
            referenceId,
            referenceInfo,
            logMessage,
            payLoad,
            timeTaken
        );
        peek().Application_Domain__c = domainMap.get(domain);
    }

    public void logMessage(
        LogLevel logLevel,
        String referenceId,
        String referenceInfo,
        String logMessage,
        String payLoad,
        long timeTaken
    ) {
        Application_Event__e event = new Application_Event__e(
            Log_Level__c = levelMap.get(logLevel),
            Source_Class__c = getSourceClass(),
            Source_Function__c = getSourceFunction(),
            ReferenceId__c = referenceId,
            Reference_Info__c = referenceInfo,
            Log_Messages__c = logMessage,
            Payload__c = payLoad,
            UUID__c = Request.getCurrent().getRequestId(),
            User_Context__c = UserInfo.getUserId(),
            Category__c = this.category,
            Application_Domain__c = this.domain
        );
        logs.add(event);
    }
    /**
     * @description Method to publish the created event
     * @author Lars Petter Johnsen
     */
    public void publish() {
        EventBus.publish(logs);
        logs.clear();
    }

    @InvocableMethod(
        label='Create Application Log'
        description='Call apex to store application log in DB'
        category='Application Logging'
    )
    public static void handleLogRequests(List<LogRequest> request) {
        LoggerUtility flowLogger = new LoggerUtility();
        Boolean hasDomain;
        for (LogRequest req : request) {
            hasDomain = String.isNotBlank(req.domain);
            switch on req.logLevel {
                when 'INFO' {
                    if (hasDomain) {
                        flowLogger.info(
                            req.logMessage,
                            req.refRecord,
                            CRM_ApplicationDomain.Domain.valueOf(req.domain)
                        );
                    } else {
                        flowLogger.info(req.logMessage, req.refRecord);
                    }
                }
                when 'WARNING' {
                    if (hasDomain) {
                        flowLogger.warning(
                            req.logMessage,
                            req.refRecord,
                            CRM_ApplicationDomain.Domain.valueOf(req.domain)
                        );
                    } else {
                        flowLogger.warning(req.logMessage, req.refRecord);
                    }
                }
                when 'ERROR' {
                    if (hasDomain) {
                        flowLogger.error(
                            req.logMessage,
                            req.refRecord,
                            CRM_ApplicationDomain.Domain.valueOf(req.domain)
                        );
                    } else {
                        flowLogger.error(req.logMessage, req.refRecord);
                    }
                }
                when 'CRITICAL' {
                    if (hasDomain) {
                        flowLogger.critical(
                            req.logMessage,
                            req.refRecord,
                            CRM_ApplicationDomain.Domain.valueOf(req.domain)
                        );
                    } else {
                        flowLogger.critical(req.logMessage, req.refRecord);
                    }
                }
            }
            flowLogger.peek().Source_Class__c = req.source;
            flowlogger.peek().Category__c = req.category;
        }

        flowLogger.publish();
    }

    /**
     * @description returns a UUID from the System.UUID class
     * @return String
     * @author Stian Ruud Schikora | 11-03-2020
     **/
    @TestVisible
    private static String getUuid() {
        return System.UUID.randomUUID().toString();
    }

    /**
     * @description Performs a conversion from event to object allowing direct database insert
     * @author Stian Ruud Schikora | 11-02-2020
     * @return List<Application_Log__c>
     **/
    public List<Application_Log__c> publishSynch() {
        List<Application_Log__c> convertedLogs = convertToLogs();
        insert convertedLogs;
        return convertedLogs;
    }

    /**
     * @description Converts application event list directly to logs
     * @author Stian Ruud Schikora | 11-02-2020
     * @return List<Application_Log__c>
     **/
    private List<Application_Log__c> convertToLogs() {
        List<Application_Log__c> convertedLogs = new List<Application_Log__c>();
        for (Application_Event__e event : logs) {
            convertedLogs.add(convertToLog(event));
        }

        return convertedLogs;
    }

    public static List<Application_Log__c> convertToLogs(
        List<Application_Event__e> eventsToConvert
    ) {
        List<Application_Log__c> convertedLogs = new List<Application_Log__c>();
        for (Application_Event__e event : eventsToConvert) {
            if (
                inverseLevelMap.get(event.Log_Level__c) !=
                LogLevel.API_Transaction
            ) {
                convertedLogs.add(convertToLog(event));
            }
        }

        return convertedLogs;
    }

    /**
     * @description Convert an application event to an application log
     * @author Stian Ruud Schikora | 11-02-2020
     * @param event
     * @return Application_Log__c
     **/
    public static Application_Log__c convertToLog(Application_Event__e event) {
        Application_Log__c log = new Application_Log__c();
        log.Log_Level__c = event.Log_Level__c;
        log.Log_Message__c = event.Log_Messages__c;
        log.Pay_Load__c = event.Payload__c;
        log.Referrence_ID__c = event.ReferenceId__c;
        log.Referrence_Info__c = event.Reference_Info__c;
        log.Source_Class__c = event.Source_Class__c;
        log.Source_Function__c = event.Source_Function__c;
        log.UUID__c = event.UUID__c;
        log.User_Context__c = event.User_Context__c;
        log.Application_Domain__c = event.Application_Domain__c;
        log.Category__c = event.Category__c;
        return log;
    }

    /**
     * @description Returns the base endpoint from the requestUri
     * @author Stian Ruud Schikora | 07-18-2021
     * @param requestUri
     * @return String
     **/
    private static String getBaseEndpoint(String requestUri) {
        String strippedUri = requestUri.substringBefore('?'); //Get the URI without any query parameters
        String http = strippedUri.substringBetween('http://', '/') != null
            ? strippedUri.substringBetween('http://', '/')
            : strippedUri.substringAfter('http://');
        String https = strippedUri.substringBetween('https://', '/') != null
            ? strippedUri.substringBetween('https://', '/')
            : strippedUri.substringAfter('https://');

        return String.isNotBlank(https)
            ? https.abbreviate(40)
            : String.isNotBlank(http)
                  ? http.abbreviate(40)
                  : strippedUri.abbreviate(40);
    }

    /**
     * @description Returns the latest entry in the logs or null if no logs has been added
     *
     * @return  `Application_Event__e`
     **/
    public Application_Event__e peek() {
        return (logs.isEmpty() ? null : logs.get(logs.size() - 1));
    }

    public void info(String message, sObject obj) {
        logMessage(
            logLevel.Info,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null
        );
    }

    public void warning(String message, sObject obj) {
        logMessage(
            logLevel.Warning,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null
        );
    }

    public void error(String message, sObject obj) {
        logMessage(
            logLevel.Error,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null
        );
    }

    public void critical(String message, sObject obj) {
        logMessage(
            logLevel.Critical,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null
        );
    }

    /**
     * @description Simplest way to just log info with an existing LoggerUtility
     * @param message
     */
    public void infoAndPublish(String message) {
        info(message, null);
        publish();
    }

    /**
     * @description Simplest way to just log a warning with an existing LoggerUtility
     * @param message
     */
    public void warningAndPublish(String message) {
        warning(message, null);
        publish();
    }

    /**
     * @description Simplest way to just log an error with an existing LoggerUtility
     * @param message
     */
    public void errorAndPublish(String message) {
        error(message, null);
        publish();
    }

    /**
     * @description Simplest way to just log a critical error with an existing LoggerUtility
     * @param message
     */
    public void criticalAndPublish(String message) {
        critical(message, null);
        publish();
    }

    public void exception(Exception ex) {
        logMessage(
            logLevel.Critical,
            '',
            '',
            ex.getMessage(),
            ex.getStackTraceString(),
            null
        );
    }

    public void exception(Exception ex, sObject obj) {
        logMessage(
            logLevel.Critical,
            getObjectId(obj),
            getObjectName(obj),
            ex.getMessage(),
            ex.getStackTraceString(),
            null
        );
    }

    public void info(String message, sObject obj, Domain domain) {
        logMessage(
            logLevel.Info,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null,
            domain
        );
    }

    public void warning(String message, sObject obj, Domain domain) {
        logMessage(
            logLevel.Warning,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null,
            domain
        );
    }

    public void error(String message, sObject obj, Domain domain) {
        logMessage(
            logLevel.Error,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null,
            domain
        );
    }

    public void error(String message, sObject obj, Domain domain, String uuid) {
        error(message, obj, domain);
        peek().UUID__c = uuid; //Overwrites the autogenerated UUID with the input
    }

    public void critical(String message, sObject obj, Domain domain) {
        logMessage(
            logLevel.Critical,
            getObjectId(obj),
            getObjectName(obj),
            message,
            JSON.serializePretty(obj),
            null,
            domain
        );
    }

    public void httpError(
        String message,
        HttpResponse response,
        sObject obj,
        Domain domain
    ) {
        String payload =
            'HTTP Status: ' +
            String.valueOf(response.getStatusCode()) +
            ' - ' +
            response.getStatus() +
            '\n';
        payload += 'Body: \n' + response.getBody();

        payload += obj != null
            ? '\n sObject: \n' + JSON.serializePretty(obj)
            : '';

        logMessage(
            logLevel.Error,
            getObjectId(obj),
            getObjectName(obj),
            message,
            payload,
            null,
            domain
        );
    }

    public void httpError(
        String message,
        HttpResponse response,
        sObject obj,
        Domain domain,
        String uuid
    ) {
        httpError(message, response, obj, domain);
        peek().UUID__c = uuid; //Overwrites the autogenerated UUID with the input
    }

    public void exception(Exception e, Domain domain) {
        exception(e, null, domain);
    }

    public void exception(Exception ex, sObject obj, Domain domain) {
        logMessage(
            logLevel.Critical,
            getObjectId(obj),
            getObjectName(obj),
            ex.getMessage(),
            ex.getStackTraceString(),
            null,
            domain
        );
    }

    private static String getSourceClass() {
        String stackTrace = getStackTrace();

        String sourceClass = stackTrace.substringAfter('Class.')
            .substringBefore('.');

        return sourceClass;
    }

    private String getObjectName(sObject obj) {
        return obj == null ? '' : obj.getSObjectType().getDescribe().getName();
    }

    private String getObjectId(sObject obj) {
        return obj != null ? obj.Id : null;
    }

    private static String getSourceFunction() {
        String sourceFunction = getStackTrace()
            .substringAfter(getSourceClass() + '.')
            .substringBefore(':');

        return sourceFunction;
    }

    private static String getStackTrace() {
        String stackTrace = '';
        try {
            String str;
            str.length();
        } catch (Exception e) {
            stackTrace = e.getStackTraceString()
                .substringAfterLast('Class.Logger')
                .substringAfter('column 1');
        }
        return stackTrace;
    }

    public class LogRequest {
        @InvocableVariable(label='Reference Record')
        public SObject refRecord;
        @InvocableVariable(label='Log Message')
        public String logMessage;
        @InvocableVariable(label='Domain')
        public String domain;
        @InvocableVariable(
            label='Category'
            description='Optional category for the log entry'
        )
        public String category;
        @InvocableVariable(label='Log Level (INFO, WARNING, ERROR, CRITICAL)')
        public String logLevel;
        @InvocableVariable(label='Source flow')
        public String source;
    }
}
