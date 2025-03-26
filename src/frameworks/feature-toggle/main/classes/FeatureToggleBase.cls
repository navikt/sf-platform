/**
 * @description Base class for managing feature toggles.
 * Supports checking, enabling and disabling features via custom metadata (Feature_Flag__mdt) and custom permissions.
 *
 * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
 * @since 0.1.0, March 2025
 * @group Feature Toggle
 * @see IFeatureToggle
 * @example
 * Eksempel på direkte bruk:
 *
 * public with sharing MyClass {
 *     public MyClass() {
 *         ...
 *     }
 *
 *     public Decimal getDiscount() {
 *         if(new FeatureToggleBase().isFeatureEnabled('improved-discount-calculation')) {
 *             return getDiscountBeta();
 *         }
 *         ...
 *         return discount
 *     }
 *
 *     private Decimal getDiscountBeta() {
 *         ...
 *         return discount;
 *     }
 *
 *     ...
 * }
 *
 * Eksempel hvor man extender FeatureToggleBase:
 *
 * public with sharing MyClass extends FeatureToggleBase {
 *     public MyClass() {
 *         ...
 *     }
 *
 *     public Decimal getDiscount() {
 *         if(isFeatureEnabled('improved-discount-calculation')) {
 *             return getDiscountBeta();
 *         }
 *         ...
 *         return discount
 *     }
 *
 *     private Decimal getDiscountBeta() {
 *         ...
 *         return discount;
 *     }
 *
 *     ...
 * }
 */
