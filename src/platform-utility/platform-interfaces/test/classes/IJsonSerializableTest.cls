/**
 * @description Tests the `IJsonSerializable` interface.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since March 2025 - Initial Release.
 *
 * @group Platform Interfaces
 */
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@isTest
private class IJsonSerializableTest {
    /**
     * @description Tests the `toJson` method of the `IJsonSerializable` interface.
     *
     * @author Kenneth Sørensen
     * @since March 2025 - Initial Release.
     */
    @isTest
    private static void toJson() {
        MyClass myObject = new MyClass('John Doe', 30);
        String expectedJson = '{"name":"John Doe","age":30}';

        System.Test.startTest();
        String actualJson = myObject.toJson();
        System.Test.stopTest();

        System.Assert.areEqual(
            expectedJson,
            actualJson,
            'The JSON output does not match the expected value.'
        );
    }

    /**
     * @description A sample class implementing the `IJsonSerializable` interface.
     *
     * @author Kenneth Sørensen
     * @since March 2025 - Initial Release.
     */
    class MyClass implements IJsonSerializable {
        public String name;
        public Integer age;

        /**
         * @description Constructor for MyClass.
         *
         * @author Kenneth Sørensen
         * @since March 2025 - Initial Release.
         *
         * @param name
         * @param age
         */
        public MyClass(String name, Integer age) {
            this.name = name;
            this.age = age;
        }

        /**
         * @description Converts the object to a JSON string.
         *
         * @author Kenneth Sørensen
         * @since March 2025 - Initial Release.
         *
         * @return A JSON string representation of the object.
         */
        public String toJson() {
            return JSON.serialize(this);
        }
    }
}
