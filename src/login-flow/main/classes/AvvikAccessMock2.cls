public with sharing class AvvikAccessMock2 implements IAvvikAccess, Queueable {
    private String navId;

    public void setNavIdent(String navId) {
        this.navId = navId;
        system.debug('Mock (2) setNavIdent called with navId: ' + navId);
    }

    public void execute(QueueableContext context) {
        system.debug('Mock (2) execute method called with navId ' + navId);
    }
}
