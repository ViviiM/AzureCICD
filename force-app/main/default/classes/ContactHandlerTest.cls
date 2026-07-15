@isTest
private class ContactHandlerTest {

    // ✅ Branch 1: LeadSource is blank → should default to 'Web'
    @isTest
    static void testDefaultLeadSource_WhenBlank() {
        Contact c = new Contact(LastName = 'Test Blank');
        insert c;

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Web', result.LeadSource, 'LeadSource should default to Web when blank');
    }

    // ✅ Branch 2: LeadSource already has a value → should NOT be overridden
    @isTest
    static void testLeadSource_WhenAlreadySet() {
        Contact c = new Contact(LastName = 'Test Existing', LeadSource = 'Phone');
        insert c;

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Phone', result.LeadSource, 'LeadSource should not be overridden when already set');
    }

    // ✅ Bulk: multiple contacts, mix of blank and non-blank LeadSource
    @isTest
    static void testBulkInsert_MixedLeadSources() {
        List<Contact> contacts = new List<Contact>();
        for (Integer i = 0; i < 10; i++) {
            Contact c = new Contact(LastName = 'Bulk ' + i);
            if (Math.mod(i, 2) == 0) {
                c.LeadSource = 'Partner';
            }
            contacts.add(c);
        }
        insert contacts;

        List<Contact> results = [SELECT LeadSource FROM Contact WHERE Id IN :contacts];
        for (Integer i = 0; i < results.size(); i++) {
            if (String.isBlank(contacts[i].LeadSource)) {
                System.assertEquals('Web', results[i].LeadSource, 'Blank LeadSource should be set to Web');
            } else {
                System.assertEquals('Partner', results[i].LeadSource, 'Existing LeadSource should be preserved');
            }
        }
    }

    // ✅ Before Update: trigger also fires on update
    @isTest
    static void testLeadSource_OnUpdate_WhenBlank() {
        // Insert with a value first
        Contact c = new Contact(LastName = 'Update Test', LeadSource = 'Phone');
        insert c;

        // Clear LeadSource and update — trigger should set it to 'Web'
        c.LeadSource = null;
        update c;

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Web', result.LeadSource, 'LeadSource should be set to Web on update when blank');
    }
}