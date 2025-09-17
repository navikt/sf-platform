public with sharing class AvvikAccessMock implements IAvvikAccess, Queueable {
    public void setNavIdent(String navId) {
        system.debug('Mock setNavIdent called with navId: ' + navId);
    }

    public void execute(QueueableContext context) {
        system.debug('Mock execute method called.');
    }
}
