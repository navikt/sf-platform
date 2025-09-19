/**
 * @description
 * Interface for AvvikAccess job injection, enabling dependency injection and mocking of asynchronous AvvikAccess logic.
 * Implementations should provide logic for setting the NAV identifier and executing the queueable job.
 * Used to decouple DefaultLoginFlowController and related classes from concrete AvvikAccess implementations, improving testability and package boundaries.
 */
public interface IAvvikAccess {
    /**
     * @description Sets the NAV identifier for the AvvikAccess job.
     * @param navId NAV identifier to use in the job.
     */
    void setNavIdent(String navId);

    /**
     * @description Executes the queueable job logic for AvvikAccess.
     * @param context QueueableContext provided by the platform.
     */
    void execute(QueueableContext context);
}
