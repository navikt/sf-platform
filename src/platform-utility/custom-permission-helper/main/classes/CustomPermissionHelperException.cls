/**
 * @description Exception related to the package custom permission helper.
 *
 * @author Tor Håkon Sigurdsen
 * @since 0.1.0, March 2025
 */
public inherited sharing class CustomPermissionHelperException extends Exception {
    // Added in order to avoid no test coverage even if the exception class is used.
    // This is probably a bug in the Salesforce platform.
    private Boolean isCustomPermissionHelperException = true;
}
