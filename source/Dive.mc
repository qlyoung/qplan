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

    // Bottom depth (m)
    // -1 = same as MaxDepth
    private var _minGasBottomDepth as Float = 0.0;
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
    function setMetricDefaults() {
        _scr = 20.0;
        _bottomDepth = 30.0;
        _minGasBottomDepth = -1.0;
        _contingencySCR = -1.0;
        _contingencySCRMultiplier = 2.0;
        _switchDepth = 6.0;
        _problemSolvingTime = 60*2;
        _gasSwitchTime = 60;
        _ascentRate = 3.0;
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        _cylinder.fromDictionary(tankData[0]);
    }

    // Set default values to those familiar to imperial-native divers
    function setImperialDefaults() {
        _scr = Units.Convert.CubicFeetToLiters(0.7);
        _bottomDepth = Units.Convert.FeetToMeters(100.0);
        _minGasBottomDepth = -1.0;
        _contingencySCR = -1.0;
        _contingencySCRMultiplier = 2.0;
        _switchDepth = Units.Convert.FeetToMeters(20.0);
        _problemSolvingTime = 60*2;
        _gasSwitchTime = 60;
        _ascentRate = Units.Convert.FeetToMeters(10.0);
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        _cylinder.fromDictionary(tankData[0]);
    }

    function getSCR() as Float {
        return _scr;
    }

    function setSCR(scr as Float) {
        _scr = scr;
    }

    function getBottomDepth() as Float {
        return _bottomDepth;
    }

    function setBottomDepth(depth as Float) {
        _bottomDepth = depth;
    }

    function getCylinder() as Cylinder {
        return _cylinder;
    }

    function setCylinder(cylinder as Cylinder or Dictionary) {
        if (cylinder instanceof Cylinder) {
            _cylinder = cylinder;
        } else {
            _cylinder.fromDictionary(cylinder);
        }
    }

    function getContingencySCRMultiplier() as Float {
        return _contingencySCRMultiplier;
    }

    function setContingencySCRMultiplier(multiplier as Float) {
        _contingencySCRMultiplier = multiplier;
    }

    function getSwitchDepth() as Float {
        return _switchDepth;
    }

    function setSwitchDepth(depth as Float) {
        _switchDepth = depth;
    }

    function getProblemSolvingTime() as Number {
        return _problemSolvingTime;
    }

    function setProblemSolvingTime(time as Number) {
        _problemSolvingTime = time;
    }

    function getGasSwitchTime() as Number {
        return _gasSwitchTime;
    }

    function setGasSwitchTime(time as Number) {
        _gasSwitchTime = time;
    }

    function getAscentRate() as Float {
        return _ascentRate;
    }

    function setAscentRate(rate as Float) {
        _ascentRate = rate;
    }

    function getContingencySCR() as Float {
        if (_contingencySCR != -1) {
            return _contingencySCR;
        } else {
            return getSCR();
        }
    }

    function setContingencySCR(scr as Float) {
        _contingencySCR = scr;
    }

    function getMinGasBottomDepth() as Float {
        if (_minGasBottomDepth != -1) {
            return _minGasBottomDepth;
        } else {
            return getBottomDepth();
        }
    }

    function setMinGasBottomDepth(depth as Float) {
        _minGasBottomDepth = depth;
    }

    function calculateMinGas() as Dictionary {
        // Total scenario consumption per second
        var consumption_sec = (getContingencySCR()/60.0) * getContingencySCRMultiplier();
        // Average pressure between bottom and next switch depth
        var bottomDepth = getMinGasBottomDepth();
        var avgDepth = (bottomDepth + _switchDepth) / 2.0;
        var avgPressure = DiveCalculations.CalculateAmbientP(avgDepth);
        // Time to ascend (s)
        var ascRateSec = _ascentRate/60.0;
        var ascentTime = Math.ceil((bottomDepth - _switchDepth) / ascRateSec);
        // Total time until scenario is resolved (s)
        var totalTime = _problemSolvingTime + ascentTime + _gasSwitchTime;
        // Convention is to round total time up to the nearest minute for conservativism
        totalTime = Math.ceil(totalTime / 60.0) * 60.0;
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
            "total_time" => totalTime
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
            "min_gas_bottom_depth" => _minGasBottomDepth,
            "contingency_scr" => _contingencySCR,
            "contingency_scr_multiplier" => _contingencySCRMultiplier,
            "switch_depth" => _switchDepth,
            "problem_solving_time" => _problemSolvingTime,
            "gas_switch_time" => _gasSwitchTime,
            "ascent_rate" => _ascentRate
        };
    }

    function fromDictionary(data as Dictionary) {
        _scr = data["scr"] as Float;
        _bottomDepth = data["bottom_depth"] as Float;
        _cylinder.fromDictionary(data["cylinder"]);
        _minGasBottomDepth = data["min_gas_bottom_depth"] as Float;
        _contingencySCR = data["contingency_scr"] as Float;
        _contingencySCRMultiplier = data["contingency_scr_multiplier"] as Float;
        _switchDepth = data["switch_depth"] as Float;
        _problemSolvingTime = data["problem_solving_time"] as Number;
        _gasSwitchTime = data["gas_switch_time"] as Number;
        _ascentRate = data["ascent_rate"] as Float;
    }
}
