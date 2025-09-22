import Toybox.Lang;
import Toybox.System;
import Toybox.Math;
import Toybox.Application.Storage;
import Units;

/*
 * Data model for the application. The structure corresponds directly
 * to screens in the app. No data is stored in views or delegates.
 *
 * Get/set is used since some values have sentinels.
 */
module DiveSettings {
    // Diver SCR (l/min)
    var SCR as Float = 0.0;
    // Bottom depth (m)
    var BottomDepth as Float = 0.0;
    // Back gas cylinder
    var Cylinder as Dictionary = {
        "cylinder_type_name" => "AL80",
        "service_pressure" => 3000,
        "nominal_capacity" => 80,
        "water_capacity" => -1,
        "unit_type" => "standard"
    };

    function GetMaxDepth() as Float {
        return Units.MetersToSystem(300.0);
    }

    function GetSCR() as Float {
        return Units.LitersToSystem(SCR);
    }

    function SetSCR(scr as Float) {
        SCR = Units.SystemToLiters(scr);
    }

    function GetBottomDepth() as Float {
        return Units.MetersToSystem(BottomDepth);
    }

    function SetBottomDepth(depth as Float) {
        BottomDepth = Units.SystemToMeters(depth);
    }

    function GetCylinder() as Dictionary {
        return Cylinder;
    }

    function SetCylinder(cylinder as Dictionary) {
        Cylinder = cylinder;
    }

    module Segments {
        // Duration of a segment (min)
        var Duration as Number = 5;

        function GetDuration() as Number {
            return Duration;
        }

        function SetDuration(duration as Number) {
            Duration = duration;
        }
    }

    module MinGas {
        // Bottom depth (m)
        // -1 = same as MaxDepth
        var BottomDepth as Float = -1.0;
        // SCR of single diver in contingency scenario (l/min)
        // -1 = same as main SCR
        var ContingencySCR as Float = -1.0;
        // Factor by which SCR increases in contingency scenario (scalar)
        // Examples:
        // - 2 to account for two divers sharing gas;
        // - 1 for solo diver
        var ContingencySCRMultiplier as Float = 2.0;
        // Depth of next breathable gas source (m)
        var SwitchDepth as Float = 0.0;
        // Time spent on the bottom to attemt failure resolution (s)
        var ProblemSolvingTime as Number = 60*2;
        // Time spent switching gas (s)
        var GasSwitchTime as Number = 60;
        // Ascent rate (m/min)
        var AscentRate as Float = 0.0;

        function GetContingencySCRMultiplier() as Float {
            return ContingencySCRMultiplier;
        }

        function SetContingencySCRMultiplier(multiplier as Float) {
            ContingencySCRMultiplier = multiplier;
        }

        function GetSwitchDepth() as Float {
            return Units.MetersToSystem(SwitchDepth);
        }

        function SetSwitchDepth(depth as Float) {
            SwitchDepth = Units.SystemToMeters(depth);
        }

        function GetProblemSolvingTime() as Number {
            return ProblemSolvingTime;
        }

        function SetProblemSolvingTime(time as Number) {
            ProblemSolvingTime = time;
        }

        function GetGasSwitchTime() as Number {
            return GasSwitchTime;
        }

        function SetGasSwitchTime(time as Number) {
            GasSwitchTime = time;
        }

        function GetAscentRate() as Float {
            return Units.MetersToSystem(AscentRate);
        }

        function SetAscentRate(rate as Float) {
            AscentRate = Units.SystemToMeters(rate);
        }

        function GetContingencySCR() as Float {
            if (DiveSettings.MinGas.ContingencySCR != -1) {
                return Units.LitersToSystem(DiveSettings.MinGas.ContingencySCR);
            } else {
                return DiveSettings.GetSCR();
            }
        }

        function SetContingencySCR(scr as Float) {
            ContingencySCR = Units.SystemToLiters(scr);
        }

        function GetBottomDepth() as Float {
            if (DiveSettings.MinGas.BottomDepth != -1) {
                return Units.MetersToSystem(DiveSettings.MinGas.BottomDepth);
            } else {
                return DiveSettings.GetBottomDepth();
            }
        }

