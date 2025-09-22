import Toybox.Lang;
import Toybox.Math;
import Toybox.Application.Properties;

module Units {
    // Conversion factors
    const FEET_TO_METERS as Float = 0.3048;
    const METERS_TO_FEET as Float = 3.28084;
    const CUBIC_FEET_TO_LITERS as Float = 28.3168;
    const LITERS_TO_CUBIC_FEET as Float = 0.0353147;
    const BAR_TO_PSI as Float = 14.5038;
    const PSI_TO_BAR as Float = 0.0689476;

    enum UnitSystem {
        METRIC = 0,
        IMPERIAL
    }

    const UNITS = {
        METRIC => {
            "volume" => {
                "symbol" => "l",
            },
            "pressure" => {
                "symbol" => "bar",
            },
            "scr" => {
                "symbol" => "l/min",
            },
            "depth" => {
                "symbol" => "m",
            },
            "depth_change" => {
                "symbol" => "m/min",
            }
        },
        IMPERIAL => {
            "volume" => {
                "symbol" => "cf",
            },
            "pressure" => {
                "symbol" => "psi",
            },
            "scr" => {
                "symbol" => "cf/min",
            },
            "depth" => {
                "symbol" => "ft",
            },
            "depth_change" => {
                "symbol" => "ft/min",
            }
        }
    };

    function GetSystem() as UnitSystem {
        return Properties.getValue("units") as UnitSystem;
    }

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

    function BarToPsi(bar as Float) as Float {
        return bar * BAR_TO_PSI;
    }

    function PsiToBar(psi as Float) as Float {
        return psi * PSI_TO_BAR;
    }

    function BarToSystem(bar as Float) {
        if (GetSystem() == METRIC) {
            return bar;
        } else {
            return BarToPsi(bar);
        }
    }

    function SystemToMeters(value as Float) {
        if (GetSystem() == METRIC) {
            return value;
        } else {
            return FeetToMeters(value);
        }
    }

    function SystemToLiters(value as Float) {
        if (GetSystem() == METRIC) {
            return value;
        } else {
            return CubicFeetToLiters(value);
        }
    }

    function SystemToBar(value as Float) {
        if (GetSystem() == METRIC) {
            return value;
        } else {
            return PsiToBar(value);
        }
    }

    function SCR() as String {
        return UNITS[GetSystem()]["scr"]["symbol"];
    }

    function Volume() as String {
        return UNITS[GetSystem()]["volume"]["symbol"];
    }

    function Pressure() as String {
        return UNITS[GetSystem()]["pressure"]["symbol"];
    }

    function DepthChange() as String {
        return UNITS[GetSystem()]["depth_change"]["symbol"];
    }

    function Depth() as String {
        return UNITS[GetSystem()]["depth"]["symbol"];
    }
}