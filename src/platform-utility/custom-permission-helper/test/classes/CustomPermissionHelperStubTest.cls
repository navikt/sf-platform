/**
 * @description Test class for the CustomPermissionHelperStub class
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, March 2025
 */
@IsTest
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
private with sharing class CustomPermissionHelperStubTest {
    /**
     * @description Test the hasCustomPermission method with a false return value
     */
    @IsTest
    private static void hasCustomPermissionFalse() {
        CustomPermissionHelperStub stub = new CustomPermissionHelperStub();
        stub.addHasCustomPermission(false);
        Test.startTest();
        CustomPermissionHelper customPermissionHelper = stub.getMock();
        Boolean hasCustomPermission = customPermissionHelper.hasCustomPermission(
            'Test'
        );
        Test.stopTest();
        System.Assert.isFalse(
            hasCustomPermission,
            'The stub should have returned false'
        );
    }

    /**
     * @description Test the hasCustomPermission method with a true return value
     */
    @IsTest
    private static void hasCustomPermissionTrue() {
        CustomPermissionHelperStub stub = new CustomPermissionHelperStub();
        stub.addHasCustomPermission(true);
        Test.startTest();
        CustomPermissionHelper customPermissionHelper = stub.getMock();
        Boolean hasCustomPermission = customPermissionHelper.hasCustomPermission(
            'Test'
        );
        Test.stopTest();
        System.Assert.isTrue(
            hasCustomPermission,
            'The stub should have returned true'
        );
    }
}
