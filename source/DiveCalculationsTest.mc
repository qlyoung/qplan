import Toybox.Lang;
import Toybox.Test;
import Toybox.System;

import Constants;

(:test)
module DiveCalculationsTest {

    // ========================================================================
    // Tests for CalculateAmbientP
    // ========================================================================

    // Test ambient pressure at surface
    (:test)
    function testCalculateAmbientPAtSurface(logger as Logger) as Boolean {
        var ambientP = DiveCalculations.CalculateAmbientP(0.0);

        // At surface (0m), pressure should be 1 bar
        Test.assertEqual(ambientP, 1.0);

        return true;
    }

    // Test ambient pressure at 10m
    (:test)
    function testCalculateAmbientPAt10m(logger as Logger) as Boolean {
        var ambientP = DiveCalculations.CalculateAmbientP(10.0);

        // At 10m, pressure should be 2 bar (10/10 + 1)
        Test.assertEqual(ambientP, 2.0);

        return true;
    }

    // Test ambient pressure at 30m
    (:test)
    function testCalculateAmbientPAt30m(logger as Logger) as Boolean {
        var ambientP = DiveCalculations.CalculateAmbientP(30.0);

        // At 30m, pressure should be 4 bar (30/10 + 1)
        Test.assertEqual(ambientP, 4.0);

        return true;
    }

    // Test ambient pressure at various depths
    (:test)
    function testCalculateAmbientPVariousDepths(logger as Logger) as Boolean {
        // 5m depth
        var ambientP5 = DiveCalculations.CalculateAmbientP(5.0);
        Test.assertEqual(ambientP5, 1.5);

        // 20m depth
        var ambientP20 = DiveCalculations.CalculateAmbientP(20.0);
        Test.assertEqual(ambientP20, 3.0);

        // 40m depth
        var ambientP40 = DiveCalculations.CalculateAmbientP(40.0);
        Test.assertEqual(ambientP40, 5.0);

        return true;
    }

    // Test ambient pressure with fractional depths
    (:test)
    function testCalculateAmbientPFractionalDepth(logger as Logger) as Boolean {
        var ambientP = DiveCalculations.CalculateAmbientP(15.5);

        // At 15.5m, pressure should be 2.55 bar (15.5/10 + 1)
        Test.assert(CloseEnough(ambientP, 2.55, 0.001));

        return true;
    }

    // Test ambient pressure maintains precision
    (:test)
    function testCalculateAmbientPPrecision(logger as Logger) as Boolean {
        var ambientP = DiveCalculations.CalculateAmbientP(33.3);

        // At 33.3m, pressure should be 4.33 bar
        Test.assert(CloseEnough(ambientP, 4.33, 0.001));

        return true;
    }

    // ========================================================================
    // Tests for CalculateDepthConsumptionP
    // ========================================================================

    // Test depth consumption at surface
    (:test)
    function testCalculateDepthConsumptionPAtSurface(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var consumptionP = DiveCalculations.CalculateDepthConsumptionP(scr, 0.0, cylinder);

        // At surface with 20 l/min SCR and 12L cylinder
        // Volume = 20 * 1.0 = 20L
        // Pressure = 20 / 12 = 1.667 bar
        Test.assert(CloseEnough(consumptionP, 1.667, 0.001));

        return true;
    }

    // Test depth consumption at 10m
    (:test)
    function testCalculateDepthConsumptionPAt10m(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var consumptionP = DiveCalculations.CalculateDepthConsumptionP(scr, 10.0, cylinder);

        // At 10m with 20 l/min SCR and 12L cylinder
        // Volume = 20 * 2.0 = 40L
        // Pressure = 40 / 12 = 3.333 bar
        Test.assert(CloseEnough(consumptionP, 3.333, 0.001));

        return true;
    }

    // Test depth consumption at 30m
    (:test)
    function testCalculateDepthConsumptionPAt30m(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var consumptionP = DiveCalculations.CalculateDepthConsumptionP(scr, 30.0, cylinder);

        // At 30m with 20 l/min SCR and 12L cylinder
        // Volume = 20 * 4.0 = 80L
        // Pressure = 80 / 12 = 6.667 bar
        Test.assert(CloseEnough(consumptionP, 6.667, 0.001));

        return true;
    }

