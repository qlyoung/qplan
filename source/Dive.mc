import Toybox.Lang;
import Toybox.System;
import Units;

/*
 * Models a single dive.
 */
class Dive {
    // Diver SCR (l/min)
    private var _scr as Float;
    // Bottom depth (m)
    private var _bottomDepth as Float;
    // Back gas cylinder
    private var _cylinder as Cylinder;

    // SCR of single diver in contingency scenario (l/min)
    // -1 = same as main SCR
    private var _contingencySCR as Float;
    // Factor by which SCR increases in contingency scenario (scalar)
    // Examples:
    // - 2.0 to account for two divers sharing gas;
    // - 1.0 for solo diver
    private var _contingencySCRMultiplier as Float;
    // Depth of next breathable gas source (m)
    private var _switchDepth as Float;
    // Time spent on the bottom to attempt failure resolution (s)
    private var _problemSolvingTime as Number;
    // Time spent switching gas (s)
    private var _gasSwitchTime as Number;
    // Ascent rate (m/min)
    private var _ascentRate as Float;

    function initialize(
        scr as Float or Number,
        bottomDepth as Float or Number,
        cylinder as Cylinder,
        contingencySCR as Float or Number,
        contingencySCRMultiplier as Float or Number,
        switchDepth as Float or Number,
        problemSolvingTime as Number,
        gasSwitchTime as Number,
        ascentRate as Float or Number)
    {
        _scr = scr.toFloat();
        _bottomDepth = bottomDepth.toFloat();
        _cylinder = cylinder;
        _contingencySCR = contingencySCR.toFloat();
        _contingencySCRMultiplier = contingencySCRMultiplier.toFloat();
        _switchDepth = switchDepth.toFloat();
        _problemSolvingTime = problemSolvingTime;
        _gasSwitchTime = gasSwitchTime;
        _ascentRate = ascentRate.toFloat();
    }

    static function Default() as Dive {
        var dive = new Dive(0.0, 0.0, Cylinder.Default(), 0.0, 0.0, 0.0, 0, 0, 0.0);
        dive.setMetricDefaults();
        return dive;
    }

    // Set default values to those familiar to metric-native divers
    function setMetricDefaults() as Void {
        _scr = 20.0;
        _bottomDepth = 30.0;
        _contingencySCR = 20.0;
        _contingencySCRMultiplier = 2.0;
        _switchDepth = 6.0;
        _problemSolvingTime = 60*2;
        _gasSwitchTime = 60;
        _ascentRate = 3.0;
    }

    // Set default values to those familiar to imperial-native divers
    function setImperialDefaults() as Void {
        _scr = Units.Convert.CubicFeetToLiters(0.7);
        _bottomDepth = Units.Convert.FeetToMeters(100.0);
        _contingencySCR = Units.Convert.CubicFeetToLiters(.75);
        _contingencySCRMultiplier = 2.0;
        _switchDepth = Units.Convert.FeetToMeters(20.0);
        _problemSolvingTime = 60*2;
        _gasSwitchTime = 60;
        _ascentRate = Units.Convert.FeetToMeters(10.0);
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

    function setCylinder(cylinder as Cylinder) as Void {
        _cylinder = cylinder;
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


    function calculateMinGas() as Dictionary<String, SmallNumber> {
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
        };
    }

    function toDictionary() as Dictionary {
        var cylinderData = null;
        if (_cylinder != null) {
            cylinderData = _cylinder.toDictionary();
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

    static function fromDictionary(data as Dictionary) as Dive {
        var scr = data["scr"];
        if (!(scr instanceof Float or scr instanceof Number)) {
            System.error("SCR failed type check");
        }

        var bottomDepth = data["bottom_depth"];
        if (!(bottomDepth instanceof Float or bottomDepth instanceof Number)) {
            System.error("bottom_depth failed type check");
        }

        var cylinderData = data["cylinder"];
        var cylinder;
        if (cylinderData instanceof Dictionary) {
           cylinder = Cylinder.fromDictionary(cylinderData);
        } else {
            System.error("cylinder failed type check");
        }

        var contingencySCR = data["contingency_scr"];
        if (!(contingencySCR instanceof Float or contingencySCR instanceof Number)) {
            System.error("contingency_scr failed type check");
        }

        var contingencySCRMultiplier = data["contingency_scr_multiplier"];
        if (!(contingencySCRMultiplier instanceof Float or contingencySCRMultiplier instanceof Number)) {
            System.error("contingency_scr_multiplier failed type check");
        }

        var switchDepth = data["switch_depth"];
        if (!(switchDepth instanceof Float or switchDepth instanceof Number)) {
            System.error("switch_depth failed type check");
        }

        var problemSolvingTime = data["problem_solving_time"];
        if (!(problemSolvingTime instanceof Number)) {
            System.error("problem_solving_time failed type check");
        }

        var gasSwitchTime = data["gas_switch_time"];
        if (!(gasSwitchTime instanceof Number)) {
            System.error("gas_switch_time failed type check");
        }

        var ascentRate = data["ascent_rate"];
        if (!(ascentRate instanceof Float or ascentRate instanceof Number)) {
            System.error("ascent_rate failed type check");
        }

        return new Dive(scr, bottomDepth, cylinder, contingencySCR, contingencySCRMultiplier, switchDepth, problemSolvingTime, gasSwitchTime, ascentRate);
    }

    function equals(other as Object?) as Boolean {
        if (!(other instanceof Dive)) {
            return false;
        }

        return CompareDict(toDictionary(), other.toDictionary());
    }
}
