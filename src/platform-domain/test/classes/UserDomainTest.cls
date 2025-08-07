@IsTest
private with sharing class UserDomainTest {
    @IsTest
    private static void shouldReturnAccessToSkjermetAndFortrolig() {
        //Arrange
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
        user.checkAccessToFortroligAndSkjermetByAdGroups(adGroupIds);
        Test.stopTest();

        //Assert
        Assert.isTrue(user.hasAccessToFortrolig);
        Assert.isTrue(user.hasAccessToSkjermet);
    }
}
