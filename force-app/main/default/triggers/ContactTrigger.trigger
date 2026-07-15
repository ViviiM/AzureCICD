trigger ContactTrigger on Contact (before insert, before update) {
    if (Trigger.isBefore && (Trigger.isInsert || Trigger.isUpdate)) {
        ContactHandler.handleBeforeSave(Trigger.new);
    }
}