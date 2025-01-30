/**
 * @description This Custom Metadata Data Access Object class is used to get access to
 * Custom Metadata objects, and at the same time make it easier to test the
 * various paths the code can take based on the values in the Custom Metadata.
 * It will also help to get 100% test coverage of the code and reduce the need
 * for use of "Test.isRunningTest()" in the code.
 * <br><br>
 * Inspiration for this way of solving the problem is taken from the article
 * "Get 100% Code Coverage for Salesforce Custom Metadata Based Decisions".
 *
 * @author Kenneth Soerensen (kenneth.sorensen@nav.com), NAV
 * @since 0.1.0, August 2024
 * @group Custom Metadata DAO
 * @see [Get 100% Code Coverage for Salesforce Custom Metadata Based Decisions](https://www.avenga.com/magazine/salesforce-custom-metadata/)
 * @example
 * List<CustomMetadata__mdt> nameCMList = (List<CustomMetadata__mdt>) new CustomMetadataDAO()
 *     .getCustomMetadataRecords(
 *         'SELECT MasterLabel, CustomField__c ' +
 *         'FROM CustomMetadata__mdt ' +
 *         'WHERE DeveloperName = \'Name\''
 *     );
 *
 * CustomMetadata__mdt name;
 * if (nameCMList.size() > 0) {
 *     name = nameCMList[0];
 * }
 * system.debug('Name: ' + name.MasterLabel);
 */
public inherited sharing class CustomMetadataDAO {
    /**
     * @description Is used to set the Custom Metadata Records in Unit Tests.
     *
     * @author Kenneth Soerensen (kenneth.sorensen@nav.com), NAV
     * @since 0.1.0, August 2024
     */
    @TestVisible
    static private Map<String, List<SObject>> customMetadataRecordsMap = new Map<String, List<SObject>>();

    /**
     * @description Get the Custom Metadata Records based on the SOQL query string provided.
     *
     * @author Kenneth Soerensen (kenneth.sorensen@nav.com), NAV
     * @since 0.1.0, August 2024
     * @param query The SOQL query string to fetch the Custom Metadata Records.
     * @return Return a list of Custom Metadata Records as `List<SObject>`
     * @example
     * List<CustomMetadata__mdt> nameCMList = (List<CustomMetadata__mdt>) new CustomMetadataDAO()
     *     .getCustomMetadataRecords(
     *         'SELECT MasterLable, CustomField__c ' +
     *         'FROM CustomMetadata__mdt ' +
     *         'WHERE DeveloperName = \'Name\''
     *     );
     *
     * CustomMetadata__mdt name;
     * if (nameCMList.size() > 0) {
     *     name = nameCMList[0];
     * }
     */
    public List<SObject> getCustomMetadataRecords(String query) {
        if (!customMetadataRecordsMap.containsKey(query)) {
            customMetadataRecordsMap.put(query, Database.query(query));
        }

        return customMetadataRecordsMap.get(query);
    }
}
