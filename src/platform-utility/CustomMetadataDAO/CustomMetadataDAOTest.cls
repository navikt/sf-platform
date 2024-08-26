/**
 * @description This is the test class for the Custom Metadata Data Access Object class.
 * <br><br>
 * Inspiration for this way of solving the problem is taken form the article
 * "Get 100% Code Coverage for Salesforce Custom Metadata Based Decisions".
 *
 * @author Kenneth Soerensen (kenneth.sorensen@nav.com), NAV
 * @since 0.1.0, August 2024
 * @group Custom Metadata DAO
 * @see CustomMetadataDAO
 * @see [Get 100% Code Coverage for Salesforce Custom Metadata Based Decisions](https://www.avenga.com/magazine/salesforce-custom-metadata/)
 * @example
 * CustomMetadataDAOTest.setMetadata(
 *     'SELECT MasterLable, CustomField__c ' +
 *     'FROM CustomMetadata__mdt ' +
 *     'WHERE DeveloperName = \'Name\'',
 *     (List<CustomMetadata__mdt>) JSON.deserialize('[{"CustomField__c":"Value"}]', List<CustomMetadata__mdt>.class)
 * );
 *
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
@IsTest
public class CustomMetadataDAOTest {
    /**
     * @description Simple test for the getMetadata method.
     */
    @IsTest
    static void testGetMetadata() {
        List<SObject> customMetadataRecords;
        System.Test.startTest();
        customMetadataRecords = new CustomMetadataDAO()
            .getCustomMetadataRecords(
                'SELECT MasterLabel FROM API_Base_Configuration__mdt'
            );
        System.Test.stopTest();
        System.assertEquals(
            [SELECT MasterLabel FROM API_Base_Configuration__mdt].size(),
            customMetadataRecords.size(),
            'Size should match'
        );
    }

    /**
     * @description A utility method to set custom metadata records for the tests.
     *
     * @param query The SOQL query string to fetch the Custom Metadata Records.
     * @param records Set Custom Metadata Records for the tests.
     * @example
     * CustomMetadataDAOTest.setMetadata(
     *     'SELECT MasterLable, CustomField__c ' +
     *     'FROM CustomMetadata__mdt ' +
     *     'WHERE DeveloperName = \'Name\'',
     *     (List<CustomMetadata__mdt>) JSON.deserialize('[{"CustomField__c":"Value"}]', List<CustomMetadata__mdt>.class)
     * );
     *
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
    public static void setMetadata(String query, List<SObject> records) {
        CustomMetadataDAO.customMetadataRecordsMap.put(query, records);
    }
}
