public with sharing class ThemeGroupMember {
    public UserDomain user;
    public ThemeGroup themeGroup;
    public Id recordId;

    public ThemeGroupMember(UserDomain user, ThemeGroup themeGroup) {
        this.user = user;
        this.themeGroup = themeGroup;
    }

    public ThemeGroupMember(
        UserDomain user,
        ThemeGroup themeGroup,
        Id recordId
    ) {
        this.user = user;
        this.themeGroup = themeGroup;
        this.recordId = recordId;
    }

    public GroupMember convertToSaleforceObject() {
        return new GroupMember(
            UserOrGroupId = user.recordId,
            GroupId = themeGroup.groupId
        );
    }
}
