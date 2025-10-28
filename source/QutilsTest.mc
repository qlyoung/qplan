import Toybox.Lang;
import Toybox.Test;
import Toybox.System;

(:test)
module QutilsTest {

    // Test CompareDict with identical dictionaries
    (:test)
    function testCompareDictIdentical(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "key2" => 42,
            "key3" => 3.14
        };

        var dict2 = {
            "key1" => "value1",
            "key2" => 42,
            "key3" => 3.14
        };

        Test.assert(CompareDict(dict1, dict2));
        Test.assert(CompareDict(dict2, dict1));

        return true;
    }

    // Test CompareDict with same dictionary (self-comparison)
    (:test)
    function testCompareDictSelf(logger as Logger) as Boolean {
        var dict = {
            "key1" => "value1",
            "key2" => 42
        };

        Test.assert(CompareDict(dict, dict));

        return true;
    }

    // Test CompareDict with different values
    (:test)
    function testCompareDictDifferentValues(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "key2" => 42
        };

        var dict2 = {
            "key1" => "value1",
            "key2" => 43
        };

        Test.assert(!CompareDict(dict1, dict2));
        Test.assert(!CompareDict(dict2, dict1));

        return true;
    }

    // Test CompareDict with different keys
    (:test)
    function testCompareDictDifferentKeys(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "key2" => 42
        };

        var dict2 = {
            "key1" => "value1",
            "key3" => 42
        };

        Test.assert(!CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with different number of keys
    (:test)
    function testCompareDictDifferentSize(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "key2" => 42
        };

        var dict2 = {
            "key1" => "value1",
            "key2" => 42,
            "key3" => 3.14
        };

        Test.assert(!CompareDict(dict1, dict2));
        Test.assert(!CompareDict(dict2, dict1));

        return true;
    }

    // Test CompareDict with empty dictionaries
    (:test)
    function testCompareDictEmpty(logger as Logger) as Boolean {
        var dict1 = {};
        var dict2 = {};

        Test.assert(CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with null values
    (:test)
    function testCompareDictNullValues(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => null,
            "key2" => 42
        };

        var dict2 = {
            "key1" => null,
            "key2" => 42
        };

        Test.assert(CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with one null and one non-null value
    (:test)
    function testCompareDictNullVsNonNull(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => null,
            "key2" => 42
        };

        var dict2 = {
            "key1" => "value1",
            "key2" => 42
        };

        Test.assert(!CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with various data types
    (:test)
    function testCompareDictVariousTypes(logger as Logger) as Boolean {
        var dict1 = {
            "string" => "test",
            "int" => 42,
            "float" => 3.14,
            "bool" => true
        };

        var dict2 = {
            "string" => "test",
            "int" => 42,
            "float" => 3.14,
            "bool" => true
        };

        Test.assert(CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with nested dictionaries
    (:test)
    function testCompareDictNested(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "nested" => {
                "inner_key" => 42
            }
        };

        var dict2 = {
            "key1" => "value1",
            "nested" => {
                "inner_key" => 42
            }
        };

        Test.assert(CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with different nested dictionaries
    (:test)
    function testCompareDictNestedDifferent(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "nested" => {
                "inner_key" => 42
            }
        };

        var dict2 = {
            "key1" => "value1",
            "nested" => {
                "inner_key" => 43
            }
        };

        Test.assert(!CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with arrays
    (:test)
    function testCompareDictWithArrays(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "array" => [1, 2, 3]
        };

        var dict2 = {
            "key1" => "value1",
            "array" => [1, 2, 3]
        };

        Test.assert(CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with different arrays
    (:test)
    function testCompareDictWithDifferentArrays(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => "value1",
            "array" => [1, 2, 3]
        };

        var dict2 = {
            "key1" => "value1",
            "array" => [1, 2, 4]
        };

        Test.assert(!CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with float precision
    (:test)
    function testCompareDictFloatPrecision(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => 3.14159
        };

        var dict2 = {
            "key1" => 3.14159
        };

        Test.assert(CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with different float values
    (:test)
    function testCompareDictDifferentFloats(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => 3.14159
        };

        var dict2 = {
            "key1" => 3.14160
        };

        Test.assert(!CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with boolean values
    (:test)
    function testCompareDictBooleans(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => true,
            "key2" => false
        };

        var dict2 = {
            "key1" => true,
            "key2" => false
        };

        Test.assert(CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareDict with different boolean values
    (:test)
    function testCompareDictDifferentBooleans(logger as Logger) as Boolean {
        var dict1 = {
            "key1" => true
        };

        var dict2 = {
            "key1" => false
        };

        Test.assert(!CompareDict(dict1, dict2));

        return true;
    }

    // Test CompareArray with identical arrays
    (:test)
    function testCompareArrayIdentical(logger as Logger) as Boolean {
        var arr1 = [1, 2, 3, 4, 5];
        var arr2 = [1, 2, 3, 4, 5];

        Test.assert(CompareArray(arr1, arr2));
        Test.assert(CompareArray(arr2, arr1));

        return true;
    }

    // Test CompareArray with same array (self-comparison)
    (:test)
    function testCompareArraySelf(logger as Logger) as Boolean {
        var arr = [1, 2, 3];

        Test.assert(CompareArray(arr, arr));

        return true;
    }

    // Test CompareArray with empty arrays
    (:test)
    function testCompareArrayEmpty(logger as Logger) as Boolean {
        var arr1 = [];
        var arr2 = [];

        Test.assert(CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with different sizes
    (:test)
    function testCompareArrayDifferentSizes(logger as Logger) as Boolean {
        var arr1 = [1, 2, 3];
        var arr2 = [1, 2, 3, 4];

        Test.assert(!CompareArray(arr1, arr2));
        Test.assert(!CompareArray(arr2, arr1));

        return true;
    }

    // Test CompareArray with different values
    (:test)
    function testCompareArrayDifferentValues(logger as Logger) as Boolean {
        var arr1 = [1, 2, 3];
        var arr2 = [1, 2, 4];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with different order
    (:test)
    function testCompareArrayDifferentOrder(logger as Logger) as Boolean {
        var arr1 = [1, 2, 3];
        var arr2 = [3, 2, 1];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with various types
    (:test)
    function testCompareArrayVariousTypes(logger as Logger) as Boolean {
        var arr1 = [1, "test", 3.14, true, null];
        var arr2 = [1, "test", 3.14, true, null];

        Test.assert(CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with mixed types different
    (:test)
    function testCompareArrayMixedTypesDifferent(logger as Logger) as Boolean {
        var arr1 = [1, "test", 3.14];
        var arr2 = [1, "test", 3.15];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with null elements
    (:test)
    function testCompareArrayNullElements(logger as Logger) as Boolean {
        var arr1 = [1, null, 3];
        var arr2 = [1, null, 3];

        Test.assert(CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with null vs non-null
    (:test)
    function testCompareArrayNullVsNonNull(logger as Logger) as Boolean {
        var arr1 = [1, null, 3];
        var arr2 = [1, 2, 3];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with nested arrays
    (:test)
    function testCompareArrayNested(logger as Logger) as Boolean {
        var arr1 = [1, [2, 3], 4];
        var arr2 = [1, [2, 3], 4];

        Test.assert(CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with different nested arrays
    (:test)
    function testCompareArrayNestedDifferent(logger as Logger) as Boolean {
        var arr1 = [1, [2, 3], 4];
        var arr2 = [1, [2, 4], 4];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with nested dictionaries
    (:test)
    function testCompareArrayNestedDict(logger as Logger) as Boolean {
        var arr1 = [1, {"key" => "value"}, 3];
        var arr2 = [1, {"key" => "value"}, 3];

        Test.assert(CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with different nested dictionaries
    (:test)
    function testCompareArrayNestedDictDifferent(logger as Logger) as Boolean {
        var arr1 = [1, {"key" => "value1"}, 3];
        var arr2 = [1, {"key" => "value2"}, 3];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with float precision
    (:test)
    function testCompareArrayFloatPrecision(logger as Logger) as Boolean {
        var arr1 = [3.14159, 2.71828];
        var arr2 = [3.14159, 2.71828];

        Test.assert(CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with different floats
    (:test)
    function testCompareArrayDifferentFloats(logger as Logger) as Boolean {
        var arr1 = [3.14159];
        var arr2 = [3.14160];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with boolean values
    (:test)
    function testCompareArrayBooleans(logger as Logger) as Boolean {
        var arr1 = [true, false, true];
        var arr2 = [true, false, true];

        Test.assert(CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareArray with different boolean values
    (:test)
    function testCompareArrayDifferentBooleans(logger as Logger) as Boolean {
        var arr1 = [true, false];
        var arr2 = [true, true];

        Test.assert(!CompareArray(arr1, arr2));

        return true;
    }

    // Test CompareValue with null values
    (:test)
    function testCompareValueBothNull(logger as Logger) as Boolean {
        Test.assert(CompareValue(null, null));

        return true;
    }

    // Test CompareValue with one null value
    (:test)
    function testCompareValueOneNull(logger as Logger) as Boolean {
        Test.assert(!CompareValue(null, 42));
        Test.assert(!CompareValue(42, null));

        return true;
    }

    // Test CompareValue with integers
    (:test)
    function testCompareValueIntegers(logger as Logger) as Boolean {
        Test.assert(CompareValue(42, 42));
        Test.assert(!CompareValue(42, 43));

        return true;
    }

    // Test CompareValue with floats
    (:test)
    function testCompareValueFloats(logger as Logger) as Boolean {
        Test.assert(CompareValue(3.14, 3.14));
        Test.assert(!CompareValue(3.14, 3.15));

        return true;
    }

    // Test CompareValue with strings
    (:test)
    function testCompareValueStrings(logger as Logger) as Boolean {
        Test.assert(CompareValue("test", "test"));
        Test.assert(!CompareValue("test", "different"));

        return true;
    }

    // Test CompareValue with booleans
    (:test)
    function testCompareValueBooleans(logger as Logger) as Boolean {
        Test.assert(CompareValue(true, true));
        Test.assert(CompareValue(false, false));
        Test.assert(!CompareValue(true, false));

        return true;
    }

    // Test CompareValue with dictionaries
    (:test)
    function testCompareValueDictionaries(logger as Logger) as Boolean {
        var dict1 = {"key" => "value"};
        var dict2 = {"key" => "value"};
        var dict3 = {"key" => "different"};

        Test.assert(CompareValue(dict1, dict2));
        Test.assert(!CompareValue(dict1, dict3));

        return true;
    }

    // Test CompareValue with arrays
    (:test)
    function testCompareValueArrays(logger as Logger) as Boolean {
        var arr1 = [1, 2, 3];
        var arr2 = [1, 2, 3];
        var arr3 = [1, 2, 4];

        Test.assert(CompareValue(arr1, arr2));
        Test.assert(!CompareValue(arr1, arr3));

        return true;
    }

    // Test CompareValue with nested structures
    (:test)
    function testCompareValueNested(logger as Logger) as Boolean {
        var obj1 = {
            "array" => [1, 2, {"nested" => "value"}],
            "number" => 42
        };
        var obj2 = {
            "array" => [1, 2, {"nested" => "value"}],
            "number" => 42
        };
        var obj3 = {
            "array" => [1, 2, {"nested" => "different"}],
            "number" => 42
        };

        Test.assert(CompareValue(obj1, obj2));
        Test.assert(!CompareValue(obj1, obj3));

        return true;
    }

    // Test CompareValue with different types
    (:test)
    function testCompareValueDifferentTypes(logger as Logger) as Boolean {
        Test.assert(!CompareValue(42, "42"));
        Test.assert(!CompareValue(1, true));
        Test.assert(!CompareValue(0, false));

        return true;
    }

    // Test CompareValue with empty structures
    (:test)
    function testCompareValueEmptyStructures(logger as Logger) as Boolean {
        Test.assert(CompareValue([], []));
        Test.assert(CompareValue({}, {}));
        Test.assert(!CompareValue([], {}));

        return true;
    }
}
