/**
 * @description Tests the `IJsonSerializable` interface.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since 0.1.0, January 2025
 * @group Platform Interfaces
 */
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs, PMD.ApexDoc')
@isTest
private class IJsonSerializableTest {
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

    class MyClass implements IJsonSerializable {
        public String name;
        public Integer age;

        public MyClass(String name, Integer age) {
            this.name = name;
            this.age = age;
        }

        public String toJson() {
            return JSON.serialize(this);
        }
    }
}
