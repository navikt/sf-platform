/**
 * @description Helper class for checking custom permissions.
 * The easiest way to check if the running user has permsissions is to use the `FeatureManagement.checkPermission` method.
 * This class is intended to be used when you need to check:
 * - Multiple custom permissions.
 * - Custom permissions in a test context.
 * - Custom permissions for a different user than the running user.
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, March 2025
 * @group Custom Permission Helper
 * @example
 * Eksempel på bruk:
 * ```
 * Set<String> myCustomPermissionsSet = new CustomPermissionHelper().setCustomPermissionMaps().getAssignedCustomPermissions();
 * ```
 */
public inherited sharing class CustomPermissionHelper {
    @TestVisible
    private Map<Id, Set<String>> usersCustomPermissionsMap;
    @TestVisible
    private Map<Id, CustomPermission> customPermissionMapById;
    @TestVisible
    private Map<String, CustomPermission> customPermissionMapByDeveloperName;

    /**
     * @description Load all custom permissions into maps.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @return `CustomPermissionHelper` instance
     */
    public CustomPermissionHelper setCustomPermissionMaps() {
        return this.setCustomPermissionMaps(
            [SELECT Id, DeveloperName FROM CustomPermission LIMIT 1000]
        );
    }

    /**
     * @description Load all custom permissions into maps.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param customPermissions List of custom permissions to load into the maps
     * @return  `CustomPermissionHelper` instance
     */
    public CustomPermissionHelper setCustomPermissionMaps(
        List<CustomPermission> customPermissions
    ) {
        customPermissionMapById = new Map<Id, CustomPermission>();
        customPermissionMapByDeveloperName = new Map<String, CustomPermission>();
        for (CustomPermission customPermission : customPermissions) {
            customPermissionMapById.put(customPermission.Id, customPermission);
            customPermissionMapByDeveloperName.put(
                customPermission.DeveloperName,
                customPermission
            );
        }
        return this;
    }

    /**
     * @description Validate that the custom permission exists. If not, throw an exception.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param customPermissionDeveloperName Developer name of the custom permission to validate
     * @return self for chaining
     * @exception Throws `CustomPermissionHelperException` if custom permission with developer name is not found
     */
    public CustomPermissionHelper validateCustomPermission(
        String customPermissionDeveloperName
    ) {
        if (
            !customPermissionMapByDeveloperName.containsKey(
                customPermissionDeveloperName
            )
        ) {
            throw new CustomPermissionHelperException(
                'Custom Permission with Developer Name ' +
                    customPermissionDeveloperName +
                    ' not found'
            );
        }
        return this;
    }

    /**
     * @description Get the running users assigned custom permissions
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @return  `Set<String>` containing the developer name of the assigned custom permissions
     */
    public Set<String> getAssignedCustomPermissions() {
        return getAssignedCustomPermissions(UserInfo.getUserId());
    }

    /**
     * @description get the assigned custom permissions for a user
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param userId of the user to get the assigned custom permissions for
     * @return  `Set<String>` containing the developer name of the assigned custom permissions
     */
    public Set<String> getAssignedCustomPermissions(Id userId) {
        if (!this.usersCustomPermissionsMap.containsKey(userId)) {
            setAssignedCustomPermissionsByUser(
                userId,
                this.getSetupEntityAccesses(userId)
            );
        }
        return this.usersCustomPermissionsMap.get(userId);
    }

    /**
     * @description Check if the running user has a custom permission
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param customPermissionDeveloperName Developer name of the custom permission to check
     * @return  `Boolean` indicating if the running user has the custom permission
     */
    public Boolean hasCustomPermission(String customPermissionDeveloperName) {
        return FeatureManagement.checkPermission(customPermissionDeveloperName);
    }

    /**
     * @description Check if a user has a custom permission
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param userId of the user to check the custom permission for
     * @param customPermissionDeveloperName Developer name of the custom permission to check
     * @return  `Boolean` indicating if the user has the custom permission
     */
    public Boolean hasCustomPermission(
        Id userId,
        String customPermissionDeveloperName
    ) {
        return getAssignedCustomPermissions(userId)
            .contains(customPermissionDeveloperName);
    }

    /**
     * @description Load the assigned custom permissions for users
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param userId of the user to load the assigned custom permissions for
     * @param setupEntityAccessesList List of SetupEntityAccess objects for the users
     * @return  `CustomPermissionHelper` instance
     */
    @TestVisible
    private CustomPermissionHelper setAssignedCustomPermissionsByUser(
        Id userId,
        List<SetupEntityAccess> setupEntityAccessesList
    ) {
        if (usersCustomPermissionsMap == null) {
            usersCustomPermissionsMap = new Map<Id, Set<String>>();
        }

        usersCustomPermissionsMap.put(userId, new Set<String>());
        for (SetupEntityAccess setupEntityAccess : setupEntityAccessesList) {
            if (
                customPermissionMapById == null ||
                !customPermissionMapById.containsKey(
                    setupEntityAccess.SetupEntityId
                )
            ) {
                throw new CustomPermissionHelperException(
                    'Could not map Custom Permissions to user. Custom Permission with Id ' +
                        setupEntityAccess.SetupEntityId +
                        ' not found. Try calling setCustomPermissionMaps() first.'
                );
            }
            usersCustomPermissionsMap.get(userId)
                .add(
                    customPermissionMapById.get(setupEntityAccess.SetupEntityId)
                        .DeveloperName
                );
        }
        return this;
    }

    /**
     * @description Get the SetupEntityAccess objects for the provided user
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025
     * @param userId of the user to get the SetupEntityAccess objects for
     * @return  `List<SetupEntityAccess>` containing the SetupEntityAccess objects for the provided users
     */
    @TestVisible
    private List<SetupEntityAccess> getSetupEntityAccesses(Id userId) {
        return [
            SELECT SetupEntityId
            FROM SetupEntityAccess
            WHERE
                SetupEntityId IN :customPermissionMapById.keySet()
                AND ParentId IN (
                    SELECT PermissionSetId
                    FROM PermissionSetAssignment
                    WHERE AssigneeId = :userId
                )
            WITH SECURITY_ENFORCED
        ];
    }
}
