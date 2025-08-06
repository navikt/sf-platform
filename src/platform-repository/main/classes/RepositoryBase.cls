public virtual with sharing class RepositoryBase {
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
