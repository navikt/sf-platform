@IsTest
private class ThemeGroupRepositoryTest {
    @IsTest
    private static void shouldReturnAllThemeGroups() {
        // Act
        Map<Id, ThemeGroup> allThemeGroups = new ThemeGroupRepository()
            .fetchThemeGroupsMappedById();

        // Assert
        Assert.isFalse(allThemeGroups.isEmpty());
    }

    @IsTest
    private static void shouldReturnAllSensitiveThemeGroupsMappedByGroupId() {
        // Act
        Map<Id, ThemeGroup> allSensitiveThemeGroups = new ThemeGroupRepository()
            .fetchSensitiveThemeGroupsMappedById();

        // Assert
        Assert.isFalse(allSensitiveThemeGroups.isEmpty());
    }

    @IsTest
    private static void shouldReturnAllSensitiveThemeGroupsMappedByDeveloperName() {
        // Act
        Map<String, ThemeGroup> allSensitiveThemeGroups = new ThemeGroupRepository()
            .fetchSensitiveThemeGroupsMappedByDeveloperName();

        // Assert
        Assert.isFalse(allSensitiveThemeGroups.isEmpty());
    }
}
