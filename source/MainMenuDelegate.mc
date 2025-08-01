import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {

    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        if (item.getId() == :setup) {
            var setupMenu = new SetupMenu();
            WatchUi.pushView(setupMenu, new SetupMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item.getId() == :calc_segment) {
            var segmentMenu = new SegmentMenu();
            WatchUi.pushView(segmentMenu, new SegmentMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item.getId() == :calc_mingas) {
            var minGasMenu = new Rez.Menus.MinGasMenu();
            WatchUi.pushView(minGasMenu, new MinGasMenuDelegate(), WatchUi.SLIDE_UP);
        }
    }
}