/**
 * Abstraction for retrieving RecordType records, enabling test injection.
 */
public interface RecordTypeSelector {
    /**
     * Retrieve all RecordType records to be cached.
     * @return List of RecordType records
     */
    List<RecordType> getRecordTypes();
}
