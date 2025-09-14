/**
 * @description
 * Abstract base class for repository implementations.
 * Provides utility methods for handling save and delete results with error aggregation and exception handling.
 * Extend this class to standardize error handling for DML operations in repository classes.
 */
public virtual with sharing class RepositoryBase {
    /**
     * @description
     * Handles the results of Database.save operations.
     * Aggregates errors from failed save results and throws a RepositorySaveException if any errors are found.
     *
     * @param srList List of Database.SaveResult objects from a DML operation.
     * @throws RepositorySaveException if any save errors are present.
     */
    protected void handleSaveResult(List<Database.SaveResult> srList) {
        List<Database.Error> errors = new List<Database.Error>();

        for (Database.SaveResult sr : srList) {
            if (sr.isSuccess()) {
                continue;
            }
            errors.addAll(sr.getErrors());
        }
        if (!errors.isEmpty()) {
            throw new RepositorySaveException(
                'Error(s) occurred while saving records: ' +
                JSON.serializePretty(errors)
            );
        }
    }

    /**
     * @description
     * Handles the results of Database.delete operations.
     * Aggregates errors from failed delete results and throws a RepositorySaveException if any errors are found.
     *
     * @param srList List of Database.DeleteResult objects from a DML operation.
     * @throws RepositorySaveException if any delete errors are present.
     */
    protected void handleDeleteResult(List<Database.DeleteResult> srList) {
        List<Database.Error> errors = new List<Database.Error>();

        for (Database.DeleteResult dr : srList) {
            if (dr.isSuccess()) {
                continue;
            }
            errors.addAll(dr.getErrors());
        }
        if (!errors.isEmpty()) {
            throw new RepositorySaveException(
                'Error(s) occurred while deleting records: ' +
                JSON.serializePretty(errors)
            );
        }
    }
}
