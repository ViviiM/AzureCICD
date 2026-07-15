public with sharing class ContactHandler {
    public static void handleBeforeSave(List<Contact> contacts) {
        for (Contact c : contacts) {
            if (String.isBlank(c.LeadSource)) {
                c.LeadSource = 'Phone Inquiry';
            }
        }
    }
}