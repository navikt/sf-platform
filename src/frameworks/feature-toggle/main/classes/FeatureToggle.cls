/**
 * @description Class to hold common parameters in the feature toggle framework.
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, April 2025 - Created
 */
public with sharing class FeatureToggle {
    public enum ToggleType {
        CUSTOM_PERMISSION,
        FEATURE_FLAG
    }

    private static Boolean validateCustomPermissions = false;

    /**
     * @description Sets the custom permission validation flag.
     *
     * @param validate `true` to enable validation, `false` to disable.
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Created
     */
    public static void setValidateCustomPermissions(Boolean validate) {
        FeatureToggle.validateCustomPermissions = validate;
    }

    /**
     * @description Retrieves the current state of custom permission validation.
     * @return `true` if validation is enabled, `false` otherwise.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Created
     */
    public static Boolean shouldValidateCustomPermissions() {
        return FeatureToggle.validateCustomPermissions;
    }
}
