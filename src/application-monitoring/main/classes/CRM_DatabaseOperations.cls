@SuppressWarnings('PMD')
public inherited sharing class CRM_DatabaseOperations {
    private LoggerUtility logger = new LoggerUtility();
    private Boolean allOrNone = false;
    private Boolean isVerbose = false;
    private Boolean emptyRecyclebin = false;
    private Integer numberOfRetries = 0;
    private Integer maxRetries = -10;
    private CRM_ApplicationDomain.Domain domain = CRM_ApplicationDomain.Domain.CRM;

    public CRM_DatabaseOperations() {
    }

    // Set the AllOrNone database operations parameter. Defaults to false.
    public CRM_DatabaseOperations setAllOrNone() {
        this.allOrNone = true;
        return this;
    }

    // Set how many times processing failed records should be retried. Records with unable to lock errors are automatically retried.
    public CRM_DatabaseOperations setNumberOfRetries(Integer numberOfRetries) {
        this.numberOfRetries = numberOfRetries;
        return this;
    }

    // Sets the logging to verbose - i.e. every database operations error for every record is logged. Defaults to false.
    public CRM_DatabaseOperations setVerbose() {
        this.isVerbose = true;
        return this;
    }

    // Sets the current environmental domain. Defaults to CRM.
    public CRM_DatabaseOperations setDomain(
        CRM_ApplicationDomain.Domain domain
    ) {
        this.domain = domain;
        return this;
    }

    // Sets the maximum number of retries for records with unable to lock errors. Defaults to 10.
    public CRM_DatabaseOperations setMaxRetries(Integer maxRetries) {
        this.maxRetries = 0 - maxRetries;
        return this;
    }

    // Sets the EmptyRecyclebin parameter for permanent deletion.
    public CRM_DatabaseOperations setEmptyRecyclebin() {
        this.emptyRecyclebin = true;
        return this;
    }

    // Safely insert record(s) with logging and retries
    public void insertRecords(List<SObject> records) {
        processRecords(records, CRM_DatabaseOperations.ProcessingType.INSERT_T);
    }

    public void insertRecords(SObject record) {
        processRecords(
            new List<SObject>{ record },
            CRM_DatabaseOperations.ProcessingType.INSERT_T
        );
    }

    // Safely update record(s) with logging and retries
    public void updateRecords(List<SObject> records) {
        processRecords(records, CRM_DatabaseOperations.ProcessingType.UPDATE_T);
    }

    public void updateRecords(SObject record) {
        processRecords(
            new List<SObject>{ record },
            CRM_DatabaseOperations.ProcessingType.UPDATE_T
        );
    }

    // Safely upsert record(s) with logging and retries
    public void upsertRecords(List<SObject> records) {
        processRecords(records, CRM_DatabaseOperations.ProcessingType.UPSERT_T);
    }

    public void upsertRecords(SObject record) {
        processRecords(
            new List<SObject>{ record },
            CRM_DatabaseOperations.ProcessingType.UPSERT_T
        );
    }

    // Safely delete record(s) with logging and retries
    public void deleteRecords(List<SObject> records) {
        processRecords(records, CRM_DatabaseOperations.ProcessingType.DELETE_T);
    }

    public void deleteRecords(SObject record) {
        processRecords(
            new List<SObject>{ record },
            CRM_DatabaseOperations.ProcessingType.DELETE_T
        );
    }

    public void deleteRecords(Id recordId) {
        processRecords(
            recordIdsToSObject(new List<Id>{ recordId }),
            CRM_DatabaseOperations.ProcessingType.DELETE_T
        );
    }

    public void deleteRecords(List<Id> recordIds) {
        processRecords(
            recordIdsToSObject(recordIds),
            CRM_DatabaseOperations.ProcessingType.DELETE_T
        );
    }

    public void deleteRecords(Set<Id> recordIds) {
        processRecords(
            recordIdsToSObject(new List<Id>(recordIds)),
            CRM_DatabaseOperations.ProcessingType.DELETE_T
        );
    }

    // Safely undelete record(s) with logging and retries
    public void undeleteRecords(List<SObject> records) {
        processRecords(
            records,
            CRM_DatabaseOperations.ProcessingType.UNDELETE_T
        );
    }

    public void undeleteRecords(SObject record) {
        processRecords(
            new List<SObject>{ record },
            CRM_DatabaseOperations.ProcessingType.UNDELETE_T
        );
    }

    public void undeleteRecords(Id recordId) {
        processRecords(
            recordIdsToSObject(new List<Id>{ recordId }),
            CRM_DatabaseOperations.ProcessingType.UNDELETE_T
        );
    }

    public void undeleteRecords(List<Id> recordIds) {
        processRecords(
            recordIdsToSObject(recordIds),
            CRM_DatabaseOperations.ProcessingType.UNDELETE_T
        );
    }

    public void undeleteRecords(Set<Id> recordIds) {
        processRecords(
            recordIdsToSObject(new List<Id>(recordIds)),
            CRM_DatabaseOperations.ProcessingType.UNDELETE_T
        );
    }

    private void processRecords(
        List<SObject> records,
        CRM_DatabaseOperations.ProcessingType type
    ) {
        // try to process all records
        List<ResultWrapper> rws = new List<ResultWrapper>();
        Set<Id> recordIds = new Set<Id>();
        String processType = '';
        Savepoint sp = Database.setSavepoint();
        try {
            recordIds = getRecordIds(records);
            switch on type {
                when INSERT_T {
                    processType = 'insert';
                    for (
                        Database.SaveResult sr : Database.insert(
                            records,
                            allOrNone
                        )
                    ) {
                        rws.add(new ResultWrapper(sr));
                    }
                }
                when UPDATE_T {
                    processType = 'update';
                    for (
                        Database.SaveResult sr : Database.update(
                            records,
                            allOrNone
                        )
                    ) {
                        rws.add(new ResultWrapper(sr));
                    }
                }
                when UPSERT_T {
                    processType = 'upsert';
                    for (
                        Database.UpsertResult ur : Database.upsert(
                            records,
                            allOrNone
                        )
                    ) {
                        rws.add(new ResultWrapper(ur));
                    }
                }
                when DELETE_T {
                    processType = 'delete';
                    for (
                        Database.DeleteResult dr : Database.delete(
                            records,
                            allOrNone
                        )
                    ) {
                        rws.add(new ResultWrapper(dr));
                    }
                    if (emptyRecyclebin)
                        Database.emptyRecycleBin(records);
                }
                when UNDELETE_T {
                    processType = 'undelete';
                    for (
                        Database.UndeleteResult udr : Database.undelete(
                            records,
                            allOrNone
                        )
                    ) {
                        rws.add(new ResultWrapper(udr));
                    }
                }
                when else {
                    logger.critical(
                        'Unknown operation type for data processing.',
                        null,
                        domain
                    );
                }
            }
        } catch (Exception e) {
            logger.critical(
                'Exception on ' +
                    processType +
                    '! ' +
                    e.getMessage() +
                    ' Stack trace: ' +
                    e.getStackTraceString(),
                null,
                domain
            );
            logger.publish();
            Database.rollback(sp);
        }

        retryFailedRecords(rws, recordIds, type, records);
    }

    private void retryFailedRecords(
        List<ResultWrapper> results,
        Set<Id> recordId,
        CRM_DatabaseOperations.ProcessingType type,
        List<SObject> records
    ) {
        // once all retries are exhausted, log any persistent errors. If verbose, log all errors.
        // additionally, automatically retry records that failed due to UNABLE_TO_LOCK_ROW errors. (Limited by maxRetries)
        Set<Id> successfulRecords = new Set<Id>();
        Boolean isUnableToLock = false;
        Set<Id> recordIds = recordId == null ? new Set<Id>() : recordId;

        for (ResultWrapper rw : results) {
            if (rw.errors.isEmpty() || rw.errors == null) {
                successfulRecords.add(rw.recordId);
            } else {
                for (Database.Error er : rw.errors) {
                    if (
                        er.getStatusCode() ==
                        System.StatusCode.UNABLE_TO_LOCK_ROW
                    )
                        isUnableToLock = true;
                    if (
                        isVerbose ||
                        (numberOfRetries <= 0 && !isUnableToLock) ||
                        numberOfRetries == maxRetries
                    ) {
                        logger.error(
                            'Processing returned error: ' +
                                er.getStatusCode() +
                                ': ' +
                                er.getMessage() +
                                '\n Stacktrace: ' +
                                getMinimalStackTrace(),
                            null,
                            domain
                        );
                    }
                }
            }
        }
        recordIds.removeAll(successfulRecords);
        if (!recordIds.isEmpty())
            logger.error(
                'Record Ids that failed to process: ' + recordIds,
                null,
                domain
            );

        // publish all excisting errors
        if (logger.peek() != null)
            logger.publish();

        // if there are failed record ids, find the associated records and recursively try to process them again.
        if (!recordIds.isEmpty() || successfulRecords.size() < records.size()) {
            List<SObject> recordsToRetry = new List<SObject>();
            for (SObject record : records) {
                if (
                    (record.Id == null ||
                    !successfulRecords.contains(record.Id)) &&
                    (numberOfRetries > 0 || isUnableToLock)
                ) {
                    recordsToRetry.add(record);
                }
                if (
                    record.Id == null &&
                    (isVerbose || (numberOfRetries <= 0 && !isUnableToLock))
                ) {
                    logger.error(
                        'Record failed to process: ' + record,
                        null,
                        domain
                    );
                }
            }
            if (logger.peek() != null)
                logger.publish();
            numberOfRetries -= 1;
            if (numberOfRetries >= maxRetries && !recordsToRetry.isEmpty())
                processRecords(recordsToRetry, type);
        }
    }

    // Returns a set of record ids from a List of records
    private Set<Id> getRecordIds(List<SObject> records) {
        Set<Id> recordIds = new Set<Id>();
        for (SObject so : records) {
            if (so.Id != null)
                recordIds.add(so.Id);
        }
        return recordIds;
    }

    // Creates a list of SObjects from a List of Ids without querying the database
    private List<SObject> recordIdsToSObject(List<Id> recordIds) {
        if (!recordIds.isEmpty()) {
            String sObjectType = String.valueOf(recordIds[0].getSobjectType());
            List<SObject> toDelete = new List<SObject>();

            for (Id recordId : recordIds) {
                sObject sObj = (SObject) Type.forName(sObjectType)
                    .newInstance();
                sObj.Id = recordId;
                toDelete.add(sObj);
            }
            return toDelete;
        }
        return null;
    }

    // Returns the calling class, method, line. Adapted from LoggerUtility.getStackTrace()
    private String getMinimalStackTrace() {
        String stackTrace = '';
        System.debug('--- IGNORE EXCEPTION START ---');
        try {
            String str;
            str.length();
        } catch (Exception e) {
            stackTrace = e.getStackTraceString()
                .substringAfterLast('Class.CRM_DatabaseOperations')
                .substringAfter('column 1')
                .substringAfter('Class.')
                .substringBefore('\n');
        }
        System.debug('--- IGNORE EXCEPTION END ---');
        return stackTrace;
    }

    private enum ProcessingType {
        INSERT_T,
        UPDATE_T,
        UPSERT_T,
        DELETE_T,
        UNDELETE_T
    }

    private class ResultWrapper {
        public Id recordId;
        public List<Database.Error> errors = new List<Database.Error>();

        public ResultWrapper(Database.SaveResult sr) {
            recordId = sr.getId();
            if (!sr.isSuccess())
                this.errors = sr.getErrors();
        }

        public ResultWrapper(Database.UpsertResult ur) {
            recordId = ur.getId();
            if (!ur.isSuccess())
                this.errors = ur.getErrors();
        }

        public ResultWrapper(Database.DeleteResult dr) {
            recordId = dr.getId();
            if (!dr.isSuccess())
                this.errors = dr.getErrors();
        }

        public ResultWrapper(Database.UndeleteResult udr) {
            recordId = udr.getId();
            if (!udr.isSuccess())
                this.errors = udr.getErrors();
        }
    }
}
