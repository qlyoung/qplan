import Toybox.WatchUi;
import Toybox.Lang;
import Units;

class MainMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => Rez.Strings.AppName});
        buildMenu();
    }

    function buildMenu() as Void {
        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_cylinder,
            "",
            :cylinder,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_scr,
            "",
            :scr,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_bottom_depth,
            "",
            :depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_segments,
            null,
            :segments,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_mingas,
            null,
            :mingas,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            Rez.Strings.menu_label_calc_po2,
            null,
            :po2calc,
            {}
        ));
    }

    function updateLabels() as Void {
        var cylinderItem = getItem(findItemById(:cylinder));
        if (cylinderItem != null) {
            cylinderItem.setSubLabel(Globals.dive.getCylinder().getTypeName());
        }

        var scrItem = getItem(findItemById(:scr));
        if (scrItem != null) {
            var units = Units.GetSystem();
            var roundTo = (units == Units.METRIC) ? 1 : .01;
            var scr = Math.round(Units.Convert.LitersToSystem(Globals.dive.getSCR()) / roundTo) * roundTo;
            var scrText = scr.format((units == Units.METRIC) ? "%d" : "%.2f");
            scrText += " " + Units.Symbols.SCR();
            scrItem.setSubLabel(scrText);
        }

        var depthItem = getItem(findItemById(:depth));
        if (depthItem != null) {
            var depth = Math.round(Units.Convert.MetersToSystem(Globals.dive.getBottomDepth()));
            var depthText = depth.format("%d") + " " + Units.Symbols.Depth();
            depthItem.setSubLabel(depthText);
        }
    }

    function onShow() as Void {
        updateLabels();
    }
}