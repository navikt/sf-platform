/**
 * @description Tests the `IMapConvertible` interface.
 *
 * @author Kenneth Soerensen <kenneth.sorensen@nav.no>, Nav
 * @since 0.1.0, January 2025
 * @group Platform Interfaces
 */
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs, PMD.ApexDoc')
@isTest
private class IMapConvertibleTest {
    @isTest
    private static void toMap() {
        MyClass myObject = new MyClass('John Doe', 30);
        Map<String, Object> expectedMap = new Map<String, Object>{
            'name' => 'John Doe',
            'age' => 30
        };

        System.Test.startTest();
        Map<String, Object> actualMap = myObject.toMap();
        System.Test.stopTest();

        System.Assert.areEqual(
            expectedMap,
            actualMap,
            'The map output does not match the expected value.'
        );
    }

    class MyClass implements IMapConvertible {
        public String name;
        public Integer age;

        public MyClass(String name, Integer age) {
            this.name = name;
            this.age = age;
        }

        public Map<String, Object> toMap() {
            Map<String, Object> mapTest = new Map<String, Object>();
            mapTest.put('name', this.name);
            mapTest.put('age', this.age);
            return mapTest;
        }
    }
}
