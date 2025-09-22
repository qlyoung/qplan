import Toybox.WatchUi;
import Toybox.Math;

module Screens {
    function DepthSelection(depth, setcb, min, max, title) as [View, BehaviorDelegate] {
        var units = Units.GetSystem();
        var roundTo = (Units.GetSystem() == Units.METRIC) ? 1.0 : 5.0;
        depth = Math.round(depth / roundTo) * roundTo; 
        var fmt = "%d";
        var sym = Units.Depth();
        var inc = (units == Units.METRIC) ? 1.0 : 5.0;
        var view = new NumberSelectionView(depth, fmt, sym, title);
        var del = new NumberSelectionDelegate(view, setcb, inc, min, max);
        return [view, del];
    }

    function SCRSelection(scr, setcb, title) as [View, BehaviorDelegate] {
        var units = Units.GetSystem();
        var roundTo = (units == Units.METRIC) ? 1.0 : .05;
        scr = Math.round(scr / roundTo) * roundTo;
        var fmt = (units == Units.METRIC) ? "%d" : "%.2f";
        var sym = Units.SCR();
        var inc = (units == Units.METRIC) ? 1 : .05;
        var min = (units == Units.METRIC) ? 10.0 : 0.3;
        var max = (units == Units.METRIC) ? 85.0 : 3.0;
        var view = new NumberSelectionView(scr, fmt, sym, title);
        var del = new NumberSelectionDelegate(view, setcb, inc, min, max);
        return [view, del];
    }

    function AscentRateSelection(rate, setcb, title) as [View, BehaviorDelegate] {
        var units = Units.GetSystem();
        rate = Math.round(rate);
        var fmt = "%d";
        var sym = Units.DepthChange();
        var inc = 1.0;
        var min = 1.0;
        var max = (units == Units.METRIC) ? 30.0 : 100.0;
        var view = new NumberSelectionView(rate, fmt, sym, "Ascent rate");
        var del = new NumberSelectionDelegate(view, setcb, inc, min, max);
        return [view, del];
    }
}