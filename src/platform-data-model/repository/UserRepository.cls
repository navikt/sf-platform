public with sharing class UserRepository {
    public UserDomain fetchCurrentUser() {
        User currentUser = [
            SELECT Id, CRM_Nav_Ident__c, AccessToThemesFromAdGroups__c
            FROM User
            WHERE Id = :UserInfo.getUserId()
            LIMIT 1
        ];
        return new UserDomain(
            currentUser.Id,
            currentUser.CRM_Nav_Ident__c,
            currentUser.AccessToThemesFromAdGroups__c != null
                ? currentUser.AccessToThemesFromAdGroups__c
                : false
        );
    }
}
