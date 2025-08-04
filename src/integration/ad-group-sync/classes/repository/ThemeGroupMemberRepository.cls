public without sharing class ThemeGroupMemberRepository extends RepositoryBase {
    public Map<String, ThemeGroupMember> fetchMembershipsForSpecificUserMappedByDeveloperName(
        UserDomain user,
        Map<Id, ThemeGroup> groups
    ) {
        Map<String, ThemeGroupMember> themeGroupMembers = new Map<String, ThemeGroupMember>();
        for (GroupMember groupMember : [
            SELECT Id, UserOrGroupId, GroupId
            FROM GroupMember
            WHERE UserOrGroupId = :user.recordId AND GroupId IN :groups.keySet()
        ]) {
            ThemeGroup themeGroup = groups.get(groupMember.GroupId);
            themeGroupMembers.put(
                themeGroup.developerName,
                new ThemeGroupMember(user, themeGroup, groupMember.Id)
            );
        }
        return themeGroupMembers;
    }

    public void insertToDatabase(List<ThemeGroupMember> themeGroupMembers) {
        List<GroupMember> newMembers = new List<GroupMember>();
        for (ThemeGroupMember member : themeGroupMembers) {
            newMembers.add(member.convertToSaleforceObject());
        }
        if (!newMembers.isEmpty()) {
            List<Database.SaveResult> srList = Database.insert(
                newMembers,
                false
            );
            handleSaveResult(srList);
        }
    }

    public void deleteFromDatabase(List<ThemeGroupMember> themeGroupMembers) {
        List<GroupMember> membersToDelete = new List<GroupMember>();

        for (ThemeGroupMember member : themeGroupMembers) {
            if (member.recordId != null) {
                membersToDelete.add(new GroupMember(Id = member.recordId));
            }
        }

        if (!membersToDelete.isEmpty()) {
            List<Database.DeleteResult> drList = Database.delete(
                membersToDelete,
                false
            );
            handleDeleteResult(drList);
        }
    }
}
