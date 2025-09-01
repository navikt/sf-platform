public without sharing class AdGroupSyncService {
    private UserRepository userRepository = new UserRepository();
    public void addRemoveGroupsAndPerms(
        UserDomain currentUser,
        List<String> adGroupIds
    ) {
        LoggerUtility logger = new LoggerUtility(
            CRM_ApplicationDomain.Domain.PLATFORCE,
            'LoginFlow'
        );
        try {
            Boolean hasAccessToThemes = userRepository.checkUserThemeAccess(
                currentUser
            );
            //get public groups with id mapped to ad group
            Map<Id, AdGroup> adGroupBySalesforceGroupId = getAdGroupBySalesforceGroupId(
                hasAccessToThemes
            );
            Set<Id> usersSalesforceMembership = getUsersSalesforceMemberships(
                currentUser.recordId,
                adGroupBySalesforceGroupId.keySet()
            );

            //add group memberships
            List<GroupMember> membershipsToInsert = new List<GroupMember>();
            List<PermissionSetAssignment> permissionSetAssignments = new List<PermissionSetAssignment>();
            Set<String> permsetsToAssign = new Set<String>();
            Set<String> permsetGroupsToAssign = new Set<String>();
            for (Id salesforceGroupId : adGroupBySalesforceGroupId.keySet()) {
                AdGroup adGroup = adGroupBySalesforceGroupId.get(
                    salesforceGroupId
                );

                //check if user is member of ad group but not in Salesforce
                if (
                    new Set<String>(adGroupIds)
                        .containsAll(adGroup.adGroupId.split(',')) &&
                    !usersSalesforceMembership.contains(salesforceGroupId)
                ) {
                    //add membership
                    membershipsToInsert.add(
                        new GroupMember(
                            UserOrGroupId = currentUser.recordId,
                            GroupId = salesforceGroupId
                        )
                    );

                    //assign permission set if necessary
                    if (adGroup.permissionSet != null) {
                        permsetsToAssign.add(adGroup.permissionSet);
                    }

                    //Handle permset groups
                    if (adGroup.permissionSetGroup != null) {
                        permsetGroupsToAssign.add(adGroup.permissionSetGroup);
                    }
                }
            }

            if (permsetsToAssign.size() > 0) {
                List<PermissionSet> permissionSets = [
                    SELECT Id
                    FROM PermissionSet
                    WHERE Name IN :permsetsToAssign
                ]; //NOPMD - Fetching permission sets should only be allowed in the context of the login flow

                if (permissionSets.size() > 0) {
                    //assign permission set
                    for (PermissionSet permset : permissionSets) {
                        PermissionSetAssignment assignment = new PermissionSetAssignment();
                        assignment.AssigneeId = currentUser.recordId;
                        assignment.PermissionSetId = permset.Id;
                        permissionSetAssignments.add(assignment);
                    }
                }
            }

            if (permsetGroupsToAssign.size() > 0) {
                List<PermissionSetGroup> permsetGroups = [
                    SELECT Id
                    FROM PermissionSetGroup
                    WHERE DeveloperName IN :permsetGroupsToAssign // NOPMD - Fetching permission set groups should only be allowed in the context of the login flow
                ];

                if (permsetGroups.size() > 0) {
                    for (PermissionSetGroup permsetGroup : permsetGroups) {
                        //Assign permission set group
                        PermissionSetAssignment assignment = new PermissionSetAssignment();
                        assignment.AssigneeId = currentUser.recordId;
                        assignment.PermissionSetGroupId = permsetGroup.Id;
                        permissionSetAssignments.add(assignment);
                    }
                }
            }

            if (membershipsToInsert.size() > 0) {
                insert membershipsToInsert; // NOPMD - Insert group memberships should only be allowed in the context of the login flow
            }

            List<PermissionSetAssignment> updatedPermissionSetAssignments = removePermissionSetAlreadyAssignedToUser(
                permissionSetAssignments
            );

            if (updatedPermissionSetAssignments.size() > 0) {
                //insert permissionSetAssignments;
                List<Database.SaveResult> srList = Database.insert(
                    updatedPermissionSetAssignments,
                    false
                ); // NOPMD - Insert permission set assignments should only be allowed in the context of the login flow
                handleSaveResult(srList);
            }

            //remove group memberships
            Set<Id> groupMemberIdsToRemove = new Set<Id>();
            Set<String> permissionSetsToRemove = new Set<String>();
            Set<String> permissionSetGroupsToRemove = new Set<String>();
            for (Id salesforceGroupId : adGroupBySalesforceGroupId.keySet()) {
                //check if user is not member of ad group but in Salesforce
                AdGroup adGroup = adGroupBySalesforceGroupId.get(
                    salesforceGroupId
                );
                if (
                    !adGroupIds.contains(adGroup.adGroupId) &&
                    usersSalesforceMembership.contains(salesforceGroupId)
                ) {
                    groupMemberIdsToRemove.add(salesforceGroupId);
                    if (adGroup.permissionSet != null) {
                        permissionSetsToRemove.add(adGroup.permissionSet);
                    }
                    if (adGroup.permissionSetGroup != null) {
                        permissionSetGroupsToRemove.add(
                            adGroup.permissionSetGroup
                        );
                    }
                }
            }

            if (groupMemberIdsToRemove.size() > 0) {
                List<GroupMember> groupMembersToDelete = [
                    SELECT Id
                    FROM GroupMember
                    WHERE
                        UserOrGroupId = :currentUser.recordId
                        AND GroupId IN :groupMemberIdsToRemove // NOPMD - Fetching and deleting group members should only be allowed in the context of the login flow
                ];
                delete groupMembersToDelete;
            }

            if (
                permissionSetsToRemove.size() > 0 ||
                permissionSetGroupsToRemove.size() > 0
            ) {
                List<PermissionSetAssignment> assignmentToRemove = [
                    SELECT Id
                    FROM PermissionSetAssignment
                    WHERE
                        AssigneeId = :currentUser.recordId
                        AND (PermissionSet.Name IN :permissionSetsToRemove
                        OR PermissionSetGroup.DeveloperName IN :permissionSetGroupsToRemove) // NOPMD - Fetching and deleting permission set assignments should only be allowed in the context of the login flow
                ];
                delete assignmentToRemove;
            }
        } catch (Exception e) {
            logger.errorAndPublish(
                'AD group sync faild due to: ' + e.getMessage()
            );
        }
    }

    public Map<Id, AdGroup> getAdGroupBySalesforceGroupId() {
        return getAdGroupBySalesforceGroupId(false);
    }

    public static Map<Id, AdGroup> getAdGroupBySalesforceGroupId(
        Boolean accessToThemesFromAdGroupsFeatureFlag
    ) {
        Boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1]
        .IsSandbox;

        //Temprary where clause to handle feature flag for theme access from Azure AD groups
        String exludedAccessTypes = 'Tema';
        if (accessToThemesFromAdGroupsFeatureFlag) {
            exludedAccessTypes = 'None';
        }

        //put AdGroup in a map
        Map<String, AdGroup> adGroupBySalesforceDeveloperName = new Map<String, AdGroup>();
        for (AdGroupMapping__mdt mapping : [
            SELECT
                AdGroupIdPreprod__c,
                AdGroupIdProd__c,
                SalesforceGroupDeveloperName__c,
                PermissionSet__c,
                PermissionSetGroup__c
            FROM AdGroupMapping__mdt
            WHERE AccessType__c != :exludedAccessTypes // NOPMD - Fetching AD Group mappings should only be allowed in the context of the login flow
        ]) {
            String adGroupId = runningInASandbox || Test.isRunningTest()
                ? mapping.AdGroupIdPreprod__c
                : mapping.AdGroupIdProd__c;
            AdGroup adGroup = new AdGroup();
            adGroup.adGroupId = adGroupId;
            adGroup.permissionSet = mapping.PermissionSet__c;
            adGroup.permissionSetGroup = mapping.PermissionSetGroup__c;

            adGroupBySalesforceDeveloperName.put(
                mapping.SalesforceGroupDeveloperName__c,
                adGroup
            );
        }

        //get Salesforce group ids
        Map<Id, Adgroup> adGroupBySalesforceGroupId = new Map<Id, AdGroup>();
        for (Group g : [
            SELECT Id, DeveloperName
            FROM Group
            WHERE DeveloperName IN :adGroupBySalesforceDeveloperName.keySet()
        ]) {
            AdGroup adGroup = adGroupBySalesforceDeveloperName.get(
                g.DeveloperName
            );
            adGroupBySalesforceGroupId.put(g.Id, adGroup);
        }
        return adGroupBySalesforceGroupId;
    }

    public static Set<Id> getUsersSalesforceMemberships(
        Id userId,
        Set<Id> salesforceGroupIds
    ) {
        Set<Id> groupIds = new Set<Id>();
        for (GroupMember member : [
            SELECT GroupId
            FROM GroupMember
            WHERE UserOrGroupId = :userId AND GroupId IN :salesforceGroupIds // NOPMD - Fetching group members should only be allowed in the context of the login flow
        ]) {
            groupIds.add(member.GroupId);
        }
        return groupIds;
    }

    public class AdGroup {
        public String adGroupId;
        public String adGroupName;
        public String permissionSet;
        public String permissionSetGroup;

        public AdGroup() {
            this.adGroupId = null;
            this.adGroupName = null;
            this.permissionSet = null;
            this.permissionSetGroup = null;
        }
    }

    private void handleSaveResult(List<Database.SaveResult> srList) {
        LoggerUtility logger = new LoggerUtility();
        List<Database.Error> errors = new List<Database.Error>();

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                continue;
            }
            errors.addAll(sr.getErrors());
        }
        if (errors.size() > 0) {
            logger.logMessage(
                LoggerUtility.LogLevel.Error,
                null,
                'Perm Set upsert',
                'Database.UpsertResult errors ',
                JSON.serializePretty(errors),
                null,
                CRM_ApplicationDomain.Domain.AVVIK
            );
        }
        logger.publish();
    }

    private List<PermissionSetAssignment> removePermissionSetAlreadyAssignedToUser(
        List<PermissionSetAssignment> newAssignments
    ) {
        Set<Id> existingPermissionSetIds = new Set<Id>();
        Set<Id> existingPermissionSetGroupIds = new Set<Id>();
        for (PermissionSetAssignment assignment : [
            SELECT PermissionSetId, PermissionSetGroup.Id
            FROM PermissionSetAssignment
            WHERE AssigneeId = :UserInfo.getUserId() // NOPMD - Fetching permission set assignments should only be allowed in the context of the login flow
        ]) {
            if (assignment.PermissionSetId != null) {
                existingPermissionSetIds.add(assignment.PermissionSetId);
            }
            if (assignment.PermissionSetGroupId != null) {
                existingPermissionSetGroupIds.add(
                    assignment.PermissionSetGroupId
                );
            }
        }

        List<PermissionSetAssignment> updatedAssignments = new List<PermissionSetAssignment>();
        for (PermissionSetAssignment assignment : newAssignments) {
            //check if permission set or permission set group are already assigned to current user
            Boolean isAlreadyAssigned = false;
            if (
                assignment.PermissionSetId != null &&
                existingPermissionSetIds.contains(assignment.PermissionSetId)
            ) {
                isAlreadyAssigned = true;
            } else if (
                assignment.PermissionSetGroupId != null &&
                existingPermissionSetGroupIds.contains(
                    assignment.PermissionSetGroupId
                )
            ) {
                isAlreadyAssigned = true;
            }

            if (!isAlreadyAssigned) {
                updatedAssignments.add(assignment);
            }
        }
        return updatedAssignments;
    }
}
