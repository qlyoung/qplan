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
            "Bottom Depth", "",
            :min_gas_bottom_depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "SCR", "",
            :min_gas_scr,
            {}
        ));


        addItem(new WatchUi.MenuItem(
            "Switch Depth", "",
            :min_gas_switch_depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Problem Time", "",
            :min_gas_problem_time,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Switch Time", "",
            :min_gas_switch_time,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            "Ascent Rate", "",
            :min_gas_ascent_rate,
            {}
        ));

    }

    function onShow() as Void {
        var bottomDepthItem = getItem(findItemById(:min_gas_bottom_depth));
        if (bottomDepthItem != null) {
            var btmDepthText = DiveSettings.MinGas.GetBottomDepth().format("%d") + "ft";
            bottomDepthItem.setSubLabel(btmDepthText);
        }

        var scrItem = getItem(findItemById(:min_gas_scr));
        if (scrItem != null) {
            var scrText = DiveSettings.MinGas.GetContingencySCR().format("%.2f") + " cf/min";
            scrItem.setSubLabel(scrText);
        }

        var switchDepthItem = getItem(findItemById(:min_gas_switch_depth));
        if (switchDepthItem != null) {
            var switchDepthText = DiveSettings.MinGas.GetSwitchDepth().format("%d") + "ft";
            switchDepthItem.setSubLabel(switchDepthText);
        }

        var problemTimeItem = getItem(findItemById(:min_gas_problem_time));
        if (problemTimeItem != null) {
            var probTimeText = (DiveSettings.MinGas.GetProblemSolvingTime()/60.0).format("%.1f") + " min";
            problemTimeItem.setSubLabel(probTimeText);
        }

        var switchTimeItem = getItem(findItemById(:min_gas_switch_time));
        if (switchTimeItem != null) {
            var switchTimeText = (DiveSettings.MinGas.GetGasSwitchTime()/60.0).format("%.1f") + " min";
            switchTimeItem.setSubLabel(switchTimeText);
        }

        var ascentRateItem = getItem(findItemById(:min_gas_ascent_rate));
        if (ascentRateItem != null) {
            var ascRateText = DiveSettings.MinGas.GetAscentRate().format("%d") + " ft/min";
            ascentRateItem.setSubLabel(ascRateText);
        }
    }
}