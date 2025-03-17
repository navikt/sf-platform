/**
 * @description Tests the `JsonHelper` class.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since 0.1.0, January 2025
 * @see JsonHelper
 */
@SuppressWarnings('PMD.CognitiveComplexity')
@isTest(IsParallel=true)
private class JsonHelperTest {
    /**
     * @description Tests the default constructor of the `JsonHelper` class.
     * This is a basic test to ensure that the class can be instantiated without errors.
     * The `generator` property should be an instance of `JSONGenerator`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper
     */
    @IsTest
    static void defaultConstructor() {
        System.Test.startTest();
        JsonHelper helper = new JsonHelper();
        System.Test.stopTest();

        System.Assert.isNotNull(helper, 'Expected helper to be not null.');
        System.Assert.isInstanceOfType(
            helper.generator,
            JSONGenerator.class,
            'Expected generator to be an instance of JSONGenerator.'
        );
    }

    /**
     * @description Tests the constructor that accepts an existing `JSONGenerator`.
     * This is a basic test to ensure that the class can be instantiated without errors.
     * The `generator` property should be the same instance as the one passed to the constructor.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper
     */
    @IsTest
    static void constructorWithJSONGenerator() {
        JSONGenerator generator = JSON.createGenerator(false);

        System.Test.startTest();
        JsonHelper helper = new JsonHelper(generator);
        System.Test.stopTest();

        System.Assert.isNotNull(helper, 'Expected helper to be not null.');
        System.Assert.isInstanceOfType(
            helper.generator,
            JSONGenerator.class,
            'Expected generator to be an instance of JSONGenerator.'
        );
        System.Assert.areEqual(
            generator,
            helper.generator,
            'Expected generator to be the same instance as the one passed to the constructor.'
        );
    }

    /**
     * @description Tests the default constructor and basic usage of the `JsonHelper` class.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper
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
     * @see JsonHelper
     */
    @IsTest
    static void constructorWithJSONGeneratorAndBasicUsage() {
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
     * @description Tests `getAsString` with a simple object containing one field.
     * This is a basic test to ensure that the method returns the expected JSON string.
     * The JSON string should contain the field name and value.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.getAsString
     */
    @IsTest
    static void getAsString() {
        String fieldName = 'FieldOne';
        String fieldValue = 'ValueOne';

        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeStringField(fieldName, fieldValue);
        helper.generator.writeEndObject();

        Test.startTest();
        String result = helper.getAsString();
        Test.stopTest();

        System.assertEquals(
            '{"' + fieldName + '":"' + fieldValue + '"}',
            result,
            'Expected getAsString to return "{\"' +
                fieldName +
                '\":\"' +
                fieldValue +
                '\"}". Actual: ' +
                result
        );
    }

    /**
     * @description Tests `writeStartObject` and `writeEndObject` without any fields.
     * This is a "negative" or edge scenario: an empty object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeStartObject
     * @see JsonHelper.writeEndObject
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
     * @description Tests `writeStartArray` and `writeEndArray` directly.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeStartArray
     * @see JsonHelper.writeEndArray
     */
    @IsTest
    static void writeArrayDirectly() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartArray();
        helper.writeString('One');
        helper.writeString('Two');
        helper.writeEndArray();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.areEqual(
            '["One","Two"]',
            result,
            'Expected the array to be serialized as ["One","Two"]'
        );
    }

