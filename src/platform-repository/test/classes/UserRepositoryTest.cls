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
            Assert.isNotNull(currentUser);
            Assert.areEqual('A123456', currentUser.navId);
        }
    }

    @IsTest
    private static void shouldHaveAccessToThemesWhenUsersProfileIsInThemeMappingProfile() {
        //Arrange
        UserRepository userRepository = new UserRepository();
        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A123456',
            'Profile with Theme Access'
        );
        CustomMetadataDAOTest.setMetadata(
            userRepository.PROFILES_THEME_ACCESS_METADATA_QUERY,
            (List<ThemeMappingProfile__mdt>) JSON.deserialize(
                '[{"MasterLabel":"Profile with Theme Access"}]',
                List<ThemeMappingProfile__mdt>.class
            )
        );

        //Act
        Test.startTest();
        Boolean result = new UserRepository().checkUserThemeAccess(user);
        Test.stopTest();

        //Assert
        Assert.isTrue(result);
    }

    @IsTest
    private static void shouldNotHaveAccessToThemesWhenUsersProfileNotInThemeMappingProfile() {
        //Arrange
        UserRepository userRepository = new UserRepository();
        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A123456',
            'Profile without Theme Access'
        );
        CustomMetadataDAOTest.setMetadata(
            userRepository.PROFILES_THEME_ACCESS_METADATA_QUERY,
            (List<ThemeMappingProfile__mdt>) JSON.deserialize(
                '[{"MasterLabel":"Profile with Theme Access"}]',
                List<ThemeMappingProfile__mdt>.class
            )
        );

        //Act
        Test.startTest();
        Boolean result = userRepository.checkUserThemeAccess(user);
        Test.stopTest();

        //Assert
        Assert.isFalse(result);
    }

    @IsTest
    private static void shouldSetAccessToSkjermetAndFortrolig() {
        //Arrange
        UserRepository userRepository = new UserRepository();

        // Mock AdGroupMapping__mdt data with proper JSON format
        CustomMetadataDAOTest.setMetadata(
            userRepository.ADGROUP_MAPPING_METADATA_QUERY,
            (List<AdGroupMapping__mdt>) JSON.deserialize(
                '[{"AdGroupIdPreprod__c": "e750ceb5-b70b-4d94-b4fa-9d22467b786b", "AdGroupIdProd__c": "b1234567-89ab-4cde-8f01-23456789abcd", "SalesforceGroupDeveloperName__c": "Fortrolig", "AccessType__c": "Fortrolig"},' +
                '{"AdGroupIdPreprod__c": "dbe4ad45-320b-4e9a-aaa1-73cca4ee124d", "AdGroupIdProd__c": "b1234567-89ab-4cde-8f01-23456789abcd", "SalesforceGroupDeveloperName__c": "Skjermet", "AccessType__c": "Skjermet"}]',
                List<AdGroupMapping__mdt>.class
            )
        );

        List<String> adGroupIds = new List<String>{
            'e750ceb5-b70b-4d94-b4fa-9d22467b786b',
            'dbe4ad45-320b-4e9a-aaa1-73cca4ee124d',
            '9ec6487d-f37a-4aad-a027-cd221c1ac32b',
            'ea930b6b-9397-44d9-b9e6-f4cf527a632a'
        };

        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A123456',
            'Standard Profile'
        );
        Assert.isFalse(user.hasAccessToFortrolig);
        Assert.isFalse(user.hasAccessToSkjermet);

        //Act
        Test.startTest();
        userRepository.checkAccessToFortroligAndSkjermetByAdGroups(
            user,
            adGroupIds
        );
        Test.stopTest();

        //Assert
        Assert.isTrue(user.hasAccessToFortrolig);
        Assert.isTrue(user.hasAccessToSkjermet);
    }
}
