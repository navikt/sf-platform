@IsTest
private class SensitiveThemeGroupServiceTest {
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

    @IsTest
    private static void shouldAddUserTo_Fortrolig_PEN_GroupWhenUserIsMemberOfTema_PEN_andHasAccessToFortrolig() {
        Id themePenGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Tema_PEN'
            LIMIT 1
        ]
        .Id;
        Id fortroligPenGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Fortrolig_PEN'
            LIMIT 1
        ]
        .Id;

        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = true;
        user.hasAccessToSkjermet = false;

        new SensitiveThemeGroupService().updateSensitiveThemeGroups(user);

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    GroupId = :fortroligPenGroupId
                    AND UserOrGroupId = :user.recordId
            ]
        );
    }

    @IsTest
    private static void shouldRemoveUserFrom_Fortrolig_PEN_whenAccessTo_Tema_PEN_isRemoved() {
        // Arrange
        Id themePenGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Tema_PEN'
            LIMIT 1
        ]
        .Id;
        Id fortroligPenGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'Fortrolig_PEN'
            LIMIT 1
        ]
        .Id;

        UserDomain user = new UserDomain(userInfo.getUserId(), 'NAV_ID_123');
        user.hasAccessToFortrolig = false;
        user.hasAccessToSkjermet = false;

        //Act
        Test.startTest();
        new SensitiveThemeGroupService().updateSensitiveThemeGroups(user);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    GroupId = :fortroligPenGroupId
                    AND UserOrGroupId = :user.recordId
            ]
        );
    }
}
