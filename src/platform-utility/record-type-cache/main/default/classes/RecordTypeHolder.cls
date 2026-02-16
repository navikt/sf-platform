/**
 * In-memory holder for RecordType data, indexed by Id and SObjectType/DeveloperName.
 */
public inherited sharing class RecordTypeHolder {
    @TestVisible
    private Map<Id, RecordType> recordTypeByIdMap;
    @TestVisible
    private Map<String, Map<String, RecordType>> recordTypesBySObjectTypeMap;

    @TestVisible
    private transient RecordTypeSelector selector { private get; private set; } // Transient to avoid serialization issues with the selector when stored in cache

    /**
     * Constructor that accepts a RecordTypeSelector to retrieve RecordType records.
     * @param selector Provides the RecordType records to cache
     */
    public RecordTypeHolder(RecordTypeSelector selector) {
        this.selector = selector;
        this.recordTypeByIdMap = new Map<Id, RecordType>();
        this.recordTypesBySObjectTypeMap = new Map<String, Map<String, RecordType>>();
    }

    /**
     * Get a RecordType by its Id.
     * @param recordTypeId The RecordType Id to look up
     * @return Cloned RecordType, or null if not found
     */
    public RecordType getRecordTypeById(Id recordTypeId) {
        return this.recordTypeByIdMap.get(recordTypeId)
            ?.clone(true, true, true, true);
    }

    /**
     * Get a RecordType by SObjectType and DeveloperName.
     * @param sObjectType SObject API name
     * @param developerName RecordType DeveloperName
     * @return Cloned RecordType, or null if not found
     */
    public RecordType getRecordTypeByDeveloperName(
        String sObjectType,
        String developerName
    ) {
        Map<String, RecordType> rtMap = this.recordTypesBySObjectTypeMap.get(
            sObjectType
        );
        return rtMap != null
            ? rtMap.get(developerName)?.clone(true, true, true, true)
            : null;
    }

    /**
     * Get all RecordTypes for a given SObjectType, indexed by DeveloperName.
     * @param sObjectType SObject API name
     * @return Deep-cloned map of DeveloperName to RecordType, or null if none found
     */
    public Map<String, RecordType> getRecordTypesBySObjectType(
        String sObjectType
    ) {
        Map<String, RecordType> rtMap = this.recordTypesBySObjectTypeMap.get(
            sObjectType
        );
        return rtMap != null ? rtMap.deepClone() : null;
    }

    /**
     * Queries RecordTypes via the selector and populates the lookup maps.
     * @return this instance, populated
     */
    public RecordTypeHolder loadRecordTypes() {
        recordTypeByIdMap = new Map<Id, RecordType>();
        recordTypesBySObjectTypeMap = new Map<String, Map<String, RecordType>>();

        List<RecordType> recordTypes = this.selector.getRecordTypes();
        if (recordTypes == null) {
            return this;
        }

        for (RecordType rt : recordTypes) {
            this.recordTypeByIdMap.put(rt.Id, rt);

            if (!this.recordTypesBySObjectTypeMap.containsKey(rt.SobjectType)) {
                this.recordTypesBySObjectTypeMap.put(
                    rt.SobjectType,
                    new Map<String, RecordType>()
                );
            }
            this.recordTypesBySObjectTypeMap.get(rt.SobjectType)
                .put(rt.DeveloperName, rt);
        }

        return this;
    }
}