        function SetBottomDepth(depth as Float) {
            BottomDepth = Units.SystemToMeters(depth);
        }
    }

    function PersistToStorage() {
        // Top level variables
        Storage.setValue("scr", SCR);
        Storage.setValue("bottom_depth", BottomDepth);
        Storage.setValue("cylinder", Cylinder);

        // Segments module variables
        Storage.setValue("segments.duration", Segments.Duration);

        // MinGas module variables
        Storage.setValue("min_gas.bottom_depth", MinGas.BottomDepth);
        Storage.setValue("min_gas.contingency_scr", MinGas.ContingencySCR);
        Storage.setValue("min_gas.contingency_scr_multiplier", MinGas.ContingencySCRMultiplier);
        Storage.setValue("min_gas.switch_depth", MinGas.SwitchDepth);
        Storage.setValue("min_gas.problem_solving_time", MinGas.ProblemSolvingTime);
        Storage.setValue("min_gas.gas_switch_time", MinGas.GasSwitchTime);
        Storage.setValue("min_gas.ascent_rate", MinGas.AscentRate);
    }

    function LoadFromStorage() {
        // Top level variables
        var scr = Storage.getValue("scr");
        if (scr != null) {
            SCR = scr as Float;
        }
        var bottomDepth = Storage.getValue("bottom_depth");
        if (bottomDepth != null) {
            BottomDepth = bottomDepth as Float;
        }
        var cylinder = Storage.getValue("cylinder");
        if (cylinder != null) {
            Cylinder = cylinder;
        }

        // Segments module variables
        var segmentsDuration = Storage.getValue("segments.duration");
        if (segmentsDuration != null) {
            Segments.Duration = segmentsDuration as Number;
        }

        // MinGas module variables
        var minGasBottomDepth = Storage.getValue("min_gas.bottom_depth");
        if (minGasBottomDepth != null) {
            MinGas.BottomDepth = minGasBottomDepth;
        }
        var minGasContingencySCR = Storage.getValue("min_gas.contingency_scr");
        if (minGasContingencySCR != null) {
            MinGas.ContingencySCR = minGasContingencySCR;
        }
        var minGasContingencySCRMultiplier = Storage.getValue("min_gas.contingency_scr_multiplier");
        if (minGasContingencySCRMultiplier != null) {
            MinGas.ContingencySCRMultiplier = minGasContingencySCRMultiplier;
        }
        var minGasSwitchDepth = Storage.getValue("min_gas.switch_depth");
        if (minGasSwitchDepth != null) {
            MinGas.SwitchDepth = minGasSwitchDepth;
        }
        var minGasProblemSolvingTime = Storage.getValue("min_gas.problem_solving_time");
        if (minGasProblemSolvingTime != null) {
            MinGas.ProblemSolvingTime = minGasProblemSolvingTime;
        }
        var minGasGasSwitchTime = Storage.getValue("min_gas.gas_switch_time");
        if (minGasGasSwitchTime != null) {
            MinGas.GasSwitchTime = minGasGasSwitchTime;
        }
        var minGasAscentRate = Storage.getValue("min_gas.ascent_rate");
        if (minGasAscentRate != null) {
            MinGas.AscentRate = minGasAscentRate;
        }
    }

    // Set default values to those familiar to metric-native divers
    function SetMetricDefaults() {
        SCR = 20.0;
        BottomDepth = 30.0;
        Segments.Duration = 5;
        MinGas.ContingencySCRMultiplier = 2.0;
        MinGas.SwitchDepth = 6.0;
        MinGas.ProblemSolvingTime = 60*2;
        MinGas.GasSwitchTime = 60;
        MinGas.AscentRate = 3.0;
    }

    // Set default values to those familiar to imperial-native divers
    function SetImperialDefaults() {
        SCR = Units.CubicFeetToLiters(0.7);
        BottomDepth = Units.FeetToMeters(100.0);
        Segments.Duration = 5;
        MinGas.ContingencySCRMultiplier = 2.0;
        MinGas.SwitchDepth = Units.FeetToMeters(20.0);
        MinGas.ProblemSolvingTime = 60*2;
        MinGas.GasSwitchTime = 60;
        MinGas.AscentRate = Units.FeetToMeters(10.0);
    }
}

