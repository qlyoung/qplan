import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MinGasMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        if (item.getId() == :calculate) {
            WatchUi.pushView(new CalcMinGasView(), new CalcMinGasDelegate(), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_bottom_depth) {
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetBottomDepth);
            var res = Screens.DepthSelection(DiveSettings.MinGas.GetBottomDepth(), setcb, 0.0, DiveSettings.GetMaxDepth(), "Depth");
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_depth) {
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetSwitchDepth);
            var res = Screens.DepthSelection(DiveSettings.MinGas.GetSwitchDepth(), setcb, 0.0, DiveSettings.MinGas.GetBottomDepth(), "Depth");
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_scr) {
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetContingencySCR);
            var res = Screens.SCRSelection(DiveSettings.MinGas.GetContingencySCR(), setcb, "SCR");
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_problem_time) {
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetProblemSolvingTime);
            var timeView = new TimeSelectionView(DiveSettings.MinGas.GetProblemSolvingTime());
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_time) {
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetGasSwitchTime);
            var timeView = new TimeSelectionView(DiveSettings.MinGas.GetGasSwitchTime());
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_ascent_rate) {
            var setcb = new Lang.Method(DiveSettings.MinGas, :SetAscentRate);
            var res = Screens.AscentRateSelection(DiveSettings.MinGas.GetAscentRate(), setcb, "Ascent rate");
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        }
    }
}