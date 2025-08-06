public with sharing class UserRepository extends RepositoryBase {
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
}
