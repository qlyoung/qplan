import Toybox.Lang;
import Toybox.System;

/*
 * Data model for the application. The structure corresponds directly
 * to screens in the app. No data is stored in views or delegates.
 */
module DiveSettings {
    var SCR as Float = 0.70;
    var BottomDepth as Number = 100;
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
        // Duration of a segment (m)
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
        // -1 = same as MaxDepth
        var BottomDepth as Number = -1;
        // -1 = same as SCR
        var SCR as Float = -1.0;
        // Usually 2, but can be set to 1 for solo
        var SCRMultiplier as Number = 2;
        // Depth of next breathable gas source
        var SwitchDepth as Number = 20;
        // Time spent on the bottom to attemt failure resolution (s)
        var ProblemSolvingTime as Number = 60*2;
        // Time spent switching gas (s)
        var GasSwitchTime as Number = 60;
        // Ascent rate, depth/min
        var AscentRate as Number = 10;

        function GetSCRMultiplier() as Number {
            return SCRMultiplier;
        }

        function SetSCRMultiplier(multiplier as Number) {
            SCRMultiplier = multiplier;
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

        function GetSCR() as Float {
            if (DiveSettings.MinGas.SCR != -1) {
                return SCR;
            } else {
                return DiveSettings.GetSCR();
            }
        }

        function SetSCR(scr as Float) {
            SCR = scr;
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
        // Consumption of 2x divers (cf/s)
        var consumption = (DiveSettings.MinGas.GetSCR()/60.0) * DiveSettings.MinGas.GetSCRMultiplier();
        // Average pressure between bottom and next switch depth
        var bottomDepth = DiveSettings.MinGas.GetBottomDepth();
        var avgDepth = (bottomDepth + DiveSettings.MinGas.GetSwitchDepth()) / 2.0;
        var avgPressure = (avgDepth / 33.3) + 1;
        // Time to ascend (s)
        var ascentTime = (bottomDepth - DiveSettings.MinGas.GetSwitchDepth()) / DiveSettings.MinGas.GetAscentRate();
        ascentTime *= 60;
        // Total time until scenario is resolved (s)
        var totalTime = DiveSettings.MinGas.GetProblemSolvingTime() + ascentTime + DiveSettings.MinGas.GetGasSwitchTime();
        // Minimum gas in volume
        var minGasVolume = consumption * avgPressure * totalTime;
        // Convert to pressure
        var cylinderCapacity = DiveSettings.GetCylinder()["nominal_capacity"] as Number;
        var servicePressure = DiveSettings.GetCylinder()["service_pressure"] as Number;
        var minGasPressure = (minGasVolume / cylinderCapacity) * servicePressure;

        // return only calculated values
        return {
            "min_gas_volume" => minGasVolume,
            "min_gas_pressure" => minGasPressure,
            "consumption" => consumption*60,
            "avg_pressure" => avgPressure,
            "avg_depth" => avgDepth,
            "ascent_time" => ascentTime,
            "total_time" => totalTime
        };
    }

    function CalculateSegments() as Array<Dictionary> {
        var startDepth = DiveSettings.GetBottomDepth();

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

        var segments = [];

        for (var depth = startDepth; depth >= 20; depth -= DiveSettings.Segments.GetInterval()) {
            var ambient = (depth/33.3) + 1;
            var segment = pressure_per_min * ambient * DiveSettings.Segments.GetDuration();

            segments.add({
                "depth" => depth,
                "segment" => segment
            });
        }

        return segments;
    }
}