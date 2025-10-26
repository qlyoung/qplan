import Toybox.WatchUi;
import Toybox.Math;
import Toybox.Lang;

import Trolling;
import Constants;

module Screens {

    function DepthSelection(setcb as Invokable, depth as Float, minDepth as Float, maxDepth as Float, title as String) as [View, BehaviorDelegate] {
        var units = Units.GetSystem();

        depth = Units.Convert.MetersToSystem(depth);
        var min = Units.Convert.MetersToSystem(minDepth);
        var max = Units.Convert.MetersToSystem(maxDepth);
        var inc = (units == Units.METRIC) ? 1.0 : 5.0;

        depth = (Math.round(depth / inc) * inc).toFloat();
        min = (Math.ceil(min / inc) * inc).toFloat();
        max = (Math.floor(max / inc) * inc).toFloat();

        var fmt = "%d";
        var sym = Units.Symbols.Depth();
        var convertSetCb = new ChainedMethod([
            new Method(Units.Convert, :SystemToMeters),
            setcb
        ]);
        var view = new NumberSelectionView(depth, fmt, sym, title);
        var del = new NumberSelectionDelegate(view, convertSetCb, inc, min, max);
        return [view, del];
    }

    function SCRSelection(setcb as Invokable or Method, scr as Float, title as String) as [View, BehaviorDelegate] {
        var units = Units.GetSystem();

        scr = Units.Convert.LitersToSystem(scr);
        var min = Units.Convert.LitersToSystem(Constants.MIN_SCR);
        var max = Units.Convert.LitersToSystem(Constants.MAX_SCR);
        var inc = (units == Units.METRIC) ? 1.0 : .05;

        scr = (Math.round(scr / inc) * inc).toFloat();
        min = (Math.ceil(min / inc) * inc).toFloat();
        max = (Math.floor(max / inc) * inc).toFloat();

        var fmt = (units == Units.METRIC) ? "%d" : "%.2f";
        var sym = Units.Symbols.SCR();
        var convertSetCb = new ChainedMethod([
            new Method(Units.Convert, :SystemToLiters),
            setcb
        ]);
        var view = new NumberSelectionView(scr, fmt, sym, title);
        var del = new NumberSelectionDelegate(view, convertSetCb, inc, min, max);
        return [view, del];
    }

    function AscentRateSelection(setcb as Invokable, rate as Float, title as String) as [View, BehaviorDelegate] {
        rate = Units.Convert.MetersToSystem(rate);
        var inc = 1.0;
        var min = 1.0;
        var max = Units.Convert.MetersToSystem(Constants.ASCENT_RATE_MAX);

        rate = (Math.round(rate / inc) * inc).toFloat();
        min = (Math.ceil(min / inc) * inc).toFloat();
        max = (Math.floor(max / inc) * inc).toFloat();

        var fmt = "%d";
        var sym = Units.Symbols.DepthChange();
        var convertSetCb = new ChainedMethod([
            new Method(Units.Convert, :SystemToMeters),
            setcb
        ]);
        var view = new NumberSelectionView(rate, fmt, sym, title);
        var del = new NumberSelectionDelegate(view, convertSetCb, inc, min, max);
        return [view, del];
    }
}
