@IsTest
private class ThemeGroupMemberRepositoryTest {
    @TestSetup
    static void makeData() {
        // Add curent user to public group
        Id groupTemaPenId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Tema_PEN' AND Type = 'Regular'
            LIMIT 1
        ]
        .Id;
        GroupMember groupMember = new GroupMember(
            UserOrGroupId = UserInfo.getUserId(),
            GroupId = groupTemaPenId
        );
        insert groupMember;

        Profile platformProfile = [
            SELECT Id
            FROM Profile
            WHERE Name = 'Standard Platform User'
            LIMIT 1
        ];

        User platformUser = new User();
        platformUser.FirstName = 'Platform';
        platformUser.LastName = 'Test';
        platformUser.Email = 'test.user@nav.no';
        platformUser.UserName = 'test.user@nav.no';
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
    private static void shouldReturnEmptyMapWhenSpecificUserHasNoThemeGroupMemberships() {
        // Arrange
        User platformUser = [
            SELECT Id
            FROM User
            WHERE Username = 'test.user@nav.no'
            LIMIT 1
        ];
        UserDomain user = new UserDomain(platformUser.Id, 'NAV_ID_123');

        // Act
        Map<String, ThemeGroupMember> groupMembers = new ThemeGroupMemberRepository()
            .fetchMembershipsForSpecificUserMappedByDeveloperName(
                user,
                new Map<Id, ThemeGroup>()
            );

        // Assert
        Assert.isTrue(groupMembers.isEmpty());
    }

    @IsTest
    private static void shouldReturnOneThemeGroupWhenSpecificUserIsMemberOfOneThemeGroup() {
        // Arrange
        UserDomain user = new UserDomain(UserInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false;
        user.hasAccessToSkjermet = false;

        ThemeGroup themeGroup = new ThemeGroup(
            [
                SELECT Id
                FROM Group
                WHERE DeveloperName = 'Tema_PEN' AND Type = 'Regular'
                LIMIT 1
            ]
            .Id,
            'Tema_PEN'
        );

        Map<Id, ThemeGroup> groups = new Map<Id, ThemeGroup>();
        groups.put(themeGroup.groupId, themeGroup);

        // Act
        Map<String, ThemeGroupMember> groupMembers = new ThemeGroupMemberRepository()
            .fetchMembershipsForSpecificUserMappedByDeveloperName(user, groups);

        // Assert
        Assert.areEqual(1, groupMembers.size());
        Assert.isTrue(groupMembers.keySet().contains('Tema_PEN'));
    }

    @IsTest
    private static void shouldInsertGroupMemberToDatabase() {
        // Arrange
        UserDomain user = new UserDomain(UserInfo.getUserId(), 'NAV_ID_123');
        Id groupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Fortrolig_PEN' AND Type = 'Regular'
            LIMIT 1
        ]
        .Id;
        ThemeGroupMember newThemeGroupMember = new ThemeGroupMember(
            user,
            new ThemeGroup(groupId, 'Fortrolig_PEN')
        );

        // Act
        Test.startTest();
        new ThemeGroupMemberRepository()
            .insertToDatabase(
                new List<ThemeGroupMember>{ newThemeGroupMember }
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE UserOrGroupId = :user.recordId AND GroupId = :groupId
            ]
        );
    }

    @IsTest
    private static void shouldHandleEmptyListInInsertToDatabase() {
        // Act & Assert - Should not throw exception
        Test.startTest();
        new ThemeGroupMemberRepository()
            .insertToDatabase(new List<ThemeGroupMember>());
        Test.stopTest();

        // If we reach here, the method handled empty list correctly
        Assert.isTrue(true);
    }

    @IsTest
    private static void shouldDeleteGroupMember() {
        // Arrange
        UserDomain user = new UserDomain(UserInfo.getUserId(), 'NAV_ID_123');
        Id groupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Tema_PEN' AND Type = 'Regular'
            LIMIT 1
        ]
        .Id;
        ThemeGroup themeGroup = new ThemeGroup(groupId, 'Tema_PEN');

        Id groupMemberRecordId = [
            SELECT Id
            FROM GroupMember
            WHERE UserOrGroupId = :user.recordId AND GroupId = :groupId
            LIMIT 1
        ]
        .Id;
        ThemeGroupMember themeGroupMemberToBeDeleted = new ThemeGroupMember(
            user,
            themeGroup,
            groupMemberRecordId
        );

        // Act
        Test.startTest();
        new ThemeGroupMemberRepository()
            .deleteFromDatabase(
                new List<ThemeGroupMember>{ themeGroupMemberToBeDeleted }
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE UserOrGroupId = :user.recordId AND GroupId = :groupId
            ]
        );
    }

    @IsTest
    private static void shouldHandleEmptyListInDeleteFromDatabase() {
        // Act & Assert - Should not throw exception
        Test.startTest();
        new ThemeGroupMemberRepository()
            .deleteFromDatabase(new List<ThemeGroupMember>());
        Test.stopTest();

        // If we reach here, the method handled empty list correctly
        Assert.isTrue(true);
    }

    @IsTest
    private static void shouldHandleMembersWithoutRecordIdInDeleteFromDatabase() {
        // Arrange
        UserDomain user = new UserDomain(UserInfo.getUserId(), 'NAV_ID_123');
        Id groupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Tema_PEN' AND Type = 'Regular'
            LIMIT 1
        ]
        .Id;

        // Create a member without recordId (not yet persisted)
        ThemeGroupMember memberWithoutId = new ThemeGroupMember(
            user,
            new ThemeGroup(groupId, 'Tema_PEN')
        );

        // Act & Assert - Should not throw exception
        Test.startTest();
        new ThemeGroupMemberRepository()
            .deleteFromDatabase(new List<ThemeGroupMember>{ memberWithoutId });
        Test.stopTest();

        // If we reach here, the method handled members without recordId correctly
        Assert.isTrue(true);
    }
}
