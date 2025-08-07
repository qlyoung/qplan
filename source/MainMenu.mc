import Toybox.WatchUi;

class MainMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Qplanner"});
        buildMenu();
    }

    function buildMenu() as Void {
        var cylinderItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_cylinder),
            DiveSettings.Cylinder["cylinder_type_name"],
            :cylinder,
            {}
        );

        var scrText = DiveSettings.SCR.format("%.2f") + " cf/min";
        var scrItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_scr),
            scrText,
            :scr,
            {}
        );

        var depthText = DiveSettings.MaxDepth.toString() + " ft";
        var depthItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_depth),
            depthText,
            :depth,
            {}
        );

        var segmentTableItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_calc_segment),
            null,
            :segments,
            {}
        );

        var minGasItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_calc_mingas),
            null,
            :mingas,
            {}
        );

        addItem(cylinderItem);
        addItem(scrItem);
        addItem(depthItem);
        addItem(segmentTableItem);
        addItem(minGasItem);
    }

    function updateLabels() as Void {
        var cylinderItem = getItem(findItemById(:cylinder));
        if (cylinderItem != null) {
            cylinderItem.setSubLabel(DiveSettings.Cylinder["cylinder_type_name"]);
        }

        var scrItem = getItem(findItemById(:scr));
        if (scrItem != null) {
            var scrText = DiveSettings.SCR.format("%.2f") + " cf/min";
            scrItem.setSubLabel(scrText);
        }

        var depthItem = getItem(findItemById(:depth));
        if (depthItem != null) {
            var depthText = DiveSettings.MaxDepth.toString() + " ft";
            depthItem.setSubLabel(depthText);
        }
    }

    function onShow() as Void {
        updateLabels();
    }
}