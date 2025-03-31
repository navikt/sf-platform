/**
 * @description Helper class for `JSON` operations, wrapping Salesforce `JSONGenerator` methods.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.com>, Nav
 * @since 0.1.0, January 2025
 * @group JSON Helper
 * @see JSON
 * @see JSONGenerator
 * @example
 *
 */
@SuppressWarnings(
    'PMD.CognitiveComplexity, PMD.CyclomaticComplexity, PMD.ExcessivePublicCount'
)
public class JsonHelper {
    /**
     * @description Error message for when the JSON generator is closed.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     */
    public static final String CLOSED_GENERATOR_ERROR_MESSAGE = 'Cannot perform operation on a closed JSON Generator.';

    /**
     * @description The JSONGenerator instance that is used to generate the JSON.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     */
    @TestVisible
    private JSONGenerator generator;

    /**
     * @description Constructor for the `JsonHelper` class.
     * Creates a `JSONGenerator` instance with the default configuration.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @see JSONGenerator
     * @see JSON.createGenerator
     */
    public JsonHelper() {
        this.generator = JSON.createGenerator(false);
    }

    /**
     * @description Constructor for the `JsonHelper` class.
     * Accept an existing `JSONGenerator` instance to use.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @param generator The `JSONGenerator` instance to use.
     * @see JSONGenerator
     */
    public JsonHelper(JSONGenerator generator) {
        this.generator = generator;
    }

    /**
     * @description Constructor for the `JsonHelper` class.
     * Creates a `JSONGenerator` instance with the specified pretty print configuration.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param prettyPrint Determines whether the JSON generator creates JSON content in pretty-print
     * format with the content indented. Set to true to create indented content.
     * @see JSONGenerator
     * @see JSON.createGenerator
     */
    public JsonHelper(Boolean prettyPrint) {
        this.generator = JSON.createGenerator(prettyPrint);
    }

    /**
     * @description Closes the `JSONGenerator` instance.
     * This method should be called after all JSON writing operations are done.
     * This method is a wrapper for the `JSONGenerator.close` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @see JSONGenerator.close
     */
    public void close() {
        this.generator.close();
    }

    /**
     * @description Returns the generated JSON content as a `String`.
     * This method is a wrapper for the `JSONGenerator.getAsString` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @return `String` The JSON content as a string.
     * @see JSONGenerator.getAsString
     */
    public String getAsString() {
        return this.generator.getAsString();
    }

    /**
     * @description Returns whether the `JSONGenerator` instance is closed.
     * This method is a wrapper for the `JSONGenerator.isClosed` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @return `Boolean` True if the JSON generator is closed; otherwise, false.
     * @see JSONGenerator.isClosed
     */
    public Boolean isClosed() {
        return this.generator.isClosed();
    }

    /**
     * @description Writes the specified `Blob` value as a base64-encoded string.
     * This method is a wrapper for the `JSONGenerator.writeBlob` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param blobValue The blob value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeBlob
     */
    public void writeBlob(Blob blobValue) {
        this.ensureGeneratorOpen();
        this.generator.writeBlob(blobValue);
    }

    /**
     * @description Writes a `field` name and value pair using the specified field name and `Blob` value.
     * This method is a wrapper for the `JSONGenerator.writeBlobField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param fieldName The field name to write.
     * @param blobValue The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeBlobField
     */
    public void writeBlobField(String fieldName, Blob blobValue) {
        this.ensureGeneratorOpen();
        this.generator.writeBlobField(fieldName, blobValue);
    }

    /**
     * @description Writes the specified `Boolean` value.
     * This method is a wrapper for the `JSONGenerator.writeBoolean` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param boolenValue The boolean value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeBoolean
     */
    public void writeBoolean(Boolean boolenValue) {
        this.ensureGeneratorOpen();
        this.generator.writeBoolean(boolenValue);
    }

    /**
     * @description Writes a `field` name and value pair using the specified field name and
     * `Boolean` value.
     * This method is a wrapper for the `JSONGenerator.writeBooleanField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param fieldName The field name to write.
     * @param boolenValue The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeBooleanField
     */
    public void writeBooleanField(String fieldName, Boolean boolenValue) {
        this.ensureGeneratorOpen();
        this.generator.writeBooleanField(fieldName, boolenValue);
    }

    /**
     * @description Writes the specified `Date` value.
     * This method is a wrapper for the `JSONGenerator.writeDate` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param dateValue The date value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeDate
     */
    public void writeDate(Date dateValue) {
        this.ensureGeneratorOpen();
        this.generator.writeDate(dateValue);
    }

