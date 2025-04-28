/**
 * @description Tests the `IMapConvertible` interface.
 *
 * @author Kenneth Sørensen
 * @since March 2025 - Initial Release.
 *
 * @group Platform Interfaces
 */
@SuppressWarnings('PMD.ApexUnitTestClassShouldHaveRunAs')
@isTest
private class IMapConvertibleTest {
    /**
     * @description Tests the `toMap` method of the `IMapConvertible` interface.
     *
     * @author Kenneth Sørensen
     * @since March 2025 - Initial Release.
     */
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

    /**
     * @description A sample class implementing the `IMapConvertible` interface.
     *
     * @author Kenneth Sørensen
     * @since March 2025 - Initial Release.
     */
    class MyClass implements IMapConvertible {
        public String name;
        public Integer age;

        /**
         * @description
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
         * @description Converts the object to a map.
         *
         * @author Kenneth Sørensen
         * @since March 2025 - Initial Release.
         *
         * @return A map representation of the object.
         */
        public Map<String, Object> toMap() {
            Map<String, Object> mapTest = new Map<String, Object>();
            mapTest.put('name', this.name);
            mapTest.put('age', this.age);
            return mapTest;
        }
    }
}
