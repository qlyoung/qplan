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
            var setcb = new Lang.Method(DiveSettings, :SetSCR);
            var res = Screens.SCRSelection(DiveSettings.GetSCR(), setcb, "SCR");
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :cylinder) {
            var cylinderMenu = new CylinderSelectionMenu();
            var cylinderDelegate = new CylinderSelectionDelegate();
            WatchUi.pushView(cylinderMenu, cylinderDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :depth) {
            var setcb = new Lang.Method(DiveSettings, :SetBottomDepth);
            var res = Screens.DepthSelection(DiveSettings.GetBottomDepth(), setcb, 0.0, DiveSettings.GetMaxDepth(), "Depth");
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
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
