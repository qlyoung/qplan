import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SegmentMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        System.println("Got item:" + item.toString());
        if (item.getId() == :depth) {
            var depthView = new DepthSelectionView(DiveSettings.Segments.MaxDepth);
            var depthDelegate = new DepthSelectionDelegate(depthView);
            WatchUi.pushView(depthView, depthDelegate, WatchUi.SLIDE_UP);
        } else if (item.getId() == :view) {
            var tableView = new SegmentTableView();
            var tableDelegate = new SegmentTableDelegate(tableView);
            WatchUi.pushView(tableView, tableDelegate, WatchUi.SLIDE_UP);
        }
    }
}