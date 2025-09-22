import Toybox.WatchUi;
import Units;

class MainMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Qplanner"});
        buildMenu();
    }

    function buildMenu() as Void {
        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_cylinder),
            DiveSettings.GetCylinder()["cylinder_type_name"],
            :cylinder,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_scr),
            "",
            :scr,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_depth),
            "",
            :depth,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_calc_segment),
            null,
            :segments,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_calc_mingas),
            null,
            :mingas,
            {}
        ));

        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_calc_po2),
            null,
            :po2calc,
            {}
        ));
    }

    function updateLabels() as Void {
        var cylinderItem = getItem(findItemById(:cylinder));
        if (cylinderItem != null) {
            cylinderItem.setSubLabel(DiveSettings.GetCylinder()["cylinder_type_name"]);
        }

        var scrItem = getItem(findItemById(:scr));
        if (scrItem != null) {
            var units = Units.GetSystem();
            var roundTo = (units == Units.METRIC) ? 1 : .01;
            var scr = Math.round(DiveSettings.GetSCR() / roundTo) * roundTo;
            var scrText = scr.format((units == Units.METRIC) ? "%d" : "%.2f");
            scrText += " " + Units.SCR();
            scrItem.setSubLabel(scrText);
        }

        var depthItem = getItem(findItemById(:depth));
        if (depthItem != null) {
            var depth = Math.round(DiveSettings.GetBottomDepth());
            var depthText = depth.format("%d") + " " + Units.Depth();
            depthItem.setSubLabel(depthText);
        }
    }

    function onShow() as Void {
        updateLabels();
    }
}