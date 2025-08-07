public with sharing class RefreshTokenService {
    public void saveRefreshToken(String refreshToken) {
        // The AllOrNone parameter is used to catch errors due to already deleted Log__c
        List<Database.DeleteResult> deletedTokens = Database.delete(
            [
                SELECT Id
                FROM Log__c
                WHERE
                    CRM_Type__c = 'Refresh Token'
                    AND OwnerId = :userinfo.getuserid()
            ],
            false
        );

        List<Id> deletedTokenIds = new List<Id>();
        for (Database.DeleteResult dr : deletedTokens) {
            if (dr.isSuccess())
                deletedTokenIds.add(dr.getId());
        }
        if (!deletedTokenIds.isEmpty())
            Database.emptyRecycleBin(deletedTokenIds);

        String encryptedRefreshToken = CryptoService.encryptString(
            refreshToken
        );
        Log__c newRefreshTokenLog = new Log__c(
            CRM_Type__c = 'Refresh Token',
            CRM_Payload__c = encryptedRefreshToken
        );
        insert newRefreshTokenLog;
    }
}
