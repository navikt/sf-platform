/**
 * @description Tests the `JsonHelper` class.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since 0.1.0, January 2025
 * @group JSON Helper
 * @see JsonHelper
 */
@SuppressWarnings(
    'PMD.CognitiveComplexity, PMD.ApexUnitTestClassShouldHaveRunAs, PMD.CyclomaticComplexity, PMD.NcssTypeCount'
)
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
    private static void defaultConstructor() {
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
    private static void constructorWithJSONGenerator() {
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
     * @description Tests the constructor that accepts a boolean for pretty printing.
     * This test verifies that the `generator` property is an instance of `JSONGenerator`
     * and that the pretty printing setting is applied correctly.
     * The JSON string should not contain newline characters or indentation when pretty printing is disabled.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper
     */
    @IsTest
    private static void constructorWithPrettyPrintFalse() {
        System.Test.startTest();
        JsonHelper helper = new JsonHelper(false);
        helper.generator.writeStartObject();
        helper.generator.writeStringField('FieldOne', 'ValueOne');
        helper.generator.writeEndObject();
        String result = helper.generator.getAsString();
        System.Test.stopTest();

        System.Assert.isInstanceOfType(
            helper.generator,
            JSONGenerator.class,
            'Expected generator to be an instance of JSONGenerator.'
        );
        System.Assert.isFalse(
            result.contains('\n'),
            'Compact JSON should not contain newline characters.'
        );
        System.Assert.isFalse(
            result.contains('  '),
            'Compact JSON should not contain indentation.'
        );
    }

    /**
     * @description Tests the constructor that accepts a boolean for pretty printing.
     * This test verifies that the `generator` property is an instance of `JSONGenerator`
     * and that the pretty printing setting is applied correctly.
     * The JSON string should contain newline characters and indentation when pretty printing is enabled.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper
     */
    @IsTest
    private static void constructorWithPrettyPrintTrue() {
        System.Test.startTest();
        JsonHelper helper = new JsonHelper(true);
        helper.generator.writeStartObject();
        helper.generator.writeStringField('FieldOne', 'ValueOne');
        helper.generator.writeEndObject();
        String result = helper.generator.getAsString();
        System.Test.stopTest();

        System.Assert.isInstanceOfType(
            helper.generator,
            JSONGenerator.class,
            'Expected generator to be an instance of JSONGenerator.'
        );
        System.Assert.isTrue(
            result.contains('\n'),
            'Pretty JSON should contain newline characters.'
        );
        System.Assert.isTrue(
            result.contains('  '),
            'Compact JSON should not contain indentation.'
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
    private static void defaultConstructorAndBasicUsage() {
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
    private static void constructorWithJSONGeneratorAndBasicUsage() {
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
     * @description Tests `close` to ensure that the `JsonHelper` is closed after calling the method.
     * This is a basic test to ensure that the method can be called without errors.
     * The `isClosed` method should return `true` after calling `close`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.close
     * @see JsonHelper.isClosed
     */
    @IsTest
    private static void closed() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeStringField('FieldOne', 'ValueOne');
        helper.generator.writeEndObject();

        System.Assert.isFalse(helper.isClosed(), 'Expected helper to be open');

        Test.startTest();
        helper.close();
        Test.stopTest();

        System.Assert.isTrue(helper.isClosed(), 'Expected helper to be closed');
    }

    /**
     * @description Tests that an exception is thrown when calling methods on a closed `JsonHelper`.
     * This is a negative test to ensure that an exception is thrown when calling methods on a closed helper.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     * @see JsonHelper.JsonHelperException
     */
    @IsTest
    private static void closedThrowException() {
        JsonHelper helper = new JsonHelper();
        helper.writeStartObject();
        helper.writeStringField('FieldOne', 'ValueOne');

        System.Assert.isFalse(
            helper.isClosed(),
            'Expected JSON Generator to be open'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.close();
            helper.writeEndObject();
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
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
    private static void getAsString() {
        String fieldName = 'FieldOne';
        String fieldValue = 'ValueOne';

        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeStringField(fieldName, fieldValue);
        helper.generator.writeEndObject();

        System.Test.startTest();
        String result = helper.getAsString();
        System.Test.stopTest();

        System.assertEquals(
            '{"' + fieldName + '":"' + fieldValue + '"}',
            result,
            'Expected getAsString to return the JSON object with one field and value as a string.'
        );
    }

    /**
     * @description Tests `writeBlob` with a simple blob value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the base64 encoded blob value.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBlob
     */
    @IsTest
    private static void writeBlob() {
        JsonHelper helper = new JsonHelper();
        Blob blobValue = Blob.valueOf('Hello, World!');
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('BlobField');

        System.Test.startTest();
        helper.writeBlob(blobValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.assertEquals(
            '{"BlobField":"' + EncodingUtil.base64Encode(blobValue) + '"}',
            result,
            'Expected getAsString to return a JSON string with a base64 encoded blob value.'
        );
    }

    /**
     * @description Tests `writeBlob` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeBlob` on a
     * closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBlob
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeBlobThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Blob blobValue = Blob.valueOf('Hello, World!');
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('BlobField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeBlob(blobValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeBlobField` with a simple blob value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and base64 encoded blob value.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBlobField
     */
    @IsTest
    private static void writeBlobField() {
        JsonHelper helper = new JsonHelper();
        Blob blobValue = Blob.valueOf('Hello, World!');
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeBlobField('BlobField', blobValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains(
                '"BlobField":"' + EncodingUtil.base64Encode(blobValue) + '"'
            ),
            'Expected JSON to contain the field name and base64 encoded blob value.'
        );
    }

    /**
     * @description Tests `writeBlobField` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeBlobField` on a
     * closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBlobField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeBlobFieldThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Blob blobValue = Blob.valueOf('Hello, World!');
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeBlobField('BlobField', blobValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeBoolean` with a `true` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the boolean value `true`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBoolean
     */
    @IsTest
    private static void writeBoolean() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('BooleanField');

        System.Test.startTest();
        helper.writeBoolean(true);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"BooleanField":true'),
            'Expected JSON to contain the field name and boolean value "true".'
        );
    }

    /**
     * @description Tests `writeBoolean` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeBoolean` on
     * a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBoolean
     * @see JsonHelper.JsonHelperException
     */
    @IsTest
    private static void writeBooleanThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('BooleanField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeBoolean(true);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeBooleanField` with a `false` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and boolean value `false`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBooleanField
     */
    @IsTest
    private static void writeBooleanField() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeBooleanField('BooleanField', false);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"BooleanField":false'),
            'Expected JSON to contain the field name and boolean value "false".'
        );
    }

    /**
     * @description Tests `writeBooleanField` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeBooleanField`
     * on a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeBooleanField
     * @see JsonHelper.JsonHelperException
     */
    @IsTest
    private static void writeBooleanFieldThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeBooleanField('BooleanField', false);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeDate` with a valid date value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the date value in the format "yyyy-MM-dd".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDate
     */
    @IsTest
    private static void writeDate() {
        JsonHelper helper = new JsonHelper();
        Date dateValue = Date.today();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('DateField');

        System.Test.startTest();
        helper.writeDate(dateValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.areEqual(
            '{"DateField":"' + String.valueOf(dateValue) + '"}',
            result,
            'Expected JSON to contain the field name and date value in the format "yyyy-MM-dd".'
        );
    }

    /**
     * @description Tests `writeDate` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeDate` on
     * a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDate
     * @see JsonHelper.JsonHelperException
     */
    @IsTest
    private static void writeDateThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Date dateValue = Date.today();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('BooleanField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeDate(dateValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeDateField` with a valid date value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and date value in the format "yyyy-MM-dd".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDateField
     */
    @IsTest
    private static void writeDateField() {
        JsonHelper helper = new JsonHelper();
        Date dateValue = Date.today();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeDateField('DateField', dateValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.areEqual(
            '{"DateField":"' + String.valueOf(dateValue) + '"}',
            result,
            'Expected JSON to contain the field name and date value in the format "yyyy-MM-dd".'
        );
    }

    /**
     * @description Tests `writeDateField` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeDateField` on
     * a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDateField
     * @see JsonHelper.JsonHelperException
     */
    @IsTest
    private static void writeDateFieldThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Date dateValue = Date.today();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeDateField('DateField', dateValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeDateTime` with a valid datetime value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the datetime value in the format "yyyy-MM-dd'T'HH:mm:ss.SSSZ".
     * The timezone should be UTC.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDateTime
     */
    @IsTest
    private static void writeDateTime() {
        JsonHelper helper = new JsonHelper();
        Datetime dateTimeValue = Datetime.now();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('DateTimeField');

        System.Test.startTest();
        helper.writeDateTime(dateTimeValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains(
                '"DateTimeField":"' +
                    dateTimeValue.formatGMT(
                        'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
                    ) +
                    '"'
            ),
            'Expected JSON to contain the field name and datetime value in the format "yyyy-MM-dd\'T\'HH:mm:ss.SSSZ".'
        );
    }

    /**
     * @description Tests `writeDateTime` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeDateTime` on
     * a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDateTime
     * @see JsonHelper.JsonHelperException
     */
    @IsTest
    private static void writeDateTimeThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Datetime dateTimeValue = Datetime.now();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('DateTimeField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeDateTime(dateTimeValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeDateTimeField` with a valid datetime value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the datetime value in the format "yyyy-MM-dd'T'HH:mm:ss.SSSZ".
     * The timezone should be UTC.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDateTimeField
     */
    @IsTest
    private static void writeDateTimeField() {
        JsonHelper helper = new JsonHelper();
        Datetime dateTimeValue = Datetime.now();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeDateTimeField('DateTimeField', dateTimeValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains(
                '"DateTimeField":"' +
                    dateTimeValue.formatGMT(
                        'yyyy-MM-dd\'T\'HH:mm:ss.SSS\'Z\''
                    ) +
                    '"'
            ),
            'Expected JSON to contain the field name and datetime value in the format "yyyy-MM-dd\'T\'HH:mm:ss.SSSZ".'
        );
    }

    /**
     * @description Tests `writeDateTimeField` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeDateTimeField`
     * on a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeDateTimeField
     * @see JsonHelper.JsonHelperException
     */
    @IsTest
    private static void writeDateTimeFieldThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Datetime dateTimeValue = Datetime.now();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeDateTimeField('DateTimeField', dateTimeValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeEndArray` with an open array.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the end of the array "]".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeEndArray
     */
    @IsTest
    private static void writeEndArray() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('ArrayField');
        helper.generator.writeStartArray();

        System.Test.startTest();
        helper.writeEndArray();
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"ArrayField":[]'),
            'Expected JSON to contain the field name and start of an array.'
        );
    }

    /**
     * @description Tests `writeEndArray` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeEndArray` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @see JsonHelper.writeEndArray
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeEndArrayThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('ArrayField');
        helper.generator.writeStartArray();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeEndArray();
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeEndObject` with an open object.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the end of the object "}".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeEndObject
     */
    @IsTest
    private static void writeEndObject() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeEndObject();
        System.Test.stopTest();

        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('{}'),
            'Expected JSON to contain the end of an object "}".'
        );
    }

    /**
     * @description Tests `writeEndObject` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeEndObject` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeEndObject
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeEndObjectThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeEndObject();
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeFieldName` with a valid name.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeFieldName
     */
    @IsTest
    private static void writeFieldName() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeFieldName('ValidField');
        System.Test.stopTest();

        helper.generator.writeString('Value');
        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"ValidField":"Value"'),
            'Expected field name "ValidField". Actual: ' + result
        );
    }

    /**
     * @description Tests `writeFieldName` with an empty string.
     * The Apex JSON generator allow empty keys, so we check for key-value pair with empty key.
     * The JSON string should contain an empty key with value "EmptyKey".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeFieldName
     */
    @IsTest
    private static void writeFieldNameEmpty() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeFieldName('');
        System.Test.stopTest();

        helper.generator.writeString('EmptyKey');
        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('""') && result.contains('"EmptyKey"'),
            'Expected JSON to contain an empty key with value "EmptyKey". Actual: ' +
            result
        );
    }

    /**
     * @description Tests `writeFieldName` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeFieldName` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeFieldName
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeFieldNameThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeFieldName('FieldName');
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Negative test for `writeFieldName` with null argument, expecting an exception or
     * error.
     * The exception type should be `System.NullPointerException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeFieldName
     * @see System.NullPointerException
     */
    @IsTest
    private static void writeFieldNameWithNullArgument() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';

        System.Test.startTest();
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
     * @description Tests `writeId` with a valid Id value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the Id value.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeId
     */
    @SuppressWarnings('PMD.AvoidHardcodingId')
    @IsTest
    private static void writeId() {
        JsonHelper helper = new JsonHelper();
        Id idValue = '001000000000000AAA';
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('IdField');

        System.Test.startTest();
        helper.writeId(idValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"IdField":"' + idValue + '"'),
            'Expected JSON to contain the field name and Id value.'
        );
    }

    /**
     * @description Tests `writeId` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeId` on
     * a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeId
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @SuppressWarnings('PMD.AvoidHardcodingId')
    @IsTest
    private static void writeIdThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Id idValue = '001000000000000AAA';
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('IdField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeId(idValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeIdField` with a valid Id value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and Id value.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeIdField
     */
    @SuppressWarnings('PMD.AvoidHardcodingId')
    @IsTest
    private static void writeIdField() {
        JsonHelper helper = new JsonHelper();
        Id idValue = '001000000000000AAA';
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeIdField('IdField', idValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"IdField":"' + idValue + '"'),
            'Expected JSON to contain the field name and Id value.'
        );
    }

    /**
     * @description Tests `writeIdField` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeIdField` on
     * a closed generator.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeIdField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @SuppressWarnings('PMD.AvoidHardcodingId')
    @IsTest
    private static void writeIdFieldThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        Id idValue = '001000000000000AAA';
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeIdField('IdField', idValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNull` method to ensure that the method can be called without errors.
     * The JSON string should contain the field name and null value.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNull
     */
    @IsTest
    private static void writeNull() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('NullField');

        System.Test.startTest();
        helper.writeNull();
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"NullField":null'),
            'Expected JSON to contain the field name and null value.'
        );
    }

    /**
     * @description Tests `writeNull` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNull` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNull
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNullThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('NullField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNull();
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNullField` method to ensure that the method can be called without errors.
     * The JSON string should contain the field name and null value.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNullField
     */
    @IsTest
    private static void writeNullField() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeNullField('NullField');
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"NullField":null'),
            'Expected JSON to contain the field name and null value.'
        );
    }

    /**
     * @description Tests `writeNullField` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNullField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNullField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNullFieldThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNullField('NullField');
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumber` with a valid `Decimal` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and decimal value.
     * The decimal value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     */
    @IsTest
    private static void writeNumberWithDecimal() {
        Decimal decimalValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('DecimalField');

        System.Test.startTest();
        helper.writeNumber(decimalValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"DecimalField":' + decimalValue),
            'Expected JSON to contain the field name and decimal value.'
        );
    }

    /**
     * @description Tests `writeNumber` with a `Decimal` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumber` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberWithDecimalThrowCloseGeneratorException() {
        Decimal decimalValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('DecimalField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNumber(decimalValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumber` with a valid `Double` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and double value.
     * The double value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     */
    @IsTest
    private static void writeNumberWithDouble() {
        Double doubleValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('DoubleField');

        System.Test.startTest();
        helper.writeNumber(doubleValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"DoubleField":' + doubleValue),
            'Expected JSON to contain the field name and double value.'
        );
    }

    /**
     * @description Tests `writeNumber` with a `Double` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumber` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberWithDoubleThrowCloseGeneratorException() {
        Double doubleValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('DoubleField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNumber(doubleValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumber` with a valid `Integer` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and integer value.
     * The integer value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     */
    @IsTest
    private static void writeNumberWithInteger() {
        Integer integerValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('IntegerField');

        System.Test.startTest();
        helper.writeNumber(integerValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"IntegerField":' + integerValue),
            'Expected JSON to contain the field name and integer value.'
        );
    }

    /**
     * @description Tests `writeNumber` with a `Integer` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumber` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberWithIntegerThrowClosedGeneratorException() {
        Integer integerValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('IntegerField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNumber(integerValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumber` with a valid `Long` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and long value.
     * The long value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     */
    @IsTest
    private static void writeNumberWithLong() {
        Long longValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('LongField');

        System.Test.startTest();
        helper.writeNumber(longValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"LongField":' + longValue),
            'Expected JSON to contain the field name and long value.'
        );
    }

    /**
     * @description Tests `writeNumber` with a `Integer` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumber` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumber
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberWithLongThrowClosedGeneratorException() {
        Long longValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('LongField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNumber(longValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumberField` with a valid `Decimal` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and decimal value.
     * The decimal value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     */
    @IsTest
    private static void writeNumberFieldWithDecimal() {
        Decimal decimalValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeNumberField('DecimalField', decimalValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"DecimalField":' + decimalValue),
            'Expected JSON to contain the field name and decimal value.'
        );
    }

    /**
     * @description Tests `writeNumberField` with a `Decimal` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumberField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberFieldWithDecimalThrowClosedGeneratorException() {
        Decimal decimalValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNumberField('DecimalField', decimalValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumberField` with a valid `Double` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and double value.
     * The double value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     */
    @IsTest
    private static void writeNumberFieldWithDouble() {
        Double doubleValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeNumberField('DoubleField', doubleValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"DoubleField":' + doubleValue),
            'Expected JSON to contain the field name and double value.'
        );
    }

    /**
     * @description Tests `writeNumberField` with a `Double` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumberField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberFieldWithDoubleThrowClosedGeneratorException() {
        Double doubleValue = 123.456;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();

        try {
            helper.writeNumberField('DoubleField', doubleValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumberField` with a valid `Integer` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and integer value.
     * The integer value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     */
    @IsTest
    private static void writeNumberFieldWithInteger() {
        Integer integerValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeNumberField('IntegerField', integerValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"IntegerField":' + integerValue),
            'Expected JSON to contain the field name and integer value.'
        );
    }

    /**
     * @description Tests `writeNumberField` with a `Integer` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumberField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberFieldWithIntegerThrowClosedGeneratorException() {
        Integer integerValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNumberField('IntegerField', integerValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );

        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );

        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeNumberField` with a valid `Long` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and long value.
     * The long value should be serialized as a number without quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     */
    @IsTest
    private static void writeNumberFieldWithLong() {
        Long longValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeNumberField('LongField', longValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"LongField":' + longValue),
            'Expected JSON to contain the field name and long value.'
        );
    }

    /**
     * @description Tests `writeNumberField` with a `Long` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeNumberField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeNumberField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeNumberFieldWithLongThrowClosedGeneratorException() {
        Long longValue = 123;
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeNumberField('LongField', longValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );

        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );

        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeObject` with an empty object.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and an empty object.
     * The object should be serialized as an empty object "{}".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeObject
     */
    @IsTest
    private static void writeObject() {
        Map<String, Object> obj = new Map<String, Object>();
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('ObjectField');

        System.Test.startTest();
        helper.writeObject(obj);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"ObjectField":{}'),
            'Expected JSON to contain the field name and empty object.'
        );
    }

    /**
     * @description Tests `writeObject` with an empty object when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeObject` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeObject
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeObjectThrowClosedGeneratorException() {
        Map<String, Object> obj = new Map<String, Object>();
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('ObjectField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeObject(obj);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Test ´writeObjectField´ with an empty object.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and an empty object.
     * The object should be serialized as an empty object "{}".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeObjectField
     */
    @IsTest
    private static void writeObjectField() {
        Map<String, Object> obj = new Map<String, Object>();
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeObjectField('ObjectField', obj);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"ObjectField":{}'),
            'Expected JSON to contain the field name and empty object.'
        );
    }

    /**
     * @description Tests `writeObjectField` with an empty object when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeObjectField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeObjectField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeObjectFieldThrowClosedGeneratorException() {
        Map<String, Object> obj = new Map<String, Object>();
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeObjectField('ObjectField', obj);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeStartArray` with an open array.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the end of the array "]".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeStartArray
     */
    @IsTest
    private static void writeStartArray() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('ArrayField');

        System.Test.startTest();
        helper.writeStartArray();
        System.Test.stopTest();

        helper.generator.writeEndArray();
        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"ArrayField":[]'),
            'Expected JSON to contain the field name and start of an array.'
        );
    }

    /**
     * @description Tests `writeStartArray` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeStartArray` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @see JsonHelper.writeStartArray
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeStartArrayThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('ArrayField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeStartArray();
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeStartObject` with an open object.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the end of the object "}".
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeStartObject
     */
    @IsTest
    private static void writeStartObject() {
        JsonHelper helper = new JsonHelper();

        System.Test.startTest();
        helper.writeStartObject();
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('{}'),
            'Expected JSON to contain the end of an object "}".'
        );
    }

    /**
     * @description Tests `writeStartObject` when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeStartObject` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeStartObject
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeStartObjectThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeStartObject();
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeString` with a valid `String` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and string value.
     * The string value should be serialized with quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeString
     */
    @IsTest
    private static void writeString() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('StringField');

        System.Test.startTest();
        helper.writeString('Hello, World!');
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"StringField":"Hello, World!"'),
            'Expected JSON to contain the field name and string value.'
        );
    }

    /**
     * @description Tests `writeString` with a `String` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeString` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeString
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeStringThrowCloseGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('StringField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeString('Hello, World!');
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeStringField` with a valid `String` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and string value.
     * The string value should be serialized with quotes.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeStringField
     */
    @IsTest
    private static void writeStringField() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeStringField('StringField', 'Hello, World!');
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"StringField":"Hello, World!"'),
            'Expected JSON to contain the field name and string value.'
        );
    }

    /**
     * @description Tests `writeStringField` with a `String` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeStringField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeStringField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeStringFieldThrowClosedGeneratorException() {
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeStringField('StringField', 'Hello, World!');
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeTime` with a valid `Time` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and time value.
     * The time value should be serialized as a string with quotes.
     * The time value should be formatted as "HH:mm:ss.SSS".
     * The time value should be in UTC time zone.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeTime
     */
    @IsTest
    private static void writeTime() {
        Time timeValue = Time.newInstance(12, 34, 56, 789);
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('TimeField');

        System.Test.startTest();
        helper.writeTime(timeValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"TimeField":"' + timeValue.toString() + '"'),
            'Expected JSON to contain the field name and time value.'
        );
    }

    /**
     * @description Tests `writeTime` with a closed `JSONGenerator`.
     * This is a negative test to ensure that an exception is thrown when calling `writeTime` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeTime
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeTimeThrowClosedGeneratorException() {
        Time timeValue = Time.newInstance(12, 34, 56, 789);
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.generator.writeFieldName('TimeField');
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeTime(timeValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    /**
     * @description Tests `writeTimeField` with a valid `Time` value.
     * This is a basic test to ensure that the method can be called without errors.
     * The JSON string should contain the field name and time value.
     * The time value should be serialized as a string with quotes.
     * The time value should be formatted as "HH:mm:ss.SSS".
     * The time value should be in UTC time zone.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeTimeField
     */
    @IsTest
    private static void writeTimeField() {
        Time timeValue = Time.newInstance(12, 34, 56, 789);
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();

        System.Test.startTest();
        helper.writeTimeField('TimeField', timeValue);
        System.Test.stopTest();

        helper.generator.writeEndObject();
        String result = helper.getAsString();

        System.Assert.isTrue(
            result.contains('"TimeField":"' + timeValue.toString() + '"'),
            'Expected JSON to contain the field name and time value.'
        );
    }

    /**
     * @description Tests `writeTimeField` with a `Time` property when the `JSONGenerator` is closed.
     * This is a negative test to ensure that an exception is thrown when calling `writeTimeField` on
     * a closed generator.
     * The exception message should contain a warning about a closed generator.
     * The exception type should be `JsonHelper.JsonHelperException`.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, March 2025
     * @see JsonHelper.writeTimeField
     * @see JsonHelper.JsonHelperException
     * @see JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE
     */
    @IsTest
    private static void writeTimeFieldhrowClosedGeneratorException() {
        Time timeValue = Time.newInstance(12, 34, 56, 789);
        JsonHelper helper = new JsonHelper();
        helper.generator.writeStartObject();
        helper.close();

        System.Assert.isTrue(
            helper.isClosed(),
            'Expected JSON Generator to be closed'
        );

        Boolean exceptionThrown = false;
        String exceptionTypeName = '';
        String exceptionMessage = '';

        System.Test.startTest();
        try {
            helper.writeTimeField('TimeField', timeValue);
            exceptionThrown = false;
        } catch (Exception e) {
            exceptionThrown = true;
            exceptionTypeName = e.getTypeName();
            exceptionMessage = e.getMessage();
        }
        System.Test.stopTest();

        System.Assert.isTrue(
            exceptionThrown,
            'Expected an exception when performing operations on a closed "JSONGenerator".'
        );
        System.Assert.areEqual(
            JsonHelper.CLOSED_GENERATOR_ERROR_MESSAGE,
            exceptionMessage,
            'Expected the exception message warning about a closed generator.'
        );
        System.Assert.areEqual(
            'JsonHelper.JsonHelperException',
            exceptionTypeName,
            'Expected the exception type to be "JsonHelper.JsonHelperException".'
        );
    }

    //--------------------------------------------------------------------------------------------------
    // Fix tests under this line
    //--------------------------------------------------------------------------------------------------

    @IsTest
    private static void fixTestsUnderThisLine() {
        System.debug('Fix tests under this line');
        System.Assert.fail('Fix tests under this line');
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
    private static void emptyObject() {
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
    private static void writeArrayDirectly() {
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
    private static void emptyArray() {
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
    private static void emptyArrayDirectly() {
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
    private static void writeBooleanFieldIfNotNull() {
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
    private static void writeIntegerFieldIfNotNull() {
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
     * @description Tests that `writeStringFieldIfNotNull` does not write a field when value is null.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeStringFieldIfNotNull
     */
    @IsTest
    private static void writeStringFieldIfNotNullNullValue() {
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
    private static void writeStringListIfNotEmpty() {
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
    private static void writeNestedObject() {
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
    private static void writeNestedObjectList() {
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
    /*@IsTest
    private static void writeFieldName() {
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
    }*/

    /**
     * @description Tests `writeFieldName` with an empty string.
     * The Apex JSON generator allow empty keys, so we check for key-value pair with empty key.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeFieldName
     */
    /*@IsTest
    private static void writeFieldNameEmpty() {
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
    }*/

    /**
     * @description Negative test for `writeFieldName` with null argument,
     * expecting an exception or error.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, January 2025
     * @see JsonHelper.writeFieldName
     */
    /*@IsTest
    private static void writeFieldNameWithNullArgument() {
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
    }*/

    /**
     * @description Tests `writeObjectListAsRootArray` with a list of `IJsonSerializable` objects,
     * including a null object in the list.
     *
     * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
     * @since 0.1.0, February 2025
     * @see JsonHelper.writeObjectListAsRootArray
     */
    @IsTest
    private static void writeObjectListAsRootArray() {
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
    private static void jsonEqualsPositive() {
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
    private static void jsonEqualsNegative() {
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
    private static void jsonEqualsListOrderMatters() {
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
    private static void roundTripWriteObjectListAsRootArray() {
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
    private static void jsonEqualsBothNull() {
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
    private static void jsonEqualsOneNull() {
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
    private static void jsonEqualsMapsDifferentKeyCounts() {
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
    private static void jsonEqualsNestedMapDifference() {
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
    private static void jsonEqualsListsDifferentSizes() {
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
    private static void jsonEqualsComparingTwoIdenticalPrimitives() {
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
    private static void jsonEqualsComparingTwoDifferentPrimitives() {
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
    private static void jsonEqualsMapsWithSameCountButDifferentKeys() {
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
    private static void jsonEqualsNestedMapValueDifferent() {
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
    private static void jsonEqualsListsWithDifferentElements() {
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
    private static void jsonEqualsIdenticalLists() {
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
     * @description Tests that `jsonEquals` returns false when strings differ only in case.
     *
     * @author Eivind Øksnevad <eivind.oksnevad@nav.no>, Nav
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void jsonStringIsCaseSensitive() {
        String jsonA = '"now"';
        String jsonB = '"NOW"';

        System.Test.startTest();
        Boolean areEqual = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            areEqual,
            'Expected jsonEquals comparison to be case sensitive'
        );
    }

    /**
     * @description Tests that `jsonEquals` returns false when key is different case in two JSON strings.
     *
     * @author Eivind Øksnevad <eivind.oksnevad@nav.no>, Nav
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void jsonKeyIsCaseSensitive() {
        String jsonA = '{"now":"winter"}';
        String jsonB = '{"NOW":"winter"}';

        System.Test.startTest();
        Boolean areEqual = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isFalse(
            areEqual,
            'Expected jsonEquals comparison to be case sensitive'
        );
    }

    /**
     * @description Tests that `jsonEquals` returns true when double and integer values are equal.
     *
     * @author Eivind Øksnevad <eivind.oksnevad@nav.no>, Nav
     * @since 0.1.0, March 2025
     */
    @IsTest
    private static void jsonDoubleCanEqualInt() {
        String jsonA = '{"answer": 42.0}';
        String jsonB = '{"answer": 42}';

        System.Test.startTest();
        Boolean areEqual = JsonHelper.jsonEquals(jsonA, jsonB);
        System.Test.stopTest();

        System.Assert.isTrue(areEqual, 'Expected 42 and 42.0 to be the same');
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
