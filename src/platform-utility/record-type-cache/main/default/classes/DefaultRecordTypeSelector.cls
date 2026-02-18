/**
 * Default RecordTypeSelector that queries all RecordType records from the org.
 */
@SuppressWarnings(
    'PMD.AvoidNonRestrictiveQueries'
) // No need for LIMIT here as we want all record types and it's not expected to be a large number
public inherited sharing class DefaultRecordTypeSelector implements RecordTypeSelector {
    /**
     * Queries all RecordType records from the org with SECURITY_ENFORCED to respect user permissions.
     * @return All RecordType records with SECURITY_ENFORCED
     */
    public List<RecordType> getRecordTypes() {
        return [
            SELECT
                Id,
                DeveloperName,
                Name,
                SobjectType,
                IsActive,
                BusinessProcessId,
                IsPersonType,
                NamespacePrefix
            FROM RecordType
            WITH SECURITY_ENFORCED
        ];
    }
}
