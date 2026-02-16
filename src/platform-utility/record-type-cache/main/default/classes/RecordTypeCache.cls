/**
 * Org-partitioned cache for RecordType lookups by Id or DeveloperName. Built on demand via RecordTypeCacheBuilder.
 *
 * @author Tor Håkon Sigurdsen
 * @since feb 2026
 * @example
 * {@code
 * // Example usage of the RecordTypeCache class
 * RecordType recordTypeById = RecordTypeCache.getRecordTypeById('012000000000001AAA');
 * RecordType recordTypeByDeveloperName = RecordTypeCache.getRecordTypeByDeveloperName('Account', 'Business_Account');
 * Map<String, RecordType> accountRecordTypes = RecordTypeCache.getRecordTypesBySObjectType('Account');
 *
 * //Example of clearing the cache (when a record type is created, updated, or deleted, you may want to clear the cache to ensure that the cache is refreshed with the latest record type information)
 * RecordTypeCache.clearCache();
 *
 *  // Test example using a mock RecordTypeSelector to inject test data into the cache
 * private class RecordTypeSelectorStub implements RecordTypeSelector {
 *     private List<RecordType> records;
 *   public RecordTypeSelectorStub(List<RecordType> records) {
 *        this.records = records;
 *   }
 *   public List<RecordType> getRecordTypes() {
 *       return records;
 *  }
 *
 * List<RecordType> mockRecordTypes = new List<RecordType>{
 *     new RecordType(Id = '012000000000001AAA', DeveloperName = 'Test_Record_Type_1', Name = 'Test Record Type 1', SobjectType = 'Account', IsActive = true),  //NOPMD - This is a mock id
 *     new RecordType(Id = '012000000000002AAA', DeveloperName = 'Test_Record_Type_2', Name = 'Test Record Type 2', SobjectType = 'Contact', IsActive = true)  //NOPMD - This is a mock id
 * };
 *
 * @IsTest
 *     private static void testRecordTypeCacheWithMockSelector() {
 *     RecordTypeCache.selector = new RecordTypeSelectorStub(mockRecordTypes);
 *     Test.startTest();
 *     RecordType result = RecordTypeCache.getRecordTypeById('012000000000001AAA'); //NOPMD - This is a mock id
 *     Test.stopTest();
 *     System.Assert.isNotNull(result, 'Expected to have a mock recordtype returned');
 *     System.Assert.areEqual('012000000000001AAA', result.Id, 'Expected the id of the result to be the same as the mock'); //NOPMD - This is a mock id
 * }
 * }
 */
public inherited sharing class RecordTypeCache {
    private static final String CACHE_KEY = 'RecordTypeCacheKey';
    @TestVisible
    private static String cachePartition = 'local.tokens';
    @TestVisible
    private static RecordTypeSelector selector = new DefaultRecordTypeSelector();
    private static Cache.OrgPartition orgPartition {
        private get {
            if (orgPartition == null) {
                try {
                    orgPartition = Cache.Org.getPartition(
                        RecordTypeCache.cachePartition
                    );
                } catch (Cache.Org.OrgCacheException e) {
                    throw new RecordTypeCacheException(
                        'Cache partition not configured: ' + cachePartition,
                        e
                    );
                }
            }
            return orgPartition;
        }
        private set;
    }

    @TestVisible
    private static RecordTypeHolder rtCache {
        get {
            if (rtCache == null) {
                RecordTypeHolder holder = (RecordTypeHolder) RecordTypeCache.orgPartition.get(
                    RecordTypeCacheBuilder.class,
                    RecordTypeCache.CACHE_KEY
                );
                rtCache = holder;
            }
            return rtCache;
        }
        private set;
    }

    /**
     * Retrieve a cached RecordType by its Id.
     * @param recordTypeId The RecordType Id to look up
     * @return Matching RecordType, or null if not found
     */
    public static RecordType getRecordTypeById(Id recordTypeId) {
        return rtCache.getRecordTypeById(recordTypeId);
    }

    /**
     * Retrieve a cached RecordType by SObjectType and DeveloperName.
     * @param sObjectType SObject API name (e.g. 'Account')
     * @param developerName RecordType DeveloperName (e.g. 'Business_Account')
     * @return Matching RecordType, or null if not found
     */
    public static RecordType getRecordTypeByDeveloperName(
        String sObjectType,
        String developerName
    ) {
        return rtCache.getRecordTypeByDeveloperName(sObjectType, developerName);
    }

    /**
     * Retrieve all cached RecordTypes for a given SObjectType.
     * @param sObjectType SObject API name (e.g. 'Account')
     * @return Map of DeveloperName to RecordType, or null if none found
     */
    public static Map<String, RecordType> getRecordTypesBySObjectType(
        String sObjectType
    ) {
        return rtCache.getRecordTypesBySObjectType(sObjectType);
    }

    /**
     * Evicts cached data so it is reloaded on next access.
     */
    public static void clearCache() {
        RecordTypeCache.orgPartition.remove(
            RecordTypeCacheBuilder.class,
            RecordTypeCache.CACHE_KEY
        );
        RecordTypeCache.rtCache = null;
    }

    /**
     * CacheBuilder that loads RecordType data via the configured selector.
     */
    @TestVisible
    private class RecordTypeCacheBuilder implements Cache.CacheBuilder {
        /**
         * Loads RecordTypes into a RecordTypeHolder.
         * @param cacheKey Unused – single cache entry
         * @return Populated RecordTypeHolder
         */
        public Object doLoad(String cacheKey) {
            return new RecordTypeHolder(selector).loadRecordTypes();
        }
    }

    /** Exception for RecordTypeCache errors. */
    public class RecordTypeCacheException extends Exception {
    }
}
