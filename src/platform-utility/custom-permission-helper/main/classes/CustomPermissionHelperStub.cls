/**
 * @description CustomPermissionHelperStub class
 * This class is used to stub the CustomPermissionHelper class in the test
 * context. This class is used to provide a stub implementation of the
 * CustomPermissionHelper class for testing
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, March 2025
 */
@IsTest
public with sharing class CustomPermissionHelperStub implements System.StubProvider {
    private List<Boolean> hasCustomPermissionList;

    /**
     * @description Constructor
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     */
    public CustomPermissionHelperStub() {
        this.hasCustomPermissionList = new List<Boolean>();
    }

    /**
     * @description Add wanted stub response from the hasCustomPermission method
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param hasCustomPermission true or false
     * @return  `CustomPermissionHelperStub`
     */
    public CustomPermissionHelperStub addHasCustomPermission(
        Boolean hasCustomPermission
    ) {
        this.hasCustomPermissionList.add(hasCustomPermission);
        return this;
    }

    /**
     * @description Handle the method call
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param stubbedObject The object that is being stubbed
     * @param stubbedMethodName The name of the method that is being stubbed
     * @param returnType The return type of the method
     * @param listOfParamTypes The list of parameter types
     * @param listOfParamNames The list of parameter names
     * @param listOfArgs The list of arguments
     * @return The return value of the method
     */
    @SuppressWarnings(
        'PMD.ExcessiveParameterList'
    ) // PMD is disabled for this method as this is a required method for the StubProvider interface
    public Object handleMethodCall(
        Object stubbedObject,
        String stubbedMethodName,
        Type returnType,
        List<Type> listOfParamTypes,
        List<String> listOfParamNames,
        List<Object> listOfArgs
    ) {
        if (stubbedMethodName == 'hasCustomPermission') {
            return this.hasCustomPermissionList.remove(0);
        }
        return null;
    }

    /**
     * @description Get the mock object
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @return The mock object
     */
    public CustomPermissionHelper getMock() {
        return (CustomPermissionHelper) System.Test.createStub(
            CustomPermissionHelper.class,
            this
        );
    }

    /**
     * @description Create a CustomPermission object
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param id The ID of the CustomPermission
     * @param developerName The developer name of the CustomPermission
     * @return The CustomPermission object
     */
    public static CustomPermission createCustomPermission(
        String id,
        String developerName
    ) {
        if (id.length() != 15 || id.length() != 18) {
            id = getCustomPermissionId(id);
        }
        return (CustomPermission) JSON.deserialize(
            '{"attributes": {"type": "CustomPermission"},"Id": "' +
                id +
                '","DeveloperName": "' +
                developerName +
                '"}',
            CustomPermission.class
        );
    }

    /**
     * @description Get a CustomPermission ID
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param id The ID of the CustomPermission
     * @return The CustomPermission ID
     */
    public static Id getCustomPermissionId(String id) {
        return CustomPermission.sObjectType
                .getDescribe(SObjectDescribeOptions.DEFERRED)
                .getKeyPrefix() + id.leftPad(15, '1T00000wXYZ12AB'); //NOPMD - We are not using a hardcoded ID, we dynamically set the prefix and generate an ID
    }

    /**
     * @description Create a SetupEntityAccess object
     *
     * @param setupEntityId The ID of the SetupEntityAccess
     * @return The SetupEntityAccess object
     */
    public static SetupEntityAccess createSetupEntityAccess(
        String setupEntityId
    ) {
        if (setupEntityId.length() != 15 || setupEntityId.length() != 18) {
            setupEntityId = getCustomPermissionId(setupEntityId);
        }
        return (SetupEntityAccess) JSON.deserialize(
            '{"attributes": {"type": "SetupEntityAccess"},"SetupEntityId": "' +
                setupEntityId +
                '"}',
            SetupEntityAccess.class
        );
    }
}