    /**
     * @description Writes a `field` name and value pair using the specified field name and `Date`
     * value.
     * This method is a wrapper for the `JSONGenerator.writeDateField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param fieldName The field name to write.
     * @param dateValue The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeDateField
     */
    public void writeDateField(String fieldName, Date dateValue) {
        this.ensureGeneratorOpen();
        this.generator.writeDateField(fieldName, dateValue);
    }

    /**
     * @description Writes the specified `Datetime` value.
     * This method is a wrapper for the `JSONGenerator.writeDateTime` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param dateTimeValue The datetime value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeDateTime
     */
    public void writeDateTime(Datetime dateTimeValue) {
        this.ensureGeneratorOpen();
        this.generator.writeDateTime(dateTimeValue);
    }

    /**
     * @description Writes a `field` name and value pair using the specified field name and
     * `Datetime` value.
     * This method is a wrapper for the `JSONGenerator.writeDateTimeField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, march 2025
     * @param fieldName The field name to write.
     * @param dateTimeValue The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeDateTimeField
     */
    public void writeDateTimeField(String fieldName, Datetime dateTimeValue) {
        this.ensureGeneratorOpen();
        this.generator.writeDateTimeField(fieldName, dateTimeValue);
    }

    /**
     * @description Writes the ending marker of a JSON array (']').
     * This method is a wrapper for the `JSONGenerator.writeEndArray` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeEndArray
     */
    public void writeEndArray() {
        this.ensureGeneratorOpen();
        this.generator.writeEndArray();
    }

    /**
     * @description Writes the ending marker of a JSON object ('}').
     * This method is a wrapper for the `JSONGenerator.writeEndObject` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeEndObject
     */
    public void writeEndObject() {
        this.ensureGeneratorOpen();
        this.generator.writeEndObject();
    }

    /**
     * @description Writes a field name to the JSON object.
     * This method is a wrapper for the `JSONGenerator.writeFieldName` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @param name The field name to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeFieldName
     */
    public void writeFieldName(String name) {
        this.ensureGeneratorOpen();
        this.generator.writeFieldName(name);
    }

    /**
     * @description Writes the specified `Id` value as a string.
     * This method is a wrapper for the `JSONGenerator.writeId` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param id The ID value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeId
     */
    public void writeId(Id id) {
        this.ensureGeneratorOpen();
        this.generator.writeId(id);
    }

    /**
     * @description Writes a `field` name and value pair using the specified field name and `Id` value.
     * This method is a wrapper for the `JSONGenerator.writeIdField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param fieldName The field name to write.
     * @param id The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeIdField
     */
    public void writeIdField(String fieldName, Id id) {
        this.ensureGeneratorOpen();
        this.generator.writeIdField(fieldName, id);
    }

    /**
     * @description Writes the `null` value to the JSON object.
     * This method is a wrapper for the `JSONGenerator.writeNull` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     */
    public void writeNull() {
        this.ensureGeneratorOpen();
        this.generator.writeNull();
    }

    /**
     * @description Writes a `field` name and the `null` value to the JSON object.
     * This method is a wrapper for the `JSONGenerator.writeNullField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param fieldName The field name to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNullField
     */
    public void writeNullField(String fieldName) {
        this.ensureGeneratorOpen();
        this.generator.writeNullField(fieldName);
    }

    /**
     * @description Writes the specified `Decimal` value.
     * This method is a wrapper for the `JSONGenerator.writeNumber` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param decimalValue The decimal value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumber
     */
    public void writeNumber(Decimal decimalValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumber(decimalValue);
    }

    /**
     * @description Writes the specified `Double` value.
     * This method is a wrapper for the `JSONGenerator.writeNumber` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param doubleValue The double value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumber
     */
    public void writeNumber(Double doubleValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumber(doubleValue);
    }

    /**
     * @description Writes the specified `Integer` value.
     * This method is a wrapper for the `JSONGenerator.writeNumber` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param integerValue The integer value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumber
     */
    public void writeNumber(Integer integerValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumber(integerValue);
    }

    /**
     * @description Writes the specified `Long` value.
     * This method is a wrapper for the `JSONGenerator.writeNumber` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param longValue The long value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumber
     */
    public void writeNumber(Long longValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumber(longValue);
    }

