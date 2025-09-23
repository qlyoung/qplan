import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Application.Properties;

module Units {
    enum UnitSystem {
        // metric system
        METRIC = 0,
        // imperial system
        IMPERIAL,
    }

    enum QuantityType {
        VOLUME,
        DEPTH,
        PRESSURE,
        SCR,
        DEPTH_CHANGE
    }

    function GetSystem() as UnitSystem {
        // 0 = metric, 1 = imperial
        return Properties.getValue("units") as UnitSystem;
    }

    module Convert {
        // Conversion factors
        const FEET_TO_METERS as Float = 0.3048;
        const METERS_TO_FEET as Float = 3.28084;
        const CUBIC_FEET_TO_LITERS as Float = 28.3168;
        const LITERS_TO_CUBIC_FEET as Float = 0.0353147;
        const BAR_TO_PSI as Float = 14.5038;
        const PSI_TO_BAR as Float = 0.0689476;
        const MSW_TO_BAR as Float = 0.1;
        const BAR_TO_MSW as Float = 10.0;

        function FeetToMeters(feet as Float) as Float {
            return feet * FEET_TO_METERS;
        }

        function MetersToFeet(meters as Float) as Float {
            return meters * METERS_TO_FEET;
        }

        function MetersToSystem(meters as Float) {
            if (GetSystem() == METRIC) {
                return meters;
            } else {
                return MetersToFeet(meters);
            }
        }

        function SystemToMeters(value as Float) {
            if (GetSystem() == METRIC) {
                return value;
            } else {
                return FeetToMeters(value);
            }
        }

        function CubicFeetToLiters(cubicFeet as Float) as Float {
            return cubicFeet * CUBIC_FEET_TO_LITERS;
        }

        function LitersToCubicFeet(liters as Float) as Float {
            return liters * LITERS_TO_CUBIC_FEET;
        }

        function LitersToSystem(liters as Float) {
            if (GetSystem() == METRIC) {
                return liters;
            } else {
                return LitersToCubicFeet(liters);
            }
        }

        function SystemToLiters(value as Float) {
            if (GetSystem() == METRIC) {
                return value;
            } else {
                return CubicFeetToLiters(value);
            }
        }

        function BarToPsi(bar as Float) as Float {
            return bar * BAR_TO_PSI;
        }

        function PsiToBar(psi as Float) as Float {
            return psi * PSI_TO_BAR;
        }

        function BarToSystem(bar as Float) as Float {
            if (GetSystem() == METRIC) {
                return bar;
            } else {
                return BarToPsi(bar);
            }
        }

        function SystemToBar(value as Float) as Float {
            if (GetSystem() == METRIC) {
                return value;
            } else {
                return PsiToBar(value);
            }
        }

        function MswToBar(msw as Float) as Float {
            return msw * MSW_TO_BAR;
        }

        function BarToMsw(bar as Float) as Float {
            return bar * BAR_TO_MSW;
        }

    }

    module Symbols {
        const SYMBOLS as Dictionary<UnitSystem, Dictionary> = {
            METRIC => {
                VOLUME => "l",
                PRESSURE => "bar",
                SCR => "l/min",
                DEPTH => "m",
                DEPTH_CHANGE => "m/min",
            },
            IMPERIAL => {
                VOLUME => "cf",
                PRESSURE => "psi",
                SCR => "cf/min",
                DEPTH => "ft",
                DEPTH_CHANGE => "ft/min",
            }
        };

        function SCR() as String {
            return SYMBOLS[GetSystem()][SCR];
        }

        function Volume() as String {
            return SYMBOLS[GetSystem()][VOLUME];
        }

        function Pressure() as String {
            return SYMBOLS[GetSystem()][PRESSURE];
        }

        function DepthChange() as String {
            return SYMBOLS[GetSystem()][DEPTH_CHANGE];
        }

        function Depth() as String {
            return SYMBOLS[GetSystem()][DEPTH];
        }
    }
}
