import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Globals;
import Units;

class MinGasMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        if (item.getId() == :calculate) {
            WatchUi.pushView(new CalcMinGasView(), new CalcMinGasDelegate(), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_bottom_depth) {
            var res = Screens.DepthSelection(
                new Method(Globals.dive, :setMinGasBottomDepth),
                Globals.dive.getMinGasBottomDepth(),
                0.0,
                Constants.MAX_DEPTH,
                "Depth");
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_depth) {
            var res = Screens.DepthSelection(
                new Method(Globals.dive, :setSwitchDepth),
                Globals.dive.getSwitchDepth(),
                0.0,
                Globals.dive.getBottomDepth(),
                "Depth"
            );
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_scr) {
            var res = Screens.SCRSelection(
                new Method(Globals.dive, :setContingencySCR),
                Globals.dive.getContingencySCR(),
                "SCR"
            );
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_problem_time) {
            var setcb = new Method(Globals.dive, :setProblemSolvingTime);
            var timeView = new TimeSelectionView(Globals.dive.getProblemSolvingTime());
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_switch_time) {
            var setcb = new Method(Globals.dive, :setGasSwitchTime);
            var timeView = new TimeSelectionView(Globals.dive.getGasSwitchTime());
            WatchUi.pushView(timeView, new TimeSelectionDelegate(timeView, setcb), WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :min_gas_ascent_rate) {
            var res = Screens.AscentRateSelection(
                new Method(Globals.dive, :setAscentRate),
                Globals.dive.getAscentRate(),
                "Ascent rate"
            );
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        }
    }
}