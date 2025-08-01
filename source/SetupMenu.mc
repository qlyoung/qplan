import Toybox.WatchUi;

class SetupMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Setup"});
        buildMenu();
    }

    function buildMenu() as Void {
        var cylinderItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_cylinder),
            DiveSettings.cylinder["cylinder_type_name"],
            :cylinder,
            {}
        );
        
        var scrText = DiveSettings.scrRate.format("%.2f") + " cf/min";
        var scrItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_scr),
            scrText,
            :scr,
            {}
        );

        addItem(cylinderItem);
        addItem(scrItem);
    }

    function updateLabels() as Void {
        var cylinderItem = getItem(findItemById(:cylinder));
        if (cylinderItem != null) {
            cylinderItem.setSubLabel(DiveSettings.cylinder["cylinder_type_name"]);
        }

        var scrItem = getItem(findItemById(:scr));
        if (scrItem != null) {
            var scrText = DiveSettings.scrRate.format("%.2f") + " cf/min";
            scrItem.setSubLabel(scrText);
        }
    }

    function onShow() as Void {
        updateLabels();
    }
}