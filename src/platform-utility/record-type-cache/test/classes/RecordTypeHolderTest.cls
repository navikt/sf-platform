@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@IsTest
private with sharing class RecordTypeHolderTest {
    /** Verify cache returns null when no record types exist. */
    @IsTest
    private static void noRecordTypesAvailable() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks(
            new List<RecordType>()
        );

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            'Account',
            'My_mocked_devName'
        );
        RecordType resultById = rtHolder.getRecordTypeById(
            '012RR000007iE9hAAA'
        ); //NOPMD - This is a mock id
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected to have a null result when no record types are available'
        );
        System.Assert.isNull(
            resultById,
            'Expected to have a null result when no record types are available'
        );
    }

    /** Verify cache returns null when no record types exist. */
    @IsTest
    private static void nullRecordTypes() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks(
            null
        );

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            'Account',
            'My_mocked_devName'
        );
        RecordType resultById = rtHolder.getRecordTypeById(
            '012RR000007iE9hAAA'
        ); //NOPMD - This is a mock id
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected to have a null result when no record types are available'
        );
        System.Assert.isNull(
            resultById,
            'Expected to have a null result when no record types are available'
        );
    }

    /** Verify lookup by SObjectType and DeveloperName returns correct record type. */
    @IsTest
    private static void getRecordTypeByDeveloperName() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            'Account',
            'My_mocked_devName'
        );
        Test.stopTest();

        System.Assert.isNotNull(
            result,
            'Expected to have a mock recordtype returned'
        );
        System.Assert.areEqual(
            'My_mocked_devName',
            result.DeveloperName,
            'Expected the developername of the result to be the same as the mock'
        );
    }

    /** Verify null is returned for a non-existent DeveloperName. */
    @IsTest
    private static void getRecordTypeByDeveloperNameNotFound() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            'Account',
            'Non_existent_devName'
        );
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected to have a null result when the developer name is not found in the cache'
        );
    }

    /** Verify null DeveloperName returns null gracefully. */
    @IsTest
    private static void nullDeveloperNameHandling() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            'Account',
            null
        );
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected null when developerName is null'
        );
    }

    /** Verify empty DeveloperName returns null gracefully. */
    @IsTest
    private static void blankDeveloperNameHandling() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            'Account',
            ''
        );
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected null when developerName is null'
        );
    }

    /** Verify null SObjectType returns null gracefully. */
    @IsTest
    private static void getRecordTypeByDeveloperNameNullsObjectName() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            null,
            'My_mocked_devName'
        );
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected null when developerName is null'
        );
    }

    /** Verify empty SObjectType returns null gracefully. */
    @IsTest
    private static void getRecordTypeByDeveloperNameBlanksObjectName() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeByDeveloperName(
            '',
            'My_mocked_devName'
        );
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected null when developerName is blank'
        );
    }

    /** Verify lookup by Id returns the correct record type. */
    @IsTest
    private static void getRecordTypeById() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeById('012RR000007iE9hAAA'); //NOPMD - This is a mock id
        Test.stopTest();

        System.Assert.isNotNull(
            result,
            'Expected to have a mock recordtype returned' +
            RecordTypeCache.rtCache
        );
        System.Assert.areEqual(
            '012RR000007iE9hAAA',
            result.Id,
            'Expected the id of the result to be the same as the mock. Got :' +
            result
        ); //NOPMD - This is a mock id
    }

    /** Verify null is returned for a non-existent Id. */
    @IsTest
    private static void getRecordTypeByIdNotFound() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeById('012RR000007iE9hXXX'); //NOPMD - This is a mock id
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected to have a null result when the id is not found in the cache'
        );
    }

    /** Verify null Id returns null gracefully. */
    @IsTest
    private static void nullRecordTypeIdHandling() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        RecordType result = rtHolder.getRecordTypeById(null);
        Test.stopTest();

        System.Assert.isNull(result, 'Expected null when recordTypeId is null');
    }

    /** Verify lookup by SObjectType returns the correct map of record types. */
    @IsTest
    private static void getRecordTypesBySObjectType() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        Map<String, RecordType> result = rtHolder.getRecordTypesBySObjectType(
            'Account'
        );
        Test.stopTest();

        System.Assert.isNotNull(
            result,
            'Expected to have a mock recordtype map returned'
        );
        System.Assert.areEqual(
            2,
            result.size(),
            'Expected to have 2 record types for Account sObject type'
        );
        System.Assert.isTrue(
            result.containsKey('My_mocked_devName'),
            'Expected to have the first mocked record type in the result'
        );
        System.Assert.isTrue(
            result.containsKey('My_mocked_devName2'),
            'Expected to have the second mocked record type in the result'
        );
    }

    /** Verify null is returned for a non-existent SObjectType. */
    @IsTest
    private static void getRecordTypesBySObjectTypeNotFound() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        Map<String, RecordType> result = rtHolder.getRecordTypesBySObjectType(
            'Opportunity'
        );
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected to have a null result when the sObject type is not found in the cache'
        );
    }

    /** Verify null SObjectType returns null gracefully. */
    @IsTest
    private static void nullSObjectTypeHandling() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        Map<String, RecordType> result = rtHolder.getRecordTypesBySObjectType(
            null
        );
        Test.stopTest();

        System.Assert.isNull(result, 'Expected null when sObjectType is null');
    }

    /** Verify empty SObjectType string returns null. */
    @IsTest
    private static void getRecordTypesBySObjectTypeEmptyString() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        Map<String, RecordType> result = rtHolder.getRecordTypesBySObjectType(
            ''
        );
        Test.stopTest();

        System.Assert.isNull(
            result,
            'Expected null for empty sObjectType string'
        );
    }
}
