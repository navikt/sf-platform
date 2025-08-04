public without sharing class ThemeGroupRepository {
    public Map<Id, ThemeGroup> fetchThemeGroupsMappedById() {
        Map<Id, ThemeGroup> themeGroups = new Map<Id, ThemeGroup>();
        for (Group themeGroup : [
            SELECT Id, DeveloperName
            FROM Group
            WHERE DeveloperName LIKE 'Tema_%' AND Type = 'Regular'
        ]) {
            themeGroups.put(
                themeGroup.Id,
                new ThemeGroup(themeGroup.Id, themeGroup.DeveloperName)
            );
        }
        return themeGroups;
    }

    public Map<Id, ThemeGroup> fetchSensitiveThemeGroupsMappedById() {
        Map<Id, ThemeGroup> sensitiveThemeGroups = new Map<Id, ThemeGroup>();
        for (Group sensitiveThemeGroup : fetchGroupsFromDatabase()) {
            sensitiveThemeGroups.put(
                sensitiveThemeGroup.Id,
                new ThemeGroup(
                    sensitiveThemeGroup.Id,
                    sensitiveThemeGroup.DeveloperName
                )
            );
        }
        return sensitiveThemeGroups;
    }

    public Map<String, ThemeGroup> fetchSensitiveThemeGroupsMappedByDeveloperName() {
        Map<String, ThemeGroup> sensitiveThemeGroups = new Map<String, ThemeGroup>();
        for (Group sensitiveThemeGroup : fetchGroupsFromDatabase()) {
            sensitiveThemeGroups.put(
                sensitiveThemeGroup.DeveloperName,
                new ThemeGroup(
                    sensitiveThemeGroup.Id,
                    sensitiveThemeGroup.DeveloperName
                )
            );
        }
        return sensitiveThemeGroups;
    }

    private List<Group> fetchGroupsFromDatabase() {
        return [
            SELECT Id, DeveloperName
            FROM Group
            WHERE
                (DeveloperName LIKE 'Skjermet_%'
                OR DeveloperName LIKE 'Fortrolig_%'
                OR DeveloperName LIKE 'Fortrolig_Skjermet_%')
                AND Type = 'Regular'
        ];
    }
}
