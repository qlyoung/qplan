import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class diveplanSegmentDelegate extends WatchUi.Menu2InputDelegate {
    private var _settings as SegmentSettings;
    private var _menu as WatchUi.Menu2;

    function initialize(menu as WatchUi.Menu2) {
        Menu2InputDelegate.initialize();
        _settings = new SegmentSettings();
        _menu = menu;
        updateMenuLabels();
    }

    function onSelect(item) as Void {
        System.println("Got item:" + item.toString());
        if (item.getId() == :scr) {
            var scrView = new SCRSelectionView();
            scrView.setSCRValue(_settings.getSCR());
            var scrDelegate = new SCRSelectionDelegate(scrView, _settings, self);
            WatchUi.pushView(scrView, scrDelegate, WatchUi.SLIDE_UP);
        } else if (item.getId() == :depth) {
            var depthView = new DepthSelectionView();
            depthView.setDepthValue(_settings.getDepth());
            var depthDelegate = new DepthSelectionDelegate(depthView, _settings, self);
            WatchUi.pushView(depthView, depthDelegate, WatchUi.SLIDE_UP);
        } else if (item.getId() == :cylinder) {
            var cylinderMenu = createCylinderMenu();
            var cylinderDelegate = new CylinderSelectionDelegate(_settings, self);
            WatchUi.pushView(cylinderMenu, cylinderDelegate, WatchUi.SLIDE_UP);
        } else if (item.getId() == :view) {
            var tableView = new SegmentTableView(_settings);
            var tableDelegate = new SegmentTableDelegate(tableView);
            WatchUi.pushView(tableView, tableDelegate, WatchUi.SLIDE_UP);
        }
    }

    function updateMenuLabels() as Void {
        var scrItem = _menu.getItem(_menu.findItemById(:scr));
        if (scrItem != null) {
            var scrText = _settings.getSCR().format("%.2f") + " cf/min";
            scrItem.setSubLabel(scrText);
        }

        var depthItem = _menu.getItem(_menu.findItemById(:depth));
        if (depthItem != null) {
            var depthText = _settings.getDepth().toString() + " ft";
            depthItem.setSubLabel(depthText);
        }

        var cylinderItem = _menu.getItem(_menu.findItemById(:cylinder));
        if (cylinderItem != null) {
            cylinderItem.setSubLabel(_settings.getCylinderName());
        }
    }

    function createCylinderMenu() as WatchUi.Menu2 {
        var menu = new WatchUi.Menu2({:title => "Select Cylinder"});
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        
        for (var i = 0; i < tankData.size(); i++) {
            var tank = tankData[i];
            var tankName = tank["cylinder_type_name"];
            menu.addItem(new WatchUi.MenuItem(tankName, null, tankName, {}));
        }
        
        return menu;
    }
}