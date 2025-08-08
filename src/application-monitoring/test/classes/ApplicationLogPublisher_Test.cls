@isTest
public class ApplicationLogPublisher_Test {
    private static final String category = 'TEST CATEGORY';

    @isTest
    static void testAppLogPublish() {
        SingleRequestMock mock = new SingleRequestMock(200, 'OK', '', null);
        Test.setMock(HttpCalloutMock.class, mock);

        Application_Log_Setting__mdt testSetting = new Application_Log_Setting__mdt(
            Application_Domain__c = 'NKS',
            Slack_Hook__c = 'https://slack.test.com',
            Slack_Hook_Sandbox__c = 'https://slack.test.com',
            Message_Template__c = 'TEST TEMPLATE',
            Immediate_Post__c = true,
            Minimum_Log_Level__c = 'Error',
            Category__c = category
        );

        LoggerUtility logger = new LoggerUtility(category);
        for (Integer i = 0; i < 101; i++) {
            logger.error('TESTING', null, CRM_ApplicationDomain.Domain.NKS);
        }

        Test.startTest();
        ApplicationLogPublisher.testSetting = testSetting;
        List<Application_Log__c> logs = logger.publishSynch(); //Do DML for trigger coverage
        ApplicationLogPublisher.publishLogs(logs); //Calling directly in static context to trigger testSettings
        Test.stopTest();
    }
}
