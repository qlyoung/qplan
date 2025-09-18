import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using DiveSettings;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        System.println("Got item:" + item.toString());
        if (item.getId() == :scr) {
            var scrView = new SCRSelectionView();
            var setcb = new Lang.Method(DiveSettings, :SetSCR);
            var scrDelegate = new SCRSelectionDelegate(scrView, setcb);
            WatchUi.pushView(scrView, scrDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :cylinder) {
            var cylinderMenu = new CylinderSelectionMenu();
            var cylinderDelegate = new CylinderSelectionDelegate();
            WatchUi.pushView(cylinderMenu, cylinderDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :depth) {
            var depthView = new DepthSelectionView(DiveSettings.GetBottomDepth());
            var setcb = new Lang.Method(DiveSettings, :SetBottomDepth);
            var depthDelegate = new DepthSelectionDelegate(depthView, setcb, 5, 0, -1);
            WatchUi.pushView(depthView, depthDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :segments) {
            var tableView = new SegmentTableView();
            var tableDelegate = new SegmentTableDelegate(tableView);
            WatchUi.pushView(tableView, tableDelegate, WatchUi.SLIDE_UP);
        } else if (item.getId() == :mingas) {
            var minGasMenu = new MinGasMenu();
            WatchUi.pushView(minGasMenu, new MinGasMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item.getId() == :po2calc) {
            var fo2View = new FO2SelectionView(0.21); // Default to air
            var fo2Delegate = new FO2SelectionDelegate(fo2View, null, 0.01, 0.10, 1.00);
            WatchUi.pushView(fo2View, fo2Delegate, WatchUi.SLIDE_LEFT);
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
