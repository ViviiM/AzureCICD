public with sharing class AccountHandler {

    public static void handleBeforeSave(List<Account> accounts) {
        if (accounts == null || accounts.isEmpty()) {
            return;
        }

        for (Account acc : accounts) {
            if (String.isBlank(acc.Type)) {
                acc.Type = 'Prospect';
            }
        }
    }
}