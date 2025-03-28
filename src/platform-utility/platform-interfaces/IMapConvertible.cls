/**
 * @description This interface defines the contract for classes that can be converted to a map.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since 0.1.0, February 2025
 */
public interface IMapConvertible {
    /**
     * @description Returns a map representation of this object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @return `Map<String, Object>` A map representation of this object.
     */
    Map<String, Object> toMap();
}
