import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class CylinderSelectionDelegate extends WatchUi.Menu2InputDelegate {
    private var _settings as SegmentSettings;
    private var _parentDelegate as diveplanSegmentDelegate;

    function initialize(settings as SegmentSettings, parentDelegate as diveplanSegmentDelegate) {
        Menu2InputDelegate.initialize();
        _settings = settings;
        _parentDelegate = parentDelegate;
    }

    function onSelect(item) as Void {
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        var selectedTank = null;
        
        // Find the tank that matches the selected menu item
        for (var i = 0; i < tankData.size(); i++) {
            var tank = tankData[i];
            if (tank["cylinder_type_name"].equals(item.getId().toString())) {
                selectedTank = tank;
                break;
            }
        }
        
        if (selectedTank != null) {
            _settings.setCylinder(selectedTank);
            _parentDelegate.updateMenuLabels();
        }
        
        WatchUi.popView(WatchUi.SLIDE_DOWN);
    }
}