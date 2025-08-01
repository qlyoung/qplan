import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class MinGasMenuDelegate extends WatchUi.Menu2InputDelegate {
    function initialize() {
        Menu2InputDelegate.initialize();
    }

    function onSelect(item) as Void {
        System.println("Got mingas item:" + item.toString());
        if (item.getId() == :next_gas_depth) {
            // TODO: Create depth selection for next gas depth
        } else if (item.getId() == :problem_time) {
            // TODO: Create time selection for problem solving time
        } else if (item.getId() == :switch_time) {
            // TODO: Create time selection for gas switch time
        }
    }

/*
    function updateMenuLabels() as Void {
        var bottomDepthItem = _menu.findItemById(:bottom_depth) as WatchUi.MenuItem;
        if (bottomDepthItem != null) {
            var depthText = _settings.getBottomDepth().toString() + " ft";
            bottomDepthItem.setSubLabel(depthText);
        }

        var nextGasDepthItem = _menu.findItemById(:next_gas_depth) as WatchUi.MenuItem;
        if (nextGasDepthItem != null) {
            var depthText = _settings.getNextGasDepth().toString() + " ft";
            nextGasDepthItem.setSubLabel(depthText);
        }

        var problemTimeItem = _menu.findItemById(:problem_time) as WatchUi.MenuItem;
        if (problemTimeItem != null) {
            var timeText = _settings.getProblemSolvingTime().toString() + " min";
            problemTimeItem.setSubLabel(timeText);
        }

        var switchTimeItem = _menu.findItemById(:switch_time) as WatchUi.MenuItem;
        if (switchTimeItem != null) {
            var timeText = _settings.getGasSwitchTime().toString() + " min";
            switchTimeItem.setSubLabel(timeText);
        }

        WatchUi.requestUpdate();
    }
    */
}