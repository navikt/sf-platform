/**
 * @description Invocable method for checking feature toggles.
 *
 * @group Feature Toggle
 *
 * @see FeatureToggleBase
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, April 2025 - Moved from FeatureToggleBase
 */
public with sharing class FeatureToggleInvokable {
    /**
     * @description Checks if a feature is enabled for a specific toggle type.
     *
     * @param requests A list of `FeatureToogleRequest` objects with the feature name and type.
     * @return A list of `FeatureToogleResponse` objects with the feature name and if it is enabled or not.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Moved from FeatureToggleBase
     */
    @InvocableMethod(
        label='Is Feature Enabled'
        description='Checks if a feature is enabled for the current user.'
        category='Platform Utility'
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
                    FeatureToggle.ToggleType.valueOf(request.featureType)
                );
            responses.add(response);
        }
        return responses;
    }

    /**
     * @description Invocable request for enabling a feature.
     *
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Moved from FeatureToggleBase
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
     * @author Tor Håkon Sigurdsen
     * @since 0.1.0, April 2025 - Moved from FeatureToggleBase
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
