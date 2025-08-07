public class ApplicationLogPublisher {
    public static Application_Log_Setting__mdt testSetting;
    //Introduce setting to determine if messages should be published also for sandboxes
    private static Boolean isSandbox = [
        SELECT Id, isSandbox
        FROM Organization
        LIMIT 1
    ]
    .isSandbox;

    /**
     * @description: Performs a check on created application logs to see if any meet
     * the requirements for publishing to slack channels.
     * @author Stian Ruud Schikora | 02-23-2021
     * @param appLogs
     **/
    public static void publishLogs(List<Application_Log__c> appLogs) {
        Set<String> appDomains = new Set<String>();
        List<AppLog> logsToPublish = new List<AppLog>();

        for (Application_Log__c log : appLogs) {
            appDomains.add(log.Application_Domain__c);
        }

        List<Application_Log_Setting__mdt> logSettings = getLogSettings(
            appDomains
        );

        for (Application_Log__c log : appLogs) {
            for (Application_Log_Setting__mdt setting : logSettings) {
                if (
                    log.Application_Domain__c == setting.Application_Domain__c
                ) {
                    String hook = getHook(setting);
                    if (
                        getLogLevelOrdinal(log.Log_Level__c) >=
                        getLogLevelOrdinal(setting.Minimum_Log_Level__c) &&
                        setting.Category__c == log.Category__c
                    ) {
                        if (
                            Setting.Immediate_Post__c && String.isNotBlank(hook)
                        ) {
                            logsToPublish.add(
                                new AppLog(
                                    log,
                                    hook,
                                    Setting.Message_Template__c
                                )
                            );
                        }
                    }
                } else {
                    continue;
                }
            }
        }

        if (!logsToPublish.isEmpty()) {
            //If there are more logs to publish than the transactional callout limit, generate several future contexts
            if (logsToPublish.size() > Limits.getLimitCallouts()) {
                List<AppLog> listToPublish = new List<AppLog>();
                while (logsToPublish.size() > 0) {
                    listToPublish.add(logsToPublish.remove(0));
                    if (listToPublish.size() == Limits.getLimitCallouts()) {
                        publishToSlack(JSON.serialize(listToPublish));
                        listToPublish.clear();
                    }
                }
            } else {
                publishToSlack(JSON.serialize(logsToPublish));
            }
        }
    }

    @future(Callout=true)
    private static void publishToSlack(String jsonAppLogs) {
        List<AppLog> logs = (List<AppLog>) JSON.deserialize(
            jsonAppLogs,
            List<AppLog>.class
        );
        ApiController apiCtrl = new ApiController();
        for (AppLog log : logs) {
            apiCtrl.setEndpoint(log.slackHook);
            apiCtrl.setMethod('POST');
            apiCtrl.addHeader('Content-Type', 'application/json');

            SlackMessage message = new SlackMessage(log.messageTemplate);
            String errorMessage =
                'Log level: ' +
                log.logRecord.Log_Level__c +
                '\n Source: ' +
                log.logRecord.Source_Class__c +
                '\n Link: ' +
                URL.getSalesforceBaseUrl().toExternalForm() +
                '/' +
                log.logRecord.Id +
                '\n Message: ' +
                log.logRecord.Log_Message__c;
            message.addSection(errorMessage);

            apiCtrl.setBody(JSON.serialize(message));

            apiCtrl.doCallout();
        }
    }

    /**
     * @description: Queries the relevant log settings for the defined application domains
     * @author Stian Ruud Schikora | 02-23-2021
     * @param appDomains
     * @return List<Application_Log_Setting__mdt>
     **/
    private static List<Application_Log_Setting__mdt> getLogSettings(
        Set<String> appDomains
    ) {
        if (Test.isRunningTest()) {
            return testSetting != null
                ? new List<Application_Log_Setting__mdt>{ testSetting }
                : new List<Application_Log_Setting__mdt>();
        }
        return [
            SELECT
                Id,
                MasterLabel,
                Application_Domain__c,
                Slack_Hook__c,
                Slack_Hook_Sandbox__c,
                Message_Template__c,
                Immediate_Post__c,
                Minimum_Log_Level__c,
                Named_Credential__c,
                Category__c
            FROM Application_Log_Setting__mdt
            WHERE Application_Domain__c IN :appDomains
        ];
    }

    /**
     * @description: Returns the correct slack hook for production or sandbox.
     * @author Stian Ruud Schikora | 03-13-2021
     * @param logSetting
     * @return String
     **/
    private static String getHook(Application_Log_Setting__mdt logSetting) {
        if (isSandbox) {
            return logSetting.Slack_Hook_Sandbox__c;
        }

        return String.isNotBlank(logSetting.Named_Credential__c)
            ? 'callout:' + logSetting.Named_Credential__c
            : logSetting.Slack_Hook__c;
    }

    /**
  * @description: Returns the log level ordinal for a input loglevel string
  INFO = 0, WARNING = 1, ERROR = 2, CRITICAL = 3
  * @author Stian Ruud Schikora | 02-22-2021
  * @param logLevel
  * @return Integer
  **/
    private static Integer getLogLevelOrdinal(String logLevel) {
        return LoggerUtility.inverseLevelMap.get(logLevel).ordinal();
    }

    private class AppLog {
        private AppLog(
            Application_Log__c appLog,
            String slackHook,
            String messageTemplate
        ) {
            this.logRecord = appLog;
            this.slackHook = slackHook;
            this.messageTemplate = messageTemplate;
        }

        private Application_Log__c logRecord;
        private String slackHook;
        private String messageTemplate;
    }
}
