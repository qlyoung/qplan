import Toybox.WatchUi;
import Toybox.Lang;

class CylinderMenuItem extends WatchUi.MenuItem {

    var cylinder as Cylinder;

    function initialize(cylinder as Cylinder) {
        var label = cylinder.getTypeName();
        var sublabel = formatServicePressure(cylinder);
        var identifier = cylinder.getTypeName();
        self.cylinder = cylinder;

        MenuItem.initialize(label, sublabel, identifier, {});
    }

    private function formatServicePressure(cylinder as Cylinder) as String {
        var servicePressure = cylinder.getServicePressure();
        var pressureSymbol = Units.Symbols.getSymbol(cylinder.getUnitType(), Units.PRESSURE);

        // Convert service pressure to the cylinder's native unit type
        var displayPressure;
        if (cylinder.getUnitType() == Units.METRIC) {
            displayPressure = servicePressure;
        } else {
            displayPressure = Units.Convert.BarToPsi(servicePressure);
        }

        return displayPressure.format("%d") + " " + pressureSymbol;
    }
}

class CylinderSelectionMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Select Cylinder"});
        buildMenu();
    }

    private function LoadCylinders() as Array<Cylinder> {
        var tankData = WatchUi.loadResource(Rez.JsonData.ScubaTanks);
        if (!(tankData instanceof Array)) {
            System.error("ScubaTanks resource failed type check");
        }

        var cylinders = [] as Array<Cylinder>;
        for (var i = 0; i < tankData.size(); i++) {
            var tankDict = tankData[i];
            if (!(tankDict instanceof Dictionary)) {
                System.error("ScubaTanks entry failed type check");
            }

            var cylinder = Cylinder.fromDictionaryPresentation(tankDict);
            cylinders.add(cylinder);
        }

        return cylinders;
    }

    function buildMenu() as Void {
        var cylinders = LoadCylinders();
        var filter = Units.GetSystem();
        // order the cylinders of the system unit type first
        for (var i = 0; i <= 1; i++) {
            for (var j = 0; j < cylinders.size(); j++) {
                var tank = cylinders[j];
                var tankUnits = tank.getUnitType();
                if (tankUnits != filter) {
                    continue;
                }

                addItem(new CylinderMenuItem(tank));
            }
            filter = (filter + 1) % 2;
        }
    }
}
