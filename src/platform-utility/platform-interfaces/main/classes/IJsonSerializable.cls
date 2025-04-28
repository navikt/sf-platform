/**
 * @description This interface defines the contract for classes that can serialize themselves into a
 * JSON string.
 *
 * @author Kenneth Sørensen
 * @since January 2025 - Initial Release.
 *
 * @group Platform Interfaces
 */
public interface IJsonSerializable {
    /**
     * @description Serializes the current object to a JSON string representation.
     *
     * @author Kenneth Sørensen
     * @since January 2025 - Initial Release.
     *
     * @return A JSON string representing the object.
     */
    String toJson();
}
