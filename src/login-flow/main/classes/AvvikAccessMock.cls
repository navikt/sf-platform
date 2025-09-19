/**
 * @description
 * Mock implementation of the IAvvikAccess interface for unit testing login flow logic.
 * Implements Queueable to simulate asynchronous job behavior.
 * Used in test classes to verify DI and job enqueuing without invoking real AvvikAccess logic.
 */
@SuppressWarnings('PMD')
public with sharing class AvvikAccessMock implements IAvvikAccess, Queueable {
    /**
     * @description NAV identifier for the user, used to simulate AvvikAccess logic.
     */
    private String navIdent;

    /**
     * @description Sets the NAV identifier for the mock job.
     * @param navIdent NAV identifier to use in the mock.
     */
    public void setNavIdent(String navIdent) {
        this.navIdent = navIdent;
        System.debug('Mock setNavIdent called with: ' + navIdent);
    }

    /**
     * @description Simulates execution of the queueable job for testing purposes.
     * @param context QueueableContext provided by the platform.
     */
    public void execute(QueueableContext context) {
        System.debug('Mock execute method called with navIdent: ' + navIdent);
    }
}
