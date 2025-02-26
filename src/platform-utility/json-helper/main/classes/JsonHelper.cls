/**
 * @description Helper class for JSON operations.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.com>, Nav
 * @since 0.1.0, January 2025
 * @group Public 360 Integration
 * @see JSON
 * @see JSONGenerator
 * @example
 *
 */
@SuppressWarnings(
    'PMD.CognitiveComplexity, PMD.StdCyclomaticComplexity, PMD.CyclomaticComplexity'
)
public class JsonHelper {
    /**
     * @description The JSONGenerator instance that is used to generate the JSON.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    private JSONGenerator generator;

    /**
     * @description Constructor for the `JsonHelper` class.
     * Creates an `JSONGenerator`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    public JsonHelper() {
        this.generator = JSON.createGenerator(false);
    }

    /**
     * @description Constructor for the `JsonHelper` class.
     * Accept an existing `JSONGenerator`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param generator The `JSONGenerator` instance to use.
     * @see JSONGenerator
     */
    public JsonHelper(JSONGenerator generator) {
        this.generator = generator;
    }

    /**
     * @description Returns the serialized JSON string.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @return `String` The serialized JSON string.
     * @see JSONGenerator.getAsString
     */
    public String getAsString() {
        return generator.getAsString();
    }

    /**
     * @description Writes the start of a JSON object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeStartObject
     */
    public void writeStartObject() {
        generator.writeStartObject();
    }

    /**
     * @description Writes the end of a JSON object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeEndObject
     */
    public void writeEndObject() {
        generator.writeEndObject();
    }

    /**
     * @description Writes the start of a JSON array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeStartArray
     */
    public void writeStartArray() {
        generator.writeStartArray();
    }

    /**
     * @description Writes the end of a JSON array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeEndArray
     */
    public void writeEndArray() {
        generator.writeEndArray();
    }

    /**
     * @description Writes a field name to the JSON object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param name The field name to write.
     * @see JSONGenerator.writeFieldName
     */
    public void writeFieldName(String name) {
        generator.writeFieldName(name);
    }

    /**
     * @description Writes a string value to the JSON object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param value The value to write.
     * @see JSONGenerator.writeString
     */
    public void writeString(String value) {
        generator.writeString(value);
    }

    /**
     * @description Writes a string field to the JSON object if the value is not null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param value The value to write.
     * @see JSONGenerator.writeStringField
     */
    public void writeStringFieldIfNotNull(String fieldName, String value) {
        if (value != null) {
            generator.writeStringField(fieldName, value);
        }
    }

    /**
     * @description Writes an integer field to the JSON object if the value is not null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param value The value to write.
     * @see JSONGenerator.writeNumberField
     */
    public void writeIntegerFieldIfNotNull(String fieldName, Integer value) {
        if (value != null) {
            generator.writeNumberField(fieldName, value);
        }
    }

    /**
     * @description Writes a boolean field to the JSON object if the value is not null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param value The value to write.
     * @see JSONGenerator.writeBooleanField
     */
    public void writeBooleanFieldIfNotNull(String fieldName, Boolean value) {
        if (value != null) {
            generator.writeBooleanField(fieldName, value);
        }
    }

    /**
     * @description Writes a list of strings to the JSON object if the list is not null and not empty.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param values The list of strings to write.
     * @see JSONGenerator.writeFieldName
     * @see JSONGenerator.writeStartArray
     * @see JSONGenerator.writeString
     * @see JSONGenerator.writeEndArray
     */
    public void writeStringListIfNotEmpty(
        String fieldName,
        List<String> values
    ) {
        if (values != null && !values.isEmpty()) {
            generator.writeFieldName(fieldName);
            generator.writeStartArray();
            for (String v : values) {
                if (v != null) {
                    generator.writeString(v);
                }
            }
            generator.writeEndArray();
        }
    }

