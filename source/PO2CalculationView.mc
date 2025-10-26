import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

import Units;

class PO2CalculationView extends ScrollableView {
    private var _fo2 as Float;

    function initialize(fo2 as Float) {
        ScrollableView.initialize();
        _fo2 = fo2;
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.PO2TableLayout(dc));
    }

    function updateLayout(dc as Dc) as Void {
        var fo2Label = View.findDrawableById("fo2Label") as Text;
        var fo2Text = _fo2.format("%.2f");
        fo2Label.setText(fo2Text);

        var modLabel = View.findDrawableById("modValue") as Text;
        var modDepth = DiveCalculations.CalculateDepthForPO2(1.4, _fo2);
        var modText = Math.round(Units.Convert.MetersToSystem(modDepth)).format("%d") + Units.Symbols.Depth();
        modLabel.setText(modText);

        var codLabel = View.findDrawableById("codValue") as Text;
        var codDepth = DiveCalculations.CalculateDepthForPO2(1.6, _fo2);
        var codText = Math.round(Units.Convert.MetersToSystem(codDepth)).format("%d") + Units.Symbols.Depth();
        codLabel.setText(codText);
    }

    function drawPO2Table(dc as Dc) as Void {
        // Generate depth/PO2 data
        var data = generatePO2Data();

        // Get label and calculate how many lines it can fit based on position and display height
        var width = dc.getWidth();
        var height = dc.getHeight();
        var po2TableText = View.findDrawableById("po2TableText") as Text;
        var startY = po2TableText.locY;
        var availableHeight = height - startY;
        var lineHeight = Graphics.getFontHeight(Graphics.FONT_TINY);
        var maxVisibleLines = Math.floor(availableHeight / lineHeight);

        setMaxScroll(data.size() - 1);

        for (var i = _scrollOffset; i < data.size() && i < _scrollOffset + maxVisibleLines; i++) {
            var row = data[i];
            var yPos = startY + ((i - _scrollOffset) * lineHeight);
            var depth = row["depth"];
            if (!(depth instanceof Float)) {
                System.error("Type check failed on depth");
            }
            var depthText = Math.round(Units.Convert.MetersToSystem(depth)).format("%d");
            depthText = depth + " " + Units.Symbols.Depth();
            var po2 = row["po2"];
            if (!(po2 instanceof Float)) {
                System.error("Type check failed on po2");
            }
            var po2Text = po2.format("%.2f");

            var thirty = width * .30;
            dc.drawText(thirty, yPos, Graphics.FONT_TINY, depthText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width - thirty, yPos, Graphics.FONT_TINY, po2Text, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function updateDynamic(dc as Dc) as Void {
        drawPO2Table(dc);
    }

    function onUpdate(dc as Dc) as Void {
        // Output display
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        updateLayout(dc);
        View.onUpdate(dc);
        // Must be done after View.onUpdate, or layout background will overwrite
        updateDynamic(dc);
    }

    function generatePO2Data() as Array<Dictionary<String, Float>> {
        var data = [] as Array<Dictionary<String, Float>>;

        var start = 0.0;
        var interval = (Units.GetSystem() == Units.METRIC) ? 5.0 : Units.Convert.FeetToMeters(10.0);
        var end = Math.ceil(Constants.MAX_DEPTH / interval) * interval;
        for (var depth = start; depth <= end; depth += interval) {
            var po2 = DiveCalculations.CalculatePO2(_fo2, depth);
            data.add({
                "depth" => depth,
                "po2" => po2
            });
        }

        return data;
    }

    function setFO2(fo2 as Float) as Void {
        _fo2 = fo2;
        _scrollOffset = 0;
        WatchUi.requestUpdate();
    }

    function getFO2() as Float {
        return _fo2;
    }
}