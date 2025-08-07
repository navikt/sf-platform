public with sharing class UserDomain {
    public Id recordId;
    public String navId;
    public String profileName;
    public Boolean hasAccessToFortrolig = false;
    public Boolean hasAccessToSkjermet = false;
    public Boolean hasAccessToStrengtFortrolig = false;

    public UserDomain(Id recordId, String navId, String profileName) {
        this.recordId = recordId;
        this.navId = navId;
        this.profileName = profileName;
    }

    public void setAccessLevel(String accessType) {
        if (accessType == 'Fortrolig') {
            hasAccessToFortrolig = true;
        } else if (accessType == 'Skjermet') {
            hasAccessToSkjermet = true;
        } else if (accessType == 'Strengt_Fortrolig') {
            hasAccessToStrengtFortrolig = true;
        }
    }

    public Boolean hasSensitiveDataAccess() {
        return hasAccessToFortrolig ||
            hasAccessToSkjermet ||
            hasAccessToStrengtFortrolig;
    }
}
