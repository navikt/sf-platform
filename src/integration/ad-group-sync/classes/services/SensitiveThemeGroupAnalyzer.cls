/* Responsible for comparing and analyzing theme groups with sensitive theme groups, to verify users have the appropriate access to sensitive theme groups
When a user has access to fortrolig and member of Tema_PEN, the user should be added to Fortrolig_PEN and Skjermet_PEN
When a user has access to skjermet and member of Tema_PEN, the user should be added to Skjermet_PEN
When a user has access to skjermet and fortrolig and member of Tema_PEN, the user should be added to Fortrolig_Skjermet_PEN
*/

public with sharing class SensitiveThemeGroupAnalyzer {
    public Set<String> findSensitiveThemeGroupsToBeAddedAsMembers(
        Map<String, ThemeGroupMember> mapOfThemeGroupMembers,
        Map<String, ThemeGroupMember> mapOfSensitiveThemeGroupMembers
    ) {
        Set<String> groupNamesToBeAdded = new Set<String>();

        for (
            ThemeGroupMember themeGroupMember : mapOfThemeGroupMembers.values()
        ) {
            String themeName = themeGroupMember.themeGroup.getThemeName();
            UserDomain user = themeGroupMember.user;

            // Check which sensitive groups should be added based on user access
            List<String> potentialGroups = getSensitiveGroupNames(
                user,
                themeName
            );

            for (String groupName : potentialGroups) {
                if (!mapOfSensitiveThemeGroupMembers.containsKey(groupName)) {
                    groupNamesToBeAdded.add(groupName);
                }
            }
        }
        return groupNamesToBeAdded;
    }

    public Set<String> findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
        Map<String, ThemeGroupMember> mapOfThemeGroupMembers,
        Map<String, ThemeGroupMember> mapOfSensitiveThemeGroupMembers
    ) {
        Set<String> groupNamesToBeRemoved = new Set<String>();

        for (
            String sensitiveGroupName : mapOfSensitiveThemeGroupMembers.keySet()
        ) {
            ThemeGroupMember sensitiveThemeGroupMember = mapOfSensitiveThemeGroupMembers.get(
                sensitiveGroupName
            );
            String themeName = sensitiveThemeGroupMember.themeGroup.getThemeName();
            UserDomain user = sensitiveThemeGroupMember.user;

            // Check if user should be removed from this sensitive group
            if (
                shouldRemoveUserFromSensitiveGroup(
                    user,
                    themeName,
                    sensitiveGroupName,
                    mapOfThemeGroupMembers
                )
            ) {
                groupNamesToBeRemoved.add(sensitiveGroupName);
            }
        }
        return groupNamesToBeRemoved;
    }

    private Boolean shouldRemoveUserFromSensitiveGroup(
        UserDomain user,
        String themeName,
        String sensitiveGroupName,
        Map<String, ThemeGroupMember> mapOfThemeGroupMembers
    ) {
        // Check if user is still in the corresponding theme group
        String themeGroupName = 'Tema_' + themeName;
        ThemeGroupMember themeGroupMember = mapOfThemeGroupMembers.get(
            themeGroupName
        );
        Boolean userIsInThemeGroup = (themeGroupMember != null &&
        themeGroupMember.user.recordId == user.recordId);

        if (!userIsInThemeGroup) {
            return true; // Remove if not in theme group
        }

        // Check if user still has required access level
        return !hasRequiredAccessForSensitiveGroup(user, sensitiveGroupName);
    }

    private Boolean hasRequiredAccessForSensitiveGroup(
        UserDomain user,
        String sensitiveGroupName
    ) {
        if (sensitiveGroupName.startsWith('Fortrolig_Skjermet_')) {
            return user.hasAccessToFortrolig && user.hasAccessToSkjermet;
        } else if (sensitiveGroupName.startsWith('Fortrolig_')) {
            return user.hasAccessToFortrolig;
        } else if (sensitiveGroupName.startsWith('Skjermet_')) {
            return user.hasAccessToSkjermet;
        }
        return false; // Unknown group type
    }

    private List<String> getSensitiveGroupNames(
        UserDomain user,
        String themeName
    ) {
        List<String> sensitiveGroups = new List<String>();

        Boolean hasFortrolig = user.hasAccessToFortrolig;
        Boolean hasSkjermet = user.hasAccessToSkjermet;

        if (hasFortrolig && hasSkjermet) {
            sensitiveGroups.add('Fortrolig_Skjermet_' + themeName);
        } else if (hasFortrolig) {
            sensitiveGroups.add('Fortrolig_' + themeName);
        } else if (hasSkjermet) {
            sensitiveGroups.add('Skjermet_' + themeName);
        }

        return sensitiveGroups;
    }
}
