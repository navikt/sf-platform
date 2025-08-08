// NOPMD -- Suppressing all PMD warnings for this trigger
trigger ApplicationEventTrigger on Application_Event__e(after insert) {
    List<Application_Log__c> logs = new List<Application_Log__c>();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            logs.addAll(LoggerUtility.convertToLogs(Trigger.new));
            insert logs;
        }
    }

}
