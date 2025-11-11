/**
 * @description
 * Domain object representing a Salesforce user with NAV-specific access levels.
 * Encapsulates business logic for sensitive data access and profile information.
 * Used throughout the platform for permission checks and user context.
 */
public with sharing class UserDomain {
    /**
     * @description Salesforce record Id for the user.
     */
    public Id recordId;

    /**
     * @description NAV identifier for the user.
     */
    public String navId;

    /**
     * @description Profile name of the user.
     */
    public String profileName;

    /**
     * @description Indicates if the user has access to Fortrolig data.
     */
    public Boolean hasAccessToFortrolig = false;

    /**
     * @description Indicates if the user has access to Skjermet data.
     */
    public Boolean hasAccessToSkjermet = false;

    /**
     * @description Indicates if the user has access to Strengt Fortrolig data.
     */
    public Boolean hasAccessToStrengtFortrolig = false;

    /**
     * @description
     * Constructs a UserDomain instance with the given identifiers and profile.
     * @param recordId Salesforce record Id for the user.
     * @param navId NAV identifier for the user.
     * @param profileName Profile name of the user.
     */
    public UserDomain(Id recordId, String navId, String profileName) {
        this.recordId = recordId;
        this.navId = navId;
        this.profileName = profileName;
    }

    /**
     * @description
     * Sets the user's access level based on the provided access type.
     * @param accessType The access type ('Fortrolig', 'Skjermet', or 'Strengt_Fortrolig').
     */
    public void setAccessLevel(String accessType) {
        if (accessType == 'Fortrolig') {
            hasAccessToFortrolig = true;
        } else if (accessType == 'Skjermet') {
            hasAccessToSkjermet = true;
        } else if (accessType == 'Strengt_Fortrolig') {
            hasAccessToStrengtFortrolig = true;
        }
    }

    /**
     * @description
     * Checks if the user has access to any sensitive data category.
     * @return True if the user has access to Fortrolig, Skjermet, or Strengt Fortrolig data.
     */
    public Boolean hasSensitiveDataAccess() {
        return hasAccessToFortrolig ||
            hasAccessToSkjermet ||
            hasAccessToStrengtFortrolig;
    }

    /** Temporary due to deployment issue */
    public Boolean accessToThemesFromAdGroups;
    public UserDomain(Id recordId, String navId) {
        this.recordId = recordId;
        this.navId = navId;
        this.accessToThemesFromAdGroups = false; // Default value
    }
    public UserDomain(
        Id recordId,
        String navId,
        Boolean accessToThemesFromAdGroups
    ) {
        this.recordId = recordId;
        this.navId = navId;
        this.accessToThemesFromAdGroups = accessToThemesFromAdGroups;
    }

    public void checkAccessToFortroligAndSkjermetByAdGroups(
        List<String> usersAdGroupIds
    ) {
    }
}
