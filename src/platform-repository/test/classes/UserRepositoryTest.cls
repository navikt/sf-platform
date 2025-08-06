@isTest
private class UserRepositoryTest {
    @TestSetup
    private static void makeData() {
        Profile platformProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard Platform User'
            LIMIT 1
        ];

        User platformUser = new User();
        platformUser.FirstName = 'Platform';
        platformUser.LastName = 'Test';
        platformUser.Email = 'test.platform@nav.no';
        platformUser.UserName = 'test.platform423_fdsfds@nav.no';
        platformUser.ProfileId = platformProfile.Id;
        platformUser.CRM_Nav_Ident__c = 'A123456';
        platformUser.Alias = 'plattest';
        platformUser.TimeZoneSidKey = 'Europe/Paris';
        platformUser.LocaleSidKey = 'no_NO';
        platformUser.EmailEncodingKey = 'ISO-8859-1';
        platformUser.LanguageLocaleKey = 'no';
        insert platformUser;
    }

    @IsTest
    private static void shouldFetchCurrentUserWithNavIdA123456() {
        // Arrange
        User platformUser = [
            SELECT Id
            FROM User
            WHERE UserName = 'test.platform423_fdsfds@nav.no'
            LIMIT 1
        ];

        //Act
        System.runAs(platformUser) {
            UserDomain currentUser = new UserRepository().fetchCurrentUser();

            //Assert
            System.assertNotEquals(null, currentUser);
            System.assertEquals('A123456', currentUser.navId);
        }
    }
}
