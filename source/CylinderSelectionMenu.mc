import Toybox.WatchUi;
import Toybox.Lang;

class CylinderMenuItem extends WatchUi.MenuItem {

    var cylinder as Cylinder;

    function initialize(cylinder as Cylinder) {
        var label = cylinder.getTypeName();
        var sublabel = formatServicePressure(cylinder);
        var identifier = cylinder.getTypeName();
        self.cylinder = cylinder;

        // var icon = loadResource(cylinder.isDouble() ?  Rez.Drawables.DoubleTank : Rez.Drawables.Tank) as Float;
        var icon = cylinder.isDouble() ? Rez.Drawables.DoubleTank : Rez.Drawables.Tank;

        MenuItem.initialize(label, sublabel, identifier, {:icon => icon});
    }

    private function formatServicePressure(cylinder as Cylinder) as String {
        var servicePressure = cylinder.getServicePressure();
        var pressureSymbol = Units.Symbols.getSymbol(cylinder.getUnitType(), Units.PRESSURE);
        var volumeSymbol = Units.Symbols.getSymbol(cylinder.getUnitType(), Units.VOLUME);

        // Convert service pressure and capacity to the cylinder's native unit type
        var displayPressure;
        var displayCapacity;
        if (cylinder.getUnitType() == Units.METRIC) {
            displayPressure = servicePressure;
            displayCapacity = cylinder.getWaterCapacity();
        } else {
            displayPressure = Units.Convert.BarToPsi(servicePressure);
            displayCapacity = Units.Convert.LitersToCubicFeet(cylinder.getNominalCapacity());
        }

        var pressureLabel = displayPressure.format("%d") + " " + pressureSymbol;
        var capLabel = Math.round(displayCapacity).format("%d") + " " + volumeSymbol;
        return pressureLabel + " / " + capLabel;
    }
}

class CylinderSelectionMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => Rez.Strings.menu_label_cylinder_select, :icon => Rez.Drawables.Tank});
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
