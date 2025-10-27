import Toybox.Lang;
import Toybox.Math;
import Toybox.System;
import Toybox.Application.Properties;

module Units {
    enum UnitSystem {
        // metric system
        METRIC = 0,
        // imperial system
        IMPERIAL = 1,
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

        function FeetToMeters(feet as Numeric) as Float {
            return (feet * FEET_TO_METERS).toFloat();
        }

        function MetersToFeet(meters as Numeric) as Float {
            return (meters * METERS_TO_FEET).toFloat();
        }

        function MetersToSystem(meters as Numeric) as Float {
            if (GetSystem() == METRIC) {
                return meters.toFloat();
            } else {
                return MetersToFeet(meters);
            }
        }

        function SystemToMeters(value as Numeric) as Float {
            if (GetSystem() == METRIC) {
                return value.toFloat();
            } else {
                return FeetToMeters(value);
            }
        }

        function CubicFeetToLiters(cubicFeet as Numeric) as Float {
            return (cubicFeet * CUBIC_FEET_TO_LITERS).toFloat();
        }

        function LitersToCubicFeet(liters as Numeric) as Float {
            return (liters * LITERS_TO_CUBIC_FEET).toFloat();
        }

        function LitersToSystem(liters as Numeric) as Float {
            if (GetSystem() == METRIC) {
                return liters.toFloat();
            } else {
                return LitersToCubicFeet(liters);
            }
        }

        function SystemToLiters(value as Numeric) as Float {
            if (GetSystem() == METRIC) {
                return value.toFloat();
            } else {
                return CubicFeetToLiters(value);
            }
        }

        function BarToPsi(bar as Numeric) as Float {
            return (bar * BAR_TO_PSI).toFloat();
        }

        function PsiToBar(psi as Numeric) as Float {
            return (psi * PSI_TO_BAR).toFloat();
        }

        function BarToSystem(bar as Numeric) as Float {
            if (GetSystem() == METRIC) {
                return bar.toFloat();
            } else {
                return BarToPsi(bar);
            }
        }

        function SystemToBar(value as Numeric) as Float {
            if (GetSystem() == METRIC) {
                return value.toFloat();
            } else {
                return PsiToBar(value);
            }
        }

        function MswToBar(msw as Numeric) as Float {
            return (msw * MSW_TO_BAR).toFloat();
        }

        function BarToMsw(bar as Numeric) as Float {
            return (bar * BAR_TO_MSW).toFloat();
        }

    }

    module Symbols {
        // It is impossible to declare the type of SYMBOLS and also assign to
        // it, because the compiler is incapable of inferring the type of the
        // RHS any more specifically than "Dictionary". We must be careful to
        // prefix Units. to all keys because e.g. SCR would refer to the SCR()
        // function in this module and not QuantityType.SCR
        const SYMBOLS as Dictionary = {
            Units.METRIC => {
                Units.VOLUME => "l",
                Units.PRESSURE => "bar",
                Units.SCR => "l/min",
                Units.DEPTH => "m",
                Units.DEPTH_CHANGE => "m/min",
            },
            Units.IMPERIAL => {
                Units.VOLUME => "cf",
                Units.PRESSURE => "psi",
                Units.SCR => "cf/min",
                Units.DEPTH => "ft",
                Units.DEPTH_CHANGE => "ft/min",
            }
        };

        function SCR() as String {
            return getSymbolInt(Units.SCR);
        }

        function Volume() as String {
            return getSymbolInt(Units.VOLUME);
        }

        function Pressure() as String {
            return getSymbolInt(Units.PRESSURE);
        }

        function DepthChange() as String {
            return getSymbolInt(Units.DEPTH_CHANGE);
        }

        function Depth() as String {
            return getSymbolInt(Units.DEPTH);
        }

        function getSymbol(unitSystem as UnitSystem, type as QuantityType) as String {
            var symsForSystem = Symbols.SYMBOLS[unitSystem];
            if (!(symsForSystem instanceof Dictionary)) {
                System.error("Impossible type check: Units.Symbols.getSymbol");
            }

            var symbol = symsForSystem[type];
            if (!(symbol instanceof String)) {
                System.error("Impossible type check: Units.Symbols.getSymbol");
            }

            return symbol;
        }

        function getSymbolInt(type as QuantityType) as String {
            return getSymbol(Units.GetSystem(), type);
        }
    }
}