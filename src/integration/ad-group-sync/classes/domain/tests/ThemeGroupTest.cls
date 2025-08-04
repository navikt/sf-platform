@isTest
private class ThemeGroupTest {
    @IsTest
    private static void shouldSetThemeNameTo_PEN_WhenDeveloperNameIsTema_PEN() {
        // Arrange
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'Tema_PEN'
        );

        // Act
        String themeName = themeGroup.getThemeName();

        // Assert
        Assert.areEqual('PEN', themeName);
    }

    @IsTest
    private static void shouldSetThemeNameTo_BID_WhenDeveloperNameIsFortrolig_BID() {
        // Arrange
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'Fortrolig_BID'
        );

        // Act
        String themeName = themeGroup.getThemeName();

        // Assert
        Assert.areEqual('BID', themeName);
    }

    @IsTest
    private static void shouldSetThemeNameTo_DAG_WhenDeveloperNameIsSkjermet_DAG() {
        // Arrange
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'Skjermet_DAG'
        );

        // Act
        String themeName = themeGroup.getThemeName();

        // Assert
        Assert.areEqual('DAG', themeName);
    }

    @IsTest
    private static void shouldSetThemeNameTo_AFP_WhenDeveloperNameIsFortrolig_Skjermet_AFP() {
        // Arrange
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'Fortrolig_Skjermet_AFP'
        );

        // Act
        String themeName = themeGroup.getThemeName();

        // Assert
        Assert.areEqual('AFP', themeName);
    }

    @IsTest
    private static void shouldSetThemeNameToNullWhenDeveloperNameDoesNotStartWithTemaOrSensitivity() {
        // Arrange
        ThemeGroup themeGroup = new ThemeGroup(
            '00GS8000007QPziMAG',
            'NonTemaGroup'
        );

        // Act
        String themeName = themeGroup.getThemeName();

        // Assert
        Assert.isNull(themeName);
    }
}
