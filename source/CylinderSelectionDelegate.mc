import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CylinderSelectionDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) as Void {
        if (!(item instanceof CylinderMenuItem)) {
            System.error("Cylinder menu item failed type check");
        }
        Globals.dive.setCylinder(item.cylinder);

        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}