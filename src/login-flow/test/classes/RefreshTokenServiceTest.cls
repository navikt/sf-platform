@IsTest
private class RefreshTokenServiceTest {
    @TestSetup
    static void makeData() {
        BaseTestFactory.insertEncryptionKey();
    }

    @IsTest
    private static void shouldSaveNewDecryptedToken() {
        // Arrange
        Log__c oldToken = new Log__c(
            CRM_Payload__c = 'oldToken',
            CRM_Type__c = 'Refresh Token'
        );
        insert oldToken;

        // Act
        Test.startTest();
        new RefreshTokenService().saveRefreshToken('newToken');
        Test.stopTest();

        // Assert
        List<Log__c> logs = [
            SELECT CRM_Payload__c
            FROM Log__c
            WHERE CRM_Type__c = 'Refresh Token'
        ];
        Assert.areEqual(1, logs.size());
        String decryptedToken = CryptoService.decryptString(
            logs[0].CRM_Payload__c
        );
        System.assertEquals('newToken', decryptedToken);
    }
}
