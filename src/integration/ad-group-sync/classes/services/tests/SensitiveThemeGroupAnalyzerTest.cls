@isTest
private class SensitiveThemeGroupAnalyzerTest {
    @TestSetup
    private static void makeData() {
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
    }

    @isTest
    private static void shouldSuggestToAdd_Fortrolig_PEN_whenUserHasAccessToFortrligAndMemberOf_Tema_PEN() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true;
        user.hasAccessToSkjermet = false;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'Tema_PEN'
        );
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(user, themeGroup)
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Fortrolig_PEN'));
    }

    @IsTest
    private static void shouldNotSuggestToAdd_Fortrolig_PEN_whenUserIsMemberOf_Fortrolig_PEN() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true;
        user.hasAccessToSkjermet = false;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();

        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Fortrolig_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAX', 'Fortrolig_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.isTrue(result.isEmpty());
    }

    @IsTest
    private static void shouldNotSuggestToAddFortroligGroupsWhenUserHasNoAccessToFortrolig() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false;
        user.hasAccessToSkjermet = false;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.isTrue(result.isEmpty());
    }

    @IsTest
    private static void shouldSuggestToAdd_Skjermet_PEN_whenUserHasAccessToSkjermetAndMemberOf_Tema_PEN() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false;
        user.hasAccessToSkjermet = true;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'Tema_PEN'
        );
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(user, themeGroup)
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Skjermet_PEN'));
    }

    @IsTest
    private static void shouldNotSuggestToAdd_Skjermet_PEN_whenUserIsMemberOf_Skjermet_PEN() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false;
        user.hasAccessToSkjermet = true;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();

        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Skjermet_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAY', 'Skjermet_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.isTrue(result.isEmpty());
    }

    @IsTest
    private static void shouldNotSuggestToAddSkjermetGroupsWhenUserHasNoAccessToSkjermet() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false;
        user.hasAccessToSkjermet = false;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.isTrue(result.isEmpty());
    }

    @IsTest
    private static void shouldSuggestToAdd_Fortrolig_Skjermet_PEN_whenUserHasAccessToBothAndMemberOf_Tema_PEN() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true;
        user.hasAccessToSkjermet = true;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'Tema_PEN'
        );
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(user, themeGroup)
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Fortrolig_Skjermet_PEN'));
    }

    @IsTest
    private static void shouldNotSuggestToAdd_Fortrolig_Skjermet_PEN_whenUserIsMemberOf_Fortrolig_Skjermet_PEN() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true;
        user.hasAccessToSkjermet = true;
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();

        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Fortrolig_Skjermet_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAZ', 'Fortrolig_Skjermet_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsToBeAddedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.isTrue(result.isEmpty());
    }

    // Tests for findSensitiveThemeGroupsMembersToBeRemovedAsMembers

    @IsTest
    private static void shouldSuggestToRemove_Fortrolig_PEN_whenUserNoLongerHasAccessToFortrolig() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false; // No longer has access
        user.hasAccessToSkjermet = false;

        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Fortrolig_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAX', 'Fortrolig_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Fortrolig_PEN'));
    }

    @IsTest
    private static void shouldSuggestToRemove_Skjermet_PEN_whenUserNoLongerHasAccessToSkjermet() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false;
        user.hasAccessToSkjermet = false; // No longer has access

        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Skjermet_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAY', 'Skjermet_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Skjermet_PEN'));
    }

    @IsTest
    private static void shouldSuggestToRemove_Fortrolig_Skjermet_PEN_whenUserNoLongerHasAccessToFortrolig() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false; // Lost Fortrolig access
        user.hasAccessToSkjermet = true; // Still has Skjermet access

        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Fortrolig_Skjermet_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAZ', 'Fortrolig_Skjermet_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Fortrolig_Skjermet_PEN'));
    }

    @IsTest
    private static void shouldSuggestToRemove_Fortrolig_Skjermet_PEN_whenUserNoLongerHasAccessToSkjermet() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true; // Still has Fortrolig access
        user.hasAccessToSkjermet = false; // Lost Skjermet access

        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Fortrolig_Skjermet_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAZ', 'Fortrolig_Skjermet_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Fortrolig_Skjermet_PEN'));
    }

    @IsTest
    private static void shouldSuggestToRemove_Fortrolig_PEN_whenUserNoLongerMemberOf_Tema_PEN() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true;
        user.hasAccessToSkjermet = false;

        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        // User is no longer member of Tema_PEN (empty map)

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Fortrolig_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAX', 'Fortrolig_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );

        // Assert
        Assert.areEqual(1, result.size());
        Assert.isTrue(result.contains('Fortrolig_PEN'));
    }

    @IsTest
    private static void shouldNotSuggestToRemove_Fortrolig_PEN_whenUserStillHasAccessAndMembership() {
        // Arrange
        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true;
        user.hasAccessToSkjermet = false;

        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        themeGroupMembers.put(
            'Tema_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAG', 'Tema_PEN')
            )
        );

        Map<String, ThemeGroupMember> sensitiveThemeGroupMembers = new Map<String, ThemeGroupMember>();
        sensitiveThemeGroupMembers.put(
            'Fortrolig_PEN',
            new ThemeGroupMember(
                user,
                new ThemeGroup('00GS8000007QPziMAX', 'Fortrolig_PEN')
            )
        );

        // Act
        Test.startTest();
        Set<String> result = new SensitiveThemeGroupAnalyzer()
            .findSensitiveThemeGroupsMembersToBeRemovedAsMembers(
                themeGroupMembers,
                sensitiveThemeGroupMembers
            );
        Test.stopTest();

        // Assert
        Assert.isTrue(result.isEmpty());
    }
}
