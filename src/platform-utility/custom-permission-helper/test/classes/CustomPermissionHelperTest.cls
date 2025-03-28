/**
 * @description Test class for the CustomPermissionHelper class
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, March 2025
 */
@IsTest(IsParallel=true)
@SuppressWarnings(
    'PMD.ApexUnitTestClassShouldHaveRunAs'
) // We don't need to run as a specific user for this test class
private with sharing class CustomPermissionHelperTest {
    /**
     * @description Test the setCustomPermissionMaps method with null input
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void setCustomPermissionMapsWithNull() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        Exception testException;
        Test.startTest();
        try {
            customPermissionHelper.setCustomPermissionMaps(null);
        } catch (Exception e) {
            testException = e;
        }
        Test.stopTest();
        System.Assert.isInstanceOfType(
            testException,
            NullPointerException.class,
            'Expected a NullPointerException'
        );
    }

    /**
     * @description Test the setCustomPermissionMaps method with an empty list
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void setCustomPermissionMapsWithEmptyList() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        Test.startTest();
        customPermissionHelper.setCustomPermissionMaps(
            new List<CustomPermission>()
        );
        Test.stopTest();
        System.Assert.areEqual(
            0,
            customPermissionHelper.customPermissionMapById.size(),
            'The customPermissionMapById should be empty'
        );
        System.Assert.areEqual(
            0,
            customPermissionHelper.customPermissionMapByDeveloperName.size(),
            'The customPermissionMapByDeveloperName should be empty'
        );
    }

    /**
     * @description Test the setCustomPermissionMaps method with custom permissions
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void setCustomPermissionMapsWithCustomPermissions() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        List<CustomPermission> customPermissions = new List<CustomPermission>();
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('1', 'Test1')
        );
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('2', 'Test2')
        );

        Test.startTest();
        customPermissionHelper.setCustomPermissionMaps(customPermissions);
        Test.stopTest();

        System.Assert.areEqual(
            2,
            customPermissionHelper.customPermissionMapById.size(),
            'The customPermissionMapById should contain 2 elements'
        );
        System.Assert.areEqual(
            2,
            customPermissionHelper.customPermissionMapByDeveloperName.size(),
            'The customPermissionMapByDeveloperName should contain 2 elements'
        );
        System.Assert.isTrue(
            customPermissionHelper.customPermissionMapById.containsKey(
                customPermissions[0].Id
            ),
            'The customPermissionMapById should contain the key 1'
        );
        System.Assert.isTrue(
            customPermissionHelper.customPermissionMapById.containsKey(
                customPermissions[1].Id
            ),
            'The customPermissionMapById should contain the key 2'
        );
        System.Assert.isTrue(
            customPermissionHelper.customPermissionMapByDeveloperName.containsKey(
                'Test1'
            ),
            'The customPermissionMapByDeveloperName should contain the key Test1'
        );
        System.Assert.isTrue(
            customPermissionHelper.customPermissionMapByDeveloperName.containsKey(
                'Test2'
            ),
            'The customPermissionMapByDeveloperName should contain the key Test2'
        );
    }

    /**
     * @description Test the validateCustomPermission method with a non existent permission
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void validateCustomPermissionNonExistentPermission() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        List<CustomPermission> customPermissions = new List<CustomPermission>();
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('1', 'Test1')
        );
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('2', 'Test2')
        );
        customPermissionHelper.setCustomPermissionMaps(customPermissions);

        Exception testException;
        Test.startTest();
        try {
            customPermissionHelper.validateCustomPermission('Test3');
        } catch (Exception e) {
            testException = e;
        }
        Test.stopTest();
        System.Assert.isInstanceOfType(
            testException,
            CustomPermissionHelperException.class,
            'Expected a CustomPermissionHelperException'
        );
    }

    /**
     * @description Test the validateCustomPermission method with no custom permissions loaded
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void validateCustomPermissionNoCustomPermissionsLoaded() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        customPermissionHelper.setCustomPermissionMaps(
            new List<CustomPermission>()
        );

        Exception testException;
        Test.startTest();
        try {
            customPermissionHelper.validateCustomPermission('Test1');
        } catch (Exception e) {
            testException = e;
        }
        Test.stopTest();
        System.Assert.isInstanceOfType(
            testException,
            CustomPermissionHelperException.class,
            'Expected a CustomPermissionHelperException'
        );
    }

    /**
     * @description Test the validateCustomPermission method with null input, should throw an exception
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void validateCustomPermissionNullInput() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        List<CustomPermission> customPermissions = new List<CustomPermission>();
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('1', 'Test1')
        );
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('2', 'Test2')
        );
        customPermissionHelper.setCustomPermissionMaps(customPermissions);

        Exception testException;
        Test.startTest();
        try {
            customPermissionHelper.validateCustomPermission(null);
        } catch (Exception e) {
            testException = e;
        }
        Test.stopTest();
        System.Assert.isInstanceOfType(
            testException,
            CustomPermissionHelperException.class,
            'Expected a CustomPermissionHelperException'
        );
    }

    /**
     * @description Test the validateCustomPermission method with blank input, should throw a an exception
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void validateCustomPermissionBlankInput() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        List<CustomPermission> customPermissions = new List<CustomPermission>();
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('1', 'Test1')
        );
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('2', 'Test2')
        );
        customPermissionHelper.setCustomPermissionMaps(customPermissions);

        Exception testException;
        Test.startTest();
        try {
            customPermissionHelper.validateCustomPermission('');
        } catch (Exception e) {
            testException = e;
        }
        Test.stopTest();
        System.Assert.isInstanceOfType(
            testException,
            CustomPermissionHelperException.class,
            'Expected a CustomPermissionHelperException'
        );
    }

    /**
     * @description Test the validateCustomPermission method with an existing permission
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void validateCustomPermissionExistentPermission() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        List<CustomPermission> customPermissions = new List<CustomPermission>();
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('1', 'Test1')
        );
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('2', 'Test2')
        );
        customPermissionHelper.setCustomPermissionMaps(customPermissions);

        Test.startTest();
        CustomPermissionHelper customPermissionHelper2 = customPermissionHelper.validateCustomPermission(
            'Test1'
        );
        Test.stopTest();
        System.Assert.areEqual(
            customPermissionHelper,
            customPermissionHelper2,
            'The customPermissionHelper should be returned'
        );
    }

    /**
     * @description Test the getAssignedCustomPermissions method with no custom permissions loaded
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void getSetupEntityAccesses() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper()
            .setCustomPermissionMaps(new List<CustomPermission>());
        Test.startTest();
        List<SetupEntityAccess> result = customPermissionHelper
            .getSetupEntityAccesses(UserInfo.getUserId());
        Test.stopTest();

        System.Assert.isNotNull(result, 'The result should not be null');
        System.Assert.areEqual(
            0,
            result.size(),
            'Expected an empty list when querying for SetupEntityAccesses'
        );
    }

    /**
     * @description Test the getSetupEntityAccesses method with null input
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void getSetupEntityAccessesNullInput() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper()
            .setCustomPermissionMaps(new List<CustomPermission>());
        Test.startTest();
        List<SetupEntityAccess> result = customPermissionHelper
            .getSetupEntityAccesses(null);
        Test.stopTest();
        System.Assert.isNotNull(result, 'The result should not be null');
    }

    /**
     * @description Test the hasCustomPermission method with running user and non existing custom permission.
     * This  method uses the standard way of getting a custom permission in Salesforce.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void hasCustomPermission() {
        Test.startTest();
        Boolean result = new CustomPermissionHelper()
            .hasCustomPermission('Test1');
        Test.stopTest();
        System.Assert.isFalse(
            result,
            'Expected false when testing with a non assigned custom permission'
        );
    }

    /**
     * @description Test the getAssignedCustomPermissions method with an existing user and custom permissions, but without any assigned custom permissions
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void hasCustomPermissionWithUserAndNonexistingPermission() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        customPermissionHelper.setAssignedCustomPermissionsByUser(
            UserInfo.getUserId(),
            new List<SetupEntityAccess>()
        );

        Test.startTest();
        Boolean result = customPermissionHelper.hasCustomPermission(
            UserInfo.getUserId(),
            'Test1'
        );
        Test.stopTest();
        System.Assert.isFalse(
            result,
            'Expected false when testing with a non existing custom permission'
        );
    }

    /**
     * @description Test the getAssignedCustomPermissions method with an existing user and custom permissions
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void hasCustomPermissionWithUserAndExistingPermission() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();
        List<CustomPermission> customPermissions = new List<CustomPermission>();
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('1', 'Test1')
        );
        customPermissions.add(
            CustomPermissionHelperStub.createCustomPermission('2', 'Test2')
        );
        customPermissionHelper.setCustomPermissionMaps(customPermissions);

        customPermissionHelper.setAssignedCustomPermissionsByUser(
            UserInfo.getUserId(),
            new List<SetupEntityAccess>{
                CustomPermissionHelperStub.createSetupEntityAccess('1'),
                CustomPermissionHelperStub.createSetupEntityAccess('2')
            }
        );

        Test.startTest();
        Boolean result = customPermissionHelper.hasCustomPermission(
            UserInfo.getUserId(),
            'Test1'
        );
        Test.stopTest();
        System.Assert.isTrue(
            result,
            'Expected true when testing with an existing custom permission'
        );
    }

    /**
     * @description Test the getAssignedCustomPermissions method with an existing user and custom permissions, but without preloading custom permissions. This should throw an exception.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void setAssignedCustomPermissionsByUserWithoutPreloadingCustomPermissions() {
        CustomPermissionHelper customPermissionHelper = new CustomPermissionHelper();

        Exception testException;

        Test.startTest();
        try {
            customPermissionHelper.setAssignedCustomPermissionsByUser(
                UserInfo.getUserId(),
                new List<SetupEntityAccess>{
                    CustomPermissionHelperStub.createSetupEntityAccess('1'),
                    CustomPermissionHelperStub.createSetupEntityAccess('2')
                }
            );
        } catch (Exception e) {
            testException = e;
        }
        Test.stopTest();

        System.Assert.isInstanceOfType(
            testException,
            CustomPermissionHelperException.class,
            'Expected a CustomPermissionHelperException'
        );
    }
}
