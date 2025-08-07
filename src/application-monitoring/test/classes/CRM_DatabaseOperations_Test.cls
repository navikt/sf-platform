@isTest
public class CRM_DatabaseOperations_Test {
    @isTest
    public static void testDatabaseOperationsLists() {
        List<Account> accs = TestDataFactory.getAccounts(10, false);
        List<Account> accs2 = new List<Account>();
        List<String> names = new List<String>{
            '1',
            '2',
            '3',
            '4',
            '5',
            '6',
            '7',
            '8',
            '9',
            '10',
            '11',
            '12',
            '13',
            '14',
            '15'
        };
        CRM_DatabaseOperations cbr = new CRM_DatabaseOperations();

        for (Integer i = 0; i < 5; i++) {
            accs2.add(accs[accs.size() - 1]);
            accs.remove(accs.size() - 1);
        }
        System.assert(
            accs.size() == 5 && accs2.size() == 5,
            'Account creation went wrong.'
        );

        Test.startTest();

        // INSERT
        cbr.insertRecords(accs);
        accs = [SELECT Name, Id FROM Account WHERE Name IN :names];
        System.assert(
            accs.size() == 5,
            'Accounts were not inserted correctly.'
        );

        // UPSERT
        for (Account acc : accs) {
            acc.Name = String.valueOf(Integer.valueOf(acc.Name) + 10);
        }
        accs.addAll(accs2);
        cbr.upsertRecords(accs);
        accs = [SELECT Name, Id FROM Account WHERE Name IN :names];
        System.assert(
            accs.size() == 10,
            'Accounts were not upserted correctly.'
        );

        // UPDATE
        for (Account acc : accs) {
            acc.Name = acc.Name + ' DatabaseTest';
        }
        cbr.updateRecords(accs);
        accs = [SELECT Name, Id FROM Account WHERE Name LIKE '%DatabaseTest%'];
        System.assert(
            accs.size() == 10,
            'Accounts were not updated correctly.'
        );

        // DELETE
        cbr.deleteRecords(accs);
        List<Account> afterDelete = new List<Account>(
            [SELECT Name, Id FROM Account WHERE Name LIKE '%DatabaseTest%']
        );
        System.assert(
            afterDelete.isEmpty(),
            'Accounts were not deleted correctly.'
        );

        // UNDELETE
        cbr.undeleteRecords(accs);
        accs = [SELECT Name, Id FROM Account WHERE Name LIKE '%DatabaseTest%'];
        System.assert(
            accs.size() == 10,
            'Accounts were not undeleted correctly.'
        );

        Test.stopTest();
    }

    @isTest
    public static void testDatabaseOperationsSingleRecord() {
        Account acc = new Account(Name = '1');
        List<String> names = new List<String>{ '11', '2' };
        CRM_DatabaseOperations cbr = new CRM_DatabaseOperations();

        Test.startTest();

        // INSERT
        cbr.insertRecords(acc);
        List<Account> accs = new List<Account>(
            [SELECT Name, Id FROM Account WHERE Name = '1']
        );
        System.assert(
            accs.size() == 1,
            'Accounts were not inserted correctly.'
        );

        // UPSERT
        for (Account ac : accs) {
            ac.Name = String.valueOf(Integer.valueOf(ac.Name) + 10);
        }
        acc = accs[0];
        Account acc2 = new Account(Name = '2');
        cbr.upsertRecords(acc);
        cbr.upsertRecords(acc2);
        accs = [SELECT Name, Id FROM Account WHERE Name IN :names];
        System.assert(
            accs.size() == 2,
            'Accounts were not upserted correctly.'
        );

        // UPDATE
        acc.Name = acc.Name + ' DatabaseTest';
        cbr.updateRecords(acc);
        accs = [SELECT Name, Id FROM Account WHERE Name LIKE '%DatabaseTest%'];
        System.assert(accs.size() == 1, 'Accounts were not updated correctly.');

        // DELETE
        cbr.deleteRecords(acc);
        List<Account> afterDelete = new List<Account>(
            [SELECT Name, Id FROM Account WHERE Name LIKE '%DatabaseTest%']
        );
        System.assert(
            afterDelete.isEmpty(),
            'Accounts were not deleted correctly.'
        );

        // UNDELETE
        cbr.undeleteRecords(acc);
        accs = [SELECT Name, Id FROM Account WHERE Name LIKE '%DatabaseTest%'];
        System.assert(
            accs.size() == 1,
            'Accounts were not undeleted correctly.'
        );

        Test.stopTest();
    }

    @isTest
    public static void testParameters() {
        Account acc1 = new Account();
        Account acc2 = new Account(Name = 'TestAllOrNone');
        Account acc3 = new Account(Name = 'TestAllOrNone');
        List<Account> accs = new List<Account>{ acc1, acc2 };
        List<Account> accs2 = new List<Account>{ acc1, acc3 };
        CRM_DatabaseOperations cbr = new CRM_DatabaseOperations()
            .setVerbose()
            .setNumberOfRetries(1)
            .setDomain(CRM_ApplicationDomain.Domain.NKS);

        Test.startTest();
        cbr.insertRecords(accs);
        cbr = cbr.setAllOrNone();
        cbr.insertRecords(accs2);
        Test.stopTest();
        System.assert(
            [SELECT COUNT() FROM Application_Log__c] == 7,
            'Incorrect amount of application logs was created.'
        );
        System.assert(
            [SELECT Application_Domain__c FROM Application_Log__c LIMIT 1][0]
            .Application_Domain__c == 'NKS',
            'Domain wasn\'t set correctly.'
        );
        System.assert(
            [SELECT Id FROM Account WHERE Name = 'TestAllOrNone'].size() == 1,
            'Partial insert was unsuccessful.'
        );
    }
}
