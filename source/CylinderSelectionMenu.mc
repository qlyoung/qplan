import Toybox.WatchUi;
import Toybox.Lang;

class CylinderSelectionMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Select Cylinder"});
        buildMenu();
    }

    function buildMenu() as Void {
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        for (var i = 0; i < tankData.size(); i++) {
            var tank = tankData[i] as Dictionary;
            var tankName = tank["cylinder_type_name"];
            addItem(new WatchUi.MenuItem(tankName, null, tankName, {}));
        }
    }
}