/**
 * @description AuraEnabled method for checking feature toggles.
 *
 * @group Feature Toggle
 *
 * @see FeatureToggleBase
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, April 2025 - Moved from FeatureToggleBase
 */
public with sharing class FeatureToggleAura {
    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @param featureName The feature name.
     * @param toogleType The type (FEATURE_FLAG or CUSTOM_PERMISSION).
     * @return `true` if enabled, `false` otherwise.
     *
     * @exception throws `AuraHandledException` if something goes wrong.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Moved from FeatureToggleBase
     */
    @AuraEnabled(cacheable=true)
    public static Boolean isFeatureEnabled(
        String featureName,
        String toogleType
    ) {
        try {
            return new FeatureToggleBase()
                .isFeatureEnabled(
                    featureName,
                    FeatureToggle.ToggleType.valueOf(toogleType)
                );
        } catch (Exception e) {
            String exceptionMessage = String.format(
                'Something went wrong when checking the feature {0} with toogle type {1}: {2}',
                new List<String>{ featureName, toogleType, e.getMessage() }
            );
            AuraHandledException auraException = new AuraHandledException(
                exceptionMessage
            );
            auraException.setMessage(exceptionMessage);
            throw auraException;
        }
    }
}
