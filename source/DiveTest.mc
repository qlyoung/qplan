import Toybox.Lang;
import Toybox.Test;
import Toybox.System;
import Toybox.Math;

(:test)
module DiveTest {

    // Test metric defaults
    (:test)
    function testMetricDefaults(logger as Logger) as Boolean {
        var dive = Dive.Default();
        dive.setMetricDefaults();

        Test.assertEqual(dive.getSCR(), 20.0);
        Test.assertEqual(dive.getBottomDepth(), 30.0);
        Test.assertEqual(dive.getContingencySCRMultiplier(), 2.0);
        Test.assertEqual(dive.getSwitchDepth(), 6.0);
        Test.assertEqual(dive.getProblemSolvingTime(), 120);
        Test.assertEqual(dive.getGasSwitchTime(), 60);
        Test.assertEqual(dive.getAscentRate(), 3.0);

        // Contingency SCR should default to -1, which means use main SCR
        Test.assertEqual(dive.getContingencySCR(), 20.0);

        // Cylinder should be initialized from first tank in resources
        var cylinder = dive.getCylinder();
        Test.assert(cylinder != null);
        Test.assert(cylinder.getTypeName() != "");

        return true;
    }

    // Test imperial defaults
    (:test)
    function testImperialDefaults(logger as Logger) as Boolean {
        var dive = Dive.Default();
        dive.setImperialDefaults();

        // SCR should be converted from 0.7 cf/min to liters/min
        var expectedSCR = Units.Convert.CubicFeetToLiters(0.7);
        Test.assertEqual(dive.getSCR(), expectedSCR);

        // Bottom depth should be converted from 100 ft to meters
        var expectedDepth = Units.Convert.FeetToMeters(100.0);
        Test.assertEqual(dive.getBottomDepth(), expectedDepth);

        Test.assertEqual(dive.getContingencySCRMultiplier(), 2.0);

        // Switch depth should be converted from 20 ft to meters
        var expectedSwitchDepth = Units.Convert.FeetToMeters(20.0);
        Test.assertEqual(dive.getSwitchDepth(), expectedSwitchDepth);

        Test.assertEqual(dive.getProblemSolvingTime(), 120);
        Test.assertEqual(dive.getGasSwitchTime(), 60);

        // Ascent rate should be converted from 10 ft/min to m/min
        var expectedAscentRate = Units.Convert.FeetToMeters(10.0);
        Test.assertEqual(dive.getAscentRate(), expectedAscentRate);

        return true;
    }

    // Test SCR getter and setter
    (:test)
    function testSCRGetterSetter(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSCR(25.0);
        Test.assertEqual(dive.getSCR(), 25.0);

        dive.setSCR(15.5);
        Test.assertEqual(dive.getSCR(), 15.5);

        return true;
    }

    // Test bottom depth getter and setter
    (:test)
    function testBottomDepthGetterSetter(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setBottomDepth(40.0);
        Test.assertEqual(dive.getBottomDepth(), 40.0);

        dive.setBottomDepth(18.5);
        Test.assertEqual(dive.getBottomDepth(), 18.5);

        return true;
    }

