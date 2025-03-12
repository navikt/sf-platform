@IsTest
private with sharing class FeatureToggleBaseTest {
    @IsTest
    private static void noFeatures() {
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            new List<Feature_Flag__mdt>()
        );

        FeatureToggleBase featureToggle;

        Test.startTest();
        featureToggle = new FeatureToggleBase();
        Test.stopTest();

        System.Assert.isFalse(
            featureToggle.isFeatureEnabled('Feature1'),
            'Did not expect Feature1 to be enabled'
        );
        System.Assert.isNull(
            featureToggle.getFeatureFlag('Feature1'),
            'Did not expect to get a Feature Flag, only null'
        );
    }

    @IsTest
    private static void getFeatureFlagsException() {
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            new List<Feature_Flag__mdt>()
        );

        Exception expectedException;

        Test.startTest();
        FeatureToggleBase featureToggle = new FeatureToggleBase(null);
        try {
            featureToggle.isFeatureEnabled('Feature1');
        } catch (Exception e) {
            expectedException = e;
        }
        Test.stopTest();

        System.Assert.isInstanceOfType(
            expectedException,
            FeatureToggleException.class,
            'Expected a FeatureToggleException.'
        );
    }

    @IsTest
    private static void oneFeatureEnabled() {
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

        FeatureToggleBase featureToggle;

        Test.startTest();
        featureToggle = new FeatureToggleBase();
        Test.stopTest();

        System.Assert.isTrue(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be enabled'
        );
        System.Assert.isNotNull(
            featureToggle.getFeatureFlag('Feature1'),
            'Expected to get a Feature Flag'
        );
    }

    @IsTest
    private static void oneFeatureEnabledWithoutCustomSetting() {
        List<Feature_Flag__mdt> featureFlags = new List<Feature_Flag__mdt>();
        featureFlags.add(
            new Feature_Flag__mdt(
                MasterLabel = 'Feature1',
                DeveloperName = 'Feature1',
                Is_Enabled__c = true,
                Description__c = 'Feature 1',
                Required_Custom_Permission__c = 'Custom_Permission'
            )
        );
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            featureFlags
        );

        FeatureToggleBase featureToggle;

        Test.startTest();
        featureToggle = new FeatureToggleBase();
        Test.stopTest();

        System.Assert.isFalse(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be enabled'
        );
        System.Assert.isTrue(
            featureToggle.getFeatureFlag('Feature1').Is_Enabled__c,
            'Expected Is_Enabled___c to be true'
        );
    }

    @IsTest
    private static void oneFeatureDisabled() {
        List<Feature_Flag__mdt> featureFlags = new List<Feature_Flag__mdt>();
        featureFlags.add(
            new Feature_Flag__mdt(
                MasterLabel = 'Feature1',
                DeveloperName = 'Feature1',
                Is_Enabled__c = false,
                Description__c = 'Feature 1'
            )
        );
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            featureFlags
        );

        FeatureToggleBase featureToggle;

        Test.startTest();
        featureToggle = new FeatureToggleBase();
        Test.stopTest();

        System.Assert.isFalse(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be disabled'
        );
        System.Assert.isNotNull(
            featureToggle.getFeatureFlag('Feature1'),
            'Expected to get a Feature Flag'
        );
    }

    @IsTest
    private static void isFeatureEnabledException() {
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            new List<Feature_Flag__mdt>()
        );

        Exception expectedException;
        FeatureToggleBase featureToggle = new FeatureToggleBase();

        Test.startTest();
        try {
            featureToggle.isFeatureEnabled('Feature1', null);
        } catch (Exception e) {
            expectedException = e;
        }
        Test.stopTest();

        System.Assert.isInstanceOfType(
            expectedException,
            FeatureToggleException.class,
            'Expected a FeatureToggleException.'
        );
    }

    @IsTest
    private static void enableDisabledFeatureOnTheGo() {
        List<Feature_Flag__mdt> featureFlags = new List<Feature_Flag__mdt>();
        featureFlags.add(
            new Feature_Flag__mdt(
                MasterLabel = 'Feature1',
                DeveloperName = 'Feature1',
                Is_Enabled__c = false,
                Description__c = 'Feature 1'
            )
        );
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            featureFlags
        );

        FeatureToggleBase featureToggle = new FeatureToggleBase();

        Test.startTest();
        featureToggle.enableFeature('Feature1');
        Test.stopTest();

        System.Assert.isTrue(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be enabled'
        );
    }

    @IsTest
    private static void addFeaturesOnTheGo() {
        List<Feature_Flag__mdt> featureFlags = new List<Feature_Flag__mdt>();
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            featureFlags
        );

        FeatureToggleBase featureToggle;

        Test.startTest();
        featureToggle = new FeatureToggleBase();
        featureToggle.enableFeature('Feature1');
        Test.stopTest();

        System.Assert.isTrue(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be enabled'
        );
    }

    @IsTest
    private static void removeFeaturesOnTheGo() {
        List<Feature_Flag__mdt> featureFlags = new List<Feature_Flag__mdt>();
        featureFlags.add(
            new Feature_Flag__mdt(
                MasterLabel = 'Feature1',
                DeveloperName = 'Feature1',
                Is_Enabled__c = false,
                Description__c = 'Feature 1'
            )
        );
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            featureFlags
        );

        FeatureToggleBase featureToggle;

        Test.startTest();
        featureToggle = new FeatureToggleBase();
        featureToggle.disableFeature('Feature1');
        Test.stopTest();

        System.Assert.isFalse(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be enabled'
        );
        System.Assert.isNotNull(
            featureToggle.getFeatureFlag('Feature1'),
            'Expected to get a Feature Flag, we only removed it temporarily'
        );
    }

    @IsTest
    private static void disableEnabledFeatureOnTheGo() {
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

        FeatureToggleBase featureToggle = new FeatureToggleBase();

        Test.startTest();
        featureToggle.disableFeature('Feature1');
        Test.stopTest();

        System.Assert.isFalse(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be enabled'
        );
    }

    @IsTest
    private static void resetFeatures() {
        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            new List<Feature_Flag__mdt>{
                new Feature_Flag__mdt(
                    MasterLabel = 'Feature1',
                    DeveloperName = 'Feature1',
                    Is_Enabled__c = true,
                    Description__c = 'Feature 1'
                )
            }
        );

        FeatureToggleBase featureToggle;

        Test.startTest();
        featureToggle = new FeatureToggleBase();
        featureToggle.disableFeature('Feature1');
        featureToggle.enableFeature('Feature2');
        featureToggle.resetFeatureFlags();
        Test.stopTest();

        CustomMetadataDAO.customMetadataRecordsMap.put(
            FeatureToggleBase.METADATA_QUERY,
            new List<Feature_Flag__mdt>{
                new Feature_Flag__mdt(
                    MasterLabel = 'Feature1',
                    DeveloperName = 'Feature1',
                    Is_Enabled__c = true,
                    Description__c = 'Feature 1'
                )
            }
        );

        System.Assert.isTrue(
            featureToggle.isFeatureEnabled('Feature1'),
            'Expected Feature1 to be enabled'
        );
        System.Assert.isNotNull(
            featureToggle.getFeatureFlag('Feature1'),
            'Expected to get a Feature Flag, we only removed it temporarily'
        );
        System.Assert.isFalse(
            featureToggle.isFeatureEnabled('Feature2'),
            'Did not expect Feature2 to be enabled'
        );
    }

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
            FeatureToggleBase.isFeatureEnabled('Feature1', 'FEATURE_FLAG'),
            'Expected Feature1 to be enabled'
        );
        System.Assert.isFalse(
            FeatureToggleBase.isFeatureEnabled('Feature2', 'FEATURE_FLAG'),
            'Did not expect Feature2 to be enabled'
        );
        System.Assert.isFalse(
            FeatureToggleBase.isFeatureEnabled('Feature1', 'CUSTOM_PERMISSION'),
            'Did not expect Feature1 to be enabled'
        );
        System.Assert.isFalse(
            FeatureToggleBase.isFeatureEnabled('Feature2', 'CUSTOM_PERMISSION'),
            'Did not expect Feature2 to be enabled'
        );
        Test.stopTest();
    }

    @IsTest
    private static void isFeatureEnabledAuraException() {
        Exception expectedException;
        Test.startTest();
        try {
            FeatureToggleBase.isFeatureEnabled('Feature1', 'INVALID');
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

        List<FeatureToggleBase.FeatureToogleResponse> response;

        Test.startTest();
        FeatureToggleBase.FeatureToogleRequest request1 = new FeatureToggleBase.FeatureToogleRequest(
            'Feature1',
            'FEATURE_FLAG'
        );
        FeatureToggleBase.FeatureToogleRequest request2 = new FeatureToggleBase.FeatureToogleRequest(
            'Feature2',
            'CUSTOM_PERMISSION'
        );

        response = FeatureToggleBase.isFeatureEnabledInvokable(
            new List<FeatureToggleBase.FeatureToogleRequest>{
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
