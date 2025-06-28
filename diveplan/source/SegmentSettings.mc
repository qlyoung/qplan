import Toybox.Lang;

class SegmentSettings {
    public var scrRate as Float = 0.70;
    public var depth as Number = 100;
    public var cylinder as String = "AL80";

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

    function setCylinder(cyl as String) as Void {
        cylinder = cyl;
    }

    function getCylinder() as String {
        return cylinder;
    }
}