module DiveCalculations {

    function CalculateMinGas() as Dictionary {
        // Total scenario consumption per second
        var consumption_sec = (DiveSettings.MinGas.GetContingencySCR()/60.0) * DiveSettings.MinGas.GetContingencySCRMultiplier();
        // Average pressure between bottom and next switch depth
        var bottomDepth = DiveSettings.MinGas.GetBottomDepth();
        var avgDepth = (bottomDepth + DiveSettings.MinGas.GetSwitchDepth()) / 2.0;
        var avgPressure = DiveCalculations.CalculateAmbientP(avgDepth);
        // Time to ascend (s)
        var ascRateSec = DiveSettings.MinGas.GetAscentRate()/60.0;
        var ascentTime = Math.ceil((bottomDepth - DiveSettings.MinGas.GetSwitchDepth()) / ascRateSec);
        // Total time until scenario is resolved (s)
        var totalTime = DiveSettings.MinGas.GetProblemSolvingTime() + ascentTime + DiveSettings.MinGas.GetGasSwitchTime();
        // Convention is to round total time up to the nearest minute for conservativism
        totalTime = Math.ceil(totalTime / 60.0) * 60.0;
        // Minimum gas in volume
        var minGasVolume = consumption_sec * avgPressure * totalTime;
        // Convert to pressure
        var minGasPressure = VolumeToCylinderPressure(minGasVolume);

        // return only calculated values
        return {
            "min_gas_volume" => minGasVolume,
            "min_gas_pressure" => minGasPressure,
            "consumption" => consumption_sec*60.0,
            "avg_pressure" => avgPressure,
            "avg_depth" => avgDepth,
            "ascent_time" => ascentTime,
            "total_time" => totalTime
        };
    }

    function VolumeToCylinderPressure(volume as Float) as Float {
        // compute how much pressure per minute we use at the surface
        var cylinder = DiveSettings.GetCylinder();

        // compute water capacity in liters
        var wc = 0.0;
        if (cylinder["unit_type"].equals("metric")) {
            wc = cylinder["water_capacity"];
        } else {
            var spBar = Units.PsiToBar(cylinder["service_pressure"]) as Float;
            var nominalCapLiter = Units.CubicFeetToLiters(cylinder["nominal_capacity"]) as Float;
            wc = nominalCapLiter / spBar;
        }

        var vol_l = Units.SystemToLiters(volume);
        return Units.BarToSystem(vol_l / wc);
    }

    // Calculate pressure in atmospheres
    function CalculateAmbientP(depth) as Float {
        var d = Units.SystemToMeters(depth);
        return d/10.0 + 1;
    }

    /* Calculate how much pressure is used at a given depth in 1 min
     * Note that this works to calculate SCR in pressure if you pass depth = 0
     */
    function CalculateDepthConsumption(depth as Float) as Float {
        return VolumeToCylinderPressure(DiveSettings.GetSCR()) * DiveCalculations.CalculateAmbientP(depth);
    }

    function CalculateSegmentTable() as Array<Dictionary> {
        var startDepth = Math.ceil(DiveSettings.GetBottomDepth());
        var segments = [];

        var interval = Units.GetSystem() == Units.METRIC ? 1 : 10;

        for (var depth = startDepth; depth > 0; depth -= interval) {
            segments.add({
                "depth" => depth,
                "segment" => DiveCalculations.CalculateDepthConsumption(depth) * DiveSettings.Segments.GetDuration(),
            });
        }

        segments.add({
            "depth" => 0,
            "segment" => DiveCalculations.CalculateDepthConsumption(0.0) * DiveSettings.Segments.GetDuration(),
        });

        return segments;
    }

    function CalculatePO2(fo2 as Float, depth as Number) {
        return fo2 * DiveCalculations.CalculateAmbientP(depth);
    }

}