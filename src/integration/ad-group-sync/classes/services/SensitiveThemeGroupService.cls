/* Responsible for updating access to sensitive theme groups (fortrolig, skjermet and fortrolig_skjermet) based on group memberships in theme groups (example: Tema_PEN) */
public with sharing class SensitiveThemeGroupService {
    private ThemeGroupRepository themeGroupRepository = new ThemeGroupRepository();
    private ThemeGroupMemberRepository themeGroupMemberRepository = new ThemeGroupMemberRepository();
    private SensitiveThemeGroupAnalyzer sensitiveThemeGroupAnalyzer = new SensitiveThemeGroupAnalyzer();
    public void updateSensitiveThemeGroups(UserDomain user) {
        LoggerUtility logger = new LoggerUtility(
            CRM_ApplicationDomain.Domain.PLATFORCE,
            'LoginFlow'
        );

        try {
            // Get current memberships
            Map<String, ThemeGroupMember> themeGroupMembers = getCurrentThemeGroupMemberships(
                user
            );
            Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = getCurrentSensitiveThemeGroupMemberships(
                user
            );

            addMissingSensitiveGroupMemberships(
                user,
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );

            removeInvalidSensitiveGroupMemberships(
                user,
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        } catch (Exception e) {
            logger.errorAndPublish(
                'Sensitive theme group sync failed due to: ' + e.getMessage()
            );
        }
    }

    private Map<String, ThemeGroupMember> getCurrentThemeGroupMemberships(
        UserDomain user
    ) {
        Map<Id, ThemeGroup> themeGroups = themeGroupRepository
            .fetchThemeGroupsMappedById();
        return themeGroupMemberRepository
            .fetchMembershipsForSpecificUserMappedByDeveloperName(
                user,
                themeGroups
            );
    }

    private Map<String, ThemeGroupMember> getCurrentSensitiveThemeGroupMemberships(
        UserDomain user
    ) {
        Map<Id, ThemeGroup> sensitiveThemeGroups = themeGroupRepository
            .fetchSensitiveThemeGroupsMappedById();
        return themeGroupMemberRepository.fetchMembershipsForSpecificUserMappedByDeveloperName(
            user,
            sensitiveThemeGroups
        );
    }

    private void addMissingSensitiveGroupMemberships(
        UserDomain user,
        Map<String, ThemeGroupMember> themeGroupMembers,
        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers
    ) {
        Set<String> groupsToBeAdded = sensitiveThemeGroupAnalyzer.findSensitiveThemeGroupsToBeAddedAsMembers(
            themeGroupMembers,
            sensitiveThemeGroupMembers
        );

        if (groupsToBeAdded.isEmpty()) {
            return;
        }

        Map<String, ThemeGroup> allSensitiveThemeGroups = themeGroupRepository
            .fetchSensitiveThemeGroupsMappedByDeveloperName();
        List<ThemeGroupMember> newMembers = createThemeGroupMembers(
            user,
            groupsToBeAdded,
            allSensitiveThemeGroups
        );

        themeGroupMemberRepository.insertToDatabase(newMembers);
    }

    private void removeInvalidSensitiveGroupMemberships(
        UserDomain user,
        Map<String, ThemeGroupMember> themeGroupMembers,
        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers
    ) {
        Set<String> groupsToBeRemoved = sensitiveThemeGroupAnalyzer.findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
            themeGroupMembers,
            sensitiveThemeGroupMembers
        );

        if (groupsToBeRemoved.isEmpty()) {
            return;
        }

        List<ThemeGroupMember> membersToRemove = new List<ThemeGroupMember>();
        for (String groupDevName : groupsToBeRemoved) {
            ThemeGroupMember member = sensitiveThemeGroupMembers.get(
                groupDevName
            );

            if (member != null) {
                membersToRemove.add(member);
            }
        }

        if (!membersToRemove.isEmpty()) {
            themeGroupMemberRepository.deleteFromDatabase(membersToRemove);
        }
    }

    private List<ThemeGroupMember> createThemeGroupMembers(
        UserDomain user,
        Set<String> groupDeveloperNames,
        Map<String, ThemeGroup> allSensitiveThemeGroups
    ) {
        List<ThemeGroupMember> newMembers = new List<ThemeGroupMember>();

        for (String groupDeveloperName : groupDeveloperNames) {
            ThemeGroup themeGroup = allSensitiveThemeGroups.get(
                groupDeveloperName
            );
            if (themeGroup != null) {
                newMembers.add(new ThemeGroupMember(user, themeGroup));
            }
        }

        return newMembers;
    }
}
