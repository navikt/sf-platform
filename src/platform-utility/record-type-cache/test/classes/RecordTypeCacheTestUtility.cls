@IsTest
public with sharing class RecordTypeCacheTestUtility {
    public static final List<RecordType> MOCK_RECORD_TYPES = new List<RecordType>{
        new RecordType(
            Id = '012RR000007iE9hAAA', //NOPMD - This is a mock id
            DeveloperName = 'My_mocked_devName',
            Name = 'Mocked RT',
            SobjectType = 'Account',
            IsActive = true
        ),
        new RecordType(
            Id = '012RR000007iE9hBBB', //NOPMD - This is a mock id
            DeveloperName = 'My_mocked_devName2',
            Name = 'Mocked RT 2',
            SobjectType = 'Account',
            IsActive = true
        ),
        new RecordType(
            Id = '012RR000007iE9hCCC', //NOPMD - This is a mock id
            DeveloperName = 'My_mocked_devName3',
            Name = 'Mocked RT 3',
            SobjectType = 'Contact',
            IsActive = true
        )
    };

    /** Stub selector that returns injected mock RecordTypes. */
    public class RecordTypeSelectorStub implements RecordTypeSelector {
        private List<RecordType> records;

        /**
         * Default constructor which initializes the stub with the predefined mock record types.
         * If you want to initialize the stub with a different set of record types, use the constructor that takes a List<RecordType> as a parameter.
         * This allows for flexibility in testing different scenarios by providing different sets of record types to the cache.
         */
        public RecordTypeSelectorStub() {
            this(RecordTypeCacheTestUtility.MOCK_RECORD_TYPES);
        }
        /**
         * Constructor
         * @param records List of RecordType records that will be returned by this stub when the getRecordTypes method is called
         */
        public RecordTypeSelectorStub(List<RecordType> records) {
            this.records = records;
        }

        /**
         * Return the mock record types.
         * @return List of RecordType records that were set in the constructor
         */
        public List<RecordType> getRecordTypes() {
            return records;
        }
    }

    /** Initialize cache with predefined mocks */
    public static void initCacheWithMocks() {
        RecordTypeCache.rtCache = RecordTypeCacheTestUtility.getCacheHolderWithMocks();
    }

    /**
     * Initialize cache with predefined mocks
     * @param recordTypes List of RecordType records to initialize the cache with.
     */
    public static void initCacheWithMocks(List<RecordType> recordTypes) {
        RecordTypeCache.rtCache = RecordTypeCacheTestUtility.getCacheHolderWithMocks(
            recordTypes
        );
    }

    /**
     * Get cacheholder with predefined mocks
     * @return RecordTypeHolder instance with mock record types loaded
     */
    public static RecordTypeHolder getCacheHolderWithMocks() {
        return getCacheHolderWithMocks(
            RecordTypeCacheTestUtility.MOCK_RECORD_TYPES
        );
    }

    /**
     * Get cacheholder with predefined mocks
     * @param recordTypes List of RecordType records to initialize the cache holder with.
     * @return RecordTypeHolder instance with mock record types loaded
     */
    public static RecordTypeHolder getCacheHolderWithMocks(
        List<RecordType> recordTypes
    ) {
        return new RecordTypeHolder(new RecordTypeSelectorStub(recordTypes))
            .loadRecordTypes();
    }
}
