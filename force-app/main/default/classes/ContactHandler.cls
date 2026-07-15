public with sharing class ContactHandler {
    public static void handleBeforeSave(List<Contact> contacts) {
        if (contacts == null || contacts.isEmpty()) {
            return;
        }
        for (Contact c : contacts) {
            if (String.isBlank(c.LeadSource)) {
                c.LeadSource = 'Phone Inquiry';
            }
        }
    }
}