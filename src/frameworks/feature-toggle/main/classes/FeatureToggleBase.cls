/**
 * @description Base class for managing feature toggles.
 * Supports checking, enabling and disabling features via custom metadata (Feature_Flag__mdt) and custom permissions.
 *
 * @group Feature Toggle
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, March 2025 - Created
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, April 2025 - Added custom permission helper, moved invokable and aura methods to separate classes
 */
public virtual class FeatureToggleBase implements IFeatureToggle {
    /**
     * @description Metadata query to retrieve feature flags.
     * Retrieves MasterLabel, DeveloperName, Is_Enabled__c, and Description__c.
     *
     * @see CustomMetadataDAO
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    @TestVisible
    private final static String METADATA_QUERY = 'SELECT MasterLabel, DeveloperName, Is_Enabled__c, Description__c, Required_Custom_Permission__c FROM Feature_Flag__mdt';

    private CustomMetadataDAO dao;
    private CustomPermissionHelper customPermissionHelper;

    private Map<String, Feature_Flag__mdt> featureFlagMap {
        get {
            // If featureFlagMap is not already initialized, load feature flags.
            return featureFlagMap ?? getFeatureFlags();
        }
        set;
    }

    /**
     * @description Default constructor.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Added custom permission helper
     */
    public FeatureToggleBase() {
        this(new CustomMetadataDAO(), new CustomPermissionHelper());
    }

    /**
     * @description Constructor with dependency injection.
     *
     * @param dao The DAO for custom metadata operations.
     * @param customPermissionHelper The helper for custom permission operations.
     * @see CustomMetadataDAO
     * @see CustomPermissionHelper
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Added custom permission helper
     */
    public FeatureToggleBase(
        CustomMetadataDAO dao,
        CustomPermissionHelper customPermissionHelper
    ) {
        this.dao = dao ?? new CustomMetadataDAO();
        this.customPermissionHelper = customPermissionHelper ??
            new CustomPermissionHelper();

        this.customPermissionHelper.setCustomPermissionMaps();
    }

    /**
     * @description Loads feature flags from custom metadata using the injected DAO.
     *
     * @return Map of feature flags keyed by DeveloperName.
     *
     * @see CustomMetadataDAO
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    @TestVisible
    private Map<String, Feature_Flag__mdt> getFeatureFlags() {
        // Initialize the feature flag map.
        featureFlagMap = new Map<String, Feature_Flag__mdt>();
        try {
            // Query custom metadata records and add them to the map.
            for (
                Feature_Flag__mdt featureFlag : (List<Feature_Flag__mdt>) dao.getCustomMetadataRecords(
                    METADATA_QUERY
                )
            ) {
                featureFlagMap.put(featureFlag.DeveloperName, featureFlag);
            }
        } catch (Exception e) {
            throw new FeatureToggleException(
                'Failed to retrieve feature flags.',
                e
            );
        }
        return featureFlagMap;
    }

    /**
     * @description Retrieves a feature flag by developer name.
     *
     * @param featureName The feature's DeveloperName.
     * @return The `Feature_Flag__mdt` record or null if not found.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    public Feature_Flag__mdt getFeatureFlag(String featureName) {
        return featureFlagMap.get(featureName);
    }

    /**
     * @description Checks if a feature is enabled via feature flags or custom permissions.
     * Uses an OR condition: true if either check passes.
     *
     * @param featureName The feature name.
     * @return `true` if enabled, `false` otherwise.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    public virtual Boolean isFeatureEnabled(String featureName) {
        return isFeatureEnabled(
                featureName,
                FeatureToggle.ToggleType.FEATURE_FLAG
            ) ||
            isFeatureEnabled(
                featureName,
                FeatureToggle.ToggleType.CUSTOM_PERMISSION
            );
    }

    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @param featureName The feature name.
     * @param toggleType The type (FEATURE_FLAG or CUSTOM_PERMISSION).
     * @return `true` if enabled, `false` otherwise.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    public virtual Boolean isFeatureEnabled(
        String featureName,
        FeatureToggle.ToggleType toggleType
    ) {
        if (toggleType == FeatureToggle.ToggleType.CUSTOM_PERMISSION) {
            // Evaluate based on custom permissions.
            return hasCustomPermission(featureName);
        }

        if (toggleType == FeatureToggle.ToggleType.FEATURE_FLAG) {
            // Evaluate using the feature flag status.
            if (
                featureFlagMap.containsKey(featureName) &&
                featureFlagMap.get(featureName).Is_Enabled__c
            ) {
                return String.isBlank(
                        featureFlagMap.get(featureName)
                            .Required_Custom_Permission__c
                    ) ||
                    isFeatureEnabled(
                        featureFlagMap.get(featureName)
                            .Required_Custom_Permission__c,
                        FeatureToggle.ToggleType.CUSTOM_PERMISSION
                    );
            }

            return false;
        }

        throw new FeatureToggleException('Invalid toggle type: ' + toggleType);
    }

    /**
     * @description Temporarily enables a feature in this instance’s cache.
     * Does not persist to metadata.
     *
     * @param featureName The feature to enable.
     * @return This instance for chaining.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    public virtual FeatureToggleBase enableFeature(String featureName) {
        if (getFeatureFlag(featureName) != null) {
            getFeatureFlag(featureName).Is_Enabled__c = true;
        } else {
            Feature_Flag__mdt featureFlag = new Feature_Flag__mdt();
            featureFlag.DeveloperName = featureName;
            featureFlag.Is_Enabled__c = true;
            featureFlagMap.put(featureName, featureFlag);
        }

        return this;
    }

    /**
     * @description Temporarily disables a feature in this instance’s cache.
     * Does not persist to metadata.
     *
     * @param featureName The feature to disable.
     * @return This instance for chaining.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    public virtual FeatureToggleBase disableFeature(String featureName) {
        if (getFeatureFlag(featureName) != null) {
            getFeatureFlag(featureName).Is_Enabled__c = false;
        }
        return this;
    }

    /**
     * @description Resets caches, forcing reload on next access.
     *
     * @return This instance for chaining
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    public virtual FeatureToggleBase resetFeatureFlags() {
        featureFlagMap = null;
        return this;
    }

    /**
     * @description Checks if a custom permission is granted.+
     *
     * @param customPermissionDeveloperName The permission name.
     * @return `true` if granted, `false` otherwise.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, March 2025 - Created
     */
    public virtual Boolean hasCustomPermission(
        String customPermissionDeveloperName
    ) {
        if (FeatureToggle.shouldValidateCustomPermissions()) {
            return customPermissionHelper.validateCustomPermission(
                    customPermissionDeveloperName
                )
                .hasCustomPermission(customPermissionDeveloperName);
        }
        return customPermissionHelper.hasCustomPermission(
            customPermissionDeveloperName
        );
    }
}
