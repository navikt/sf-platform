/**
 * @description This is the test class for the Custom Metadata Data Access Object class.
 * <br><br>
 * Inspiration for this way of solving the problem is taken form the article
 * "Get 100% Code Coverage for Salesforce Custom Metadata Based Decisions".
 *
 * @author Kenneth Soerensen (kenneth.sorensen@nav.com), NAV
 * @since 0.1.0, August 2024
 *
 * @author Tor Håkon Sigurdsen, Nav
 * @since 2025-01-14 - Made tests independent from Custom Metadata types in the orgs
 *
 * @group Custom Metadata DAO
 * @see CustomMetadataDAO
 * @see [Get 100% Code Coverage for Salesforce Custom Metadata Based Decisions](https://www.avenga.com/magazine/salesforce-custom-metadata/)
 * @example
 * CustomMetadataDAOTest.setMetadata(
 *   'SELECT MasterLabel ' +
 *   'FROM CustomMetadata__mdt ' +
 *   'WHERE DeveloperName = \'Name\'',
 *   (List<CustomMetadata__mdt>) JSON.deserialize(
 *     '[{"attributes": {"type": "CustomMetadata__mdt"},"MasterLabel":"Value"}]',
 *     List<CustomMetadata__mdt>.class)
 * );
 *
 * List<CustomMetadata__mdt> nameCMList = (List<CustomMetadata__mdt>) new CustomMetadataDAO()
 *   .getCustomMetadataRecords(
 *       'SELECT MasterLable, CustomField__c ' +
 *       'FROM CustomMetadata__mdt ' +
 *       'WHERE DeveloperName = \'Name\''
 *   );
 *
 * CustomMetadata__mdt name;
 * if (nameCMList.size() > 0) {
 *     name = nameCMList[0];
 * }
 */
@IsTest(IsParallel=true)
@SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveRunAs'
) // In these tests we don't need to run as a specific user
public class CustomMetadataDAOTest {
    @IsTest
    private static void getCustomMetadataRecords() {
        System.Test.startTest();
        List<SObject> customMetadataRecords = new CustomMetadataDAO()
            .getCustomMetadataRecords(
                'SELECT Id ' + 'FROM Account ' + 'LIMIT 1'
            );
        System.Test.stopTest();

        System.Assert.isNotNull(
            customMetadataRecords,
            'Did not expect any custom metadata records'
        );
        System.Assert.areEqual(
            0,
            customMetadataRecords.size(),
            'Expected size should be 0'
        );
    }

    /**
     * @description Simple test for the getMetadata method.
     */
    @IsTest
    private static void testGetMetadata() {
        List<SObject> customMetadataRecords;
        String query =
            'SELECT MasterLabel ' +
            'FROM CustomMetadata__mdt ' +
            'WHERE DeveloperName = \'Name\'';

        // We set the type to Account in order to not be dependent on any Custom Metadata types
        CustomMetadataDAOTest.setMetadata(
            query,
            (List<SObject>) JSON.deserialize(
                '[{"attributes": {"type": "Account"},"MasterLabel":"Label"}]',
                List<SObject>.class
            )
        );

        System.Test.startTest();
        customMetadataRecords = new CustomMetadataDAO()
            .getCustomMetadataRecords(query);
        System.Test.stopTest();
        System.Assert.areEqual(
            1,
            customMetadataRecords.size(),
            'Size should match'
        );
    }

    /**
     * @description A utility method to set custom metadata records for the tests.
     *
     * @author Kenneth Soerensen (kenneth.sorensen@nav.com), NAV
     * @since 0.1.0, August 2024
     * @param query The SOQL query string to fetch the Custom Metadata Records.
     * @param records Set Custom Metadata Records for the tests.
     * @example
     * CustomMetadataDAOTest.setMetadata(
     *   'SELECT MasterLabel ' +
     *   'FROM CustomMetadata__mdt ' +
     *   'WHERE DeveloperName = \'Name\'',
     *   (List<CustomMetadata__mdt>) JSON.deserialize(
     *     '[{"attributes": {"type": "CustomMetadata__mdt"},"MasterLabel":"Value"}]',
     *   List<CustomMetadata__mdt>.class)
     * );
     *
     * List<CustomMetadata__mdt> nameCMList = (List<CustomMetadata__mdt>) new CustomMetadataDAO()
     *   .getCustomMetadataRecords(
     *       'SELECT MasterLabel ' +
     *       'FROM CustomMetadata__mdt ' +
     *       'WHERE DeveloperName = \'Name\''
     *   );
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