    /**
     * @description Writes a `field` name and the specified `Decimal` value to the JSON object.
     * This method is a wrapper for the `JSONGenerator.writeNumberField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param fieldName The field name to write.
     * @param decimalValue The decimal value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumberField
     */
    public void writeNumberField(String fieldName, Decimal decimalValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumberField(fieldName, decimalValue);
    }

    /**
     * @description Writes a `field` name and the specified `Double` value to the JSON object.
     * This method is a wrapper for the `JSONGenerator.writeNumberField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param fieldName The field name to write.
     * @param doubleValue The double value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumberField
     */
    public void writeNumberField(String fieldName, Double doubleValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumberField(fieldName, doubleValue);
    }

    /**
     * @description Writes a `field` name and the specified `Integer` value to the JSON object.
     * This method is a wrapper for the `JSONGenerator.writeNumberField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param fieldName The field name to write.
     * @param integerValue The integer value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumberField
     */
    public void writeNumberField(String fieldName, Integer integerValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumberField(fieldName, integerValue);
    }

    /**
     * @description Writes a `field` name and the specified `Long` value to the JSON object.
     * This method is a wrapper for the `JSONGenerator.writeNumberField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param fieldName The field name to write.
     * @param longValue The long value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeNumberField
     */
    public void writeNumberField(String fieldName, Long longValue) {
        this.ensureGeneratorOpen();
        this.generator.writeNumberField(fieldName, longValue);
    }

    /**
     * @description Writes the specified Apex object in JSON format.
     * This method is a wrapper for the `JSONGenerator.writeObjectField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param objectValue The object to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeObject
     */
    public void writeObject(Object objectValue) {
        this.ensureGeneratorOpen();
        this.generator.writeObject(objectValue);
    }

    /**
     * @description Writes a `field` name and the specified Apex object in JSON format.
     * This method is a wrapper for the `JSONGenerator.writeObjectField` method.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param fieldName The field name to write.
     * @param objectValue The object to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeObjectField
     */
    public void writeObjectField(String fieldName, Object objectValue) {
        this.ensureGeneratorOpen();
        this.generator.writeObjectField(fieldName, objectValue);
    }

    /**
     * @description Writes the starting marker of a JSON array ('[').
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeStartArray
     */
    public void writeStartArray() {
        this.ensureGeneratorOpen();
        this.generator.writeStartArray();
    }

    /**
     * @description Writes the starting marker of a JSON object ('{').
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeStartObject
     */
    public void writeStartObject() {
        this.ensureGeneratorOpen();
        this.generator.writeStartObject();
    }

    /**
     * @description Writes string value to the JSON object.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @param value The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeString
     */
    public void writeString(String value) {
        this.ensureGeneratorOpen();
        generator.writeString(value);
    }

    /**
     * @description Writes a `field` name and value pair using the specified field name and `String` value.
     * This method is a wrapper for the `JSONGenerator.writeStringField` method.
     *
     * @param fieldName The field name to write.
     * @param value The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeStringField
     */
    public void writeStringField(String fieldName, String value) {
        this.ensureGeneratorOpen();
        generator.writeStringField(fieldName, value);
    }

    /**
     * @description Writes the specified time value in the ISO-8601 format.
     * This method is a wrapper for the `JSONGenerator.writeTime` method.
     *
     * @param timeValue The time value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeTime
     */
    public void writeTime(Time timeValue) {
        this.ensureGeneratorOpen();
        this.generator.writeTime(timeValue);
    }

    /**
     * @description Writes a field name and value pair using the specified field name and time value
     * in the ISO-8601 format.
     * This method is a wrapper for the `JSONGenerator.writeTimeField` method.
     *
     * @param fieldName The field name to write.
     * @param timeValue The value to write.
     * @exception JsonHelperException If the generator is closed.
     * @see JSONGenerator.writeTimeField
     */
    public void writeTimeField(String fieldName, Time timeValue) {
        this.ensureGeneratorOpen();
        this.generator.writeTimeField(fieldName, timeValue);
    }

