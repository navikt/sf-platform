trigger ApplicationLogTrigger on Application_Log__c(after insert) {
    ApplicationLogPublisher.publishLogs(Trigger.new);
}
