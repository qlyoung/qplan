import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MinGasMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        System.println("Got mingas item:" + item.toString());
        if (item.getId() == :calculate) {
            WatchUi.pushView(new CalcMinGasView(), new CalcMinGasDelegate(), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_bottom_depth) {
            var ds = new NumberSelectionView(DiveSettings.MinGas.GetBottomDepth() as Float, "%d", "ft", "Depth");
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetBottomDepth);
            WatchUi.pushView(ds, new NumberSelectionDelegate(ds, setcb, 5.0, 0.0, 1000.0), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_depth) {
            var ds = new NumberSelectionView(DiveSettings.MinGas.GetSwitchDepth() as Float, "%d", "ft", "Switch depth");
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetSwitchDepth);
            WatchUi.pushView(ds, new NumberSelectionDelegate(ds, setcb, 5.0, 0.0, 1000.0), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_scr) {
            var scrView = new NumberSelectionView(DiveSettings.MinGas.GetContingencySCR(), "%.2f", "cf/min", "SCR");
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetSCR);
            WatchUi.pushView(scrView, new NumberSelectionDelegate(scrView, setcb, .05, 0.0, 10.0), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_problem_time) {
            var timeView = new TimeSelectionView(DiveSettings.MinGas.GetProblemSolvingTime());
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetProblemSolvingTime);
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_time) {
            var timeView = new TimeSelectionView(DiveSettings.MinGas.GetGasSwitchTime());
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetGasSwitchTime);
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_ascent_rate) {
            var rateView = new NumberSelectionView(DiveSettings.MinGas.GetAscentRate() as Float, "%d", "ft/min", "Ascent rate");
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetAscentRate);
            WatchUi.pushView(rateView, new NumberSelectionDelegate(rateView, setcb, 1.0, 1.0, 100.0), WatchUi.SLIDE_LEFT);
        }
    }
}