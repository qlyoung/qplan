import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class diveplanMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        if (item.getId() == :calc_segment) {
            var segmentMenu = new Rez.Menus.SegmentMenu();
            WatchUi.pushView(segmentMenu, new diveplanSegmentDelegate(segmentMenu), WatchUi.SLIDE_UP);
        } else if (item.getId() == :calc_mingas) {
            var minGasMenu = new Rez.Menus.MinGasMenu();
            WatchUi.pushView(minGasMenu, new diveplanMinGasDelegate(minGasMenu), WatchUi.SLIDE_UP);
        }
    }
}