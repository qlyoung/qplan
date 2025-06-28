import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class diveplanMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :calc_segment) {
            var segmentMenu = new Rez.Menus.SegmentMenu();
            WatchUi.pushView(segmentMenu, new diveplanSegmentDelegate(segmentMenu), WatchUi.SLIDE_UP);
        }
    }
}