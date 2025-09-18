import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
using DiveSettings;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        if (item.getId() == :scr) {
            var scrView = new NumberSelectionView(DiveSettings.GetSCR(), "%.2f", "cf/min", "Set SCR");
            var setcb = new Lang.Method(DiveSettings, :SetSCR);
            var scrDelegate = new NumberSelectionDelegate(scrView, setcb, .05, 0.0, 10.0);
            WatchUi.pushView(scrView, scrDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :cylinder) {
            var cylinderMenu = new CylinderSelectionMenu();
            var cylinderDelegate = new CylinderSelectionDelegate();
            WatchUi.pushView(cylinderMenu, cylinderDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :depth) {
            var depthView = new NumberSelectionView(DiveSettings.GetBottomDepth() as Float, "%d", "ft", "Depth");
            var setcb = new Lang.Method(DiveSettings, :SetBottomDepth);
            var depthDelegate = new NumberSelectionDelegate(depthView, setcb, 5.0, 0.0, 1000.0);
            WatchUi.pushView(depthView, depthDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :segments) {
            var tableView = new SegmentTableView();
            var tableDelegate = new SegmentTableDelegate(tableView);
            WatchUi.pushView(tableView, tableDelegate, WatchUi.SLIDE_UP);
        } else if (item.getId() == :mingas) {
            var minGasMenu = new MinGasMenu();
            WatchUi.pushView(minGasMenu, new MinGasMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item.getId() == :po2calc) {
            var fo2View = new NumberSelectionView(0.21, "%.2f", "", "FO2");
            var setcb = method(:ShowPO2Table);
            var fo2Delegate = new NumberSelectionDelegate(fo2View, setcb, 0.01, 0.00, 1.00);
            WatchUi.pushView(fo2View, fo2Delegate, WatchUi.SLIDE_LEFT);
        }
    }

    function ShowPO2Table(fo2 as Float) {
        var po2View = new PO2CalculationView(fo2);
        var po2Delegate = new PO2CalculationDelegate(po2View);
        WatchUi.pushView(po2View, po2Delegate, WatchUi.SLIDE_LEFT);
    }
}
