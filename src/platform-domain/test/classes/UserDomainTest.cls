@IsTest
private with sharing class UserDomainTest {
    @IsTest
    private static void shouldNotHaveSensitiveDataAccessInitiallyFullArgs() {
        // Arrange
        Id userId = UserInfo.getUserId();
        String navId = 'NAV123';
        String profileName = 'Standard';

        // Act
        System.Test.startTest();
        UserDomain domain = new UserDomain(userId, navId, profileName);
        System.Test.stopTest();

        // Assert
        Assert.areEqual(
            false,
            domain.hasSensitiveDataAccess(),
            'Should not have access initially'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToFortrolig,
            'Fortrolig access should be false initially'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToSkjermet,
            'Skjermet access should be false initially'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToStrengtFortrolig,
            'Strengt_Fortrolig access should be false initially'
        );
    }

    @IsTest
    private static void shouldSetFortroligAccessAndHaveSensitiveDataAccess() {
        // Arrange
        Id userId = UserInfo.getUserId();
        String navId = 'NAV123';
        String profileName = 'Standard';
        UserDomain domain = new UserDomain(userId, navId, profileName);

        // Act
        System.Test.startTest();
        domain.setAccessLevel('Fortrolig');
        System.Test.stopTest();

        // Assert
        Assert.areEqual(
            true,
            domain.hasAccessToFortrolig,
            'Fortrolig access should be true'
        );
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access after Fortrolig'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToSkjermet,
            'Skjermet access should remain false'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToStrengtFortrolig,
            'Strengt_Fortrolig access should remain false'
        );
    }

    @IsTest
    private static void shouldSetSkjermetAccessAndHaveSensitiveDataAccess() {
        // Arrange
        Id userId = UserInfo.getUserId();
        String navId = 'NAV123';
        String profileName = 'Standard';
        UserDomain domain = new UserDomain(userId, navId, profileName);

        // Act
        System.Test.startTest();
        domain.setAccessLevel('Skjermet');
        System.Test.stopTest();

        // Assert
        Assert.areEqual(
            true,
            domain.hasAccessToSkjermet,
            'Skjermet access should be true'
        );
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access after Skjermet'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToFortrolig,
            'Fortrolig access should remain false'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToStrengtFortrolig,
            'Strengt_Fortrolig access should remain false'
        );
    }

    @IsTest
    private static void shouldSetStrengtFortroligAccessAndHaveSensitiveDataAccess() {
        // Arrange
        Id userId = UserInfo.getUserId();
        String navId = 'NAV123';
        String profileName = 'Standard';
        UserDomain domain = new UserDomain(userId, navId, profileName);

        // Act
        System.Test.startTest();
        domain.setAccessLevel('Strengt_Fortrolig');
        System.Test.stopTest();

        // Assert
        Assert.areEqual(
            true,
            domain.hasAccessToStrengtFortrolig,
            'Strengt_Fortrolig access should be true'
        );
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access after Strengt_Fortrolig'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToFortrolig,
            'Fortrolig access should remain false'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToSkjermet,
            'Skjermet access should remain false'
        );
    }

    @IsTest
    private static void shouldNotSetAccessForUnknownAccessType_fullArgs() {
        // Arrange
        Id userId = UserInfo.getUserId();
        String navId = 'NAV123';
        String profileName = 'Standard';
        UserDomain domain = new UserDomain(userId, navId, profileName);

        // Act
        System.Test.startTest();
        domain.setAccessLevel('Unknown');
        System.Test.stopTest();

        // Assert
        Assert.areEqual(
            false,
            domain.hasSensitiveDataAccess(),
            'Should not have sensitive data access for unknown type'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToFortrolig,
            'Fortrolig access should remain false'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToSkjermet,
            'Skjermet access should remain false'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToStrengtFortrolig,
            'Strengt_Fortrolig access should remain false'
        );
    }

    @IsTest
    private static void shouldAllowMultipleAccessLevelsToBeSet_fullArgs() {
        // Arrange
        Id userId = UserInfo.getUserId();
        String navId = 'NAV123';
        String profileName = 'Standard';
        UserDomain domain = new UserDomain(userId, navId, profileName);

        // Act
        System.Test.startTest();
        domain.setAccessLevel('Fortrolig');
        domain.setAccessLevel('Skjermet');
        domain.setAccessLevel('Strengt_Fortrolig');
        System.Test.stopTest();

        // Assert
        Assert.areEqual(
            true,
            domain.hasAccessToFortrolig,
            'Should have Fortrolig access'
        );
        Assert.areEqual(
            true,
            domain.hasAccessToSkjermet,
            'Should have Skjermet access'
        );
        Assert.areEqual(
            true,
            domain.hasAccessToStrengtFortrolig,
            'Should have Strengt_Fortrolig access'
        );
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access when multiple levels are set'
        );
    }

    @IsTest
    private static void shouldNotHaveSensitiveDataAccessInitially() {
        // Arrange
        Id userId = UserInfo.getUserId();
        String navId = 'NAV123';
        String profileName = 'Standard';

        // Act
        System.Test.startTest();
        UserDomain domain = new UserDomain(userId, navId, profileName);
        System.Test.stopTest();

        // Assert
        Assert.areEqual(
            false,
            domain.hasSensitiveDataAccess(),
            'Should not have access initially'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToFortrolig,
            'Fortrolig access should be false initially'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToSkjermet,
            'Skjermet access should be false initially'
        );
        Assert.areEqual(
            false,
            domain.hasAccessToStrengtFortrolig,
            'Strengt_Fortrolig access should be false initially'
        );
    }

    @IsTest
    private static void shouldSetFortroligAccess() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Fortrolig');
        System.Test.stopTest();
        Assert.areEqual(
            true,
            domain.hasAccessToFortrolig,
            'Fortrolig access should be true'
        );
    }

    @IsTest
    private static void shouldSetSkjermetAccess() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Skjermet');
        System.Test.stopTest();
        Assert.areEqual(
            true,
            domain.hasAccessToSkjermet,
            'Skjermet access should be true'
        );
    }

    @IsTest
    private static void shouldSetStrengtFortroligAccess() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Strengt_Fortrolig');
        System.Test.stopTest();
        Assert.areEqual(
            true,
            domain.hasAccessToStrengtFortrolig,
            'Strengt_Fortrolig access should be true'
        );
    }

    @IsTest
    private static void shouldNotSetAccessForUnknownAccessType() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Unknown');
        System.Test.stopTest();
        Assert.areEqual(
            false,
            domain.hasSensitiveDataAccess(),
            'Should not have sensitive data access for unknown type'
        );
    }

    @IsTest
    private static void shouldAllowMultipleAccessLevelsToBeSet() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Fortrolig');
        domain.setAccessLevel('Skjermet');
        domain.setAccessLevel('Strengt_Fortrolig');
        System.Test.stopTest();
        Assert.areEqual(
            true,
            domain.hasAccessToFortrolig,
            'Should have Fortrolig access'
        );
        Assert.areEqual(
            true,
            domain.hasAccessToSkjermet,
            'Should have Skjermet access'
        );
        Assert.areEqual(
            true,
            domain.hasAccessToStrengtFortrolig,
            'Should have Strengt_Fortrolig access'
        );
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access when multiple levels are set'
        );
    }

    @IsTest
    private static void shouldReturnTrueForSensitiveDataAccessAfterFortrolig() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Fortrolig');
        System.Test.stopTest();
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access after Fortrolig'
        );
    }

    @IsTest
    private static void shouldReturnTrueForSensitiveDataAccessAfterSkjermet() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Skjermet');
        System.Test.stopTest();
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access after Skjermet'
        );
    }

    @IsTest
    private static void shouldReturnTrueForSensitiveDataAccessAfterStrengtFortrolig() {
        Id userId = UserInfo.getUserId();
        UserDomain domain = new UserDomain(userId, 'NAV123', 'Standard');
        System.Test.startTest();
        domain.setAccessLevel('Strengt_Fortrolig');
        System.Test.stopTest();
        Assert.areEqual(
            true,
            domain.hasSensitiveDataAccess(),
            'Should have sensitive data access after Strengt_Fortrolig'
        );
    }
}
