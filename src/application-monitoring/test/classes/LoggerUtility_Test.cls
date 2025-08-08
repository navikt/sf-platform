/**
 * @description Unit tests for the LoggerUtility class.
 */
@IsTest(isParallel=true)
public class LoggerUtility_Test {
    @IsTest
    public static void testLogging() {
        LoggerUtility logger = new LoggerUtility();

        logger.info('Testing info logging', null);
        logger.error('Testing error logging', null);
        logger.warning('Testing warning logging', null);
        logger.critical('Testing critical logging', null);

        try {
            Integer i = 1 / 0;
        } catch (Exception ex) {
            logger.exception(ex);
            logger.exception(ex, new Account());
        }

        logger.peek();

        Test.startTest();
        logger.publish();
        Test.stopTest();

        System.assert([SELECT COUNT() FROM Application_Log__c] == 6);
    }

    @IsTest
    public static void testLoggingDomain() {
        LoggerUtility logger = new LoggerUtility();

        logger.setCategory('Test');

        logger.info(
            'Testing info logging',
            null,
            CRM_ApplicationDomain.Domain.NKS
        );
        logger.error(
            'Testing error logging',
            null,
            CRM_ApplicationDomain.Domain.NKS
        );
        logger.warning(
            'Testing warning logging',
            null,
            CRM_ApplicationDomain.Domain.NKS
        );
        logger.critical(
            'Testing critical logging',
            null,
            CRM_ApplicationDomain.Domain.NKS
        );

        try {
            Integer i = 1 / 0;
        } catch (Exception ex) {
            logger.exception(ex, CRM_ApplicationDomain.Domain.NKS);
        }

        logger.peek();

        Test.startTest();
        logger.publish();
        Test.stopTest();

        System.assert([SELECT COUNT() FROM Application_Log__c] == 5);
    }

    @IsTest
    public static void testLoggingHttpError() {
        LoggerUtility logger = new LoggerUtility();

        HttpResponse response = new HttpResponse();
        response.setStatusCode(400);
        response.setBody('Http body');
        response.setStatus('Error status');

        logger.httpError(
            'Test logging http error',
            response,
            null,
            CRM_ApplicationDomain.Domain.NKS
        );

        Test.startTest();
        logger.publish();
        Test.stopTest();

        System.assert([SELECT COUNT() FROM Application_Log__c] == 1);
    }

    @isTest
    public static void testPublishSynch() {
        LoggerUtility logger = new LoggerUtility();

        logger.info('Testing info logging', null);
        logger.error('Testing error logging', null);
        logger.warning('Testing warning logging', null);
        logger.critical('Testing critical logging', null);

        Test.startTest();
        logger.publishSynch();
        Test.stopTest();

        System.assert(
            [SELECT COUNT() FROM Application_Log__c] == 4,
            'Invalid log amount: ' + [SELECT COUNT() FROM Application_Log__c]
        );
    }

    @IsTest
    private static void getUuid() {
        String uuid;
        Test.startTest();
        uuid = LoggerUtility.getUuid();
        Test.stopTest();

        System.Assert.isTrue(String.isNotBlank(uuid), 'UUID is blank');
    }

    @isTest
    public static void testHandleLogRequests() {
        LoggerUtility.LogRequest logReq1 = new LoggerUtility.LogRequest();
        LoggerUtility.LogRequest logReq2 = new LoggerUtility.LogRequest();
        LoggerUtility.LogRequest logReq3 = new LoggerUtility.LogRequest();
        LoggerUtility.LogRequest logReq4 = new LoggerUtility.LogRequest();

        logReq1.logLevel = 'INFO';
        logReq1.source = 'TEST';
        logReq1.logMessage = 'MESSAGE';

        logReq2.logLevel = 'WARNING';
        logReq2.source = 'TEST';
        logReq2.logMessage = 'MESSAGE';

        logReq3.logLevel = 'ERROR';
        logReq3.source = 'TEST';
        logReq3.logMessage = 'MESSAGE';

        logReq4.logLevel = 'CRITICAL';
        logReq4.source = 'TEST';
        logReq4.logMessage = 'MESSAGE';

        Test.startTest();
        LoggerUtility.handleLogRequests(
            new List<LoggerUtility.LogRequest>{
                logReq1,
                logReq2,
                logReq3,
                logReq4
            }
        );
        Test.stopTest();

        System.assert([SELECT COUNT() FROM Application_Log__c] == 4);
    }

    /**
     * Ensure that the domain can be set in the constructor. Also ensure that
     * this can be overridden in calls to logMessage.
     */
    @IsTest
    public static void constructDomain() {
        LoggerUtility logger = new LoggerUtility(
            CRM_ApplicationDomain.Domain.NKS,
            'Test'
        );
        logger.info('Testing info logging', null);
        logger.logMessage(
            LoggerUtility.logLevel.Info,
            null,
            null,
            'Testing separate domain logging',
            JSON.serializePretty(null),
            null,
            CRM_ApplicationDomain.Domain.HOT
        );
        Test.startTest();
        logger.publish();
        Test.stopTest();
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Application_Domain__c = 'NKS'
            ]
        );
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Application_Domain__c = 'HOT'
            ]
        );
    }

    /**
     * Ensure that not setting the domain in the constructor is still fine.
     */
    @IsTest
    public static void doNotConstructDomain() {
        LoggerUtility logger = new LoggerUtility('Test');
        logger.info('Testing info logging', null);
        Test.startTest();
        logger.publish();
        Test.stopTest();
        Assert.areEqual(1, [SELECT COUNT() FROM Application_Log__c]);
        Application_Log__c entry = [
            SELECT Application_Domain__c
            FROM Application_Log__c
            LIMIT 1
        ];
        Assert.isNull(entry.Application_Domain__c);
    }
}
