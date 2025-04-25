@IsTest(IsParallel=true)
@SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveRunAs'
) // In these tests we don't need to run as a specific user
private with sharing class FeatureToggleBaseTest {
    @IsTest
    private static void featureToggleBaseWithNullInput() {
        Test.startTest();
        FeatureToggleBase featureToggle = new FeatureToggleBase(null, null);
        Test.stopTest();

        System.Assert.isNotNull(
            featureToggle,
            'Expected FeatureToggleBase to be initialized'
        );
    }

    @IsTest
    private static void getFeatureFlagsThrowException() {
        CustomMetadataDAOTest.setMetadata(
            FeatureToggleBase.METADATA_QUERY,
            null
        );
        Exception expectedException = null;

        Test.startTest();
        try {
            new FeatureToggleBase().getFeatureFlags();
        } catch (FeatureToggleException e) {
            expectedException = e;
        }
        Test.stopTest();
        System.Assert.isInstanceOfType(
            expectedException,
            FeatureToggleException.class,
            'Expected FeatureToggleException to be thrown'
        );
    }

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
    private static void hasCustomPermissionWithInvalidCustomPermissionAndNoValidation() {
        System.Test.startTest();
        Boolean result = new FeatureToggleBase()
            .hasCustomPermission('Feature1');
        System.Test.stopTest();

        System.Assert.isFalse(result, 'Expected Feature1 to be disabled');
    }

    @IsTest
    private static void hasCustomPermissionWithInvalidCustomPermissionAndValidation() {
        Exception expectedException = null;
        System.Test.startTest();
        try {
            FeatureToggle.setValidateCustomPermissions(true);
            new FeatureToggleBase().hasCustomPermission('Feature1');
        } catch (Exception e) {
            expectedException = e;
        }
        System.Test.stopTest();
        System.Assert.isInstanceOfType(
            expectedException,
            CustomPermissionHelperException.class,
            'Expected FeatureToggleException to be thrown'
        );
    }

    @IsTest
    private static void hasCustomPermissionWithValidCustomPermissionAndValidation() {
        CustomPermissionHelper customPermissionHelperMock = new CustomPermissionHelperStub()
            .addHasCustomPermission(true)
            .addValidateCustomPermissionResult(true)
            .getMock();

        System.Test.startTest();
        FeatureToggle.setValidateCustomPermissions(true);
        Boolean result = new FeatureToggleBase(null, customPermissionHelperMock)
            .hasCustomPermission('Feature1');
        System.Test.stopTest();

        System.Assert.isTrue(result, 'Expected Feature1 to be active');
    }

    @IsTest
    private static void hasCustomPermissionWithValidCustomPermissionAndNoValidation() {
        CustomPermissionHelper customPermissionHelperMock = new CustomPermissionHelperStub()
            .addHasCustomPermission(true)
            .getMock();
        System.Test.startTest();
        Boolean result = new FeatureToggleBase(null, customPermissionHelperMock)
            .hasCustomPermission('Feature1');
        System.Test.stopTest();

        System.Assert.isTrue(result, 'Expected Feature1 to be active');
    }
}
