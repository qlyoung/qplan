import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;

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
        var unitSystem = Units.GetSystem();

        var bottomDepthItem = getItem(findItemById(:min_gas_bottom_depth));
        if (bottomDepthItem != null) {
            var btmDepth = Math.round(DiveSettings.MinGas.GetBottomDepth());
            var btmDepthText = btmDepth.format("%d") + " " + Units.Depth();
            bottomDepthItem.setSubLabel(btmDepthText);
        }

        var scrItem = getItem(findItemById(:min_gas_scr));
        if (scrItem != null) {
            var scr = DiveSettings.MinGas.GetContingencySCR();
            var scrText = scr.format((unitSystem == Units.METRIC) ? "%d" : "%.2f");
            scrText += " " + Units.SCR();
            scrItem.setSubLabel(scrText);
        }

        var switchDepthItem = getItem(findItemById(:min_gas_switch_depth));
        if (switchDepthItem != null) {
            var switchDepthText = DiveSettings.MinGas.GetSwitchDepth().format("%d");
            switchDepthText += " " + Units.Depth();
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
            var ascRateText = DiveSettings.MinGas.GetAscentRate().format("%d");
            ascRateText += " " + Units.DepthChange();
            ascentRateItem.setSubLabel(ascRateText);
        }
    }
}