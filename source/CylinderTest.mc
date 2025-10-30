import Toybox.Lang;
import Toybox.Test;
import Toybox.System;

(:test)
module CylinderTest {

    // Test metric cylinder initialization - standard 12L 232 bar
    (:test)
    function testMetricCylinderInitialization(logger as Logger) as Boolean {
        var cylinderData = {
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        };

        var cylinder = Cylinder.fromDictionaryPresentation(cylinderData);

        Test.assertEqual(cylinder.getTypeName(), "12L 232bar");
        Test.assertEqual(cylinder.getUnitType(), Units.METRIC);
        Test.assertEqual(cylinder.getServicePressure(), 232.0);
        Test.assertEqual(cylinder.getWaterCapacity(), 12.0);

        // Nominal capacity should be service_pressure * water_capacity
        // 232 bar * 12 L = 2784 L
        Test.assertEqualMessage(
            cylinder.getNominalCapacity(),
            2784.0,
            "Nominal capacity should be service_pressure * water_capacity"
        );

        Test.assert(cylinder.isMetric());
        Test.assert(!cylinder.isStandard());

        return true;
    }

    // Test metric cylinder with different sizes
    (:test)
    function testMetricCylinderVariousSizes(logger as Logger) as Boolean {
        // Test 15L 200 bar
        var cylinder15L = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "15L 200bar",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 15.0
        });

        Test.assertEqual(cylinder15L.getNominalCapacity(), 3000.0);

        // Test 10L 300 bar
        var cylinder10L = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "10L 300bar",
            "unit_type" => "metric",
            "service_pressure" => 300,
            "water_capacity" => 10.0
        });

        Test.assertEqual(cylinder10L.getNominalCapacity(), 3000.0);

        return true;
    }

    // Test imperial cylinder initialization - AL80
    (:test)
    function testImperialCylinderInitialization(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "AL80",
            "unit_type" => "imperial",
            "service_pressure" => 3000,
            "nominal_capacity" => 80.0
        });

        Test.assertEqual(cylinder.getTypeName(), "AL80");
        Test.assertEqual(cylinder.getUnitType(), Units.IMPERIAL);

        // Service pressure should be converted from PSI to bar
        var expectedServicePressureBar = Units.Convert.PsiToBar(3000);
        Test.assertEqualMessage(
            cylinder.getServicePressure(),
            expectedServicePressureBar,
            "Service pressure should be converted to bar"
        );

        // Nominal capacity should be converted from cubic feet to liters
        var expectedNominalCapacityL = Units.Convert.CubicFeetToLiters(80.0);
        Test.assertEqualMessage(
            cylinder.getNominalCapacity(),
            expectedNominalCapacityL,
            "Nominal capacity should be converted to liters"
        );

        // Water capacity = nominal capacity / service pressure
        var expectedWaterCapacity = expectedNominalCapacityL / expectedServicePressureBar;
        Test.assertEqualMessage(
            cylinder.getWaterCapacity(),
            expectedWaterCapacity,
            "Water capacity should be calculated from nominal capacity and service pressure"
        );

        Test.assert(!cylinder.isMetric());
        Test.assert(cylinder.isStandard());

        return true;
    }

    // Test imperial cylinder - HP100
    (:test)
    function testImperialHP100Cylinder(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "HP100",
            "unit_type" => "imperial",
            "service_pressure" => 3442,
            "nominal_capacity" => 100.0
        });

        Test.assertEqual(cylinder.getTypeName(), "HP100");

        var expectedServicePressureBar = Units.Convert.PsiToBar(3442);
        Test.assertEqual(cylinder.getServicePressure(), expectedServicePressureBar);

        var expectedNominalCapacityL = Units.Convert.CubicFeetToLiters(100.0);
        Test.assertEqual(cylinder.getNominalCapacity(), expectedNominalCapacityL);

        return true;
    }

    // Test getter methods consistency
    (:test)
    function testGetterMethods(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "Test Cylinder",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 15.0
        });


        // Test getTypeName
        Test.assertEqual(cylinder.getTypeName(), "Test Cylinder");

        // Test getUnitType
        Test.assertEqual(cylinder.getUnitType(), Units.METRIC);

        // Test getServicePressure
        Test.assertEqual(cylinder.getServicePressure(), 200.0);

        // Test getWaterCapacity
        Test.assertEqual(cylinder.getWaterCapacity(), 15.0);

        // Test getNominalCapacity
        Test.assertEqual(cylinder.getNominalCapacity(), 3000.0);

        return true;
    }

    // Test volumeToPressure calculation
    (:test)
    function testVolumeToPressure(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });


        // If we have the full nominal capacity (2784L), pressure should be service pressure
        var fullPressure = cylinder.volumeToPressure(2784.0);
        Test.assertEqualMessage(
            fullPressure,
            232.0,
            "Full volume should give service pressure"
        );

        // If we have half the nominal capacity (1392L), pressure should be half service pressure
        var halfPressure = cylinder.volumeToPressure(1392.0);
        Test.assertEqualMessage(
            halfPressure,
            116.0,
            "Half volume should give half service pressure"
        );

        // If we have quarter nominal capacity (696L), pressure should be quarter service pressure
        var quarterPressure = cylinder.volumeToPressure(696.0);
        Test.assertEqualMessage(
            quarterPressure,
            58.0,
            "Quarter volume should give quarter service pressure"
        );

        // Test with zero volume
        var zeroPressure = cylinder.volumeToPressure(0.0);
        Test.assertEqual(zeroPressure, 0.0);

        return true;
    }

    // Test volumeToPressure with imperial cylinder
    (:test)
    function testVolumeToPressureImperial(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "AL80",
            "unit_type" => "imperial",
            "service_pressure" => 3000,
            "nominal_capacity" => 80.0
        });


        var nominalCapacity = cylinder.getNominalCapacity();
        var servicePressure = cylinder.getServicePressure();

        // Full nominal capacity should give service pressure
        var fullPressure = cylinder.volumeToPressure(nominalCapacity);
        Test.assertEqualMessage(
            fullPressure,
            servicePressure,
            "Full nominal capacity should give service pressure"
        );

        // Half nominal capacity should give half service pressure
        var halfPressure = cylinder.volumeToPressure(nominalCapacity / 2.0);
        var expectedHalfPressure = servicePressure / 2.0;
        Test.assertEqualMessage(
            halfPressure,
            expectedHalfPressure,
            "Half nominal capacity should give half service pressure"
        );

        return true;
    }

    // Test isMetric and isStandard methods
    (:test)
    function testUnitTypeChecks(logger as Logger) as Boolean {

        // Test metric cylinder
        var metricCylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        Test.assert(metricCylinder.isMetric());
        Test.assert(!metricCylinder.isStandard());

        // Test imperial cylinder
        var imperialCylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "AL80",
            "unit_type" => "imperial",
            "service_pressure" => 3000,
            "nominal_capacity" => 80.0
        });

        Test.assert(!imperialCylinder.isMetric());
        Test.assert(imperialCylinder.isStandard());

        return true;
    }

    // Test precision in calculations
    (:test)
    function testCalculationPrecision(logger as Logger) as Boolean {

        // Test that calculations maintain precision (no premature rounding)
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "Test",
            "unit_type" => "metric",
            "service_pressure" => 237,
            "water_capacity" => 11.1
        });

        // Nominal capacity should be exactly 237 * 11.1 = 2630.7
        // Floating point error should be less than 0.001
        Test.assertEqual(cylinder.getServicePressure(), 237.0);
        Test.assertEqual(cylinder.getWaterCapacity(), 11.1);
        var nomcap = cylinder.getNominalCapacity();
        Test.assert(CloseEnough(nomcap, 2630.7, 0.001));

        // volumeToPressure should also maintain precision
        // Exact value should be 118.5
        var pressure = cylinder.volumeToPressure(1315.35);
        Test.assert(CloseEnough(pressure, 118.5, 0.001));

        return true;
    }

    // Test edge case: very small water capacity
    (:test)
    function testSmallWaterCapacity(logger as Logger) as Boolean {

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "Pony",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 3.0
        });

        Test.assertEqual(cylinder.getNominalCapacity(), 600.0);
        Test.assertEqual(cylinder.volumeToPressure(600.0), 200.0);
        Test.assertEqual(cylinder.volumeToPressure(300.0), 100.0);

        return true;
    }

    // Test edge case: very high pressure
    (:test)
    function testHighPressureCylinder(logger as Logger) as Boolean {

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "300bar",
            "unit_type" => "metric",
            "service_pressure" => 300,
            "water_capacity" => 10.0
        });


        Test.assertEqual(cylinder.getServicePressure(), 300.0);
        Test.assertEqual(cylinder.getNominalCapacity(), 3000.0);

        return true;
    }

    // Test dictionary round-trip - metric - dict -> cyl1 -> dict -> cyl2 yields cyl1 == cyl2
    (:test)
    function testDictionaryRoundTripMetric(logger as Logger) as Boolean {

        var originalData = {
            "cylinder_type_name" => "RoundTrip",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        };

        var cylinder = Cylinder.fromDictionaryPresentation(originalData);
        var retrievedData = cylinder.toDictionary();
        var cylinder2 = Cylinder.fromDictionary(retrievedData);

        // Dicts should compare equal
        Test.assertEqual(cylinder, cylinder2);

        return true;
    }

    // Test dictionary round-trip - imperial - dict -> cyl1 -> dict -> cyl2 yields cyl1 == cyl2
    (:test)
    function testDictionaryRoundTripImperial(logger as Logger) as Boolean {

        var originalData = {
            "cylinder_type_name" => "AL80 RoundTrip",
            "unit_type" => "imperial",
            "service_pressure" => 3000,
            "nominal_capacity" => 80.0
        };

        var cylinder = Cylinder.fromDictionaryPresentation(originalData);
        var retrievedData = cylinder.toDictionary();
        var cylinder2 = Cylinder.fromDictionary(retrievedData);

        // Dicts should compare equal
        Test.assertEqual(cylinder, cylinder2);

        return true;
    }

    // Test conversion accuracy for common imperial cylinders
    (:test)
    function testImperialConversionAccuracy(logger as Logger) as Boolean {

        // AL80: 3000 PSI, 80 cf
        var al80 = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "AL80",
            "unit_type" => "imperial",
            "service_pressure" => 3000,
            "nominal_capacity" => 80.0
        });

        var al80ServicePressure = Units.Convert.PsiToBar(3000);
        var al80NominalCapacity = Units.Convert.CubicFeetToLiters(80.0);

        Test.assertEqual(al80.getServicePressure(), al80ServicePressure);
        Test.assertEqual(al80.getNominalCapacity(), al80NominalCapacity);

        // HP100: 3442 PSI, 100 cf
        var hp100 = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "HP100",
            "unit_type" => "imperial",
            "service_pressure" => 3442,
            "nominal_capacity" => 100.0
        });

        var hp100ServicePressure = Units.Convert.PsiToBar(3442);
        var hp100NominalCapacity = Units.Convert.CubicFeetToLiters(100.0);

        Test.assertEqual(hp100.getServicePressure(), hp100ServicePressure);
        Test.assertEqual(hp100.getNominalCapacity(), hp100NominalCapacity);

        return true;
    }

    // Test that water capacity is correctly calculated for imperial cylinders
    (:test)
    function testImperialWaterCapacityCalculation(logger as Logger) as Boolean {

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "Test Imperial",
            "unit_type" => "imperial",
            "service_pressure" => 3000,
            "nominal_capacity" => 80.0
        });

        // Water capacity should be nominal capacity / service pressure
        var expectedWaterCapacity = cylinder.getNominalCapacity() / cylinder.getServicePressure();

        Test.assertEqualMessage(
            cylinder.getWaterCapacity(),
            expectedWaterCapacity,
            "Water capacity should equal nominal capacity divided by service pressure"
        );

        return true;
    }
}
