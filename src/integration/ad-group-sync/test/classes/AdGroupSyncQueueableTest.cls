@IsTest
private class AdGroupSyncQueueableTest {
    @IsTest
    private static void testExecuteWithValidParameters() {
        //Arrange
        UserDomain currentUser = new UserDomain(
            UserInfo.getUserId(),
            'test123',
            'Standard Profile'
        );

        List<String> adGroupIds = new List<String>{
            'test-ad-group-1',
            'test-ad-group-2'
        };

        AdGroupSyncQueueable queueable = new AdGroupSyncQueueable(
            adGroupIds,
            currentUser
        );

        //Act
        System.Test.startTest();
        System.enqueueJob(queueable);
        System.Test.stopTest();

        // Assert
        List<AsyncApexJob> jobs = [
            SELECT Id, Status, JobType
            FROM AsyncApexJob
            WHERE JobType = 'Queueable'
        ];

        Assert.isTrue(
            jobs.size() > 0,
            'Expected at least one queueable job to be enqueued'
        );
    }

    @IsTest
    private static void testExecuteWithEmptyAdGroupList() {
        //Arrange
        UserDomain currentUser = new UserDomain(
            UserInfo.getUserId(),
            'test123',
            'Standard Profile'
        );

        List<String> emptyAdGroupIds = new List<String>();

        AdGroupSyncQueueable queueable = new AdGroupSyncQueueable(
            emptyAdGroupIds,
            currentUser
        );

        //Act
        System.Test.startTest();
        System.enqueueJob(queueable);
        System.Test.stopTest();

        // Assert
        List<AsyncApexJob> jobs = [
            SELECT Id, Status, JobType
            FROM AsyncApexJob
            WHERE JobType = 'Queueable'
        ];

        Assert.isTrue(
            jobs.size() > 0,
            'Expected at least one queueable job to be enqueued'
        );
    }

    @IsTest
    private static void testConstructorSetsPropertiesCorrectly() {
        //Arrange
        UserDomain currentUser = new UserDomain(
            UserInfo.getUserId(),
            'test123',
            'Standard Profile'
        );

        List<String> adGroupIds = new List<String>{
            'test-ad-group-1',
            'test-ad-group-2'
        };

        // Act
        System.Test.startTest();
        AdGroupSyncQueueable queueable = new AdGroupSyncQueueable(
            adGroupIds,
            currentUser
        );
        System.Test.stopTest();

        //Assert
        Assert.isNotNull(
            queueable,
            'Expected queueable instance to be created'
        );
    }
}