    /**
     * @description Tests `writeStartArray`, `writeEndArray`, and `writeFieldName` for an empty array.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeStartArray
     * @see JsonHelper.writeEndArray
     * @see JsonHelper.writeFieldName
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
     * @description Tests `writeStartArray` and `writeEndArray` directly without any elements.
     * This is a basic test to ensure that the methods can be called without errors.
     * The JSON string should contain an empty array "[]".
     * This test is similar to `emptyArray` but writes the array directly without a field name.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeStartArray
     * @see JsonHelper.writeEndArray
     */
    @IsTest
    static void emptyArrayDirectly() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartArray();
        helper.writeEndArray();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.areEqual(
            '[]',
            result,
            'Expected an empty JSON array "[]"'
        );
    }

    /**
     * @description Tests `writeBooleanFieldIfNotNull` with both null and non-null values.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeBooleanFieldIfNotNull
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
     * @see JsonHelper.writeIntegerFieldIfNotNull
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
     * @description Tests `writeString` by invoking it directly within a JSON object.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeString
     */
    @IsTest
    static void writeStringDirectly() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeFieldName('DirectString');
        helper.writeString('Hello, World!');
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('"DirectString":"Hello, World!"'),
            'Expected JSON to contain "DirectString":"Hello, World!". Actual: ' +
            result
        );
    }

    /**
     * @description Tests that `writeStringFieldIfNotNull` does not write a field when value is null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeStringFieldIfNotNull
     */
    @IsTest
    static void writeStringFieldIfNotNullNullValue() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeStringFieldIfNotNull('OptionalField', null);
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isFalse(
            result.contains('OptionalField'),
            'Expected JSON not to contain OptionalField when value is null. Actual: ' +
            result
        );
    }

    /**
     * @description Tests `writeStringListIfNotEmpty` with a non-empty and empty or null lists.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeStringListIfNotEmpty
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
     * @see JsonHelper.writeNestedObject
     * @see IJsonSerializable
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
     * @see JsonHelper.writeNestedObjectList
     * @see IJsonSerializable
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
     * @description Tests `writeFieldName` with a valid name.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeFieldName
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
     * @description Tests `writeFieldName` with an empty string.
     * The Apex JSON generator allow empty keys, so we check for key-value pair with empty key.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeFieldName
     */
    @IsTest
    static void writeFieldNameEmpty() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        helper.writeFieldName('');
        helper.writeString('EmptyKey');
        helper.writeEndObject();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.Assert.isTrue(
            result.contains('""') && result.contains('"EmptyKey"'),
            'Expected JSON to contain an empty key with value "EmptyKey". Actual: ' +
            result
        );
    }

    /**
     * @description Negative test for `writeFieldName` with null argument,
     * expecting an exception or error.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeFieldName
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
     * @description Tests `writeObjectListAsRootArray` with a list of `IJsonSerializable` objects,
     * including a null object in the list.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeObjectListAsRootArray
     */
    @IsTest
    static void writeObjectListAsRootArray() {
        String valueOne = 'Value1';
        String valueTwo = 'Value2';

        List<IJsonSerializable> dummyList = new List<IJsonSerializable>{
            new DummySerializable(valueOne),
            new DummySerializable(valueTwo),
            null
        };
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeObjectListAsRootArray(dummyList);
        String result = helper.getAsString();
        System.Test.stopTest();

        List<Object> parsed = (List<Object>) JSON.deserializeUntyped(result);

        System.Assert.areEqual(
            dummyList.size() - 1,
            parsed.size(),
            'Expected three elements in the root array'
        );
        Map<String, Object> firstObj = (Map<String, Object>) parsed[0];
        System.Assert.areEqual(
            valueOne,
            firstObj.get('testField'),
            'First testField value mismatch'
        );
        Map<String, Object> secondObj = (Map<String, Object>) parsed[1];
        System.Assert.areEqual(
            valueTwo,
            secondObj.get('testField'),
            'Second testField value mismatch'
        );
    }

    /**
     * @description Tests `jsonEquals` for two equivalent JSON strings (even with different key order).
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsPositive() {
        String jsonA = '{"a":1,"b":"test"}';
        String jsonB = '{"b":"test","a":1}'; // different order

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isTrue(
            result,
            'jsonEquals should return true for equivalent JSON regardless of order'
        );
    }

    /**
     * @description Tests `jsonEquals` for two non-equivalent JSON strings.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsNegative() {
        String jsonA = '{"a":1,"b":"test"}';
        String jsonB = '{"a":2,"b":"test"}'; // different value for a

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'jsonEquals should return false for JSON with differing values'
        );
    }

    /**
     * @description Tests that two JSON arrays with the same elements in different orders are not equal.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsListOrderMatters() {
        String jsonA = '["a","b","c"]';
        String jsonB = '["c","b","a"]';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'jsonEquals should return false for arrays with same elements in different order'
        );
    }

    /**
     * @description Roundtrip test: Serialize a list of `IJsonSerializable` objects as a root array
     * and then deserialize it, verifying that the roundtrip preserves the data.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeObjectListAsRootArray
     * @see IJsonSerializable
     */
    @IsTest
    static void roundTripWriteObjectListAsRootArray() {
        String valueOne = 'Value1';
        String valueTwo = 'Value2';

        List<IJsonSerializable> dummyList = new List<IJsonSerializable>{
            new DummySerializable(valueOne),
            new DummySerializable(valueTwo)
        };
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeObjectListAsRootArray(dummyList);
        String jsonArray = helper.getAsString();
        System.Test.stopTest();

        List<Object> parsedList = (List<Object>) JSON.deserializeUntyped(
            jsonArray
        );
        System.Assert.areEqual(
            dummyList.size(),
            parsedList.size(),
            'Expected two items after roundtrip'
        );
        Map<String, Object> item0 = (Map<String, Object>) parsedList[0];
        System.Assert.areEqual(
            valueOne,
            item0.get('testField'),
            'Roundtrip item 0 mismatch'
        );
        Map<String, Object> item1 = (Map<String, Object>) parsedList[1];
        System.Assert.areEqual(
            valueTwo,
            item1.get('testField'),
            'Roundtrip item 1 mismatch'
        );
    }

    /**
     * @description Test `jsonEquals` when both JSON strings are "null".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsBothNull() {
        String jsonA = 'null';
        String jsonB = 'null';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isTrue(
            result,
            'Expected jsonEquals to return true when both JSON strings are null'
        );
    }

    /**
     * @description Test `jsonEquals` when one JSON string is "null" and the other is not.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsOneNull() {
        String jsonA = 'null';
        String jsonB = '{"a":1}';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'Expected jsonEquals to return false when one JSON string is null and the other is not'
        );
    }

    /**
     * @description Test `jsonEquals` with two maps of different key counts.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsMapsDifferentKeyCounts() {
        String jsonA = '{"a":1}';
        String jsonB = '{"a":1,"b":2}';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'Expected jsonEquals to return false for maps with different key counts'
        );
    }

    /**
     * @description Test `jsonEquals` with nested maps where one nested value differs.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsNestedMapDifference() {
        String jsonA = '{"a":{"b":1}}';
        String jsonB = '{"a":{"b":2}}';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'Expected jsonEquals to return false for nested maps with different values'
        );
    }

    /**
     * @description Test `jsonEquals` with two lists of different sizes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsListsDifferentSizes() {
        String jsonA = '["a", "b"]';
        String jsonB = '["a"]';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'Expected jsonEquals to return false for lists with different sizes'
        );
    }

    /**
     * @description Test jsonEquals for two identical primitive values.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     */
    @IsTest
    static void jsonEqualsComparingTwoIdenticalPrimitives() {
        String jsonA = '1';
        String jsonB = '1';
        System.Test.startTest();
        Boolean resultIdentical = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();
        System.Assert.isTrue(
            resultIdentical,
            'Expected jsonEquals to return true for identical primitive values'
        );
    }

    /**
     * @description Test `jsonEquals` for two different primitive values.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsComparingTwoDifferentPrimitives() {
        String jsonA = '1';
        String jsonB = '2';

        System.Test.startTest();
        Boolean resultDifferent = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            resultDifferent,
            'Expected jsonEquals to return false for different primitive values'
        );
    }

    /**
     * @description Verifies that `jsonEquals` returns false when comparing two maps that have the same number
     * of keys but differ in key names. This forces the comparison loop to check for a key that
     * exists in one map but not in the other.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsMapsWithSameCountButDifferentKeys() {
        String jsonA = '{"a":1,"b":2}';
        String jsonB = '{"a":1,"c":2}';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'Expected jsonEquals to return false for maps with a missing key'
        );
    }

    /**
     * @description Verifies that `jsonEquals` returns false when comparing two maps with nested
     * values that differ.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     */
    @IsTest
    static void jsonEqualsNestedMapValueDifferent() {
        String jsonA = '{"a": {"x":1, "y":2}}';
        String jsonB = '{"a": {"x":1, "y":3}}'; // nested value "y" differs

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'Expected jsonEquals to return false for nested maps with differing values'
        );
    }

    /**
     * @description Verifies that `jsonEquals` returns false for two lists with the same size but with
     * one differing element.
     *
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsListsWithDifferentElements() {
        String jsonA = '["apple", "banana", "cherry"]';
        String jsonB = '["apple", "blueberry", "cherry"]'; // second element differs

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            result,
            'Expected jsonEquals to return false for lists with different elements'
        );
    }

    /**
     * @description Verifies that `jsonEquals` returns true for two identical lists.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.jsonEquals
     */
    @IsTest
    static void jsonEqualsIdenticalLists() {
        String jsonA = '["apple", "banana", "cherry"]';
        String jsonB = '["apple", "banana", "cherry"]';

        System.Test.startTest();
        Boolean result = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isTrue(
            result,
            'Expected jsonEquals to return true for identical lists'
        );
    }

    /**
     * @description A dummy class that implements `IJsonSerializable` for testing purposes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see IJsonSerializable
     */
    @SuppressWarnings('PMD.ApexDoc')
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
