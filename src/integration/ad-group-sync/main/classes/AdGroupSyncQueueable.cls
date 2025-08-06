public with sharing class AdGroupSyncQueueable implements Queueable {
   private List<String> adGroupIds;
    private UserDomain currentUser;
    private AdGroupSyncService adGroupSyncService= new AdGroupSyncService();

    public AdGroupSyncQueueable(List<String> adGroupIds, UserDomain currentUser) {
        this.adGroupIds = adGroupIds;
        this.currentUser = currentUser;
    }

    public void execute(QueueableContext context) {
        adGroupSyncService.addRemoveGroupsAndPerms(currentUser, adGroupIds);
    }
}