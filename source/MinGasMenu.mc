import Toybox.WatchUi;
import Toybox.Lang;
import Toybox.Math;
import Globals;
import Units;

class MinGasMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Min Gas"});
        buildMenu();
    }

    function buildMenu() as Void {
        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_calculate,
            "",
            :calculate,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_contingency_scr,
            "",
            :min_gas_scr,
            {}
        ));


        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_switch_depth,
            "",
            :min_gas_switch_depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_problem_time,
            "",
            :min_gas_problem_time,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_switch_time,
            "",
            :min_gas_switch_time,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_ascent_rate,
            "",
            :min_gas_ascent_rate,
            {}
        ));

    }

    function onShow() as Void {
        var unitSystem = Units.GetSystem();

        var scrItem = getItem(findItemById(:min_gas_scr));
        if (scrItem != null) {
            var scr = Units.Convert.LitersToSystem(Globals.dive.getContingencySCR());
            var scrText = scr.format((unitSystem == Units.METRIC) ? "%d" : "%.2f");
            scrText += " " + Units.Symbols.SCR();
            scrItem.setSubLabel(scrText);
        }

        var switchDepthItem = getItem(findItemById(:min_gas_switch_depth));
        if (switchDepthItem != null) {
            var switchDepth = Globals.dive.getSwitchDepth();
            switchDepth = Units.Convert.MetersToSystem(switchDepth);
            switchDepth = Math.round(switchDepth);
            var switchDepthText = switchDepth.format("%d") + " " + Units.Symbols.Depth();
            switchDepthItem.setSubLabel(switchDepthText);
        }

        var problemTimeItem = getItem(findItemById(:min_gas_problem_time));
        if (problemTimeItem != null) {
            var problemTime = Globals.dive.getProblemSolvingTime();
            problemTime = Math.round((problemTime/60.0)/.1) * .1;
            var probTimeText = problemTime.format("%.1f") + " min";
            problemTimeItem.setSubLabel(probTimeText);
        }

        var switchTimeItem = getItem(findItemById(:min_gas_switch_time));
        if (switchTimeItem != null) {
            var switchTime = Globals.dive.getGasSwitchTime();
            switchTime = Math.round((switchTime/60.0)/.1) * .1;
            var switchTimeText = switchTime.format("%.1f") + " min";
            switchTimeItem.setSubLabel(switchTimeText);
        }

        var ascentRateItem = getItem(findItemById(:min_gas_ascent_rate));
        if (ascentRateItem != null) {
            var ascRate = Globals.dive.getAscentRate();
            ascRate = Units.Convert.MetersToSystem(ascRate);
            ascRate = Math.round(ascRate);
            var ascRateText = ascRate.format("%d") + " " + Units.Symbols.DepthChange();
            ascentRateItem.setSubLabel(ascRateText);
        }
    }
}