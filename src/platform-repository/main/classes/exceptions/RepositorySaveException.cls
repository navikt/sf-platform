/**
 * @description
 * Custom exception for handling errors during repository save or delete operations.
 * Used by RepositoryBase to surface aggregated DML errors in a standardized way.
 * Extend this exception to provide more context or error handling for repository operations.
 */
public class RepositorySaveException extends Exception {
}