    /**
     * @description
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @param fieldName
     * @param value
     */
    @TestVisible
    private void writeFieldIfNotNull(String fieldName, Object value) {
        if (value != null) {
            if (value instanceof Blob) {
                generator.writeBlobField(fieldName, (Blob) value);
            } else if (value instanceof Boolean) {
                generator.writeBooleanField(fieldName, (Boolean) value);
            } else if (value instanceof Date) {
                generator.writeDateField(fieldName, (Date) value);
            } else if (value instanceof Datetime) {
                generator.writeDateTimeField(fieldName, (Datetime) value);
            } else if (value instanceof Id) {
                generator.writeIdField(fieldName, (Id) value);
            } else if (value instanceof Decimal) {
                generator.writeNumberField(fieldName, (Decimal) value);
            } else if (value instanceof Double) {
                generator.writeNumberField(fieldName, (Double) value);
            } else if (value instanceof Integer) {
                generator.writeNumberField(fieldName, (Integer) value);
            } else if (value instanceof Long) {
                generator.writeNumberField(fieldName, (Long) value);
            } else if (value instanceof String) {
                generator.writeStringField(fieldName, (String) value);
            } else if (value instanceof Time) {
                generator.writeTimeField(fieldName, (Time) value);
            } else {
                generator.writeObjectField(fieldName, (Object) value);
            }
        }
    }

    //--------------------------------------------------------------------------------
    // The following methods are not checked against the original JSONGenerator class
    //--------------------------------------------------------------------------------

    /**
     * @description Writes objectA string field to the JSON object if the value is not null.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param value The value to write.
     * @see JSONGenerator.writeStringField
     * @see writeFieldIfNotNull
     */
    public void writeStringFieldIfNotNull(String fieldName, String value) {
        writeFieldIfNotNull(fieldName, value);
    }

    /**
     * @description Writes an integer field to the JSON object if the value is not null.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param value The value to write.
     * @see JSONGenerator.writeNumberField
     * @see writeFieldIfNotNull
     */
    public void writeIntegerFieldIfNotNull(String fieldName, Integer value) {
        writeFieldIfNotNull(fieldName, value);
    }

    /**
     * @description Writes objectA boolean field to the JSON object if the value is not null.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, January 2025
     * @param fieldName The field name to write.
     * @param value The value to write.
     * @see JSONGenerator.writeBooleanField
     * @see writeFieldIfNotNull
     */
    public void writeBooleanFieldIfNotNull(String fieldName, Boolean value) {
        writeFieldIfNotNull(fieldName, value);
    }

    /**
     * @description Writes objectA list of strings to the JSON object if the list is not null and not empty.
     *
     * @author Kenneth Sørensen
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
     * @author Kenneth Sørensen
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
     * @author Kenneth Sørensen
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
     * @author Kenneth Sørensen
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
     * @author Kenneth Sørensen
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
     * @author Kenneth Sørensen
     * @since 0.1.0, February 2025
     * @param objectA The first object to compare.
     * @param objectB The second object to compare.
     * @return `Boolean` True if the objects are equal, false otherwise.
     */
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
            return caseSensitiveCompareStrings(
                (String) objectA,
                (String) objectB
            );
        }

        return comparePrimitives(objectA, objectB);
    }

    /**
     * @description Compares two strings for equality, case-sensitive.
     *
     * @author Eivind Øksnevad <eivind.oksnevad@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @param a The first string to compare.
     * @param b The second string to compare.
     * @return `Boolean` True if the strings are equal, false otherwise.
     */
    private static Boolean caseSensitiveCompareStrings(String a, String b) {
        return a.equals(b);
    }

    /**
     * @description Helper method to handle nulls.
     * If both are null, return true.
     * If one is null but not the other, return false.
     * Otherwise, return null.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param objectA The first object to compare.
     * @param objectB The second object to compare.
     * @return `Boolean` True if both objects are null, false if one is null, and null if neither is null.
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
     * @author Kenneth Sørensen
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
     * @author Kenneth Sørensen
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
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @param objectA The first object to compare.
     * @param objectB The second object to compare.
     * @return `Boolean` True if the objects are equal, false otherwise.
     */
    private static Boolean comparePrimitives(Object objectA, Object objectB) {
        return objectA == objectB;
    }

    /**
     * @description Ensures that the JSON generator is open.
     * Throws an exception if the generator is closed.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, March 2025
     * @throws JsonHelperException If the generator is closed.
     * @see CLOSED_GENERATOR_ERROR_MESSAGE
     * @see JSONGenerator.isClosed
     */
    private void ensureGeneratorOpen() {
        if (this.generator.isClosed()) {
            throw new JsonHelperException(CLOSED_GENERATOR_ERROR_MESSAGE);
        }
    }

    /**
     * @description Custom exception class for the `JsonHelper` class.
     *
     * @author Kenneth Sørensen
     * @since 0.1.0, December 2024
     * @group Public 360 Integration
     */
    public class JsonHelperException extends Exception {
    }
}
