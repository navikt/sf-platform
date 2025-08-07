@IsTest
private class AdGroupSyncServiceTest {
    private static List<String> adGroupIds = new List<String>{
        'e750ceb5-b70b-4d94-b4fa-9d22467b786b',
        'dbe4ad45-320b-4e9a-aaa1-73cca4ee124d',
        'cd0a9215-9673-48ca-84a1-6a6ef349811a',
        'ea930b6b-9397-44d9-b9e6-f4cf527a632a'
    };
    private static String publicGroupDevName = 'NKS_Skjermede_Personer_AD';

    @IsTest
    private static void updateGroupMembership_insertMembership() {
        //Arrange
        Id publicGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = :publicGroupDevName
            LIMIT 1
        ]
        .Id;
        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to not be member of any groups before the update'
        );

        Id permissionSetId = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'CRM_NavEmployees'
            LIMIT 1
        ]
        .Id;
        List<String> adGroupsInTest = new List<String>();
        adGroupsInTest.add(adGroupIds[0]);
        adGroupsInTest.add(adGroupIds[1]);

        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A33213',
            'Standard Profile'
        );

        //Act
        Test.startTest();
        new AdGroupSyncService().addRemoveGroupsAndPerms(user, adGroupsInTest);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to be added to one group'
        );

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetId = :permissionSetId
            ],
            'Expect permission set to be added to be able to access necessary fields'
        );

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Log_Level__c = 'Error'
            ],
            'Expect no errors in application log'
        );
    }

    @IsTest
    private static void updateGroupMembership_newMembershipWithPermsetGroup() {
        //Arrange
        Id publicGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'group_410098'
            LIMIT 1
        ]
        .Id;
        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to not be member of any groups before the update'
        );

        List<String> adGroupsInTest = new List<String>();
        adGroupsInTest.add('597b2345-5846-4c9c-ba9d-15323preprod');

        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A33213',
            'Standard Profile'
        );

        //Act
        Test.startTest();
        new AdGroupSyncService().addRemoveGroupsAndPerms(user, adGroupsInTest);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to be added to one group'
        );

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetGroup.DeveloperName = 'Test'
            ],
            'Expect permission set to be added to be able to access necessary fields'
        );

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Log_Level__c = 'Error'
            ],
            'Expect no errors in application log'
        );
    }

    @IsTest
    private static void updateGroupMembership_removeMembershipWithPermsetGroup() {
        //Arrange
        Id publicGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'group_410098'
            LIMIT 1
        ]
        .Id;
        GroupMember member = new GroupMember(
            UserOrGroupId = UserInfo.getUserId(),
            GroupId = publicGroupId
        );
        insert member;
        insert new PermissionSetAssignment(
            AssigneeId = UserInfo.getUserId(),
            PermissionSetGroupId = [
                SELECT Id
                FROM PermissionSetGroup
                WHERE DeveloperName = 'TEST'
            ]
            ?.Id
        );

        List<String> adGroupsInTest = new List<String>();
        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A33213',
            'Standard Profile'
        );

        //Act
        Test.startTest();
        new AdGroupSyncService().addRemoveGroupsAndPerms(user, adGroupsInTest);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetGroup.DeveloperName = 'Test'
            ],
            'Expect permission set to be added to be able to access necessary fields'
        );

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Log_Level__c = 'Error'
            ],
            'Expect no errors in application log'
        );
    }

    @IsTest
    private static void updateGroupMembership_removeMembership() {
        //Arrange
        //add user to group before the update
        //we will test removing membership
        Id publicGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'NKS_Skjermede_Personer_AD'
            LIMIT 1
        ]
        .Id;
        GroupMember member = new GroupMember(
            UserOrGroupId = UserInfo.getUserId(),
            GroupId = publicGroupId
        );
        insert member;
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to be member of one group before the update'
        );
        Id permissionSetId = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'CRM_NavEmployees'
            LIMIT 1
        ]
        .Id;
        //assign permission set before update
        PermissionSetAssignment assignment = new PermissionSetAssignment();
        assignment.AssigneeId = UserInfo.getUserId();
        assignment.PermissionSetId = permissionSetId;
        insert assignment;
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetId = :permissionSetId
            ],
            'Expect user to be assigned to one perm set before update'
        );

        List<String> adGroupsInTest = new List<String>();
        adGroupsInTest.add(adGroupIds[0]);

        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A33213',
            'Standard Profile'
        );

        //Act
        Test.startTest();
        new AdGroupSyncService().addRemoveGroupsAndPerms(user, adGroupsInTest);
        Test.stopTest();

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to be removed from the group'
        );

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetId = :permissionSetId
            ],
            'Expect no permission set to be assigned'
        );

        //Assert
        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Log_Level__c = 'Error'
            ],
            'Expect no errors in application log'
        );
    }

    @IsTest
    private static void updateGroupMembership_whenNoChanges() {
        //Arrange
        //add user to group before the update
        Id publicGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'NKS_Skjermede_Personer_AD'
            LIMIT 1
        ]
        .Id;
        GroupMember member = new GroupMember(
            UserOrGroupId = UserInfo.getUserId(),
            GroupId = publicGroupId
        );
        insert member;
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to be member of one group before the update'
        );

        Id permissionSetId = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'CRM_NavEmployees'
            LIMIT 1
        ]
        .Id;
        //assign permission set before update
        PermissionSetAssignment assignment = new PermissionSetAssignment();
        assignment.AssigneeId = UserInfo.getUserId();
        assignment.PermissionSetId = permissionSetId;
        insert assignment;

        List<String> adGroupsInTest = new List<String>();
        adGroupsInTest.add(adGroupIds[0]);
        adGroupsInTest.add(adGroupIds[1]);

        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A33213',
            'Standard Profile'
        );

        //Act
        Test.startTest();
        new AdGroupSyncService().addRemoveGroupsAndPerms(user, adGroupsInTest);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to still be member of the group'
        );

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetId = :permissionSetId
            ],
            'Expect permission set to still be assigned'
        );

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Log_Level__c = 'Error'
            ],
            'Expect no errors in application log'
        );
    }

    @IsTest
    private static void updateGroupMembership_insertMultiGroupMembership() {
        //Arrange
        Id groupOne = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'NKS_Skjermede_Personer_AD'
            LIMIT 1
        ]
        .Id;
        Id groupTwo = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'group_AD_Fortrolig_Adresse'
            LIMIT 1
        ]
        .Id;
        Id multiGroup = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'NKS_Fortrolig_Skjermet_AD'
            LIMIT 1
        ]
        .Id;

        Set<Id> groupIdSet = new Set<Id>{ groupOne, groupTwo, multiGroup };
        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId IN :groupIdSet
            ],
            'Expected user to not be member of any groups before the update'
        );

        Id permissionSetId = [
            SELECT Id
            FROM PermissionSet
            WHERE Name = 'CRM_NavEmployees'
            LIMIT 1
        ]
        .Id;

        List<String> adGroupsInTest = new List<String>();
        adGroupsInTest.add(adGroupIds[0]);
        adGroupsInTest.add(adGroupIds[1]);
        adGroupsInTest.add(adGroupIds[2]);
        adGroupsInTest.add(adGroupIds[3]);

        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A33213',
            'Standard Profile'
        );

        //Act
        Test.startTest();
        new AdGroupSyncService().addRemoveGroupsAndPerms(user, adGroupsInTest);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            3,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId IN :groupIdSet
            ],
            'Expected user to be added to all relevant groups'
        );

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetId = :permissionSetId
            ],
            'Expect permission set to be added to be able to access necessary fields'
        );

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Log_Level__c = 'Error'
            ],
            'Expect no errors in application log'
        );
    }

    @IsTest
    private static void updateGroupMembership_whenTheUserIsAlreadyAssignedToThePermissionSetGroup() {
        //Arrange
        //Assign perm set group to current user
        PermissionSetGroup permSetGroup = [
            SELECT Id
            FROM PermissionSetGroup
            WHERE DeveloperName = 'Test'
            LIMIT 1
        ];
        PermissionSetAssignment assignment = new PermissionSetAssignment();
        assignment.AssigneeId = UserInfo.getUserId();
        assignment.PermissionSetGroupId = permSetGroup.Id;
        insert assignment;

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetGroup.DeveloperName = 'Test'
            ],
            'Expect user to already be assigned with the permission set group'
        );

        Id publicGroupId = [
            SELECT Id
            FROM Group
            WHERE DeveloperName = 'group_410098'
            LIMIT 1
        ]
        .Id;

        List<String> adGroupsInTest = new List<String>();
        adGroupsInTest.add('597b2345-5846-4c9c-ba9d-15323preprod');

        UserDomain user = new UserDomain(
            UserInfo.getUserId(),
            'A33213',
            'Standard Profile'
        );

        //Act
        Test.startTest();
        new AdGroupSyncService().addRemoveGroupsAndPerms(user, adGroupsInTest);
        Test.stopTest();

        //Assert
        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM GroupMember
                WHERE
                    UserOrGroupId = :UserInfo.getUserId()
                    AND GroupId = :publicGroupId
            ],
            'Expected user to be added to one group'
        );

        Assert.areEqual(
            1,
            [
                SELECT COUNT()
                FROM PermissionSetAssignment
                WHERE
                    AssigneeId = :UserInfo.getUserId()
                    AND PermissionSetGroup.DeveloperName = 'Test'
            ],
            'Expect permission set to be added to be able to access necessary fields'
        );

        Assert.areEqual(
            0,
            [
                SELECT COUNT()
                FROM Application_Log__c
                WHERE Log_Level__c = 'Error'
            ],
            'Expect no errors in application log'
        );
    }
}
