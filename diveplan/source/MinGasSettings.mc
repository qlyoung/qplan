import Toybox.Lang;

class MinGasSettings {
    public var bottomDepth as Number = 100;
    public var nextGasDepth as Number = 70;
    public var problemSolvingTime as Number = 2;
    public var gasSwitchTime as Number = 1;

    function initialize() {
    }

    function setBottomDepth(depth as Number) as Void {
        bottomDepth = depth;
    }

    function getBottomDepth() as Number {
        return bottomDepth;
    }

    function setNextGasDepth(depth as Number) as Void {
        nextGasDepth = depth;
    }

    function getNextGasDepth() as Number {
        return nextGasDepth;
    }

    function setProblemSolvingTime(time as Number) as Void {
        problemSolvingTime = time;
    }

    function getProblemSolvingTime() as Number {
        return problemSolvingTime;
    }

    function setGasSwitchTime(time as Number) as Void {
        gasSwitchTime = time;
    }

    function getGasSwitchTime() as Number {
        return gasSwitchTime;
    }
}