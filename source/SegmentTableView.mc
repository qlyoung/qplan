import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

import Constants;

class SegmentTableView extends WatchUi.View {
    private var _scrollOffset as Number = 0;
    private var _maxScrollOffset as Number = 0;

    function initialize() {
        View.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.SegmentTableLayout(dc));
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        var cylinderTypeLabel = View.findDrawableById("cylinderTypeLabel") as Text;
        cylinderTypeLabel.setText(Globals.dive.getCylinder().getTypeName());

        var scrLabel = View.findDrawableById("scrLabel") as Text;
        var roundTo = Units.GetSystem() == Units.METRIC ? 1 : .01;
        var scr = Math.round(Units.Convert.LitersToSystem(Globals.dive.getSCR()) / roundTo) * roundTo;
        var fmt = Units.GetSystem() == Units.METRIC ? "%d" : "%.2f";
        var scrText = scr.format(fmt) + " " + Units.Symbols.SCR();
        scrLabel.setText(scrText);

        var segLabel = View.findDrawableById("timeLabel") as Text;
        segLabel.setText("@ " + Constants.SEGMENT_LENGTH.format("%d") + " min");

        // Calculate segments
        var interval = (Units.GetSystem() == Units.METRIC) ? 1.0 : Units.Convert.FeetToMeters(10.0);
        var startDepth = Globals.dive.getBottomDepth();
        if (Units.GetSystem() == Units.IMPERIAL) {
            startDepth = Units.Convert.FeetToMeters(
                Math.ceil(Units.Convert.MetersToFeet(startDepth) / 10.0) * 10.0
            );
        } else {
            startDepth = Math.ceil(startDepth);
        }

        var segments = DiveCalculations.CalculateSegmentTable(
            Globals.dive.getSCR(),
            Globals.dive.getCylinder(),
            startDepth,
            interval
        );

        // Get label and calculate how many lines it can fit based on position and display height
        var width = dc.getWidth();
        var height = dc.getHeight();
        var segmentTableText = View.findDrawableById("segmentTableText") as Text;
        var startY = segmentTableText.locY;
        var availableHeight = height - startY;
        var lineHeight = Graphics.getFontHeight(Graphics.FONT_TINY);
        var maxVisibleLines = Math.floor(availableHeight / lineHeight);

        _maxScrollOffset = segments.size() - 1;

        for (var i = _scrollOffset; i < segments.size() && i < _scrollOffset + maxVisibleLines; i++) {
            var segment = segments[i];
            var yPos = startY + ((i - _scrollOffset) * lineHeight);

            var depthText = Math.round(Units.Convert.MetersToSystem(segment["depth"])).format("%d") + Units.Symbols.Depth();
            var segmentText = Math.ceil(Units.Convert.BarToSystem(segment["segment"])).format("%d") + Units.Symbols.Pressure();

            var thirty = width * .30;
            dc.drawText(thirty, yPos, Graphics.FONT_TINY, depthText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width - thirty, yPos, Graphics.FONT_TINY, segmentText, Graphics.TEXT_JUSTIFY_CENTER);
        }

        if (segments.size() > maxVisibleLines) {
            var scrollIndicator = (_scrollOffset + 1).toString() + "/" + (segments.size() - maxVisibleLines + 1).toString();
            dc.drawText(width - 10, height - 15, Graphics.FONT_TINY, scrollIndicator, Graphics.TEXT_JUSTIFY_RIGHT);
        }
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
}
