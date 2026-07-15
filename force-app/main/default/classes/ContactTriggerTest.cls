@isTest
private class ContactTriggerTest {

    // ✅ Covers: Trigger before insert → ContactHandler.handleBeforeSave called
    @isTest
    static void testTrigger_BeforeInsert_SetsLeadSource() {
        Test.startTest();
        Contact c = new Contact(LastName = 'Trigger Insert Test');
        insert c;
        Test.stopTest();

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Web', result.LeadSource,
            'Trigger should set LeadSource to Web on before insert');
    }

    // ✅ Covers: Trigger before insert with LeadSource already set → not overridden
    @isTest
    static void testTrigger_BeforeInsert_PreservesLeadSource() {
        Test.startTest();
        Contact c = new Contact(LastName = 'Trigger Insert Existing', LeadSource = 'Cold Call');
        insert c;
        Test.stopTest();

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Cold Call', result.LeadSource,
            'Trigger should not override existing LeadSource on before insert');
    }

    // ✅ Covers: Trigger before update → ContactHandler.handleBeforeSave called on update
    @isTest
    static void testTrigger_BeforeUpdate_SetsLeadSource() {
        Contact c = new Contact(LastName = 'Trigger Update Test', LeadSource = 'Email');
        insert c;

        Test.startTest();
        c.LeadSource = null;  // clear it
        update c;
        Test.stopTest();

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Web', result.LeadSource,
            'Trigger should set LeadSource to Web on before update when blank');
    }

    // ✅ Covers: Trigger before update → existing LeadSource preserved
    @isTest
    static void testTrigger_BeforeUpdate_PreservesLeadSource() {
        Contact c = new Contact(LastName = 'Trigger Update Preserve', LeadSource = 'Web');
        insert c;

        Test.startTest();
        c.LastName = 'Trigger Update Preserve Updated';
        update c;
        Test.stopTest();

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Web', result.LeadSource,
            'Trigger should not change LeadSource when already set on update');
    }

    // ✅ Covers: Bulk before insert → trigger handles multiple records
    @isTest
    static void testTrigger_BulkInsert() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 200; i++) {
            contacts.add(new Contact(LastName = 'Bulk Trigger ' + i));
        }

        Test.startTest();
        insert contacts;
        Test.stopTest();

        List<Contact> results = [SELECT LeadSource FROM Contact WHERE Id IN :contacts];
        for (Contact result : results) {
            System.assertEquals('Web', result.LeadSource,
                'All bulk contacts without LeadSource should default to Web');
        }
    }
}
