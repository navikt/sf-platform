/**
 * @description This interface defines the contract for classes that can serialize themselves into a
 * JSON string.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since 0.1.0, January 2025
 */
public interface IJsonSerializable {
    /**
     * @description Serializes the current object to a JSON string representation.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @return A JSON string representing the object.
     */
    String toJson();
}
