import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Units;

/*
 * Models a Cylinder.
 */
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

    function initialize(
        name as String,
        units as Units.UnitSystem,
        servicePressure as Float or Number,
        nominalCapacity as Float or Number,
        waterCapacity as Float or Number)
    {
        _typeName = name;
        _unitType = units;
        _servicePressure = servicePressure.toFloat();
        _nominalCapacity = nominalCapacity.toFloat();
        _waterCapacity = waterCapacity.toFloat();
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

    function equals(other as Object?) as Boolean {
        if (!(other instanceof Cylinder)) {
            return false;
        }

        return CompareDict(toDictionary(), other.toDictionary());
    }

    function toDictionary() as Dictionary {
        var result = {} as Dictionary;

        result["cylinder_type_name"] = _typeName;
        result["unit_type"] = _unitType;
        result["service_pressure"] = _servicePressure;
        result["nominal_capacity"] = _nominalCapacity;
        result["water_capacity"] = _waterCapacity;

        return result;
    }

    static function fromDictionary(cylinderData as Dictionary) as Cylinder {
        var name = cylinderData["cylinder_type_name"];
        if (!(name instanceof String)) {
            System.error("cylinder_type_name failed type check");
        }

        var unitSystem;
        var units = cylinderData["unit_type"];
        if (units instanceof Number or units instanceof String) {
            switch (units) {
                case Units.METRIC:
                    unitSystem = Units.METRIC;
                    break;
                case Units.IMPERIAL:
                    unitSystem = Units.IMPERIAL;
                    break;
                default:
                    System.error("unit_type invalid value");
            }
        } else {
            System.error("unit_type failed type check");
        }

        // All numeric values are assumed to be in metric units
        var servicePressure = cylinderData["service_pressure"];
        if (!(servicePressure instanceof Number or servicePressure instanceof Float)) {
            System.error("service_pressure failed type check");
        }

        var waterCapacity = cylinderData["water_capacity"];
        if (!(waterCapacity instanceof Float or waterCapacity instanceof Number)) {
            System.error("water_capacity failed type check");
        }

        var nominalCapacity = cylinderData["nominal_capacity"];
        if (!(nominalCapacity instanceof Float or nominalCapacity instanceof Number)) {
            System.error("nominal_capacity failed type check");
        }

        return new Cylinder(name, unitSystem, servicePressure, nominalCapacity, waterCapacity);
    }

    static function fromDictionaryPresentation(cylinderData as Dictionary) as Cylinder {
        var name = cylinderData["cylinder_type_name"];
        if (!(name instanceof String)) {
            System.error("cylinder_type_name failed type check");
        }

        var unitSystem;
        var units = cylinderData["unit_type"];
        if (units instanceof Number or units instanceof String) {
            switch (units) {
                case Units.METRIC:
                case "metric":
                    unitSystem = Units.METRIC;
                    break;
                case Units.IMPERIAL:
                case "imperial":
                    unitSystem = Units.IMPERIAL;
                    break;
                default:
                    System.error("unit_type invalid value");
            }
        } else {
            System.error("unit_type failed type check");
        }

        var servicePressure;
        var waterCapacity;
        var nominalCapacity;
        if (unitSystem == Units.METRIC) {
            servicePressure = cylinderData["service_pressure"];
            if (!(servicePressure instanceof Number or servicePressure instanceof Float)) {
                System.error("service_pressure failed type check");
            }

            waterCapacity = cylinderData["water_capacity"];
            if (!(waterCapacity instanceof Float or waterCapacity instanceof Number)) {
                System.error("water_capacity failed type check");
            }
            nominalCapacity = servicePressure * waterCapacity;
        } else {
            var servicePressurePsi = cylinderData["service_pressure"];
            if (!(servicePressurePsi instanceof Number or servicePressurePsi instanceof Float)) {
                System.error("service_pressure failed type check");
            }
            servicePressure = Units.Convert.PsiToBar(servicePressurePsi);

            var nominalCapacityCf = cylinderData["nominal_capacity"];
            if (!(nominalCapacityCf instanceof Float or nominalCapacityCf instanceof Number)) {
                System.error("nominal_capacity failed type check");
            }

            nominalCapacity = Units.Convert.CubicFeetToLiters(nominalCapacityCf);
            waterCapacity = nominalCapacity / servicePressure;
        }

        return new Cylinder(name, unitSystem, servicePressure, nominalCapacity, waterCapacity);
    }

    static function Default() as Cylinder {
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks);
        if (tankData instanceof Array) {
            var fv = tankData[0];
            if (fv instanceof Dictionary) {
                return Cylinder.fromDictionaryPresentation(fv);
            } else {
                System.error("Failed type check");
            }
        } else {
            System.error("Failed type check");
        }
    }
}
