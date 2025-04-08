@IsTest(IsParallel=true)
@SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveRunAs'
) // In these tests we don't need to run as a specific user
private with sharing class FeatureToggleTest {
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
}
