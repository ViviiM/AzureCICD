@isTest
private class AccountHandlerTest {

    // Covers null and empty list branches
    @isTest
    static void testHandleBeforeSave_NullAndEmptyList() {
        Test.startTest();

        AccountHandler.handleBeforeSave(null);
        AccountHandler.handleBeforeSave(new List<Account>());

        Test.stopTest();

        System.assert(true,
            'Method should handle null and empty lists without exception');
    }

    // Covers blank Type branch
    @isTest
    static void testHandleBeforeSave_SetsDefaultType() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Test Account')
        };

        Test.startTest();
        AccountHandler.handleBeforeSave(accounts);
        Test.stopTest();

        System.assertEquals(
            'Prospect',
            accounts[0].Type,
            'Type should be set to Prospect when blank'
        );
    }

    // Covers non-blank Type branch
    @isTest
    static void testHandleBeforeSave_PreservesExistingType() {
        List<Account> accounts = new List<Account>{
            new Account(Name = 'Existing Account', Type = 'Customer - Direct')
        };

        Test.startTest();
        AccountHandler.handleBeforeSave(accounts);
        Test.stopTest();

        System.assertEquals(
            'Customer - Direct',
            accounts[0].Type,
            'Existing Type should not be changed'
        );
    }

    // Covers bulk processing
    @isTest
    static void testHandleBeforeSave_BulkRecords() {
        List<Account> accounts = new List<Account>();

        for (Integer i = 0; i < 200; i++) {
            accounts.add(new Account(Name = 'Bulk Account ' + i));
        }

        Test.startTest();
        AccountHandler.handleBeforeSave(accounts);
        Test.stopTest();

        for (Account acc : accounts) {
            System.assertEquals(
                'Prospect',
                acc.Type,
                'All bulk records should receive default Type'
            );
        }
    }
}