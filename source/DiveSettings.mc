import Toybox.Lang;
import Toybox.System;

/*
 * Data model for the application. The structure corresponds directly
 * to screens in the app. No data is stored in views or delegates.
 */
module DiveSettings {
    public var SCR as Float = 0.70;
    public var MaxDepth as Number = 100;
    public var Cylinder as Dictionary = {
        "cylinder_type_name" => "AL80",
        "service_pressure" => 3000,
        "nominal_capacity" => 80,
        "water_capacity" => -1,
        "unit_type" => "standard"
    };

    module Segments {
        // Depth between segment values
        public var Interval as Number = 10;
    }

    module MinGas {
        // Overrides MaxDepth
        public var BottomDepth as Number = 100;
        // Depth of next breathable gas source
        public var NextGasDepth as Number = 20;
        // Time spent on the bottom to attemt failure resolution
        public var ProblemSolvingTime as Number = 2;
        // Time spent switching gas
        public var GasSwitchTime as Number = 1;
        // Ascent rate, depth/min
        public var AscentRate as Number = 10;
    }
}

module DiveCalculations {

    function CalculateMinGas() as Dictionary {
        // Consumption of 2x divers
        var consumption = DiveSettings.SCR * 2.0;
        // Average pressure between bottom and next switch depth
        var avgDepth = (DiveSettings.MaxDepth + DiveSettings.MinGas.NextGasDepth) / 2.0;
        var avgPressure = (avgDepth / 33.0) + 1;
        // Time to ascend
        var ascentTime = (DiveSettings.MaxDepth - DiveSettings.MinGas.NextGasDepth) / DiveSettings.MinGas.AscentRate;
        // Total time until scenario is resolved
        var totalTime = DiveSettings.MinGas.ProblemSolvingTime + ascentTime + DiveSettings.MinGas.GasSwitchTime;

        // Minimum gas in volume
        var minGasVolume = consumption * avgPressure * totalTime;

        // Convert to pressure
        var cylinderCapacity = DiveSettings.Cylinder["nominal_capacity"] as Number;
        var servicePressure = DiveSettings.Cylinder["service_pressure"] as Number;
        var minGasPressure = (minGasVolume / cylinderCapacity) * servicePressure;

        return {
            "min_gas_volume" => minGasVolume,
            "min_gas_pressure" => minGasPressure,
            "consumption" => consumption,
            "avg_pressure" => avgPressure,
            "avg_depth" => avgDepth,
            "ascent_time" => ascentTime,
            "total_time" => totalTime
        };
    }

    function CalculateSegments() as Array<Dictionary> {
        var startDepth = DiveSettings.MaxDepth;

        // compute how much pressure per minute we use at the surface
        var pressure_per_min;

        if (DiveSettings.Cylinder["unit_type"].equals("standard")) {
            pressure_per_min = (DiveSettings.SCR / DiveSettings.Cylinder["nominal_capacity"]) * DiveSettings.Cylinder["service_pressure"];
        } else if (DiveSettings.Cylinder["unit_type"].equals("metric")) {
            pressure_per_min = DiveSettings.SCR / DiveSettings.Cylinder["water_capacity"];
        } else {
            System.println("Exiting due to unrecognized cylinder");
            System.exit();
        }

        var segments = [];

        for (var depth = startDepth; depth >= 20; depth -= 10) {
            var ambient = (depth/33.3) + 1;
            var segment = pressure_per_min * ambient * 5;

            segments.add({
                "depth" => depth,
                "segment" => segment
            });
        }

        return segments;
    }
}