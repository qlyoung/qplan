import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

import Units;

class PO2CalculationView extends WatchUi.View {
    private var _scrollOffset as Number = 0;
    private var _maxScrollOffset as Number = 0;
    private var _fo2 as Float;

    function initialize(fo2 as Float) {
        View.initialize();
        _fo2 = fo2;
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        // Title
        dc.drawText(width / 2, 10, Graphics.FONT_SMALL, "PO2 Calculator", Graphics.TEXT_JUSTIFY_CENTER);

        // FO2 input display
        var fo2Text = "FO2: " + _fo2.format("%.2f");
        dc.drawText(width / 2, 30, Graphics.FONT_TINY, fo2Text, Graphics.TEXT_JUSTIFY_CENTER);

        // Table headers
        var headerY = 50;
        dc.drawText(width / 4, headerY, Graphics.FONT_TINY, "Depth", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(3 * width / 4, headerY, Graphics.FONT_TINY, "PO2", Graphics.TEXT_JUSTIFY_CENTER);

        var lineHeight = 18;
        var startY = 70;
        var maxVisibleLines = (height - startY - 10) / lineHeight;

        // Generate depth/PO2 data
        var data = generatePO2Data();
        _maxScrollOffset = (data.size() > maxVisibleLines) ? data.size() - maxVisibleLines : 0;

        for (var i = _scrollOffset; i < data.size() && i < _scrollOffset + maxVisibleLines; i++) {
            var row = data[i] as Dictionary;
            var yPos = startY + ((i - _scrollOffset) * lineHeight);
            var depth = Math.round(Units.Convert.MetersToSystem(row["depth"])).format("%d");
            var depthText = depth + " " + Units.Symbols.Depth();
            var po2Text = row["po2"].format("%.2f");

            dc.drawText(width / 4, yPos, Graphics.FONT_TINY, depthText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(3 * width / 4, yPos, Graphics.FONT_TINY, po2Text, Graphics.TEXT_JUSTIFY_CENTER);
        }

        // Scroll indicator
        if (data.size() > maxVisibleLines) {
            var scrollIndicator = (_scrollOffset + 1).toString() + "/" + (data.size() - maxVisibleLines + 1).toString();
            dc.drawText(width - 10, height - 15, Graphics.FONT_TINY, scrollIndicator, Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }

    function onHide() as Void {
    }

    function generatePO2Data() as Array {
        var data = [] as Array;

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

    function scrollUp() as Void {
        if (_scrollOffset > 0) {
            _scrollOffset -= 1;
            WatchUi.requestUpdate();
        }
    }

    function scrollDown() as Void {
        if (_scrollOffset < _maxScrollOffset) {
            _scrollOffset += 1;
            WatchUi.requestUpdate();
        }
    }

    function setFO2(fo2 as Float) as Void {
        _fo2 = fo2;
        _scrollOffset = 0; // Reset scroll when FO2 changes
        WatchUi.requestUpdate();
    }

    function getFO2() as Float {
        return _fo2;
    }
}