/**
 * @description Tests the JsonHelper class.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since 0.1.0, January 2025
 */
@SuppressWarnings('PMD.CognitiveComplexity')
@isTest(IsParallel=true)
private class JsonHelperTest {
    /**
     * @description Tests the default constructor and basic usage of the `JsonHelper` class.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void defaultConstructorAndBasicUsage() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeStringFieldIfNotNull('FieldOne', 'ValueOne');
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"FieldOne":"ValueOne"'),
            'Expected JSON to contain "FieldOne":"ValueOne". Actual: ' + result
        );
        System.Assert.isTrue(
            result.startsWith('{') && result.endsWith('}'),
            'Expected JSON to start with { and end with }. Actual: ' + result
        );
    }

    /**
     * @description Tests the constructor that accepts an existing `JSONGenerator`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void constructorWithJSONGenerator() {
        JSONGenerator generator = JSON.createGenerator(false);
        JsonHelper helper = new JsonHelper(generator);

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeStringFieldIfNotNull('Test', 'ConstructorWithGenerator');
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"Test":"ConstructorWithGenerator"'),
            'Expected JSON to contain "Test":"ConstructorWithGenerator". Actual: ' +
            result
        );
    }

    /**
     * @description Tests `writeStartObject` and `writeEndObject` without any fields.
     * This is a "negative" or edge scenario: an empty object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void emptyObject() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.areEqual(
            '{}',
            result,
            'Expected an empty JSON object. Actual: ' + result
        );
    }

    /**
     * @description Tests `writeStartArray`, `writeEndArray`, and `writeFieldName` for an empty array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void emptyArray() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeFieldName('EmptyArray');
        helper.writeStartArray();
        helper.writeEndArray();
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"EmptyArray":[]'),
            'Expected JSON to contain "EmptyArray":[]. Actual: ' + result
        );
    }

    /**
     * @description Tests writeBooleanFieldIfNotNull with both null and non-null values.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void writeBooleanFieldIfNotNull() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeBooleanFieldIfNotNull('BoolTrue', true);
        helper.writeBooleanFieldIfNotNull('BoolFalse', false);
        helper.writeBooleanFieldIfNotNull('BoolNull', null); // won't be written
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"BoolTrue":true'),
            'Expected "BoolTrue":true in the JSON. Actual: ' + result
        );
        System.Assert.isTrue(
            result.contains('"BoolFalse":false'),
            'Expected "BoolFalse":false in the JSON. Actual: ' + result
        );
        System.Assert.isFalse(
            result.contains('BoolNull'),
            'Expected no "BoolNull" field in the JSON. Actual: ' + result
        );
    }

    /**
     * @description Tests `writeIntegerFieldIfNotNull` with a valid integer and null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void writeIntegerFieldIfNotNull() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeIntegerFieldIfNotNull('IntValue', 42);
        helper.writeIntegerFieldIfNotNull('IntNull', null);
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"IntValue":42'),
            'Expected "IntValue":42 in the JSON. Actual: ' + result
        );
        System.Assert.isFalse(
            result.contains('IntNull'),
            'Expected no "IntNull" field in the JSON. Actual: ' + result
        );
    }

    /**
     * @description Tests writeStringListIfNotEmpty with a non-empty and empty or null lists.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void writeStringListIfNotEmpty() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeStringListIfNotEmpty(
            'NonEmptyList',
            new List<String>{ 'Foo', 'Bar' }
        );
        helper.writeStringListIfNotEmpty('EmptyList', new List<String>());
        helper.writeStringListIfNotEmpty('NullList', null);
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"NonEmptyList":["Foo","Bar"]'),
            'Expected NonEmptyList to be present with ["Foo","Bar"]. Actual: ' +
            result
        );
        System.Assert.isFalse(
            result.contains('"EmptyList"'),
            'Expected EmptyList not to be present. Actual: ' + result
        );
        System.Assert.isFalse(
            result.contains('NullList'),
            'Expected NullList not to be present. Actual: ' + result
        );
    }

    /**
     * @description Tests `writeNestedObject` with a dummy `IJsonSerializable` object and null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void writeNestedObject() {
        JsonHelper helper = new JsonHelper();

        // A dummy object that returns {"testField":"TestValue"}
        DummySerializable dummy = new DummySerializable('TestValue');

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeNestedObject('NestedField', dummy);
        helper.writeNestedObject('NullField', null);
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"NestedField":{"testField":"TestValue"}'),
            'Expected nested object with testField. Actual: ' + result
        );
        System.Assert.isFalse(
            result.contains('NullField'),
            'Expected no NullField. Actual: ' + result
        );
    }

    /**
     * @description Tests `writeNestedObjectList` with a list of `IJsonSerializable` objects,
     * an empty list, and a null list.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void writeNestedObjectList() {
        JsonHelper helper = new JsonHelper();
        List<IJsonSerializable> dummyList = new List<IJsonSerializable>{
            new DummySerializable('Val1'),
            new DummySerializable('Val2')
        };

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeNestedObjectList('DummyList', dummyList);
        helper.writeNestedObjectList(
            'EmptyList',
            new List<IJsonSerializable>()
        );
        helper.writeNestedObjectList('NullList', null);
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains(
                '"DummyList":[{"testField":"Val1"},{"testField":"Val2"}]'
            ),
            'Expected dummy list with Val1, Val2. Actual: ' + result
        );
        System.Assert.isFalse(
            result.contains('EmptyList'),
            'Expected no EmptyList field. Actual: ' + result
        );
        System.Assert.isFalse(
            result.contains('NullList'),
            'Expected no NullList field. Actual: ' + result
        );
    }

    /**
     * @description Tests writeFieldName with a valid name.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void writeFieldName() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeFieldName('ValidField');
        helper.writeString('HelloWorld');
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"ValidField":"HelloWorld"'),
            'Expected field name "ValidField" with value "HelloWorld". Actual: ' +
            result
        );
    }

    /**
     * @description Negative test for writeFieldName() with null argument,
     * expecting an exception or error.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    @IsTest
    static void writeFieldNameWithNullArgument() {
        JsonHelper helper = new JsonHelper();

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        System.Test.startTest();
        helper.writeStartObject();
        try {
            helper.writeFieldName(null);
            exceptionThrown = false;
        } catch (NullPointerException e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
        }
        helper.writeEndObject();
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when fieldName is null.'
        );
        System.Assert.isTrue(
            exceptionTypeName == 'System.NullPointerException',
            'Expected NullPointerException, got: ' + exceptionTypeName
        );
    }

    /**
     * @description A dummy class that implements `IJsonSerializable` for testing purposes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     */
    class DummySerializable implements IJsonSerializable {
        String testField;

        DummySerializable(String testField) {
            this.testField = testField;
        }

        public String toJson() {
            JsonHelper helper = new JsonHelper();
            helper.writeStartObject();
            helper.writeStringFieldIfNotNull('testField', testField);
            helper.writeEndObject();
            return helper.getAsString();
        }
    }
}
