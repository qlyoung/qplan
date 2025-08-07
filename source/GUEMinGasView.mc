import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class GUEMinGasView extends WatchUi.View {

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

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        var minGasData = DiveCalculations.CalculateMinGas();
        System.println("Min gas:");
        System.println(minGasData);

        // Title
        dc.drawText(width / 2, height / 8, Graphics.FONT_MEDIUM, "Min Gas", Graphics.TEXT_JUSTIFY_CENTER);

        var consumptionText = "C: " + minGasData["consumption"].format("%.2f") + " cf/min";
        dc.drawText(width / 2, height / 3, Graphics.FONT_TINY, consumptionText, Graphics.TEXT_JUSTIFY_CENTER);

        var avgPressureText = "A: " + minGasData["avg_pressure"].format("%.1f") + " ATA";
        dc.drawText(width / 2, height / 3 + 25, Graphics.FONT_TINY, avgPressureText, Graphics.TEXT_JUSTIFY_CENTER);

        var timeText = "T: " + minGasData["total_time"].format("%.1f") + " min";
        dc.drawText(width / 2, height / 3 + 50, Graphics.FONT_TINY, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        // Result
        var cfText = minGasData["min_gas_volume"].format("%.1f") + " cf";
        var psiText = minGasData["min_gas_pressure"].format("%.0f") + " psi";
        var minGasText = cfText + " / " + psiText;

        dc.drawText(width / 2, 2 * height / 3 + 30, Graphics.FONT_SMALL, minGasText, Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
        View.onHide();
    }
}