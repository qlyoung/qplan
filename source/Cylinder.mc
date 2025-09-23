import Toybox.Lang;

import Units;

class Cylinder {
    // Cylinder common name; AL80, D12 etc
    private var _typeName as String;
    // The cylinder's native units; metric or imperial
    private var _unitType as Units.UnitSystem;
    // Service pressure (bar)
    private var _servicePressure as Float;
    // Volume of gas the cylinder holds when pressurized
    // to its service pressure (l)
    private var _nominalCapacity as Float;
    // The water capacity (l)
    private var _waterCapacity as Float;
    // The dictionary this cylinder was loaded from, if any
    private var _originalDict as Dictionary?;

    function initialize(data as Dictionary?) {
        _typeName = "";
        _unitType = Units.METRIC;
        _servicePressure = 0.0;
        _nominalCapacity = 0.0;
        _waterCapacity = 0.0;
        _originalDict = null;

        if (data != null) {
            fromDictionary(data);
        }
    }

    function fromDictionary(cylinderData as Dictionary) as Void {
        _originalDict = cylinderData;

        _typeName = cylinderData["cylinder_type_name"];

        if (cylinderData["unit_type"].equals("metric")) {
            _unitType = Units.METRIC;
        } else if (cylinderData["unit_type"].equals("imperial")) {
            _unitType = Units.IMPERIAL;
        } else {
            System.error("Unknown cylinder type");
        }

        if (_unitType == Units.METRIC) {
            _servicePressure = cylinderData["service_pressure"] as Float;
            _waterCapacity = cylinderData["water_capacity"] as Float;
            _nominalCapacity = _servicePressure * _waterCapacity;
        } else {
            var spPsi = cylinderData["service_pressure"] as Float;
            _servicePressure = Units.Convert.PsiToBar(spPsi);
            var nomCapCubicFeet = cylinderData["nominal_capacity"] as Float;
            _nominalCapacity = Units.Convert.CubicFeetToLiters(nomCapCubicFeet);
            _waterCapacity = _nominalCapacity / _servicePressure;
        }
    }

    function toDictionary() as Dictionary {
        return _originalDict;
    }

    function getTypeName() as String {
        return _typeName;
    }

    function getUnitType() as Units.UnitSystem {
        return _unitType;
    }

    function getServicePressure() as Float {
        return _servicePressure;
    }

    function getNominalCapacity() as Float {
        return _nominalCapacity;
    }

    function getWaterCapacity() as Float {
        return _waterCapacity;
    }

    function isMetric() as Boolean {
        return _unitType != null && _unitType == Units.METRIC;
    }

    function isStandard() as Boolean {
        return _unitType != null && _unitType == Units.IMPERIAL;
    }

    function volumeToPressure(volume as Float) as Float {
        return volume / _waterCapacity;
    }

}
