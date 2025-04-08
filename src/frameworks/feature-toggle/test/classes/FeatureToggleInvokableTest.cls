@IsTest(IsParallel=true)
@SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveRunAs'
) // In these tests we don't need to run as a specific user
private with sharing class FeatureToggleInvokableTest {
    @IsTest
    private static void isFeatureEnabledInvokable() {
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

        List<FeatureToggleInvokable.FeatureToogleResponse> response;

        Test.startTest();
        FeatureToggleInvokable.FeatureToogleRequest request1 = new FeatureToggleInvokable.FeatureToogleRequest(
            'Feature1',
            'FEATURE_FLAG'
        );
        FeatureToggleInvokable.FeatureToogleRequest request2 = new FeatureToggleInvokable.FeatureToogleRequest(
            'Feature2',
            'CUSTOM_PERMISSION'
        );

        response = FeatureToggleInvokable.isFeatureEnabledInvokable(
            new List<FeatureToggleInvokable.FeatureToogleRequest>{
                request1,
                request2
            }
        );
        Test.stopTest();

        System.Assert.isTrue(response.size() == 2, 'Expected 2 responses');
        System.Assert.isTrue(
            response[0].featureName == 'Feature1',
            'Expected Feature1'
        );
        System.Assert.isTrue(
            response[0].featureEnabled,
            'Expected Feature1 to be enabled'
        );
        System.Assert.isTrue(
            response[1].featureName == 'Feature2',
            'Expected Feature2'
        );
        System.Assert.isFalse(
            response[1].featureEnabled,
            'Did not expect Feature2 to be enabled'
        );
    }
}
