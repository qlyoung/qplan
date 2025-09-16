import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CylinderSelectionDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onUpdate() {
    }

    function onSelect(item) as Void {
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        var selectedTank = null;

        // Find the tank that matches the selected menu item
        for (var i = 0; i < tankData.size(); i++) {
            var tank = tankData[i] as Dictionary;
            if (tank["cylinder_type_name"].equals(item.getId().toString())) {
                selectedTank = tank;
                break;
            }
        }

        if (selectedTank != null) {
            DiveSettings.SetCylinder(selectedTank);
        }

        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}