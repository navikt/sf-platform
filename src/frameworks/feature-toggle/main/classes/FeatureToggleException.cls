/**
 * @description Custom exception for feature toggle errors.
 *
 * @author Tor Håkon Sigurdsen
 * @since 2025-03-07
 */
public without sharing class FeatureToggleException extends Exception {
    // Added in order to avoid no test coverage even if the exception class is used.
    // This is probably a bug in the Salesforce platform.
    private Boolean isFeatureToggleException = true;
}
