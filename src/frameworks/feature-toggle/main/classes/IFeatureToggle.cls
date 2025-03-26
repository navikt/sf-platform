/**
 * @description Interface for feature toggle implementations.
 *
 * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
 * @since 0.1.0, March 2025
 * @group Feature Toggle
 */
public interface IFeatureToggle {
    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @param featureName `String`
     * @return `true` if enabled, `false` otherwise
     */
    Boolean isFeatureEnabled(String featureName);

    /**
     * @description Enables a feature.
     *
     * @param featureName The feature to enable.
     * @return This instance for chaining.
     */
    IFeatureToggle enableFeature(String featureName);

    /**
     * @description Disables a feature.
     *
     * @param featureName The feature to disable.
     * @return This instance for chaining.
     */
    IFeatureToggle disableFeature(String featureName);

    /**
     * @description Resets all feature flags to their default values.
     *
     * @return Self
     */
    IFeatureToggle resetFeatureFlags();

    /**
     * @description Retrieves a feature flag by name.
     *
     * @param featureName `String`
     * @return A `Feature_Flag__mdt` record
     */
    Feature_Flag__mdt getFeatureFlag(String featureName);
}
