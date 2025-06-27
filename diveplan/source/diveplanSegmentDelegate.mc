import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class diveplanSegmentDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onMenu2Item(item as Symbol) as Void {
        
    }

    function onSelect(item) as Void {
        System.println("Got item:" + item.toString());
        if (item == :scr) {
            // allow scr selection
        } else if (item == :depth) {
            // allow depth selection
        } else if (item == :cylinder) {
            // allow cylinder selection
        } else if (item == :view) {
            // display segment table
        }
    }
}