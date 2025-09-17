@SuppressWarnings('PMD')
public with sharing class UserRepository extends RepositoryBase {
    private CustomMetadataDAO customMetadataDAO = new CustomMetadataDAO();
    public String PROFILES_THEME_ACCESS_METADATA_QUERY = 'SELECT MasterLabel FROM ThemeMappingProfile__mdt';
    public String ADGROUP_MAPPING_METADATA_QUERY = 'SELECT AdGroupIdPreprod__c, AdGroupIdProd__c, SalesforceGroupDeveloperName__c, AccessType__c FROM AdGroupMapping__mdt WHERE AccessType__c IN (\'Fortrolig\', \'Skjermet\', \'Strengt_Fortrolig\')';

    public UserDomain fetchCurrentUser() {
        User currentUser = [
            SELECT Id, CRM_Nav_Ident__c, Profile.Name
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];
        return new UserDomain(
            currentUser.Id,
            currentUser.CRM_Nav_Ident__c,
            currentUser.Profile.Name
        );
    }

    public Boolean checkUserThemeAccess(UserDomain user) {
        List<ThemeMappingProfile__mdt> profilesWithAccess = (List<ThemeMappingProfile__mdt>) customMetadataDAO.getCustomMetadataRecords(
            PROFILES_THEME_ACCESS_METADATA_QUERY
        );

        for (ThemeMappingProfile__mdt profile : profilesWithAccess) {
            if (profile.MasterLabel == user.profileName) {
                return true;
            }
        }
        return false;
    }

    public void checkAccessToFortroligAndSkjermetByAdGroups(
        UserDomain user,
        List<String> usersAdGroupIds
    ) {
        Boolean runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1]
        .IsSandbox;

        for (
            AdGroupMapping__mdt mapping : (List<AdGroupMapping__mdt>) customMetadataDAO.getCustomMetadataRecords(
                ADGROUP_MAPPING_METADATA_QUERY
            )
        ) {
            String adGroupId = runningInASandbox || Test.isRunningTest()
                ? mapping.AdGroupIdPreprod__c
                : mapping.AdGroupIdProd__c;
            if (usersAdGroupIds.contains(adGroupId)) {
                user.setAccessLevel(mapping.AccessType__c);
            }
        }
    }
}
