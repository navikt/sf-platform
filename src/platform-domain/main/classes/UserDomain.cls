public with sharing class UserDomain {
    public Id recordId;
    public String navId;
    public String profileName;
    public Boolean hasAccessToThemes = false;
    public Boolean hasAccessToFortrolig = false;
    public Boolean hasAccessToSkjermet = false;
    public Boolean hasAccessToStrengtFortrolig = false;

    @TestVisible
    private final String PROFILES_METADATA_QUERY = 'SELECT MasterLabel, DeveloperName FROM ThemeMappingProfile__mdt';
    private CustomMetadataDAO dao;

   
    public UserDomain(
        Id recordId,
        String navId,
        String profileName
    ) {
        this.recordId = recordId;
        this.navId = navId;
        this.profileName = profileName;
    }

    public void checkAccessToFortroligAndSkjermetByAdGroups(
        List<String> usersAdGroupIds
    ) {
        Boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1]
        .IsSandbox;

        for (AdGroupMapping__mdt mapping : [
            SELECT
                AdGroupIdPreprod__c,
                AdGroupIdProd__c,
                SalesforceGroupDeveloperName__c,
                AccessType__c
            FROM AdGroupMapping__mdt
            WHERE
                AccessType__c IN ('Fortrolig', 'Skjermet', 'Strengt_Fortrolig')
        ]) {
            String adGroupId = runningInASandbox || Test.isRunningTest()
                ? mapping.AdGroupIdPreprod__c
                : mapping.AdGroupIdProd__c;
            if (usersAdGroupIds.contains(adGroupId)) {
                if (mapping.AccessType__c == 'Fortrolig') {
                    hasAccessToFortrolig = true;
                } else if (mapping.AccessType__c == 'Skjermet') {
                    hasAccessToSkjermet = true;
                } else if (mapping.AccessType__c == 'Strengt_Fortrolig') {
                    hasAccessToStrengtFortrolig = true;
                }
            }
        }
    }
}
