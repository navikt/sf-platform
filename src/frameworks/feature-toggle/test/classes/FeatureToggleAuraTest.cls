@IsTest(IsParallel=true)
@SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveRunAs'
) // In these tests we don't need to run as a specific user
private with sharing class FeatureToggleAuraTest {
    @IsTest
    private static void isFeatureEnabledAuraEnabled() {
        List<Feature_Flag__mdt> featureFlags = new List<Feature_Flag__mdt>();
        featureFlags.add(
            new Feature_Flag__mdt(
                MasterLabel = 'Feature1',
                DeveloperName = 'Feature1',
                Is_Enabled__c = true,
                Description__c = 'Feature 1'
            )
        );
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            featureFlags
        );

        Test.startTest();
        System.Assert.isTrue(
            FeatureToggleAura.isFeatureEnabled('Feature1', 'FEATURE_FLAG'),
            'Expected Feature1 to be enabled'
        );
        System.Assert.isFalse(
            FeatureToggleAura.isFeatureEnabled('Feature2', 'FEATURE_FLAG'),
            'Did not expect Feature2 to be enabled'
        );
        try {
            FeatureToggleAura.isFeatureEnabled('Feature1', 'CUSTOM_PERMISSION');
        } catch (Exception e) {
            System.Assert.isInstanceOfType(
                e,
                AuraHandledException.class,
                'Expected a AuraHandledException.'
            );

            System.Assert.isTrue(
                e.getMessage()
                    .startsWith(
                        'Something went wrong when checking the feature Feature1 with toogle type CUSTOM_PERMISSION:'
                    ),
                'Expected a specific error message. got: ' + e.getMessage()
            );
        }
        try {
            FeatureToggleAura.isFeatureEnabled('Feature2', 'CUSTOM_PERMISSION');
        } catch (Exception e) {
            System.Assert.isInstanceOfType(
                e,
                AuraHandledException.class,
                'Expected a AuraHandledException.'
            );

            System.Assert.isTrue(
                e.getMessage()
                    .startsWith(
                        'Something went wrong when checking the feature Feature2 with toogle type CUSTOM_PERMISSION:'
                    ),
                'Expected a specific error message. got: ' + e.getMessage()
            );
        }
        Test.stopTest();
    }

    @IsTest
    private static void isFeatureEnabledAuraException() {
        Exception expectedException;
        Test.startTest();
        try {
            FeatureToggleAura.isFeatureEnabled('Feature1', 'INVALID');
        } catch (Exception e) {
            expectedException = e;
        }
        Test.stopTest();

        System.Assert.isInstanceOfType(
            expectedException,
            AuraHandledException.class,
            'Expected a AuraHandledException.'
        );
    }
}
