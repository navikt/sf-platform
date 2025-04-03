/**
 * @description This interface defines the contract for classes that can be converted to a map.
 *
 * @author Kenneth Sørensen
 * @since February 2025 - Initial Release.
 *
 * @group Platform Interfaces
 */
public interface IMapConvertible {
    /**
     * @description Returns a map representation of this object.
     *
     * @author Kenneth Sørensen
     * @since February 2025 - Initial Release.
     *
     * @return `Map<String, Object>` A map representation of this object.
     */
    Map<String, Object> toMap();
}