    /**
     * @description Writes a nested object to the JSON object if the object is not null.
     * The object must have a `toJson` method that returns a JSON string.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param obj The object to write.
     * @see IJsonSerializable
     * @see JSONGenerator.writeFieldName
     * @see JSONGenerator.writeObject
     * @see JSON.deserializeUntyped
     */
    public void writeNestedObject(String fieldName, IJsonSerializable obj) {
        if (obj != null) {
            generator.writeFieldName(fieldName);
            generator.writeObject(JSON.deserializeUntyped(obj.toJson()));
        }
    }

    // Helper for list of nested objects
    /**
     * @description Writes a list of nested objects to the JSON object if the list is not null and
     * not empty. The objects must have a `toJson` method that returns a JSON string.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param objList The list of objects to write.
     * @see IJsonSerializable
     * @see JSONGenerator.writeFieldName
     * @see JSONGenerator.writeStartArray
     * @see JSONGenerator.writeObject
     * @see JSON.deserializeUntyped
     * @see JSONGenerator.writeEndArray
     */
    public void writeNestedObjectList(
        String fieldName,
        List<IJsonSerializable> objList
    ) {
        if (objList != null && !objList.isEmpty()) {
            generator.writeFieldName(fieldName);
            generator.writeStartArray();
            for (IJsonSerializable obj : objList) {
                if (obj != null) {
                    generator.writeObject(
                        JSON.deserializeUntyped(obj.toJson())
                    );
                }
            }
            generator.writeEndArray();
        }
    }

    /**
     * @description Writes a list of IJsonSerializable objects as a top-level JSON array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     */
    public void writeObjectListAsRootArray(List<IJsonSerializable> objList) {
        generator.writeStartArray();
        if (objList != null) {
            for (IJsonSerializable obj : objList) {
                if (obj != null) {
                    generator.writeObject(
                        JSON.deserializeUntyped(obj.toJson())
                    );
                } else {
                    generator.writeObject(null);
                }
            }
        }
        generator.writeEndArray();
    }

    /**
     * @description Compares two JSON strings for equality.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @param jsonA The first JSON string to compare.
     * @param jsonB The second JSON string to compare.
     * @return `Boolean` True if the JSON strings are equal, false otherwise.
     */
    public static Boolean jsonEquals(String jsonA, String jsonB) {
        System.debug('jsonA: ' + jsonA);
        System.debug('jsonB: ' + jsonB);

        // Parse each JSON into a nested Map/List structure
        Object objA = JSON.deserializeUntyped(jsonA);
        Object objB = JSON.deserializeUntyped(jsonB);

        return compareObjects(objA, objB);
    }

    /**
     * @description Compares two objects for equality.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @param a The first object to compare.
     * @param b The second object to compare.
     * @return `Boolean` True if the objects are equal, false otherwise.
     */
    private static Boolean compareObjects(Object a, Object b) {
        // Case 1: Both null
        if (a == null && b == null)
            return true;
        // If one is null but not the other
        if (a == null || b == null)
            return false;

        // Case 2: Both are maps
        if (
            a instanceof Map<String, Object> && b instanceof Map<String, Object>
        ) {
            Map<String, Object> mapA = (Map<String, Object>) a;
            Map<String, Object> mapB = (Map<String, Object>) b;
            // Must have same number of keys
            if (mapA.keySet().size() != mapB.keySet().size())
                return false;
            // Check each key
            for (String key : mapA.keySet()) {
                if (!mapB.containsKey(key))
                    return false;
                if (!compareObjects(mapA.get(key), mapB.get(key)))
                    return false;
            }
            return true;
        }

        // Case 3: Both are lists
        if (a instanceof List<Object> && b instanceof List<Object>) {
            List<Object> listA = (List<Object>) a;
            List<Object> listB = (List<Object>) b;
            if (listA.size() != listB.size())
                return false;
            // Compare each element
            for (Integer i = 0; i < listA.size(); i++) {
                if (!compareObjects(listA[i], listB[i]))
                    return false;
            }
            return true;
        }

        // Case 4: Otherwise treat as a primitive (String, Integer, etc.)
        return a == b;
    }
}
