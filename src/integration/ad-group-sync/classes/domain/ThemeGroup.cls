public with sharing class ThemeGroup {
    public Id groupId;
    public String developerName;

    public ThemeGroup(Id groupId, String developerName) {
        this.groupId = groupId;
        this.developerName = developerName;
    }

    public String getThemeName() {
        if (developerName.startsWith('Tema_')) {
            return developerName.substring(5); // Remove 'Tema_' prefix
        } else if (developerName.startsWith('Fortrolig_Skjermet_')) {
            return developerName.substring(19); // Remove 'Fortrolig_Skjermet_' prefix
        } else if (developerName.startsWith('Fortrolig_')) {
            return developerName.substring(10); // Remove 'Fortrolig_' prefix
        } else if (developerName.startsWith('Skjermet_')) {
            return developerName.substring(9); // Remove 'Skjermet_' prefix
        } else {
            return null;
        }
    }
}
