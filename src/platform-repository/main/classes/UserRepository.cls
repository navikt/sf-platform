public with sharing class UserRepository extends RepositoryBase {
    private CustomMetadataDAO customMetadataDAO = new CustomMetadataDAO();
    @TestVisible
    public String PROFILES_METADATA_QUERY = 'SELECT MasterLabel FROM ThemeMappingProfile__mdt';

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
            PROFILES_METADATA_QUERY
        );

        for (ThemeMappingProfile__mdt profile : profilesWithAccess) {
            if (profile.MasterLabel == user.profileName) {
                return true;
            }
        }
        return false;
    }
}
