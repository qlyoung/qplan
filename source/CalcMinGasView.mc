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

    function onShow() as Void {
        View.onShow();
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
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

        var mgv = Math.round(Units.Convert.LitersToSystem(minGasData["min_gas_volume"]));
        var mgp = Math.round(Units.Convert.BarToSystem(minGasData["min_gas_pressure"]));
        var vText = mgv.format("%d") + " " + Units.Symbols.Volume();
        var pText = mgp.format("%d") + " " + Units.Symbols.Pressure();
        var minGasText = vText + " / " + pText;
        var resultLabel = View.findDrawableById("resultLabel") as Text;
        resultLabel.setText(minGasText);
    }

    function onHide() as Void {
        View.onHide();
    }
}
