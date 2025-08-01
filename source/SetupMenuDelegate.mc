import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SetupMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        System.println("Got item:" + item.toString());
        if (item.getId() == :scr) {
            var scrView = new SCRSelectionView();
            var scrDelegate = new SCRSelectionDelegate(scrView);
            WatchUi.pushView(scrView, scrDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :cylinder) {
            var cylinderMenu = createCylinderMenu();
            var cylinderDelegate = new CylinderSelectionDelegate();
            WatchUi.pushView(cylinderMenu, cylinderDelegate, WatchUi.SLIDE_LEFT);
        }
    }

    function createCylinderMenu() as WatchUi.Menu2 {
        var menu = new WatchUi.Menu2({:title => "Select Cylinder"});
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        
        for (var i = 0; i < tankData.size(); i++) {
            var tank = tankData[i] as Dictionary;
            var tankName = tank["cylinder_type_name"];
            menu.addItem(new WatchUi.MenuItem(tankName, null, tankName, {}));
        }
        
        return menu;
    }
}