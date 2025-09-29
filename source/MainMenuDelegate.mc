import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Globals;
import Trolling;

class MainMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        if (item.getId() == :cylinder) {
            // cylinder selection screen
            var cylinderMenu = new CylinderSelectionMenu();
            var cylinderDelegate = new CylinderSelectionDelegate();
            WatchUi.pushView(cylinderMenu, cylinderDelegate, WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :scr) {
            // main scr selection screen
            var res = Screens.SCRSelection(
                new Method(Globals.dive, :setSCR),
                Globals.dive.getSCR(),
                "SCR"
            );
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :depth) {
            // main depth selection screen
            var res = Screens.DepthSelection(
                new Method(Globals.dive, :setBottomDepth),
                Globals.dive.getBottomDepth(),
                0.0,
                Constants.MAX_DEPTH,
                "Depth"
            );
            WatchUi.pushView(res[0], res[1], WatchUi.SLIDE_LEFT);
        } else if (item.getId() == :segments) {
            // segment table view
            var tableView = new SegmentTableView();
            var tableDelegate = new SegmentTableDelegate(tableView);
            WatchUi.pushView(tableView, tableDelegate, WatchUi.SLIDE_UP);
        } else if (item.getId() == :mingas) {
            var minGasMenu = new MinGasMenu();
            WatchUi.pushView(minGasMenu, new MinGasMenuDelegate(), WatchUi.SLIDE_UP);
        } else if (item.getId() == :po2calc) {
            var setcb = method(:ShowPO2Table) as Invokable;
            var fo2View = new NumberSelectionView(0.21, "%.2f", "", "FO2");
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
