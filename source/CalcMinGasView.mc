import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class CalcMinGasView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
        View.onShow();
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);

        var minGasData = DiveCalculations.CalculateMinGas();

        dc.drawText(width / 8 - 5, height / 8, Graphics.FONT_SYSTEM_LARGE, "Min Gas", Graphics.TEXT_JUSTIFY_LEFT);

        // cylinder
        dc.drawText(5 * width / 6, height / 9, Graphics.FONT_SYSTEM_LARGE, DiveSettings.GetCylinder()["cylinder_type_name"], Graphics.TEXT_JUSTIFY_CENTER);

        var consumptionText = "C: " + minGasData["consumption"].format("%.1f") + " cf/min";
        dc.drawText(width / 8 - 10, height / 3 - 5, Graphics.FONT_XTINY, consumptionText, Graphics.TEXT_JUSTIFY_LEFT);

        var depthRangeText = "(" + DiveSettings.MinGas.GetBottomDepth().format("%d") + " -> " + DiveSettings.MinGas.GetSwitchDepth().format("%d") + ")";
        var avgPressureText = "A: " + minGasData["avg_pressure"].format("%.1f") + " ATA " + depthRangeText;
        dc.drawText(width / 8 - 10, height / 3 + 20, Graphics.FONT_XTINY, avgPressureText, Graphics.TEXT_JUSTIFY_LEFT);

        // All of these should already be multiples of 60, but round up just in case
        var problemSolveMinutes = Math.ceil(DiveSettings.MinGas.GetProblemSolvingTime()/60.0) as Number;
        var ascentTimeMinutes = Math.ceil(minGasData["ascent_time"]/60.0) as Number;
        var switchTimeMinutes = Math.ceil(DiveSettings.MinGas.GetGasSwitchTime()/60.0) as Number;
        var totalTimeMinutes = Math.ceil((minGasData["total_time"]/60.0)) as Number;

        var timeRangeText = "(" + problemSolveMinutes.format("%d") + "+" + ascentTimeMinutes.format("%d") + "+" + switchTimeMinutes.format("%d") + ")";
        var timeText = "T: " + totalTimeMinutes.format("%d") + " min " + timeRangeText;
        dc.drawText(width / 8 - 10, height / 3 + 45, Graphics.FONT_XTINY, timeText, Graphics.TEXT_JUSTIFY_LEFT);

        // Result
        var cfText = minGasData["min_gas_volume"].format("%.1f") + " cf";
        var psiText = minGasData["min_gas_pressure"].format("%d") + " psi";
        var minGasText = cfText + " / " + psiText;

        dc.drawText(width / 2, 2 * height / 3 + 15, Graphics.FONT_SMALL, minGasText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
        View.onHide();
    }
}