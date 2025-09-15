/**
 * @description
 * Queueable class for synchronizing AD group memberships and permissions for a user.
 * Delegates to AdGroupSyncService to perform add/remove operations asynchronously.
 * Designed for bulk-safe execution and platform integration.
 */
public with sharing class AdGroupSyncQueueable implements Queueable {
    /**
     * @description List of AD group IDs to synchronize for the user.
     */
    private List<String> adGroupIds;

    /**
     * @description Domain object representing the current user.
     */
    private UserDomain currentUser;

    /**
     * @description Service for handling AD group sync logic.
     */
    private AdGroupSyncService adGroupSyncService = new AdGroupSyncService();

    /**
     * @description Constructor for AdGroupSyncQueueable.
     * @param adGroupIds List of AD group IDs to sync.
     * @param currentUser UserDomain representing the user to sync.
     */
    public AdGroupSyncQueueable(
        List<String> adGroupIds,
        UserDomain currentUser
    ) {
        this.adGroupIds = adGroupIds;
        this.currentUser = currentUser;
    }

    /**
     * @description Executes the queueable job to synchronize AD groups and permissions.
     * @param context QueueableContext provided by the platform.
     */
    // prettier-ignore
    public void execute(QueueableContext context) { // NOPMD - No need for a Finalizer
        adGroupSyncService.addRemoveGroupsAndPerms(currentUser, adGroupIds);
    }
}
