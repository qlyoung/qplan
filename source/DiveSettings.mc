import Toybox.Lang;
import Toybox.System;
import Toybox.Math;

/*
 * Data model for the application. The structure corresponds directly
 * to screens in the app. No data is stored in views or delegates.
 *
 * Get/set is used since some values have sentinels.
 */
module DiveSettings {
    // Diver SCR (cf/min)
    var SCR as Float = 0.70;
    // Bottom depth (ft)
    var BottomDepth as Number = 100;
    // Back gas cylinder
    var Cylinder as Dictionary = {
        "cylinder_type_name" => "AL80",
        "service_pressure" => 3000,
        "nominal_capacity" => 80,
        "water_capacity" => -1,
        "unit_type" => "standard"
    };

    function GetSCR() as Float {
        return SCR;
    }

    function SetSCR(scr as Float) {
        SCR = scr;
    }

    function GetBottomDepth() as Number {
        return BottomDepth;
    }

    function SetBottomDepth(depth as Number) {
        BottomDepth = depth;
    }

    function GetCylinder() as Dictionary {
        return Cylinder;
    }

    function SetCylinder(cylinder as Dictionary) {
        Cylinder = cylinder;
    }

    module Segments {
        // Depth between segment values (ft)
        var Interval as Number = 10;
        // Duration of a segment (min)
        var Duration as Number = 5;

        function GetInterval() as Number {
            return Interval;
        }

        function SetInterval(interval as Number) {
            Interval = interval;
        }

        function GetDuration() as Number {
            return Duration;
        }

        function SetDuration(duration as Number) {
            Duration = duration;
        }
    }

    module MinGas {
        // Bottom depth (ft)
        // -1 = same as MaxDepth
        var BottomDepth as Number = -1;
        // SCR of single diver in contingency scenario (cf/min)
        // -1 = same as main SCR
        var ContingencySCR as Float = -1.0;
        // Factor by which SCR increases in contingency scenario (scalar)
        // Examples:
        // - 2 to account for two divers sharing gas;
        // - 1 for solo diver
        var ContingencySCRMultiplier as Float = 2.0;
        // Depth of next breathable gas source (ft)
        var SwitchDepth as Number = 20;
        // Time spent on the bottom to attemt failure resolution (min)
        var ProblemSolvingTime as Number = 60*2;
        // Time spent switching gas (s)
        var GasSwitchTime as Number = 60;
        // Ascent rate (ft/min)
        var AscentRate as Number = 10;

        function GetContingencySCRMultiplier() as Float {
            return ContingencySCRMultiplier;
        }

        function SetContingencySCRMultiplier(multiplier as Float) {
            ContingencySCRMultiplier = multiplier;
        }

        function GetSwitchDepth() as Number {
            return SwitchDepth;
        }

        function SetSwitchDepth(depth as Number) {
            SwitchDepth = depth;
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

        function GetAscentRate() as Number {
            return AscentRate;
        }

        function SetAscentRate(rate as Number) {
            AscentRate = rate;
        }

        function GetContingencySCR() as Float {
            if (DiveSettings.MinGas.ContingencySCR != -1) {
                return ContingencySCR;
            } else {
                return DiveSettings.GetSCR();
            }
        }

        function SetContingencySCR(scr as Float) {
            ContingencySCR = scr;
        }

        function GetBottomDepth() as Number {
            if (DiveSettings.MinGas.BottomDepth != -1) {
                return BottomDepth;
            } else {
                return DiveSettings.GetBottomDepth();
            }
        }

        function SetBottomDepth(bd as Number) {
            BottomDepth = bd;
        }
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
        var ascentTime = Math.ceil((bottomDepth - DiveSettings.MinGas.GetSwitchDepth()) / (DiveSettings.MinGas.GetAscentRate()/60.0));
        // Total time until scenario is resolved (s)
        var totalTime = DiveSettings.MinGas.GetProblemSolvingTime() + ascentTime + DiveSettings.MinGas.GetGasSwitchTime();
        // Minimum gas in volume
        var minGasVolume = consumption_sec * avgPressure * totalTime;
        // Convert to pressure
        var cylinderCapacity = DiveSettings.GetCylinder()["nominal_capacity"] as Number;
        var servicePressure = DiveSettings.GetCylinder()["service_pressure"] as Number;
        var minGasPressure = (minGasVolume / cylinderCapacity) * servicePressure;

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

    function CalculateAmbientP(depth) as Float {
        return (depth/33.3) + 1;
    }

    /* Calculate how much pressure is used at a given depth in 1 min
     * Note that this works to calculate SCR in pressure if you pass depth = 0
     */
    function CalculateSegment(depth) as Number {
        // compute how much pressure per minute we use at the surface
        var pressure_per_min;

        if (DiveSettings.GetCylinder()["unit_type"].equals("standard")) {
            pressure_per_min = (DiveSettings.GetSCR() / DiveSettings.GetCylinder()["nominal_capacity"]) * DiveSettings.GetCylinder()["service_pressure"];
        } else if (DiveSettings.GetCylinder()["unit_type"].equals("metric")) {
            pressure_per_min = DiveSettings.GetSCR() / DiveSettings.GetCylinder()["water_capacity"];
        } else {
            System.println("Exiting due to unrecognized cylinder");
            System.exit();
        }

        return pressure_per_min * DiveCalculations.CalculateAmbientP(depth);
    }

    function CalculateSegmentTable() as Array<Dictionary> {
        var startDepth = DiveSettings.GetBottomDepth();
        var segments = [];

        for (var depth = startDepth; depth >= 20; depth -= DiveSettings.Segments.GetInterval()) {
            segments.add({
                "depth" => depth,
                "segment" => DiveCalculations.CalculateSegment(depth) * DiveSettings.Segments.GetDuration(),
            });
        }

        return segments;
    }

    function CalculatePO2(fo2 as Float, depth as Number) {
        return fo2 * DiveCalculations.CalculateAmbientP(depth);
    }

}