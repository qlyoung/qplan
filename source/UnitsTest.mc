import Toybox.Lang;
import Toybox.Test;
import Toybox.System;

import Units;

(:test)
module UnitsTest {

    // ========================================================================
    // Tests for Convert.FeetToMeters
    // ========================================================================

    (:test)
    function testFeetToMetersZero(logger as Logger) as Boolean {
        var result = Units.Convert.FeetToMeters(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testFeetToMetersPositive(logger as Logger) as Boolean {
        var result = Units.Convert.FeetToMeters(10);
        // 10 feet = 10 * 0.3048 = 3.048 meters
        Test.assert(CloseEnough(result, 3.048, 0.001));
        return true;
    }

    (:test)
    function testFeetToMetersHundredFeet(logger as Logger) as Boolean {
        var result = Units.Convert.FeetToMeters(100);
        // 100 feet = 100 * 0.3048 = 30.48 meters
        Test.assert(CloseEnough(result, 30.48, 0.001));
        return true;
    }

    (:test)
    function testFeetToMetersFractional(logger as Logger) as Boolean {
        var result = Units.Convert.FeetToMeters(33.0);
        // 33 feet = 33 * 0.3048 = 10.0584 meters
        Test.assert(CloseEnough(result, 10.0584, 0.001));
        return true;
    }

    (:test)
    function testFeetToMetersPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.FeetToMeters(99.5);
        // 99.5 feet = 99.5 * 0.3048 = 30.3276 meters
        Test.assert(CloseEnough(result, 30.3276, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert.MetersToFeet
    // ========================================================================

    (:test)
    function testMetersToFeetZero(logger as Logger) as Boolean {
        var result = Units.Convert.MetersToFeet(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testMetersToFeetPositive(logger as Logger) as Boolean {
        var result = Units.Convert.MetersToFeet(10);
        // 10 meters = 10 * 3.28084 = 32.8084 feet
        Test.assert(CloseEnough(result, 32.8084, 0.001));
        return true;
    }

    (:test)
    function testMetersToFeetThirtyMeters(logger as Logger) as Boolean {
        var result = Units.Convert.MetersToFeet(30);
        // 30 meters = 30 * 3.28084 = 98.4252 feet
        Test.assert(CloseEnough(result, 98.4252, 0.001));
        return true;
    }

    (:test)
    function testMetersToFeetFractional(logger as Logger) as Boolean {
        var result = Units.Convert.MetersToFeet(18.5);
        // 18.5 meters = 18.5 * 3.28084 = 60.69554 feet
        Test.assert(CloseEnough(result, 60.69554, 0.01));
        return true;
    }

    (:test)
    function testMetersToFeetPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.MetersToFeet(12.3);
        // 12.3 meters = 12.3 * 3.28084 = 40.354332 feet
        Test.assert(CloseEnough(result, 40.354332, 0.01));
        return true;
    }

    // ========================================================================
    // Tests for Convert roundtrip: Feet <-> Meters
    // ========================================================================

    (:test)
    function testFeetMetersRoundtrip(logger as Logger) as Boolean {
        var originalFeet = 100.0;
        var meters = Units.Convert.FeetToMeters(originalFeet);
        var backToFeet = Units.Convert.MetersToFeet(meters);
        Test.assert(CloseEnough(backToFeet, originalFeet, 0.001));
        return true;
    }

    (:test)
    function testMetersFeetRoundtrip(logger as Logger) as Boolean {
        var originalMeters = 30.0;
        var feet = Units.Convert.MetersToFeet(originalMeters);
        var backToMeters = Units.Convert.FeetToMeters(feet);
        Test.assert(CloseEnough(backToMeters, originalMeters, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert.CubicFeetToLiters
    // ========================================================================

    (:test)
    function testCubicFeetToLitersZero(logger as Logger) as Boolean {
        var result = Units.Convert.CubicFeetToLiters(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testCubicFeetToLitersPositive(logger as Logger) as Boolean {
        var result = Units.Convert.CubicFeetToLiters(1);
        // 1 cubic foot = 28.3168 liters
        Test.assert(CloseEnough(result, 28.3168, 0.001));
        return true;
    }

    (:test)
    function testCubicFeetToLitersTenCubicFeet(logger as Logger) as Boolean {
        var result = Units.Convert.CubicFeetToLiters(10);
        // 10 cubic feet = 283.168 liters
        Test.assert(CloseEnough(result, 283.168, 0.001));
        return true;
    }

    (:test)
    function testCubicFeetToLitersFractional(logger as Logger) as Boolean {
        var result = Units.Convert.CubicFeetToLiters(2.5);
        // 2.5 cubic feet = 70.792 liters
        Test.assert(CloseEnough(result, 70.792, 0.001));
        return true;
    }

    (:test)
    function testCubicFeetToLitersPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.CubicFeetToLiters(0.5);
        // 0.5 cubic feet = 14.1584 liters
        Test.assert(CloseEnough(result, 14.1584, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert.LitersToCubicFeet
    // ========================================================================

    (:test)
    function testLitersToCubicFeetZero(logger as Logger) as Boolean {
        var result = Units.Convert.LitersToCubicFeet(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testLitersToCubicFeetPositive(logger as Logger) as Boolean {
        var result = Units.Convert.LitersToCubicFeet(28.3168);
        // 28.3168 liters = 1 cubic foot
        Test.assert(CloseEnough(result, 1.0, 0.001));
        return true;
    }

    (:test)
    function testLitersToCubicFeetTwelveLiters(logger as Logger) as Boolean {
        var result = Units.Convert.LitersToCubicFeet(12);
        // 12 liters = 12 * 0.0353147 = 0.4237764 cubic feet
        Test.assert(CloseEnough(result, 0.4237764, 0.001));
        return true;
    }

    (:test)
    function testLitersToCubicFeetFractional(logger as Logger) as Boolean {
        var result = Units.Convert.LitersToCubicFeet(15.5);
        // 15.5 liters = 15.5 * 0.0353147 = 0.5473779 cubic feet
        Test.assert(CloseEnough(result, 0.5473779, 0.001));
        return true;
    }

    (:test)
    function testLitersToCubicFeetPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.LitersToCubicFeet(100);
        // 100 liters = 100 * 0.0353147 = 3.53147 cubic feet
        Test.assert(CloseEnough(result, 3.53147, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert roundtrip: CubicFeet <-> Liters
    // ========================================================================

    (:test)
    function testCubicFeetLitersRoundtrip(logger as Logger) as Boolean {
        var originalCf = 10.0;
        var liters = Units.Convert.CubicFeetToLiters(originalCf);
        var backToCf = Units.Convert.LitersToCubicFeet(liters);
        Test.assert(CloseEnough(backToCf, originalCf, 0.001));
        return true;
    }

    (:test)
    function testLitersCubicFeetRoundtrip(logger as Logger) as Boolean {
        var originalLiters = 12.0;
        var cf = Units.Convert.LitersToCubicFeet(originalLiters);
        var backToLiters = Units.Convert.CubicFeetToLiters(cf);
        Test.assert(CloseEnough(backToLiters, originalLiters, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert.BarToPsi
    // ========================================================================

    (:test)
    function testBarToPsiZero(logger as Logger) as Boolean {
        var result = Units.Convert.BarToPsi(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testBarToPsiOneBar(logger as Logger) as Boolean {
        var result = Units.Convert.BarToPsi(1);
        // 1 bar = 14.5038 psi
        Test.assert(CloseEnough(result, 14.5038, 0.001));
        return true;
    }

    (:test)
    function testBarToPsiTwoHundredBar(logger as Logger) as Boolean {
        var result = Units.Convert.BarToPsi(200);
        // 200 bar = 2900.76 psi
        Test.assert(CloseEnough(result, 2900.76, 0.01));
        return true;
    }

    (:test)
    function testBarToPsiFractional(logger as Logger) as Boolean {
        var result = Units.Convert.BarToPsi(232);
        // 232 bar = 232 * 14.5038 = 3364.8816 psi
        Test.assert(CloseEnough(result, 3364.8816, 0.01));
        return true;
    }

    (:test)
    function testBarToPsiPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.BarToPsi(50.5);
        // 50.5 bar = 50.5 * 14.5038 = 732.4419 psi
        Test.assert(CloseEnough(result, 732.4419, 0.01));
        return true;
    }

    // ========================================================================
    // Tests for Convert.PsiToBar
    // ========================================================================

    (:test)
    function testPsiToBarZero(logger as Logger) as Boolean {
        var result = Units.Convert.PsiToBar(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testPsiToBarPositive(logger as Logger) as Boolean {
        var result = Units.Convert.PsiToBar(14.5038);
        // 14.5038 psi = 1 bar
        Test.assert(CloseEnough(result, 1.0, 0.001));
        return true;
    }

    (:test)
    function testPsiToBarThreeThousandPsi(logger as Logger) as Boolean {
        var result = Units.Convert.PsiToBar(3000);
        // 3000 psi = 3000 * 0.0689476 = 206.8428 bar
        Test.assert(CloseEnough(result, 206.8428, 0.01));
        return true;
    }

    (:test)
    function testPsiToBarFractional(logger as Logger) as Boolean {
        var result = Units.Convert.PsiToBar(2500.5);
        // 2500.5 psi = 2500.5 * 0.0689476 = 172.39589 bar
        Test.assert(CloseEnough(result, 172.39589, 0.01));
        return true;
    }

    (:test)
    function testPsiToBarPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.PsiToBar(100);
        // 100 psi = 100 * 0.0689476 = 6.89476 bar
        Test.assert(CloseEnough(result, 6.89476, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert roundtrip: Bar <-> Psi
    // ========================================================================

    (:test)
    function testBarPsiRoundtrip(logger as Logger) as Boolean {
        var originalBar = 232.0;
        var psi = Units.Convert.BarToPsi(originalBar);
        var backToBar = Units.Convert.PsiToBar(psi);
        Test.assert(CloseEnough(backToBar, originalBar, 0.01));
        return true;
    }

    (:test)
    function testPsiBarRoundtrip(logger as Logger) as Boolean {
        var originalPsi = 3000.0;
        var bar = Units.Convert.PsiToBar(originalPsi);
        var backToPsi = Units.Convert.BarToPsi(bar);
        Test.assert(CloseEnough(backToPsi, originalPsi, 0.1));
        return true;
    }

    // ========================================================================
    // Tests for Convert.MswToBar
    // ========================================================================

    (:test)
    function testMswToBarZero(logger as Logger) as Boolean {
        var result = Units.Convert.MswToBar(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testMswToBarTenMeters(logger as Logger) as Boolean {
        var result = Units.Convert.MswToBar(10);
        // 10 msw = 1 bar
        Test.assertEqual(result, 1.0);
        return true;
    }

    (:test)
    function testMswToBarThirtyMeters(logger as Logger) as Boolean {
        var result = Units.Convert.MswToBar(30);
        // 30 msw = 3 bar
        Test.assertEqual(result, 3.0);
        return true;
    }

    (:test)
    function testMswToBarFractional(logger as Logger) as Boolean {
        var result = Units.Convert.MswToBar(15.5);
        // 15.5 msw = 1.55 bar
        Test.assert(CloseEnough(result, 1.55, 0.001));
        return true;
    }

    (:test)
    function testMswToBarPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.MswToBar(33.3);
        // 33.3 msw = 3.33 bar
        Test.assert(CloseEnough(result, 3.33, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert.BarToMsw
    // ========================================================================

    (:test)
    function testBarToMswZero(logger as Logger) as Boolean {
        var result = Units.Convert.BarToMsw(0);
        Test.assertEqual(result, 0.0);
        return true;
    }

    (:test)
    function testBarToMswOneBar(logger as Logger) as Boolean {
        var result = Units.Convert.BarToMsw(1);
        // 1 bar = 10 msw
        Test.assertEqual(result, 10.0);
        return true;
    }

    (:test)
    function testBarToMswFourBar(logger as Logger) as Boolean {
        var result = Units.Convert.BarToMsw(4);
        // 4 bar = 40 msw
        Test.assertEqual(result, 40.0);
        return true;
    }

    (:test)
    function testBarToMswFractional(logger as Logger) as Boolean {
        var result = Units.Convert.BarToMsw(2.85);
        // 2.85 bar = 28.5 msw
        Test.assert(CloseEnough(result, 28.5, 0.001));
        return true;
    }

    (:test)
    function testBarToMswPrecision(logger as Logger) as Boolean {
        var result = Units.Convert.BarToMsw(5.75);
        // 5.75 bar = 57.5 msw
        Test.assert(CloseEnough(result, 57.5, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for Convert roundtrip: Msw <-> Bar
    // ========================================================================

    (:test)
    function testMswBarRoundtrip(logger as Logger) as Boolean {
        var originalMsw = 30.0;
        var bar = Units.Convert.MswToBar(originalMsw);
        var backToMsw = Units.Convert.BarToMsw(bar);
        Test.assert(CloseEnough(backToMsw, originalMsw, 0.001));
        return true;
    }

    (:test)
    function testBarMswRoundtrip(logger as Logger) as Boolean {
        var originalBar = 4.5;
        var msw = Units.Convert.BarToMsw(originalBar);
        var backToBar = Units.Convert.MswToBar(msw);
        Test.assert(CloseEnough(backToBar, originalBar, 0.001));
        return true;
    }

    // ========================================================================
    // Tests for conversion factor accuracy
    // ========================================================================

    (:test)
    function testConversionFactorsAreInverse(logger as Logger) as Boolean {
        // Test that conversion factors are mathematical inverses
        var ftToM = Units.Convert.FEET_TO_METERS;
        var mToFt = Units.Convert.METERS_TO_FEET;
        Test.assert(CloseEnough(ftToM * mToFt, 1.0, 0.001));

        var cfToL = Units.Convert.CUBIC_FEET_TO_LITERS;
        var lToCf = Units.Convert.LITERS_TO_CUBIC_FEET;
        Test.assert(CloseEnough(cfToL * lToCf, 1.0, 0.001));

        var barToPsi = Units.Convert.BAR_TO_PSI;
        var psiToBar = Units.Convert.PSI_TO_BAR;
        Test.assert(CloseEnough(barToPsi * psiToBar, 1.0, 0.001));

        var mswToBar = Units.Convert.MSW_TO_BAR;
        var barToMsw = Units.Convert.BAR_TO_MSW;
        Test.assert(CloseEnough(mswToBar * barToMsw, 1.0, 0.001));

        return true;
    }

    // ========================================================================
    // Tests for consistency between related conversions
    // ========================================================================

    (:test)
    function testDepthPressureConsistency(logger as Logger) as Boolean {
        // 10 meters seawater should equal 1 bar
        var depthBar = Units.Convert.MswToBar(10);
        Test.assertEqual(depthBar, 1.0);

        // 1 bar should equal 10 meters seawater
        var barDepth = Units.Convert.BarToMsw(1);
        Test.assertEqual(barDepth, 10.0);

        return true;
    }

    // ========================================================================
    // Tests for precision maintenance through multiple conversions
    // ========================================================================

    (:test)
    function testMultipleConversionsPrecision(logger as Logger) as Boolean {
        var original = 30.0; // meters

        // Convert meters -> feet -> meters -> feet -> meters
        var step1 = Units.Convert.MetersToFeet(original);
        var step2 = Units.Convert.FeetToMeters(step1);
        var step3 = Units.Convert.MetersToFeet(step2);
        var step4 = Units.Convert.FeetToMeters(step3);

        // Should still be close to original after multiple conversions
        Test.assert(CloseEnough(step4, original, 0.01));

        return true;
    }

    // ========================================================================
    // Tests for Symbols module
    // ========================================================================

    (:test)
    function testSymbolsAllCombinations(logger as Logger) as Boolean {
        // Test that every combination of unit system and quantity type has a symbol
        var unitSystems = [Units.METRIC, Units.IMPERIAL];
        var quantityTypes = [Units.VOLUME, Units.DEPTH, Units.PRESSURE, Units.SCR, Units.DEPTH_CHANGE];

        for (var i = 0; i < unitSystems.size(); i++) {
            for (var j = 0; j < quantityTypes.size(); j++) {
                var symbol = Units.Symbols.getSymbol(unitSystems[i], quantityTypes[j]);
                // Symbol should be a non-empty string
                Test.assert(symbol instanceof String);
                Test.assert(symbol.length() > 0);
            }
        }

        return true;
    }

}
