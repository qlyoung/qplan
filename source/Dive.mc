import Toybox.Lang;
import Toybox.System;
import Units;

/*
 * Models a single dive.
 */
class Dive {
    // Diver SCR (l/min)
    private var _scr as Float = 0.0;
    // Bottom depth (m)
    private var _bottomDepth as Float = 0.0;
    // Back gas cylinder
    private var _cylinder as Cylinder = new Cylinder(null);

    // SCR of single diver in contingency scenario (l/min)
    // -1 = same as main SCR
    private var _contingencySCR as Float = 0.0;
    // Factor by which SCR increases in contingency scenario (scalar)
    // Examples:
    // - 2.0 to account for two divers sharing gas;
    // - 1.0 for solo diver
    private var _contingencySCRMultiplier as Float = 0.0;
    // Depth of next breathable gas source (m)
    private var _switchDepth as Float = 0.0;
    // Time spent on the bottom to attempt failure resolution (s)
    private var _problemSolvingTime as Number = 0;
    // Time spent switching gas (s)
    private var _gasSwitchTime as Number = 0;
    // Ascent rate (m/min)
    private var _ascentRate as Float = 0.0;

    function initialize() {
    }

    // Set default values to those familiar to metric-native divers
    function setMetricDefaults() as Void {
        _scr = 20.0;
        _bottomDepth = 30.0;
        _contingencySCR = -1.0;
        _contingencySCRMultiplier = 2.0;
        _switchDepth = 6.0;
        _problemSolvingTime = 60*2;
        _gasSwitchTime = 60;
        _ascentRate = 3.0;
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks);
        if (tankData instanceof Array) {
            var fv = tankData[0];
            if (fv instanceof Dictionary) {
                _cylinder.fromDictionary(fv);
            } else {
                System.error("Failed type check");
            }
        } else {
            System.error("Failed type check");
        }
    }

    // Set default values to those familiar to imperial-native divers
    function setImperialDefaults() as Void {
        _scr = Units.Convert.CubicFeetToLiters(0.7);
        _bottomDepth = Units.Convert.FeetToMeters(100.0);
        _contingencySCR = -1.0;
        _contingencySCRMultiplier = 2.0;
        _switchDepth = Units.Convert.FeetToMeters(20.0);
        _problemSolvingTime = 60*2;
        _gasSwitchTime = 60;
        _ascentRate = Units.Convert.FeetToMeters(10.0);
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks);
        if (tankData instanceof Array) {
            var fv = tankData[0];
            if (fv instanceof Dictionary) {
                _cylinder.fromDictionary(fv);
            } else {
                System.error("Failed type check");
            }
        } else {
            System.error("Failed type check");
        }
    }

    function getSCR() as Float {
        return _scr;
    }

    function setSCR(scr as Float) as Void {
        _scr = scr;
    }

    function getBottomDepth() as Float {
        return _bottomDepth;
    }

    function setBottomDepth(depth as Float) as Void {
        _bottomDepth = depth;
    }

    function getCylinder() as Cylinder {
        return _cylinder;
    }

    function setCylinder(cylinder as Cylinder or Dictionary) as Void {
        if (cylinder instanceof Cylinder) {
            _cylinder = cylinder;
        } else {
            _cylinder.fromDictionary(cylinder);
        }
    }

    function getContingencySCRMultiplier() as Float {
        return _contingencySCRMultiplier;
    }

    function setContingencySCRMultiplier(multiplier as Float) as Void {
        _contingencySCRMultiplier = multiplier;
    }

    function getSwitchDepth() as Float {
        return _switchDepth;
    }

    function setSwitchDepth(depth as Float) as Void {
        _switchDepth = depth;
    }

    function getProblemSolvingTime() as Number {
        return _problemSolvingTime;
    }

    function setProblemSolvingTime(time as Number) as Void {
        _problemSolvingTime = time;
    }

    function getGasSwitchTime() as Number {
        return _gasSwitchTime;
    }

    function setGasSwitchTime(time as Number) as Void {
        _gasSwitchTime = time;
    }

    function getAscentRate() as Float {
        return _ascentRate;
    }

    function setAscentRate(rate as Float) as Void {
        _ascentRate = rate;
    }

    function getContingencySCR() as Float {
        if (_contingencySCR != -1) {
            return _contingencySCR;
        } else {
            return getSCR();
        }
    }

    function setContingencySCR(scr as Float) as Void {
        _contingencySCR = scr;
    }


    function calculateMinGas() as Dictionary<String, Numeric> {
        // Total scenario consumption per second
        var consumption_sec = (getContingencySCR()/60.0) * getContingencySCRMultiplier();
        // Average pressure between bottom and next switch depth
        var bottomDepth = getBottomDepth();
        var avgDepth = (bottomDepth + _switchDepth) / 2.0;
        var avgPressure = DiveCalculations.CalculateAmbientP(avgDepth);
        // Time to ascend (s)
        var ascRateSec = _ascentRate/60.0;
        var ascentTime = Math.ceil((bottomDepth - _switchDepth) / ascRateSec).toNumber();
        // Total time until scenario is resolved (s)
        var totalTime = _problemSolvingTime + ascentTime + _gasSwitchTime;
        // Convention is to round total time up to the nearest minute for conservativism
        totalTime = (Math.ceil(totalTime / 60.0) * 60.0).toNumber();
        // Minimum gas in volume
        var minGasVolume = consumption_sec * avgPressure * totalTime;
        // Convert to pressure
        var minGasPressure = _cylinder.volumeToPressure(minGasVolume);

        // return only calculated values
        return {
            "min_gas_volume" => minGasVolume,
            "min_gas_pressure" => minGasPressure,
            "consumption" => consumption_sec*60.0,
            "avg_pressure" => avgPressure,
            "avg_depth" => avgDepth,
            "ascent_time" => ascentTime,
            "total_time" => totalTime,
        } as Dictionary<String, Numeric>;
    }

    function toDictionary() as Dictionary {
        var cylinderData = null;
        if (_cylinder != null) {
            cylinderData = _cylinder.getDictionary();
        }

        return {
            "scr" => _scr,
            "bottom_depth" => _bottomDepth,
            "cylinder" => cylinderData,
            "contingency_scr" => _contingencySCR,
            "contingency_scr_multiplier" => _contingencySCRMultiplier,
            "switch_depth" => _switchDepth,
            "problem_solving_time" => _problemSolvingTime,
            "gas_switch_time" => _gasSwitchTime,
            "ascent_rate" => _ascentRate
        };
    }

    function fromDictionary(data as Dictionary) as Void {
        var x = data["scr"];
        if (x instanceof Float) {
            _scr = x;
        } else {
            System.error("SCR failed type check");
        }

        x = data["bottom_depth"];
        if (x instanceof Float) {
            _bottomDepth = x;
        } else {
            System.error("bottom_depth failed type check");
        }

        x = data["cylinder"];
        if (x instanceof Dictionary) {
            _cylinder.fromDictionary(x);
        } else {
            System.error("cylinder failed type check");
        }

        x = data["contingency_scr"];
        if (x instanceof Float) {
            _contingencySCR = x;
        } else {
            System.error("contingency_scr failed type check");
        }

        x = data["contingency_scr_multiplier"];
        if (x instanceof Float) {
            _contingencySCRMultiplier = x;
        } else {
            System.error("contingency_scr_multiplier failed type check");
        }

        x = data["switch_depth"];
        if (x instanceof Float) {
            _switchDepth = x;
        } else {
            System.error("switch_depth failed type check");
        }

        x = data["problem_solving_time"];
        if (x instanceof Number) {
            _problemSolvingTime = x;
        } else {
            System.error("problem_solving_time failed type check");
        }

        x = data["gas_switch_time"];
        if (x instanceof Number) {
            _gasSwitchTime = x;
        } else {
            System.error("gas_switch_time failed type check");
        }

        x = data["ascent_rate"];
        if (x instanceof Float) {
            _ascentRate = x;
        } else {
            System.error("ascent_rate failed type check");
        }
    }
}
