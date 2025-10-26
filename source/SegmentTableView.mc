import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

import Constants;

class SegmentTableView extends ScrollableView {
    function initialize() {
        ScrollableView.initialize();
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.SegmentTableLayout(dc));
    }

    function updateLayout(dc as Dc) as Void {
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
    }

    function drawSegmentTable(dc as Dc) as Void {
        var interval = (Units.GetSystem() == Units.METRIC) ? 1.0 : Units.Convert.FeetToMeters(10.0);
        var startDepth = Globals.dive.getBottomDepth();
        if (Units.GetSystem() == Units.IMPERIAL) {
            startDepth = Units.Convert.FeetToMeters(
                (Math.ceil(Units.Convert.MetersToFeet(startDepth) / 10.0) * 10.0).toFloat()
            );
        } else {
            startDepth = Math.ceil(startDepth).toFloat();
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

        setMaxScroll(segments.size() - 1);

        for (var i = _scrollOffset; i < segments.size() && i < _scrollOffset + maxVisibleLines; i++) {
            var segment = segments[i];
            var yPos = startY + ((i - _scrollOffset) * lineHeight);

            var depth = segment["depth"];
            if (!(depth instanceof Float)) {
                System.error("Type check failed for depth");
            }
            var depthText = Math.round(Units.Convert.MetersToSystem(depth)).format("%d") + Units.Symbols.Depth();
            var segmentVal = segment["segment"];
            if (!(segmentVal instanceof Float)) {
                System.error("Type check failed for segment");
            }
            var segmentText = Math.ceil(Units.Convert.BarToSystem(segmentVal)).format("%d") + Units.Symbols.Pressure();

            var thirty = width * .30;
            dc.drawText(thirty, yPos, Graphics.FONT_TINY, depthText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width - thirty, yPos, Graphics.FONT_TINY, segmentText, Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    function updateDynamic(dc as Dc) as Void {
        drawSegmentTable(dc);
    }

    function onUpdate(dc as Dc) as Void {
        // Output display
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        updateLayout(dc);
        View.onUpdate(dc);
        // Must be done after View.onUpdate, or layout background will overwrite
        updateDynamic(dc);
    }
}
