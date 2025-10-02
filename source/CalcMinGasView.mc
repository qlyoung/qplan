import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class CalcMinGasView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MinGasLayout(dc));
    }

    function onUpdate(dc as Dc) as Void {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        var minGasData = Globals.dive.calculateMinGas();

        var cylinderTypeLabel = View.findDrawableById("cylinderTypeLabel") as Text;
        cylinderTypeLabel.setText(Globals.dive.getCylinder().getTypeName());

        var mgc = Units.Convert.LitersToSystem(minGasData["consumption"]);
        var consText;
        if (Units.GetSystem() == Units.METRIC) {
            mgc = Math.round(mgc);
            consText = mgc.format("%d");
        } else {
            mgc = Math.round(mgc/.1) * .1;
            consText = mgc.format("%.1f");
        }
        var consumptionText = "C: " + consText + " " + Units.Symbols.SCR();
        var consumptionLabel = View.findDrawableById("consumptionLabel") as Text;
        consumptionLabel.setText(consumptionText);

        // These are rounded instead of ceiling/floor; if we were to round a
        // bottom depth of 29.5 meters to 30m, and the user verified the output
        // using 30m they may get a larger min gas # than we show, which is
        // confusing
        var bd = Math.round(Units.Convert.MetersToSystem(Globals.dive.getBottomDepth()));
        var sd = Math.round(Units.Convert.MetersToSystem(Globals.dive.getSwitchDepth()));
        var depthRangeText = "(" + bd.format("%d") + " -> " + sd.format("%d") + ")";
        var avgPressureText = "A: " + minGasData["avg_pressure"].format("%.1f") + " ATA " + depthRangeText;
        var avgPressureLabel = View.findDrawableById("avgPressureLabel") as Text;
        avgPressureLabel.setText(avgPressureText);

        var problemSolveMinutes = Math.ceil(Globals.dive.getProblemSolvingTime()/60.0) as Number;
        var ascentTimeMinutes = Math.ceil(minGasData["ascent_time"]/60.0) as Number;
        var switchTimeMinutes = Math.ceil(Globals.dive.getGasSwitchTime()/60.0) as Number;
        var totalTimeMinutes = Math.ceil((minGasData["total_time"]/60.0)) as Number;

        var timeRangeText = "(" + problemSolveMinutes.format("%d") + "+" + ascentTimeMinutes.format("%d") + "+" + switchTimeMinutes.format("%d") + ")";
        var timeText = "T: " + totalTimeMinutes.format("%d") + " min " + timeRangeText;
        var timeLabel = View.findDrawableById("timeLabel") as Text;
        timeLabel.setText(timeText);

        // Ceil liters to the nearest 1l and format as an integer
        // Ceil cubic feet to the nearest .1cf and format with 1 decimal
        var mgv = Units.Convert.LitersToSystem(minGasData["min_gas_volume"]);
        var roundTo = Units.GetSystem() == Units.METRIC ? 1.0 : 0.1;
        var fmt = Units.GetSystem() == Units.METRIC ? "%d" : "%.1f";
        mgv = Math.ceil(mgv / roundTo) * roundTo;
        var vText = mgv.format(fmt) + " " + Units.Symbols.Volume();

        // Ceil bar to the nearest .1bar and format with 1 decimal
        // Ceil PSI to the nearest 1psi and format as an integer
        var mgp = Units.Convert.BarToSystem(minGasData["min_gas_pressure"]);
        roundTo = Units.GetSystem() == Units.METRIC ? 0.1 : 1;
        mgp = Math.ceil(mgp / roundTo) * roundTo;
        fmt = Units.GetSystem() == Units.METRIC ? "%.1f" : "%d";
        var pText = mgp.format(fmt) + " " + Units.Symbols.Pressure();

        var minGasText = vText + " / " + pText;
        var resultLabel = View.findDrawableById("resultLabel") as Text;
        resultLabel.setText(minGasText);

        View.onUpdate(dc);
    }
}
