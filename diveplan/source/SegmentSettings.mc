import Toybox.Lang;

class SegmentSettings {
    public var scrRate as Float = 0.70;
    public var depth as Number = 100;
    public var cylinder as String = "AL80";
    public var selectedCylinder as Dictionary = {
        "cylinder_type_name" => "AL80",
        "service_pressure" => 3000,
        "nominal_capacity" => 80,
        "unit_type" => "standard"
    };

    function initialize() {
    }

    function setSCR(rate as Float) as Void {
        scrRate = rate;
    }

    function getSCR() as Float {
        return scrRate;
    }

    function setDepth(d as Number) as Void {
        depth = d;
    }

    function getDepth() as Number {
        return depth;
    }

    function setCylinder(cyl as Dictionary) as Void {
        selectedCylinder = cyl;
    }

    function getCylinder() as Dictionary {
        return selectedCylinder;
    }

    function getCylinderName() as String {
        return selectedCylinder["cylinder_type_name"];
    }
}