    // Test cylinder getter and setter with Cylinder object
    (:test)
    function testCylinderGetterSetterWithObject(logger as Logger) as Boolean {
        var dive = Dive.Default();

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "Test Cylinder",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 12.0
        });

        dive.setCylinder(cylinder);
        var retrievedCylinder = dive.getCylinder();

        Test.assertEqual(retrievedCylinder.getTypeName(), "Test Cylinder");
        Test.assertEqual(retrievedCylinder.getServicePressure(), 200.0);
        Test.assertEqual(retrievedCylinder.getWaterCapacity(), 12.0);

        return true;
    }

    // Test cylinder setter with Dictionary
    (:test)
    function testCylinderSetterWithDictionary(logger as Logger) as Boolean {
        var dive = Dive.Default();

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "15L 200bar",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 15.0
        });

        dive.setCylinder(cylinder);
        var retrievedCylinder = dive.getCylinder();

        Test.assertEqual(retrievedCylinder.getTypeName(), "15L 200bar");
        Test.assertEqual(retrievedCylinder.getServicePressure(), 200.0);
        Test.assertEqual(retrievedCylinder.getWaterCapacity(), 15.0);

        return true;
    }

    // Test contingency SCR multiplier getter and setter
    (:test)
    function testContingencySCRMultiplierGetterSetter(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setContingencySCRMultiplier(2.5);
        Test.assertEqual(dive.getContingencySCRMultiplier(), 2.5);

        dive.setContingencySCRMultiplier(1.0);
        Test.assertEqual(dive.getContingencySCRMultiplier(), 1.0);

        return true;
    }

    // Test switch depth getter and setter
    (:test)
    function testSwitchDepthGetterSetter(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSwitchDepth(9.0);
        Test.assertEqual(dive.getSwitchDepth(), 9.0);

        dive.setSwitchDepth(5.5);
        Test.assertEqual(dive.getSwitchDepth(), 5.5);

        return true;
    }

    // Test problem solving time getter and setter
    (:test)
    function testProblemSolvingTimeGetterSetter(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setProblemSolvingTime(180);
        Test.assertEqual(dive.getProblemSolvingTime(), 180);

        dive.setProblemSolvingTime(90);
        Test.assertEqual(dive.getProblemSolvingTime(), 90);

        return true;
    }

    // Test gas switch time getter and setter
    (:test)
    function testGasSwitchTimeGetterSetter(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setGasSwitchTime(90);
        Test.assertEqual(dive.getGasSwitchTime(), 90);

        dive.setGasSwitchTime(30);
        Test.assertEqual(dive.getGasSwitchTime(), 30);

        return true;
    }

    // Test ascent rate getter and setter
    (:test)
    function testAscentRateGetterSetter(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setAscentRate(5.0);
        Test.assertEqual(dive.getAscentRate(), 5.0);

        dive.setAscentRate(10.0);
        Test.assertEqual(dive.getAscentRate(), 10.0);

        return true;
    }

    // Test contingency SCR defaults to main SCR when set to -1
    (:test)
    function testContingencySCRDefaultsToMainSCR(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSCR(20.0);
        dive.setContingencySCR(-1.0);

        Test.assertEqual(dive.getContingencySCR(), 20.0);

        // Change main SCR and verify contingency SCR follows
        dive.setSCR(25.0);
        Test.assertEqual(dive.getContingencySCR(), 25.0);

        return true;
    }

    // Test contingency SCR can be set independently
    (:test)
    function testContingencySCRIndependent(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSCR(20.0);
        dive.setContingencySCR(40.0);

        Test.assertEqual(dive.getSCR(), 20.0);
        Test.assertEqual(dive.getContingencySCR(), 40.0);

        // Change main SCR and verify contingency SCR stays independent
        dive.setSCR(25.0);
        Test.assertEqual(dive.getContingencySCR(), 40.0);

        return true;
    }

    // Check that dependent values are correct relative to their independent
    // values in the dict. This only tests that the products are correctly
    // computed, not that the values are actually correct.
    function verifyMinGasInternalConsistency(minGas as Dictionary, dive as Dive, cylinder as Cylinder) as Boolean {
        var avgPressure = minGas["avg_pressure"];
        if (!(avgPressure instanceof Float)) {
            return false;
        }

        var consumption = minGas["consumption"];
        if (!(consumption instanceof Float)) {
            return false;
        }

        var totalTime = minGas["total_time"];
        if (!(totalTime instanceof Number)) {
            return false;
        }

        var minGasVolume = minGas["min_gas_volume"];
        if (!(minGasVolume instanceof Float)) {
            return false;
        }

        var minGasPressure = minGas["min_gas_pressure"];
        if (!(minGasPressure instanceof Float)) {
            return false;
        }

        // Verify min gas volume calculation
        // C = consumption
        // A = avg pressure
        // T = time
        var ev = (consumption/60.0) * avgPressure * totalTime;
        if (!CloseEnough(minGasVolume, ev, 0.01)) {
            return false;
        }

        // Verify pressure is correct
        ev = cylinder.volumeToPressure(minGasVolume);
        if (!CloseEnough(minGasPressure, ev, 0.01)) {
            return false;
        }

        return true;
    }

    // Test basic min gas calculation
    (:test)
    function testMinGasBasicCalculation(logger as Logger) as Boolean {
        var dive = Dive.Default();

        // Set up a simple scenario
        dive.setSCR(20.0);
        dive.setBottomDepth(30.0);
        dive.setContingencySCRMultiplier(2.0);
        dive.setContingencySCR(-1.0);
        dive.setSwitchDepth(6.0);
        dive.setProblemSolvingTime(120);
        dive.setGasSwitchTime(60);
        dive.setAscentRate(3.0);

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });
        dive.setCylinder(cylinder);

        var result = dive.calculateMinGas();

        Test.assert(verifyMinGasInternalConsistency(result as Dictionary, dive, cylinder));

        // Verify all expected keys are present
        Test.assert(result.hasKey("min_gas_volume"));
        Test.assert(result.hasKey("min_gas_pressure"));
        Test.assert(result.hasKey("consumption"));
        Test.assert(result.hasKey("avg_pressure"));
        Test.assert(result.hasKey("avg_depth"));
        Test.assert(result.hasKey("ascent_time"));
        Test.assert(result.hasKey("total_time"));

        // Verify consumption calculation
        // consumption = SCR * multiplier = 20 * 2 = 40 l/min
        var consumption = result["consumption"];
        if (!(consumption instanceof Float)) {
            return false;
        }
        Test.assertEqual(consumption, 40.0);

        // Verify average depth calculation
        // avg_depth = (bottom_depth + switch_depth) / 2 = (30 + 6) / 2 = 18m
        var avgDepth = result["avg_depth"];
        if (!(avgDepth instanceof Float)) {
            return false;
        }
        Test.assertEqual(avgDepth, 18.0);

        // Verify average pressure calculation
        // avg_pressure = (18 / 10) + 1 = 2.8 bar
        var avgPressure = result["avg_pressure"];
        if (!(avgPressure instanceof Float)) {
            return false;
        }
        Test.assert(CloseEnough(avgPressure, 2.8, .001));

        // Verify ascent time calculation
        // ascent_time = ((30 - 6) / 3)*60 = 480
        var ascentTime = result["ascent_time"];
        if (!(ascentTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(ascentTime, 480);

        // Verify total time calculation (rounded up to nearest minute)
        // total_time = problem_solving_time + ascent_time + gas_switch_time
        // = 120 + 480 + 60 = 660 seconds = 11 minutes (already a whole minute)
        var totalTime = result["total_time"];
        if (!(totalTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(totalTime, 660);

        // Verify min gas volume calculation
        // C = consumption
        // A = avg pressure
        // T = time
        // = (40/60) * 2.8 * 660 = 0.6667 * 2.8 * 660 = 1232 liters
        var minGasVolume = result["min_gas_volume"];
        if (!(minGasVolume instanceof Float)) {
            return false;
        }
        Test.assert(CloseEnough(minGasVolume, 1232.0, 0.01));

        // Verify min gas pressure
        // 1232l / 12l ~= 102.67
        var minGasPressure = result["min_gas_pressure"];
        if (!(minGasPressure instanceof Float)) {
            return false;
        }
        Test.assert(CloseEnough(minGasPressure, 102.67, 0.01));

        return true;
    }

    // Test min gas calculation with different contingency SCR
    (:test)
    function testMinGasCalculationWithDifferentContingencySCR(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSCR(20.0);
        // Different from main SCR
        dive.setContingencySCR(40.0);
        dive.setBottomDepth(30.0);
        // Solo, but higher contingency SCR
        dive.setContingencySCRMultiplier(1.0);
        dive.setSwitchDepth(6.0);
        dive.setProblemSolvingTime(120);
        dive.setGasSwitchTime(60);
        dive.setAscentRate(3.0);

        var cyl = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });
        dive.setCylinder(cyl);

        var result = dive.calculateMinGas();

        Test.assert(verifyMinGasInternalConsistency(result as Dictionary, dive, cyl));

        // consumption should use contingency SCR
        // consumption = contingency_scr * multiplier = 40 * 1 = 40 l/min
        var consumption = result["consumption"];
        if (!(consumption instanceof Float)) {
            return false;
        }
        Test.assertEqual(consumption, 40.0);

        return true;
    }

    // Test min gas calculation rounds total time up to nearest minute
    (:test)
    function testMinGasRoundsTimeUpConservatively(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSCR(20.0);
        dive.setBottomDepth(30.0);
        dive.setContingencySCRMultiplier(2.0);
        dive.setContingencySCR(-1.0);
        dive.setSwitchDepth(6.0);
        // 125 seconds = 2 min 5 sec
        dive.setProblemSolvingTime(125);
        dive.setGasSwitchTime(60);
        dive.setAscentRate(3.0);

        var cyl = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });
        dive.setCylinder(cyl);

        var result = dive.calculateMinGas();

        Test.assert(verifyMinGasInternalConsistency(result as Dictionary, dive, cyl));

        // total_time before rounding = 125 + 480 + 60 = 665 s ~= 11.08 min
        // Should round up to 720 seconds (12 minutes)
        var totalTime = result["total_time"];
        if (!(totalTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(totalTime, 720);

        return true;
    }

    // Test min gas calculation with deep dive
    (:test)
    function testMinGasCalculationDeepDive(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSCR(25.0);
        dive.setBottomDepth(60.0);
        dive.setContingencySCRMultiplier(2.0);
        dive.setContingencySCR(-1.0);
        dive.setSwitchDepth(21.0);
        dive.setProblemSolvingTime(180);
        dive.setGasSwitchTime(60);
        dive.setAscentRate(3.0);

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "15L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 15.0
        });
        dive.setCylinder(cylinder);

        var result = dive.calculateMinGas();

        Test.assert(verifyMinGasInternalConsistency(result as Dictionary, dive, cylinder));

        // Average depth should be (60 + 21) / 2 = 40.5m
        var avgDepth = result["avg_depth"];
        if (!(avgDepth instanceof Float)) {
            return false;
        }
        Test.assertEqual(avgDepth, 40.5);

        // Average pressure should be (40.5 / 10) + 1 = 5.05 bar
        var avgPressure = result["avg_pressure"];
        if (!(avgPressure instanceof Float)) {
            return false;
        }
        Test.assertEqual(avgPressure, 5.05);

        // Ascent time = 60 * (60 - 21) / 3 = 39 / 0.05 = 780 seconds
        var ascentTime = result["ascent_time"];
        if (!(ascentTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(ascentTime, 780);

        return true;
    }

    // Test min gas calculation with shallow dive
    (:test)
    function testMinGasCalculationShallowDive(logger as Logger) as Boolean {
        var dive = Dive.Default();

        dive.setSCR(15.0);
        dive.setBottomDepth(18.0);  // Shallow dive
        dive.setContingencySCRMultiplier(2.0);
        dive.setContingencySCR(-1.0);
        dive.setSwitchDepth(5.0);
        dive.setProblemSolvingTime(60);
        dive.setGasSwitchTime(30);
        dive.setAscentRate(3.0);

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "10L 200bar",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 10.0
        });
        dive.setCylinder(cylinder);

        var result = dive.calculateMinGas();

        Test.assert(verifyMinGasInternalConsistency(result as Dictionary, dive, cylinder));

        // Average depth should be (18 + 5) / 2 = 11.5m
        var avgDepth = result["avg_depth"];
        if (!(avgDepth instanceof Float)) {
            return false;
        }
        Test.assertEqual(avgDepth, 11.5);

        // Average pressure should be (11.5 / 10) + 1 = 2.15 bar
        var avgPressure = result["avg_pressure"];
        if (!(avgPressure instanceof Float)) {
            return false;
        }
        Test.assertEqual(avgPressure, 2.15);

        return true;
    }

    // Test calculation precision is maintained
    (:test)
    function testMinGasPrecision(logger as Logger) as Boolean {
        var dive = Dive.Default();

        // Use non-round numbers to test precision
        dive.setSCR(22.7);
        dive.setBottomDepth(33.3);
        dive.setContingencySCRMultiplier(1.8);
        dive.setContingencySCR(-1.0);
        dive.setSwitchDepth(7.2);
        dive.setProblemSolvingTime(135);
        dive.setGasSwitchTime(55);
        dive.setAscentRate(3.3);

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "11.1L 237bar",
            "unit_type" => "metric",
            "service_pressure" => 237,
            "water_capacity" => 11.1
        });
        dive.setCylinder(cylinder);

        var result = dive.calculateMinGas();

        // Verify calculations maintain precision
        var avgDepth = result["avg_depth"];
        if (!(avgDepth instanceof Float)) {
            return false;
        }
        var expectedAvgDepth = (33.3 + 7.2) / 2.0;
        Test.assert(CloseEnough(avgDepth, expectedAvgDepth, 0.001));

        var consumption = result["consumption"];
        if (!(consumption instanceof Float)) {
            return false;
        }
        var expectedConsumption = 22.7 * 1.8;
        Test.assert(CloseEnough(consumption, expectedConsumption, 0.001));

        return true;
    }

    // Test edge case: solo diver (multiplier = 1.0)
    (:test)
    function testMinGasSolo(logger as Logger) as Boolean {
        var dive = Dive.Default();
        dive.setMetricDefaults();
        dive.setContingencySCRMultiplier(1.0);

        var result = dive.calculateMinGas();

        // Consumption should be SCR * 1.0
        var consumption = result["consumption"];
        if (!(consumption instanceof Float)) {
            return false;
        }
        Test.assertEqual(consumption, 20.0);

        return true;
    }

    // Test edge case: zero problem solving time
    (:test)
    function testMinGasZeroProblemSolving(logger as Logger) as Boolean {
        var dive = Dive.Default();
        dive.setMetricDefaults();
        dive.setProblemSolvingTime(0);

        var result = dive.calculateMinGas();

        // Total time should be ascent time + gas switch time
        var ascentTime = result["ascent_time"];
        if (!(ascentTime instanceof Number)) {
            return false;
        }
        var totalTime = result["total_time"];
        if (!(totalTime instanceof Number)) {
            return false;
        }

        var ev = ascentTime + dive.getGasSwitchTime();
        Test.assertEqual(totalTime, ev);

        return true;
    }

    // Test edge case: bottom depth equals switch depth
    (:test)
    function testMinGasBottomDepthEqualsSwitchDepth(logger as Logger) as Boolean {
        var dive = Dive.Default();
        dive.setMetricDefaults();
        dive.setBottomDepth(6.0);
        dive.setSwitchDepth(6.0);

        var result = dive.calculateMinGas();

        // Average depth should equal both depths
        var avgDepth = result["avg_depth"];
        if (!(avgDepth instanceof Float)) {
            return false;
        }
        Test.assertEqual(avgDepth, 6.0);

        // Ascent time should be 0
        var ascentTime = result["ascent_time"];
        if (!(ascentTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(ascentTime, 0);

        // Total time should be problem solving time + switch time
        var totalTime = result["total_time"];
        if (!(totalTime instanceof Number)) {
            return false;
        }
        var ev = dive.getProblemSolvingTime() + dive.getGasSwitchTime();
        Test.assertEqual(totalTime, ev);

        // Should still have reasonable gas requirement due to problem solving time
        var minGasVolume = result["min_gas_volume"];
        if (!(minGasVolume instanceof Float)) {
            return false;
        }
        Test.assert(minGasVolume > 0.0);

        return true;
    }

    // Test that min gas calculation uses cylinder's volumeToPressure correctly
    (:test)
    function testMinGasUsesCylinderVolumeConversion(logger as Logger) as Boolean {
        var dive = Dive.Default();
        dive.setMetricDefaults();

        // Use a different cylinder
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "15L 200bar",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 15.0
        });
        dive.setCylinder(cylinder);

        var result = dive.calculateMinGas();

        var minGasVolume = result["min_gas_volume"];
        if (!(minGasVolume instanceof Float)) {
            return false;
        }
        var minGasPressure = result["min_gas_pressure"];
        if (!(minGasPressure instanceof Float)) {
            return false;
        }

        // Manually verify the conversion
        var expectedPressure = cylinder.volumeToPressure(minGasVolume);

        Test.assertEqual(minGasPressure, expectedPressure);

        return true;
    }

    // Test ascent time is computed with ceiling
    (:test)
    function testMinGasAscentTimeCeilingConservative(logger as Logger) as Boolean {
        var dive = Dive.Default();

        // Set up scenario where ascent time is not a whole number
        dive.setSCR(20.0);
        dive.setBottomDepth(25.0);
        dive.setContingencySCRMultiplier(2.0);
        dive.setContingencySCR(-1.0);
        dive.setSwitchDepth(6.0);
        dive.setProblemSolvingTime(120);
        dive.setGasSwitchTime(60);
        dive.setAscentRate(4.3);

        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });
        dive.setCylinder(cylinder);

        var result = dive.calculateMinGas();

        // Ascent time = 60 * ((25 - 6) / 4) ~= 265.12 s
        // Should be ceiled to next second
        var ascentTime = result["ascent_time"];
        if (!(ascentTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(ascentTime, 266);

        return true;
    }

    // Test dictionary serialization - toDictionary
    (:test)
    function testToDictionary(logger as Logger) as Boolean {
        var dive = Dive.Default();
        dive.setMetricDefaults();

        var dict = dive.toDictionary();

        Test.assert(dict.hasKey("scr"));
        Test.assert(dict.hasKey("bottom_depth"));
        Test.assert(dict.hasKey("cylinder"));
        Test.assert(dict.hasKey("contingency_scr"));
        Test.assert(dict.hasKey("contingency_scr_multiplier"));
        Test.assert(dict.hasKey("switch_depth"));
        Test.assert(dict.hasKey("problem_solving_time"));
        Test.assert(dict.hasKey("gas_switch_time"));
        Test.assert(dict.hasKey("ascent_rate"));

        var scr = dict["scr"];
        if (!(scr instanceof Float)) {
            return false;
        }
        Test.assertEqual(scr, 20.0);

        var bottomDepth = dict["bottom_depth"];
        if (!(bottomDepth instanceof Float)) {
            return false;
        }
        Test.assertEqual(bottomDepth, 30.0);

        var contingencySCR = dict["contingency_scr"];
        if (!(contingencySCR instanceof Float)) {
            return false;
        }
        Test.assertEqual(contingencySCR, -1.0);

        var contingencySCRMultiplier = dict["contingency_scr_multiplier"];
        if (!(contingencySCRMultiplier instanceof Float)) {
            return false;
        }
        Test.assertEqual(contingencySCRMultiplier, 2.0);

        var switchDepth = dict["switch_depth"];
        if (!(switchDepth instanceof Float)) {
            return false;
        }
        Test.assertEqual(switchDepth, 6.0);

        var problemSolvingTime = dict["problem_solving_time"];
        if (!(problemSolvingTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(problemSolvingTime, 120);

        var gasSwitchTime = dict["gas_switch_time"];
        if (!(gasSwitchTime instanceof Number)) {
            return false;
        }
        Test.assertEqual(gasSwitchTime, 60);

        var ascentRate = dict["ascent_rate"];
        if (!(ascentRate instanceof Float)) {
            return false;
        }
        Test.assertEqual(ascentRate, 3.0);

        // Cylinder should be included as a dictionary
        var cylinderData = dict["cylinder"];
        if (!(cylinderData instanceof Dictionary)) {
            return false;
        }

        return true;
    }

    // Test dictionary serialization - fromDictionary
    (:test)
    function testFromDictionary(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var diveData = {
            "scr" => 25.0,
            "bottom_depth" => 40.0,
            "cylinder" => cylinder.toDictionary(),
            "contingency_scr" => 50.0,
            "contingency_scr_multiplier" => 1.5,
            "switch_depth" => 9.0,
            "problem_solving_time" => 180,
            "gas_switch_time" => 90,
            "ascent_rate" => 5.0
        };

        var dive = Dive.fromDictionary(diveData);

        Test.assertEqual(dive.getSCR(), 25.0);
        Test.assertEqual(dive.getBottomDepth(), 40.0);
        Test.assertEqual(dive.getContingencySCR(), 50.0);
        Test.assertEqual(dive.getContingencySCRMultiplier(), 1.5);
        Test.assertEqual(dive.getSwitchDepth(), 9.0);
        Test.assertEqual(dive.getProblemSolvingTime(), 180);
        Test.assertEqual(dive.getGasSwitchTime(), 90);
        Test.assertEqual(dive.getAscentRate(), 5.0);
        Test.assertEqual(dive.getCylinder(), cylinder);

        return true;
    }

    // Test serialization round trip - dict -> dive1 -> dict -> dive2 && dive1 == dive2
    (:test)
    function testDictionaryRoundTrip(logger as Logger) as Boolean {
        var dive1 = Dive.Default();
        dive1.setMetricDefaults();
        dive1.setSCR(22.5);
        dive1.setBottomDepth(35.0);

        var dive2 = Dive.fromDictionary(dive1.toDictionary());

        Test.assertEqual(dive1, dive2);

        return true;
    }

}
