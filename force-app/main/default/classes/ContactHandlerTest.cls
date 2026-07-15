@isTest
private class ContactHandlerTest {
    @isTest
    static void testDefaultLeadSource() {
        Contact c = new Contact(LastName = 'Test');
        insert c;

        Contact result = [SELECT LeadSource FROM Contact WHERE Id = :c.Id];
        System.assertEquals('Web', result.LeadSource);
    }
}