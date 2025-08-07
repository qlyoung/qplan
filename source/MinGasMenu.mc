import Toybox.WatchUi;
import Toybox.Lang;

class MinGasMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Min Gas"});
        buildMenu();
    }

    function buildMenu() as Void {
        addItem(new WatchUi.MenuItem("Calculate", null, :calculate, {}));

        addItem(new WatchUi.MenuItem(
            "Next Gas Depth",
            DiveSettings.MinGas.NextGasDepth.toString() + " ft",
            :next_gas_depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Problem Time",
            DiveSettings.MinGas.ProblemSolvingTime.toString() + " min",
            :problem_time,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Switch Time",
            DiveSettings.MinGas.GasSwitchTime.toString() + " min",
            :switch_time,
            {}
        ));
    }

    function onShow() as Void {
        var nextGasItem = getItem(findItemById(:next_gas_depth));
        if (nextGasItem != null) {
            nextGasItem.setSubLabel(DiveSettings.MinGas.NextGasDepth.toString() + " ft");
        }

        var problemTimeItem = getItem(findItemById(:problem_time));
        if (problemTimeItem != null) {
            problemTimeItem.setSubLabel(DiveSettings.MinGas.ProblemSolvingTime.toString() + " min");
        }

        var switchTimeItem = getItem(findItemById(:switch_time));
        if (switchTimeItem != null) {
            switchTimeItem.setSubLabel(DiveSettings.MinGas.GasSwitchTime.toString() + " min");
        }
    }
}