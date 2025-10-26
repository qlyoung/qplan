import Toybox.WatchUi;
import Toybox.Lang;

class CylinderSelectionMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Select Cylinder"});
        buildMenu();
    }

    function buildMenu() as Void {
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks) as Array;
        var filter = Units.GetSystem();
        // order the cylinders of the system unit type first
        for (var i = 0; i <= 1; i++) {
            for (var j = 0; j < tankData.size(); j++) {
                var tankDict = tankData[j] as Dictionary;
                var tank = new Cylinder(tankDict);
                var tankUnits = tank.getUnitType();
                if (tankUnits != filter) {
                    continue;
                }

                var tankNativeSP = tankDict["service_pressure"];
                if (!(tankNativeSP instanceof Number)) {
                    System.error("sevice_pressure failed type check");
                }
                var spText = tankNativeSP.format("%d") + " " + Units.Symbols.getSymbol(tank.getUnitType(), Units.PRESSURE);
                addItem(new WatchUi.MenuItem(
                    tank.getTypeName(),
                    spText,
                    tank.getTypeName(),
                    {})
                );
            }
            filter = (filter + 1) % 2;
        }
    }
}