    // Test depth consumption with different cylinder
    (:test)
    function testCalculateDepthConsumptionPDifferentCylinder(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "15L 200bar",
            "unit_type" => "metric",
            "service_pressure" => 200,
            "water_capacity" => 15.0
        });

        var scr = 25.0;
        var consumptionP = DiveCalculations.CalculateDepthConsumptionP(scr, 20.0, cylinder);

        // At 20m with 25 l/min SCR and 15L cylinder
        // Ambient pressure = 3.0 bar
        // Volume = 25 * 3.0 = 75L
        // Pressure = 75 / 15 = 5.0 bar
        Test.assertEqual(consumptionP, 5.0);

        return true;
    }

    // Test depth consumption with different SCR
    (:test)
    function testCalculateDepthConsumptionPDifferentSCR(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 15.0;
        var consumptionP = DiveCalculations.CalculateDepthConsumptionP(scr, 10.0, cylinder);

        // At 10m with 15 l/min SCR and 12L cylinder
        // Volume = 15 * 2.0 = 30L
        // Pressure = 30 / 12 = 2.5 bar
        Test.assertEqual(consumptionP, 2.5);

        return true;
    }

    // Test depth consumption maintains precision
    (:test)
    function testCalculateDepthConsumptionPPrecision(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "11.1L 237bar",
            "unit_type" => "metric",
            "service_pressure" => 237,
            "water_capacity" => 11.1
        });

        var scr = 22.7;
        var consumptionP = DiveCalculations.CalculateDepthConsumptionP(scr, 18.5, cylinder);

        // At 18.5m with 22.7 l/min SCR and 11.1L cylinder
        // Ambient pressure = 2.85 bar
        // Volume = 22.7 * 2.85 = 64.695L
        // Pressure = 64.695 / 11.1 = 5.828 bar
        Test.assert(CloseEnough(consumptionP, 5.828, 0.01));

        return true;
    }

    // ========================================================================
    // Tests for CalculateSegmentTable
    // ========================================================================

    // Test segment table from 10m
    (:test)
    function testCalculateSegmentTableFrom10m(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var segments = DiveCalculations.CalculateSegmentTable(scr, cylinder, 10.0, 3.0);

        // Should have segments at: 10m, 7m, 4m, 1m, and 0m
        Test.assertEqual(segments.size(), 5);

        // Check first segment (10m)
        var seg0 = segments[0];
        var seg0Depth = seg0["depth"];
        if (!(seg0Depth instanceof Float)) {
            return false;
        }
        Test.assertEqual(seg0Depth, 10.0);

        // Check last segment (0m surface)
        var segLast = segments[4];
        var segLastDepth = segLast["depth"];
        if (!(segLastDepth instanceof Float)) {
            return false;
        }
        Test.assertEqual(segLastDepth, 0.0);

        return true;
    }

    // Test segment table from 30m with 10m intervals
    (:test)
    function testCalculateSegmentTableFrom30m(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var segments = DiveCalculations.CalculateSegmentTable(scr, cylinder, 30.0, 10.0);

        // Should have segments at: 30m, 20m, 10m, 0m
        Test.assertEqual(segments.size(), 4);

        // Verify depth values
        var depths = [30.0, 20.0, 10.0, 0.0];
        for (var i = 0; i < segments.size(); i++) {
            var seg = segments[i];
            var depth = seg["depth"];
            if (!(depth instanceof Float)) {
                return false;
            }
            Test.assertEqual(depth, depths[i]);
        }

        return true;
    }

    // Test segment table has correct segment consumption values
    (:test)
    function testCalculateSegmentTableConsumptionValues(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var segments = DiveCalculations.CalculateSegmentTable(scr, cylinder, 20.0, 10.0);

        // Check that each segment has a consumption value
        for (var i = 0; i < segments.size(); i++) {
            var seg = segments[i];

            Test.assert(seg.hasKey("segment"));
            var segmentConsumption = seg["segment"];
            if (!(segmentConsumption instanceof Float)) {
                return false;
            }
            // Consumption should be positive
            Test.assert(segmentConsumption > 0.0);
        }

        return true;
    }

    // Test segment table consumption increases with depth
    (:test)
    function testCalculateSegmentTableConsumptionIncreasesWithDepth(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var segments = DiveCalculations.CalculateSegmentTable(scr, cylinder, 30.0, 10.0);

        // Consumption at 30m should be greater than at 20m
        var seg30 = segments[0];
        var consumption30 = seg30["segment"];
        if (!(consumption30 instanceof Float)) {
            return false;
        }

        var seg20 = segments[1];
        var consumption20 = seg20["segment"];
        if (!(consumption20 instanceof Float)) {
            return false;
        }

        Test.assert(consumption30 > consumption20);

        return true;
    }

    // Test segment table from shallow depth
    (:test)
    function testCalculateSegmentTableShallowDepth(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var segments = DiveCalculations.CalculateSegmentTable(scr, cylinder, 5.0, 3.0);

        // Should have segments at: 5m, 2m, 0m
        Test.assertEqual(segments.size(), 3);

        return true;
    }

    // Test segment table with interval larger than start depth
    (:test)
    function testCalculateSegmentTableLargeInterval(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var segments = DiveCalculations.CalculateSegmentTable(scr, cylinder, 5.0, 10.0);

        // Should have segments at: 5m and 0m
        Test.assertEqual(segments.size(), 2);

        var seg0 = segments[0];
        var seg0Depth = seg0["depth"];
        if (!(seg0Depth instanceof Float)) {
            return false;
        }
        Test.assertEqual(seg0Depth, 5.0);

        var seg1 = segments[1];
        var seg1Depth = seg1["depth"];
        if (!(seg1Depth instanceof Float)) {
            return false;
        }
        Test.assertEqual(seg1Depth, 0.0);

        return true;
    }

    // Test segment table uses SEGMENT_LENGTH constant
    (:test)
    function testCalculateSegmentTableUsesSegmentLength(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var scr = 20.0;
        var segments = DiveCalculations.CalculateSegmentTable(scr, cylinder, 10.0, 10.0);

        // Get consumption at 10m
        var seg10 = segments[0];
        var segment10 = seg10["segment"];
        if (!(segment10 instanceof Float)) {
            return false;
        }

        // Manually calculate expected consumption
        var consumptionP = DiveCalculations.CalculateDepthConsumptionP(scr, 10.0, cylinder);
        var expectedSegment = consumptionP * Constants.SEGMENT_LENGTH;

        Test.assert(CloseEnough(segment10, expectedSegment, 0.001));

        return true;
    }

    // ========================================================================
    // Tests for CalculatePO2
    // ========================================================================

    // Test PO2 at surface with air
    (:test)
    function testCalculatePO2AtSurfaceWithAir(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.21, 0.0);

        // At surface with 21% O2, PO2 should be 0.21 bar
        Test.assert(CloseEnough(po2, 0.21, 0.001));

        return true;
    }

    // Test PO2 at 10m with air
    (:test)
    function testCalculatePO2At10mWithAir(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.21, 10.0);

        // At 10m (2 bar) with 21% O2, PO2 should be 0.42 bar
        Test.assert(CloseEnough(po2, 0.42, 0.001));

        return true;
    }

    // Test PO2 at 30m with air
    (:test)
    function testCalculatePO2At30mWithAir(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.21, 30.0);

        // At 30m (4 bar) with 21% O2, PO2 should be 0.84 bar
        Test.assert(CloseEnough(po2, 0.84, 0.001));

        return true;
    }

    // Test PO2 with EAN32 at surface
    (:test)
    function testCalculatePO2WithEAN32AtSurface(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.32, 0.0);

        // At surface with 32% O2, PO2 should be 0.32 bar
        Test.assert(CloseEnough(po2, 0.32, 0.001));

        return true;
    }

    // Test PO2 with EAN32 at 30m
    (:test)
    function testCalculatePO2WithEAN32At30m(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.32, 30.0);

        // At 30m (4 bar) with 32% O2, PO2 should be 1.28 bar
        Test.assert(CloseEnough(po2, 1.28, 0.001));

        return true;
    }

    // Test PO2 with pure oxygen at surface
    (:test)
    function testCalculatePO2WithOxygenAtSurface(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(1.0, 0.0);

        // At surface with 100% O2, PO2 should be 1.0 bar
        Test.assertEqual(po2, 1.0);

        return true;
    }

    // Test PO2 with pure oxygen at 6m
    (:test)
    function testCalculatePO2WithOxygenAt6m(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(1.0, 6.0);

        // At 6m (1.6 bar) with 100% O2, PO2 should be 1.6 bar
        Test.assert(CloseEnough(po2, 1.6, 0.001));

        return true;
    }

    // Test PO2 with EAN50 at 20m
    (:test)
    function testCalculatePO2WithEAN50At20m(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.50, 20.0);

        // At 20m (3 bar) with 50% O2, PO2 should be 1.5 bar
        Test.assertEqual(po2, 1.5);

        return true;
    }

    // Test PO2 maintains precision
    (:test)
    function testCalculatePO2Precision(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.21, 33.3);

        // At 33.3m (4.33 bar) with 21% O2, PO2 should be 0.9093 bar
        Test.assert(CloseEnough(po2, 0.9093, 0.001));

        return true;
    }

    // Test PO2 at 40m with EAN32 (exceeds 1.4 threshold)
    (:test)
    function testCalculatePO2ExceedsThreshold(logger as Logger) as Boolean {
        var po2 = DiveCalculations.CalculatePO2(0.32, 40.0);

        // At 40m (5 bar) with 32% O2, PO2 should be 1.6 bar
        Test.assert(CloseEnough(po2, 1.6, 0.001));

        return true;
    }

    // ========================================================================
    // Tests for CalculateDepthForPO2
    // ========================================================================

    // Test depth for PO2 1.4 with air
    (:test)
    function testCalculateDepthForPO2WithAir(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(1.4, 0.21);

        // With air (21% O2) and target PO2 of 1.4
        // depth = (1.4/0.21 - 1) * 10 = 56.67m
        Test.assert(CloseEnough(depth, 56.67, 0.01));

        return true;
    }

    // Test depth for PO2 1.4 with EAN32
    (:test)
    function testCalculateDepthForPO2WithEAN32(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(1.4, 0.32);

        // With EAN32 (32% O2) and target PO2 of 1.4
        // depth = (1.4/0.32 - 1) * 10 = 33.75m
        Test.assert(CloseEnough(depth, 33.75, 0.01));

        return true;
    }

    // Test depth for PO2 1.6 with pure oxygen
    (:test)
    function testCalculateDepthForPO2WithOxygen(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(1.6, 1.0);

        // With pure O2 (100%) and target PO2 of 1.6
        // depth = (1.6/1.0 - 1) * 10 = 6m
        Test.assertEqual(depth, 6.0);

        return true;
    }

    // Test depth for PO2 1.6 with EAN50
    (:test)
    function testCalculateDepthForPO2WithEAN50(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(1.6, 0.50);

        // With EAN50 (50% O2) and target PO2 of 1.6
        // depth = (1.6/0.5 - 1) * 10 = 22m
        Test.assertEqual(depth, 22.0);

        return true;
    }

    // Test depth for PO2 at surface pressure
    (:test)
    function testCalculateDepthForPO2AtSurface(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(0.21, 0.21);

        // With air (21% O2) and target PO2 of 0.21 (surface pressure)
        // depth = (0.21/0.21 - 1) * 10 = 0m
        Test.assertEqual(depth, 0.0);

        return true;
    }

    // Test depth for PO2 maintains precision
    (:test)
    function testCalculateDepthForPO2Precision(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(1.37, 0.33);

        // With 33% O2 and target PO2 of 1.37
        // depth = (1.37/0.33 - 1) * 10 = 31.515m
        Test.assert(CloseEnough(depth, 31.515, 0.01));

        return true;
    }

    // Test depth for PO2 with conservative limit
    (:test)
    function testCalculateDepthForPO2ConservativeLimit(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(1.2, 0.21);

        // With air (21% O2) and conservative PO2 of 1.2
        // depth = (1.2/0.21 - 1) * 10 = 47.14m
        Test.assert(CloseEnough(depth, 47.14, 0.01));

        return true;
    }

    // Test depth for PO2 with deco gas
    (:test)
    function testCalculateDepthForPO2WithDecoGas(logger as Logger) as Boolean {
        var depth = DiveCalculations.CalculateDepthForPO2(1.6, 0.80);

        // With 80% O2 and target PO2 of 1.6
        // depth = (1.6/0.80 - 1) * 10 = 10m
        Test.assertEqual(depth, 10.0);

        return true;
    }

    // Test roundtrip: depth -> PO2 -> depth
    (:test)
    function testPO2CalculationsRoundTrip(logger as Logger) as Boolean {
        var fo2 = 0.32;
        var originalDepth = 30.0;

        // Calculate PO2 at depth
        var po2 = DiveCalculations.CalculatePO2(fo2, originalDepth);

        // Calculate depth back from PO2
        var calculatedDepth = DiveCalculations.CalculateDepthForPO2(po2, fo2);

        // Should match original depth
        Test.assert(CloseEnough(calculatedDepth, originalDepth, 0.001));

        return true;
    }

    // Test roundtrip: PO2 -> depth -> PO2
    (:test)
    function testDepthCalculationsRoundTrip(logger as Logger) as Boolean {
        var fo2 = 0.50;
        var originalPO2 = 1.4;

        // Calculate depth for PO2
        var depth = DiveCalculations.CalculateDepthForPO2(originalPO2, fo2);

        // Calculate PO2 back from depth
        var calculatedPO2 = DiveCalculations.CalculatePO2(fo2, depth);

        // Should match original PO2
        Test.assert(CloseEnough(calculatedPO2, originalPO2, 0.001));

        return true;
    }

    // ========================================================================
    // Edge cases and integration tests
    // ========================================================================

    // Test ambient pressure calculation uses correct formula
    (:test)
    function testAmbientPressureFormulaConsistency(logger as Logger) as Boolean {
        // Test that ambient pressure follows P = (depth/10) + 1
        var testDepths = [0.0, 5.0, 10.0, 15.0, 20.0, 30.0, 40.0];

        for (var i = 0; i < testDepths.size(); i++) {
            var depth = testDepths[i];
            var ambientP = DiveCalculations.CalculateAmbientP(depth);
            var expectedP = (depth / 10.0) + 1.0;

            Test.assert(CloseEnough(ambientP, expectedP, 0.001));
        }

        return true;
    }

    // Test segment table always includes surface
    (:test)
    function testSegmentTableAlwaysIncludesSurface(logger as Logger) as Boolean {
        var cylinder = Cylinder.fromDictionaryPresentation({
            "cylinder_type_name" => "12L 232bar",
            "unit_type" => "metric",
            "service_pressure" => 232,
            "water_capacity" => 12.0
        });

        var testConfigs = [
            [30.0, 10.0],
            [20.0, 5.0],
            [15.0, 3.0],
            [7.0, 2.0]
        ];

        for (var i = 0; i < testConfigs.size(); i++) {
            var config = testConfigs[i];
            var startDepth = config[0];
            var interval = config[1];

            var segments = DiveCalculations.CalculateSegmentTable(20.0, cylinder, startDepth, interval);

            // Last segment should always be at 0m
            var lastSeg = segments[segments.size() - 1];
            var lastDepth = lastSeg["depth"];
            if (!(lastDepth instanceof Float)) {
                return false;
            }
            Test.assertEqual(lastDepth, 0.0);
        }

        return true;
    }

    // Test PO2 calculations with various gas mixes
    (:test)
    function testPO2WithVariousGasMixes(logger as Logger) as Boolean {
        var gasMixes = [
            [0.21, "Air"],
            [0.32, "EAN32"],
            [0.36, "EAN36"],
            [0.50, "EAN50"],
            [0.80, "EAN80"],
            [1.00, "Oxygen"]
        ];

        var testDepth = 20.0;

        for (var i = 0; i < gasMixes.size(); i++) {
            var mix = gasMixes[i];
            var fo2 = mix[0];

            var po2 = DiveCalculations.CalculatePO2(fo2, testDepth);
            var expectedPO2 = fo2 * 3.0;

            Test.assert(CloseEnough(po2, expectedPO2, 0.001));
        }

        return true;
    }

}
