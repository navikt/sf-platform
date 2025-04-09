/**
 * @description Test class for FeatureToggle functionality
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, April 2025 - Created
 */
@IsTest(IsParallel=true)
@SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveRunAs'
) // In these tests we don't need to run as a specific user
private with sharing class FeatureToggleTest {
    /**
     * @description Tests the default value of the validateCustomPermissions flag
     */
    @IsTest
    private static void testDefaultValidateCustomPermissions() {
        // No setup needed for default value test

        Test.startTest();
        Boolean result = FeatureToggle.shouldValidateCustomPermissions();
        Test.stopTest();

        System.assertEquals(
            false,
            result,
            'Expected custom permission validation to be disabled by default'
        );
    }

    /**
     * @description Tests setting and retrieving the validateCustomPermissions flag
     */
    @IsTest
    private static void testSetValidateCustomPermissions() {
        Test.startTest();
        FeatureToggle.setValidateCustomPermissions(true);
        System.assertEquals(
            true,
            FeatureToggle.shouldValidateCustomPermissions(),
            'Expected custom permission validation to be enabled'
        );

        FeatureToggle.setValidateCustomPermissions(false);
        System.assertEquals(
            false,
            FeatureToggle.shouldValidateCustomPermissions(),
            'Expected custom permission validation to be disabled'
        );
        Test.stopTest();
    }

    /**
     * @description Tests the ToggleType enum values
     */
    @IsTest
    private static void testToggleTypeEnum() {
        Test.startTest();
        FeatureToggle.ToggleType[] toggleTypes = FeatureToggle.ToggleType.values();
        Test.stopTest();

        System.assertEquals(2, toggleTypes.size(), 'Expected 2 toggle types');
        System.assertEquals(
            FeatureToggle.ToggleType.CUSTOM_PERMISSION,
            toggleTypes[0],
            'Expected CUSTOM_PERMISSION as first enum value'
        );
        System.assertEquals(
            FeatureToggle.ToggleType.FEATURE_FLAG,
            toggleTypes[1],
            'Expected FEATURE_FLAG as second enum value'
        );
    }
}
