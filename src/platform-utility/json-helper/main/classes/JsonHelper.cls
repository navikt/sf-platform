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
    @TestVisible
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
     * @description Writes the start of objectA JSON object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeStartObject
     */
    public void writeStartObject() {
        generator.writeStartObject();
    }

    /**
     * @description Writes the end of objectA JSON object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeEndObject
     */
    public void writeEndObject() {
        generator.writeEndObject();
    }

    /**
     * @description Writes the start of objectA JSON array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeStartArray
     */
    public void writeStartArray() {
        generator.writeStartArray();
    }

    /**
     * @description Writes the end of objectA JSON array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JSONGenerator.writeEndArray
     */
    public void writeEndArray() {
        generator.writeEndArray();
    }

    /**
     * @description Writes objectA field name to the JSON object.
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
     * @description Writes objectA string value to the JSON object.
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
     * @description Writes objectA string field to the JSON object if the value is not null.
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
     * @description Writes objectA boolean field to the JSON object if the value is not null.
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
     * @description Writes objectA list of strings to the JSON object if the list is not null and not empty.
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
     * @description Writes objectA nested object to the JSON object if the object is not null.
     * The object must have objectA `toJson` method that returns objectA JSON string.
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
     * @description Writes objectA list of nested objects to the JSON object if the list is not null and
     * not empty. The objects must have objectA `toJson` method that returns objectA JSON string.
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
     * @description Writes objectA list of IJsonSerializable objects as objectA top-level JSON array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @param objList The list of objects to write.
     * @see IJsonSerializable
     * @see JSON.deserializeUntyped
     * @see JSONGenerator.writeObject
     * @see JSONGenerator.writeStartArray
     * @see JSONGenerator.writeEndArray
     */
    public void writeObjectListAsRootArray(List<IJsonSerializable> objList) {
        generator.writeStartArray();
        if (objList != null) {
            for (IJsonSerializable obj : objList) {
                if (obj != null) {
                    generator.writeObject(
                        JSON.deserializeUntyped(obj.toJson())
                    );
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
     * @see JSON.deserializeUntyped
     * @see compareObjects
     */
    public static Boolean jsonEquals(String jsonA, String jsonB) {
        Object objA = JSON.deserializeUntyped(jsonA);
        Object objB = JSON.deserializeUntyped(jsonB);

        return compareObjects(objA, objB);
    }

    /**
     * @description Compares two objects for equality.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @param objectA The first object to compare.
     * @param objectB The second object to compare.
     * @return `Boolean` True if the objects are equal, false otherwise.
     */
    @suppressWarnings('PMD.NcssMethodCount')
    private static Boolean compareObjects(Object objectA, Object objectB) {
        Boolean nullCheck = handleNulls(objectA, objectB);
        if (nullCheck != null) {
            return nullCheck;
        }

        if (
            objectA instanceof Map<String, Object> &&
            objectB instanceof Map<String, Object>
        ) {
            return compareMaps(
                (Map<String, Object>) objectA,
                (Map<String, Object>) objectB
            );
        }

        if (
            objectA instanceof List<Object> && objectB instanceof List<Object>
        ) {
            return compareLists((List<Object>) objectA, (List<Object>) objectB);
        }

        if (objectA instanceof String && objectB instanceof String) {
            return caseSensitiveCompareStrings((String)objectA, (String)objectB);
        }

        return comparePrimitives(objectA, objectB);
    }

    private static Boolean caseSensitiveCompareStrings(String a, String b) {
        return a.equals(b);
    }

    /**
     * @description Helper method to handle nulls.
     * If both are null, return true.
     * If one is null but not the other, return false.
     * Otherwise, return null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param objectA The first object to compare.
     * @param objectB The second object to compare.
     * @return `Boolean` True if the objects are equal, false otherwise.
     */
    private static Boolean handleNulls(Object objectA, Object objectB) {
        if (objectA == null && objectB == null) {
            return true;
        }
        if (objectA == null || objectB == null) {
            return false;
        }

        return null;
    }

    /**
     * @description Compares two maps for equality.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param mapA The first map to compare.
     * @param mapB The second map to compare.
     * @return `Boolean` True if the maps are equal, false otherwise.
     */
    private static Boolean compareMaps(
        Map<String, Object> mapA,
        Map<String, Object> mapB
    ) {
        if (mapA.keySet().size() != mapB.keySet().size()) {
            return false;
        }

        for (String keyA : mapA.keySet()) {
            if (!mapB.containsKey(keyA)) {
                return false;
            }
            if (!compareObjects(mapA.get(keyA), mapB.get(keyA))) {
                return false;
            }
        }
        return true;
    }

    /**
     * @description Compares two lists for equality.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param listA The first list to compare.
     * @param listB The second list to compare.
     * @return `Boolean` True if the lists are equal, false otherwise.
     */
    private static Boolean compareLists(
        List<Object> listA,
        List<Object> listB
    ) {
        if (listA.size() != listB.size()) {
            return false;
        }

        for (Integer i = 0; i < listA.size(); i++) {
            if (!compareObjects(listA[i], listB[i])) {
                return false;
            }
        }
        return true;
    }

    /**
     * @description Compares two primitives for equality.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param objectA The first object to compare.
     * @param objectB The second object to compare.
     * @return `Boolean` True if the objects are equal, false otherwise.
     */
    private static Boolean comparePrimitives(Object objectA, Object objectB) {

        return objectA == objectB;
    }
}
