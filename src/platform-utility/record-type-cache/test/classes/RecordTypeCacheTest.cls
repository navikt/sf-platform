@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@IsTest(IsParallel=true)
private with sharing class RecordTypeCacheTest {
    /** Verify lookup by SObjectType and DeveloperName returns correct record type. */
    @IsTest
    private static void getRecordTypeByDeveloperName() {
        RecordTypeCacheTestUtility.initCacheWithMocks();

        Test.startTest();
        RecordType result = RecordTypeCache.getRecordTypeByDeveloperName(
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

    /** Verify lookup by Id returns the correct record type. */
    @IsTest
    private static void getRecordTypeById() {
        RecordTypeCacheTestUtility.initCacheWithMocks();

        Test.startTest();
        RecordType result = RecordTypeCache.getRecordTypeById(
            '012RR000007iE9hAAA'
        ); //NOPMD - This is a mock id
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

    /** Verify lookup by SObjectType returns the correct map of record types. */
    @IsTest
    private static void getRecordTypesBySObjectType() {
        RecordTypeCacheTestUtility.initCacheWithMocks();

        Test.startTest();
        Map<String, RecordType> result = RecordTypeCache.getRecordTypesBySObjectType(
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

    /** Verify clearCache works even when cache is empty and reloads correctly. */
    @IsTest
    private static void clearCache() {
        RecordTypeCache.selector = new RecordTypeCacheTestUtility.RecordTypeSelectorStub();

        Test.startTest();
        RecordTypeCache.clearCache();
        RecordTypeHolder result = RecordTypeCache.rtCache;
        Test.stopTest();

        System.Assert.isNotNull(
            result,
            'Expected to have a mock recordtype returned'
        );
        System.Assert.areEqual(
            RecordTypeCacheTestUtility.MOCK_RECORD_TYPES.size(),
            RecordTypeCache.rtCache.recordTypeByIdMap.size(),
            'Expected the mock and the result be the same size'
        );
        System.Assert.areEqual(
            2,
            RecordTypeCache.rtCache.recordTypesBySObjectTypeMap.size(),
            'Expected to have 2 sObject types in the map'
        );
    }

    /** Verify clearCache refreshes data when the selector changes. */
    @IsTest
    private static void refreshCache() {
        List<RecordType> newMockRecordTypes = new List<RecordType>{
            new RecordType(
                Id = '012RR000007iE9hDDD', //NOPMD - This is a mock id
                DeveloperName = 'My_mocked_devName4',
                Name = 'Mocked RT 4',
                SobjectType = 'Account',
                IsActive = true
            )
        };

        RecordTypeCache.selector = new RecordTypeCacheTestUtility.RecordTypeSelectorStub();

        Test.startTest();
        RecordType result = RecordTypeCache.getRecordTypeByDeveloperName(
            'Account',
            'My_mocked_devName'
        );

        System.Assert.isNotNull(
            result,
            'Expected to have a mock recordtype returned'
        );
        System.Assert.areEqual(
            '012RR000007iE9hAAA',
            result.Id,
            'Expected to get the correct recordtype from the cache'
        ); //NOPMD - This is a mock id
        System.Assert.areEqual(
            RecordTypeCacheTestUtility.MOCK_RECORD_TYPES.size(),
            RecordTypeCache.rtCache.recordTypeByIdMap.size(),
            'Expected the mock and the result be the same size'
        );

        // Now we change the selector to return a different set of record types, and refresh the cache. We should get the new record types after that.
        RecordTypeCache.selector = new RecordTypeCacheTestUtility.RecordTypeSelectorStub(
            newMockRecordTypes
        );
        RecordTypeCache.clearCache();

        RecordType newResult = RecordTypeCache.getRecordTypeByDeveloperName(
            'Account',
            'My_mocked_devName4'
        );
        Test.stopTest();

        System.Assert.isNotNull(
            newResult,
            'Expected to have a mock recordtype returned after refresh'
        );
        System.Assert.areEqual(
            '012RR000007iE9hDDD',
            newResult.Id,
            'Expected to get the correct recordtype from the cache after refresh'
        ); //NOPMD - This is a mock id
        System.Assert.areEqual(
            1,
            RecordTypeCache.rtCache.recordTypeByIdMap.size(),
            'Expected the cache to have only 1 record type after refresh'
        );
    }

    /** Smoke test: cache initializes and returns a non-null holder. */
    @IsTest
    private static void smokeTest() {
        Test.startTest();
        RecordTypeCache.clearCache();
        RecordTypeHolder result = RecordTypeCache.rtCache;
        Test.stopTest();

        System.Assert.isNotNull(
            result,
            'Expected to have a record type holder returned'
        );
    }

    @IsTest
    private static void notExistingPartition() {
        RecordTypeCache.cachePartition = 'non.existing.partition';
        Exception expectedException;
        Test.startTest();
        try {
            RecordTypeCache.clearCache();
            System.Assert.fail(
                'Expected an exception to be thrown when cache partition does not exist'
            );
        } catch (Exception e) {
            expectedException = e;
        }
        Test.stopTest();

        System.assert.isInstanceOfType(
            expectedException,
            RecordTypeCache.RecordTypeCacheException.class,
            'Expected to get a RecordTypeCacheException'
        );
        System.Assert.isTrue(
            expectedException.getMessage()
                .startsWith('Cache partition not configured'),
            'Expected exception message to indicate cache partition is not configured. Got: ' +
            expectedException.getMessage()
        );
    }

    /** Verify getRecordTypeIdMap returns a map of all cached record types by Id. */
    @IsTest
    private static void getRecordTypeIdMap() {
        RecordTypeCacheTestUtility.initCacheWithMocks();

        Test.startTest();
        Map<Id, RecordType> result = RecordTypeCache.getRecordTypeIdMap();
        Test.stopTest();

        System.Assert.isNotNull(
            result,
            'Expected to have a map of record types returned'
        );
        System.Assert.areEqual(
            3,
            result.size(),
            'Expected to have 3 record types in the map'
        );
        System.Assert.isTrue(
            result.containsKey('012RR000007iE9hAAA'),
            'Expected to have the first mocked record type in the result'
        );
        System.Assert.isTrue(
            result.containsKey('012RR000007iE9hBBB'),
            'Expected to have the second mocked record type in the result'
        );
        System.Assert.isTrue(
            result.containsKey('012RR000007iE9hCCC'),
            'Expected to have the third mocked record type in the result'
        );
    }

    /** Verify getAllRecordTypes returns a list of all cached record types. */
    @IsTest
    private static void getAllRecordTypes() {
        RecordTypeCacheTestUtility.initCacheWithMocks();

        Test.startTest();
        List<RecordType> result = RecordTypeCache.getAllRecordTypes();
        Test.stopTest();

        System.Assert.isNotNull(
            result,
            'Expected to have a list of record types returned'
        );
        System.Assert.areEqual(
            3,
            result.size(),
            'Expected to have 3 record types in the list'
        );
    }
}
