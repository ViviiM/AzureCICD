@isTest
private class ContactTriggerTest {

    // ✅ Covers: ContactTrigger (before insert) → ContactHandler.handleBeforeSave
    //           ContactHandler: blank LeadSource branch → sets 'Phone Inquiry'
    @isTest
    static void testTrigger_BeforeInsert_SetsLeadSource() {
        Test.startTest();
        Contact c = new Contact(LastName = 'Trigger Insert Test');
        insert c;
        Test.stopTest();

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Phone Inquiry', result.LeadSource,
            'Trigger should set LeadSource to Phone Inquiry on before insert');
    }

    // ✅ Covers: ContactTrigger (before insert) → ContactHandler: non-blank branch → preserved
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

    // ✅ Covers: ContactTrigger (before update) → ContactHandler: blank LeadSource branch → sets 'Phone Inquiry'
    @isTest
    static void testTrigger_BeforeUpdate_SetsLeadSource() {
        Contact c = new Contact(LastName = 'Trigger Update Test', LeadSource = 'Email');
        insert c;

        Test.startTest();
        c.LeadSource = null;  // clear it
        update c;
        Test.stopTest();

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Phone Inquiry', result.LeadSource,
            'Trigger should set LeadSource to Phone Inquiry on before update when blank');
    }

    // ✅ Covers: ContactTrigger (before update) → ContactHandler: non-blank branch → preserved
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

    // ✅ Covers: ContactTrigger (before insert) bulk → ContactHandler: handles 200 records
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
            System.assertEquals('Phone Inquiry', result.LeadSource,
                'All bulk contacts without LeadSource should default to Phone Inquiry');
        }
    }
}
