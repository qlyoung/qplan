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
            "Bottom Depth",
            DiveSettings.MinGas.GetBottomDepth().toString() + " ft",
            :min_gas_bottom_depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "SCR",
            DiveSettings.MinGas.GetSCR().toString() + " cf/min",
            :min_gas_scr,
            {}
        ));


        addItem(new WatchUi.MenuItem(
            "Switch Depth",
            DiveSettings.MinGas.GetSwitchDepth().toString() + " ft",
            :min_gas_switch_depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Problem Time",
            DiveSettings.MinGas.GetProblemSolvingTime().toString() + " min",
            :min_gas_problem_time,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Switch Time",
            DiveSettings.MinGas.GetGasSwitchTime().toString() + " min",
            :min_gas_switch_time,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Ascent Rate",
            DiveSettings.MinGas.GetAscentRate().toString() + " ft/min",
            :min_gas_ascent_rate,
            {}
        ));

    }

    function onShow() as Void {
        var bottomDepthItem = getItem(findItemById(:min_gas_bottom_depth));
        if (bottomDepthItem != null) {
            bottomDepthItem.setSubLabel(DiveSettings.MinGas.GetBottomDepth().toString() + " ft");
        }

        var scrItem = getItem(findItemById(:min_gas_scr));
        if (scrItem != null) {
            scrItem.setSubLabel(DiveSettings.MinGas.GetSCR().toString() + " cf/min");
        }

        var switchDepthItem = getItem(findItemById(:min_gas_switch_depth));
        if (switchDepthItem != null) {
            switchDepthItem.setSubLabel(DiveSettings.MinGas.GetSwitchDepth().toString() + " ft");
        }

        var problemTimeItem = getItem(findItemById(:min_gas_problem_time));
        if (problemTimeItem != null) {
            problemTimeItem.setSubLabel(Math.ceil(DiveSettings.MinGas.GetProblemSolvingTime()/60.0) + " min");
        }

        var switchTimeItem = getItem(findItemById(:min_gas_switch_time));
        if (switchTimeItem != null) {
            switchTimeItem.setSubLabel(Math.ceil(DiveSettings.MinGas.GetGasSwitchTime()/60.0) + " min");
        }

        var ascentRateItem = getItem(findItemById(:min_gas_ascent_rate));
        if (ascentRateItem != null) {
            ascentRateItem.setSubLabel(DiveSettings.MinGas.GetAscentRate().toString() + " ft/min");
        }
    }
}