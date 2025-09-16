import Toybox.WatchUi;

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

        var scrText = DiveSettings.GetSCR().format("%.2f") + " cf/min";
        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_scr),
            scrText,
            :scr,
            {}
        ));

        var depthText = DiveSettings.GetBottomDepth().toString() + " ft";
        addItem(new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_depth),
            depthText,
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
    }

    function updateLabels() as Void {
        var cylinderItem = getItem(findItemById(:cylinder));
        if (cylinderItem != null) {
            cylinderItem.setSubLabel(DiveSettings.GetCylinder()["cylinder_type_name"]);
        }

        var scrItem = getItem(findItemById(:scr));
        if (scrItem != null) {
            var scrText = DiveSettings.GetSCR().format("%.2f") + " cf/min";
            scrItem.setSubLabel(scrText);
        }

        var depthItem = getItem(findItemById(:depth));
        if (depthItem != null) {
            var depthText = DiveSettings.GetBottomDepth().toString() + " ft";
            depthItem.setSubLabel(depthText);
        }
    }

    function onShow() as Void {
        updateLabels();
    }
}