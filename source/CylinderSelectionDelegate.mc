import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CylinderSelectionDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item as MenuItem) as Void {
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array<Dictionary>;
        var selectedTank = null;

        // Find the tank that matches the selected menu item
        for (var i = 0; i < tankData.size(); i++) {
            var tank = tankData[i];

            var typeName = tank["cylinder_type_name"];
            var itemId = item.getId();

            if (!(typeName instanceof String)) {
                System.error("Cylinder type name failed type check");
            }
            if (itemId == null) {
                System.error("Item ID not found");
            }

            if (typeName.equals(itemId.toString())) {
                selectedTank = tank;
                break;
            }
        }

        if (selectedTank != null) {
            Globals.dive.setCylinder(selectedTank);
        }

        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}