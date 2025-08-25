trigger ApplicationEventTrigger on Application_Event__e(after insert) { // NOPMD
    List<Application_Log__c> logs = new List<Application_Log__c>();

    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            logs.addAll(LoggerUtility.convertToLogs(Trigger.new));
            insert logs; // NOPMD
        }
    }

}
