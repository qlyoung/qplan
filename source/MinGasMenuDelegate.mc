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
            var ds = new DepthSelectionView(DiveSettings.MinGas.GetBottomDepth());
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetBottomDepth);
            WatchUi.pushView(ds, new DepthSelectionDelegate(ds, setcb, 5, 0, -1), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_depth) {
            var ds = new DepthSelectionView(DiveSettings.MinGas.GetSwitchDepth());
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetSwitchDepth);
            WatchUi.pushView(ds, new DepthSelectionDelegate(ds, setcb, 5, 0, -1), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_scr) {
            var scrView = new SCRSelectionView();
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetSCR);
            WatchUi.pushView(scrView, new SCRSelectionDelegate(scrView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_problem_time) {
            var timeView = new TimeSelectionView(DiveSettings.MinGas.GetProblemSolvingTime());
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetProblemSolvingTime);
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_time) {
            var timeView = new TimeSelectionView(DiveSettings.MinGas.GetGasSwitchTime());
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetGasSwitchTime);
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_ascent_rate) {
            /*
            var rateView = new AscentRateSelectionView(DiveSettings.MinGas.GetAscentRate());
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetAscentRate);
            WatchUi.pushView(rateView, new AscentRateSelectionDelegate(rateView, setcb), WatchUi.SLIDE_LEFT);
            */
        }
    }
}