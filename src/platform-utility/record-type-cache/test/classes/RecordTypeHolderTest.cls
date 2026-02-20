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

    /** Verify getRecordTypeIdMap returns all record types indexed by Id. */
    @IsTest
    private static void getRecordTypeIdMapReturnsAllRecordTypes() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        Map<Id, RecordType> result = rtHolder.getRecordTypeIdMap();
        Test.stopTest();

        System.Assert.isNotNull(result, 'Expected map to not be null');
        System.Assert.areEqual(
            3,
            result.size(),
            'Expected map to contain all 3 mock record types'
        );
        System.Assert.isTrue(
            result.containsKey('012RR000007iE9hAAA'),
            'Expected map to contain first record type by Id'
        );
        System.Assert.isTrue(
            result.containsKey('012RR000007iE9hBBB'),
            'Expected map to contain second record type by Id'
        );
        System.Assert.isTrue(
            result.containsKey('012RR000007iE9hCCC'),
            'Expected map to contain third record type by Id'
        );
    }

    /** Verify getRecordTypeIdMap returns a deep clone. */
    @IsTest
    private static void getRecordTypeIdMapReturnsDeepClone() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        Map<Id, RecordType> result1 = rtHolder.getRecordTypeIdMap();
        Map<Id, RecordType> result2 = rtHolder.getRecordTypeIdMap();
        Test.stopTest();

        System.Assert.isNotNull(
            result1,
            'Expected first result to not be null'
        );
        System.Assert.isNotNull(
            result2,
            'Expected second result to not be null'
        );

        RecordType rt1 = result1.get('012RR000007iE9hAAA');
        String originalName = rt1.Name;
        rt1.Name = 'Modified Name';

        RecordType rt2 = result2.get('012RR000007iE9hAAA');
        System.Assert.areEqual(
            originalName,
            rt2.Name,
            'Modifying one result should not affect another result from a separate call'
        );
    }

    /** Verify getRecordTypeIdMap returns empty map when no record types exist. */
    @IsTest
    private static void getRecordTypeIdMapWithNoRecordTypes() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks(
            new List<RecordType>()
        );

        Test.startTest();
        Map<Id, RecordType> result = rtHolder.getRecordTypeIdMap();
        Test.stopTest();

        System.Assert.isNotNull(result, 'Expected map to not be null');
        System.Assert.isTrue(
            result.isEmpty(),
            'Expected map to be empty when no record types exist'
        );
    }

    /** Verify getRecordTypeIdMap returns empty map when record types are null. */
    @IsTest
    private static void getRecordTypeIdMapWithNullRecordTypes() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks(
            null
        );

        Test.startTest();
        Map<Id, RecordType> result = rtHolder.getRecordTypeIdMap();
        Test.stopTest();

        System.Assert.isNotNull(result, 'Expected map to not be null');
        System.Assert.isTrue(
            result.isEmpty(),
            'Expected map to be empty when record types are null'
        );
    }

    /** Verify getAllRecordTypes returns all record types. */
    @IsTest
    private static void getAllRecordTypesReturnsAllRecordTypes() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        List<RecordType> result = rtHolder.getAllRecordTypes();
        Test.stopTest();

        System.Assert.isNotNull(result, 'Expected list to not be null');
        System.Assert.areEqual(
            3,
            result.size(),
            'Expected list to contain all 3 mock record types'
        );

        Set<Id> resultIds = new Set<Id>();
        for (RecordType rt : result) {
            resultIds.add(rt.Id);
        }

        System.Assert.isTrue(
            resultIds.contains('012RR000007iE9hAAA'),
            'Expected list to contain first record type'
        );
        System.Assert.isTrue(
            resultIds.contains('012RR000007iE9hBBB'),
            'Expected list to contain second record type'
        );
        System.Assert.isTrue(
            resultIds.contains('012RR000007iE9hCCC'),
            'Expected list to contain third record type'
        );
    }

    /** Verify getAllRecordTypes returns a deep clone. */
    @IsTest
    private static void getAllRecordTypesReturnsDeepClone() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks();

        Test.startTest();
        List<RecordType> result1 = rtHolder.getAllRecordTypes();
        List<RecordType> result2 = rtHolder.getAllRecordTypes();
        Test.stopTest();

        System.Assert.isNotNull(
            result1,
            'Expected first result to not be null'
        );
        System.Assert.isNotNull(
            result2,
            'Expected second result to not be null'
        );

        String originalName = result1[0].Name;
        result1[0].Name = 'Modified Name';

        System.Assert.areEqual(
            originalName,
            result2[0].Name,
            'Modifying one result should not affect another result from a separate call'
        );
    }

    /** Verify getAllRecordTypes returns empty list when no record types exist. */
    @IsTest
    private static void getAllRecordTypesWithNoRecordTypes() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks(
            new List<RecordType>()
        );

        Test.startTest();
        List<RecordType> result = rtHolder.getAllRecordTypes();
        Test.stopTest();

        System.Assert.isNotNull(result, 'Expected list to not be null');
        System.Assert.isTrue(
            result.isEmpty(),
            'Expected list to be empty when no record types exist'
        );
    }

    /** Verify getAllRecordTypes returns empty list when record types are null. */
    @IsTest
    private static void getAllRecordTypesWithNullRecordTypes() {
        RecordTypeHolder rtHolder = RecordTypeCacheTestUtility.getCacheHolderWithMocks(
            null
        );

        Test.startTest();
        List<RecordType> result = rtHolder.getAllRecordTypes();
        Test.stopTest();

        System.Assert.isNotNull(result, 'Expected list to not be null');
        System.Assert.isTrue(
            result.isEmpty(),
            'Expected list to be empty when record types are null'
        );
    }
}
