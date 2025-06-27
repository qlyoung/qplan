import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class diveplanMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :calc_segment) {
            WatchUi.pushView(new Rez.Menus.SegmentMenu(), new diveplanSegmentDelegate(), WatchUi.SLIDE_UP);
        }
    }
}