public virtual class FeatureToggleBase implements IFeatureToggle {
    /**
     * @description Metadata query to retrieve feature flags.
     * Retrieves MasterLabel, DeveloperName, Is_Enabled__c, and Description__c.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see CustomMetadataDAO
     */
    @TestVisible
    private final static String METADATA_QUERY = 'SELECT MasterLabel, DeveloperName, Is_Enabled__c, Description__c, Required_Custom_Permission__c FROM Feature_Flag__mdt';

    /**
     * @description The Custom Metadata Data Access Object.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see CustomMetadataDAO
     */
    private CustomMetadataDAO dao;

    /**
     * @description Map of feature flags keyed by DeveloperName.
     * Lazy-loaded on first access.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see Feature_Flag__mdt
     */
    private Map<String, Feature_Flag__mdt> featureFlagMap {
        get {
            // If featureFlagMap is not already initialized, load feature flags.
            return featureFlagMap ?? getFeatureFlags();
        }
        set;
    }

    /**
     * @description Default constructor.
     * Initializes the Custom Metadata Data Access Object.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     */
    public FeatureToggleBase() {
        this(new CustomMetadataDAO());
    }

    /**
     * @description Constructor with dependency injection.
     * Using the provided Custom Metadata Data Access Object for custom metadata access.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param dao The custom metadata DAO.
     */
    public FeatureToggleBase(CustomMetadataDAO dao) {
        this.dao = dao;
    }

    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param featureName The feature name.
     * @param toggleType The type (FEATURE_FLAG or CUSTOM_PERMISSION).
     * @return `true` if enabled, `false` otherwise.
     */

    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param featureName The feature name.
     * @param toogleType The type (FEATURE_FLAG or CUSTOM_PERMISSION).
     * @return `true` if enabled, `false` otherwise.
     * @exception throws `AuraHandledException` if something goes wrong.
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
                    FeatureToggleType.valueOf(toogleType)
                );
        } catch (Exception e) {
            throw new AuraHandledException(
                String.format(
                    'Something went wrong when checking the feature {0}',
                    new List<String>{ e.getMessage() }
                )
            );
        }
    }

    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param requests A list of `FeatureToogleRequest` objects with the feature name and type.
     * @return A list of `FeatureToogleResponse` objects with the feature name and if it is enabled or not.
     */
    @InvocableMethod(
        label='Enable Feature'
        description='Enables a feature for the current user.'
    )
    public static List<FeatureToogleResponse> isFeatureEnabledInvokable(
        List<FeatureToogleRequest> requests
    ) {
        List<FeatureToogleResponse> responses = new List<FeatureToogleResponse>();
        for (FeatureToogleRequest request : requests) {
            FeatureToogleResponse response = new FeatureToogleResponse();
            response.featureName = request.featureName;
            response.featureEnabled = new FeatureToggleBase()
                .isFeatureEnabled(
                    request.featureName,
                    FeatureToggleType.valueOf(request.featureType)
                );
            responses.add(response);
        }
        return responses;
    }

    /**
     * @description Loads feature flags from custom metadata using the injected Custom Metadata Data
     * Access Object.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @return Map of feature flags keyed by DeveloperName.
     * @see CustomMetadataDAO
     */
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
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param featureName The feature's DeveloperName.
     * @return The `Feature_Flag__mdt` record or null if not found.
     */
    public Feature_Flag__mdt getFeatureFlag(String featureName) {
        return featureFlagMap.get(featureName);
    }

    /**
     * @description Checks if a feature is enabled via feature flags or custom permissions.
     * Uses an OR condition: true if either check passes.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param featureName The feature name.
     * @return `true` if enabled, `false` otherwise.
     */
    public virtual Boolean isFeatureEnabled(String featureName) {
        return isFeatureEnabled(featureName, FeatureToggleType.FEATURE_FLAG) ||
            isFeatureEnabled(featureName, FeatureToggleType.CUSTOM_PERMISSION);
    }

    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param featureName The feature name.
     * @param toggleType The type (FEATURE_FLAG or CUSTOM_PERMISSION).
     * @return `true` if enabled, `false` otherwise.
     */
    public virtual Boolean isFeatureEnabled(
        String featureName,
        FeatureToggleType toggleType
    ) {
        if (toggleType == FeatureToggleType.CUSTOM_PERMISSION) {
            // Evaluate based on custom permissions.
            return hasCustomPermission(featureName);
        }

        if (toggleType == FeatureToggleType.FEATURE_FLAG) {
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
                        FeatureToggleType.CUSTOM_PERMISSION
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
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param featureName The feature to enable.
     * @return This instance for chaining.
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
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param featureName The feature to disable.
     * @return This instance for chaining.
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
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @return This instance for chaining
     */
    public virtual FeatureToggleBase resetFeatureFlags() {
        featureFlagMap = null;
        return this;
    }

    /**
     * @description Checks if a custom permission is granted.+
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param customPermissionName The permission name.
     * @return `true` if granted, `false` otherwise.
     */
    public virtual Boolean hasCustomPermission(String customPermissionName) {
        return System.FeatureManagement.checkPermission(customPermissionName);
    }

    /**
     * @description Invocable request for enabling a feature.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     */
    public class FeatureToogleRequest {
        @InvocableVariable(
            label='Feature Name'
            description='The name of the feature.'
            required=true
        )
        public String featureName;
        @InvocableVariable(
            label='Feature Type'
            description='The type of the feature to enable.'
            required=true
        )
        public String featureType;

        /**
         * @description Constructor with parameters.
         *
         * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
         * @since 0.1.0, March 2025
         * @param featureName The feature name.
         * @param featureType The feature type.
         */
        public FeatureToogleRequest(String featureName, String featureType) {
            this.featureName = featureName;
            this.featureType = featureType;
        }
    }

    /**
     * @description Invocable response for enabling a feature.
     *
     * @author Tor Håkon Sigurdsen <tor.hakon.sigurdsen@nav.no>, Nav
     * @since 0.1.0, March 2025
     */
    public class FeatureToogleResponse {
        @InvocableVariable(
            label='Feature Name'
            description='Name of the feature.'
        )
        public String featureName;
        @InvocableVariable(
            label='Is Enabled'
            description='If the feature is enabled or not.'
        )
        public Boolean featureEnabled;
    }
}
