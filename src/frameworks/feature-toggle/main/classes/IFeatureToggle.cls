/**
 * @description Interface for feature toggle implementations.
 *
 * @author Tor Håkon Sigurdsen
 * @since 2025-03-07
 */
public interface IFeatureToggle {
    Boolean isFeatureEnabled(String featureName);
    IFeatureToggle enableFeature(String featureName);
    IFeatureToggle disableFeature(String featureName);
    IFeatureToggle resetFeatureFlags();
    Feature_Flag__mdt getFeatureFlag(String featureName);
}
