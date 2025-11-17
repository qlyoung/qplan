import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Math;

import Constants;

class SegmentTableView extends ScrollableView {
    private var _segmentTable as Array<Dictionary<String, Float>>;
    private var _interval as Float;

    function initialize() {
        ScrollableView.initialize();
        _interval = (Units.GetSystem() == Units.METRIC) ? 1.0 : Units.Convert.FeetToMeters(10.0);
        _segmentTable = calcSegmentTable();
        resetScroll();
        setMaxScroll(_segmentTable.size() - 1);
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.SegmentTableLayout(dc));

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

    function calcSegmentTable() as Array<Dictionary<String, Float>> {
        // Start from maximum supported depth
        var startDepth = Constants.MAX_DEPTH;

        if (Units.GetSystem() == Units.IMPERIAL) {
            // Set start depth to the nearest 10ft, represented in meters
            var sdFt = Units.Convert.MetersToFeet(startDepth);
            var sdFtRounded = (Math.ceil(sdFt / 10.0) * 10.0).toFloat();
            startDepth = Units.Convert.FeetToMeters(sdFtRounded);
        }

        var segments = DiveCalculations.CalculateSegmentTable(
            Globals.dive.getSCR(),
            Globals.dive.getCylinder(),
            startDepth,
            _interval
        );

        return segments;
    }

    function resetScroll() as Void {
        var startDepth = _segmentTable[0]["depth"];
        if (!(startDepth instanceof Float)) {
            System.error("Segment depth failed type check");
        }

        // Calculate planned bottom depth with same rounding for scroll position
        var plannedDepth = Globals.dive.getBottomDepth();
        if (Units.GetSystem() == Units.IMPERIAL) {
            plannedDepth = Units.Convert.FeetToMeters(
                (Math.ceil(Units.Convert.MetersToFeet(plannedDepth) / 10.0) * 10.0).toFloat()
            );
        } else {
            plannedDepth = Math.ceil(plannedDepth).toFloat();
        }
        var initialScrollIndex = ((startDepth - plannedDepth) / _interval).toNumber();
        if (initialScrollIndex < 0) {
            initialScrollIndex = 0;
        }
        if (initialScrollIndex >= _segmentTable.size()) {
            initialScrollIndex = _segmentTable.size() - 1;
        }
        _scrollOffset = initialScrollIndex;
        updateScrollIndicators();
    }

    function drawSegmentTable(dc as Dc) as Void {
        // Get label and calculate how many lines it can fit based on position and display height
        var width = dc.getWidth();
        var height = dc.getHeight();
        var segmentTableText = View.findDrawableById("segmentTableText") as Text;
        var startY = segmentTableText.locY;
        var availableHeight = height - startY;
        var lineHeight = Graphics.getFontHeight(Graphics.FONT_TINY);
        var maxVisibleLines = Math.floor(availableHeight / lineHeight);

        // Output display
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

        for (var i = _scrollOffset; i < _segmentTable.size() && i < _scrollOffset + maxVisibleLines; i++) {
            var segment = _segmentTable[i];
            var yPos = startY + ((i - _scrollOffset) * lineHeight);

            var depth = segment["depth"];
            if (!(depth instanceof Float)) {
                System.error("Type check failed for depth");
            }
            var depthValue = Math.round(Units.Convert.MetersToSystem(depth));
            var depthText = depthValue.format("%d") + Units.Symbols.Depth();

            var segmentVal = segment["segment"];
            if (segmentVal == null) {
                System.error("Type check failed for segment");
            }
            var segmentValue = Math.ceil(Units.Convert.BarToSystem(segmentVal));
            var segmentText = segmentValue.format("%d") + Units.Symbols.Pressure();

            var thirty = width * .30;
            dc.drawText(thirty, yPos, Graphics.FONT_TINY, depthText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(width - thirty, yPos, Graphics.FONT_TINY, segmentText, Graphics.TEXT_JUSTIFY_CENTER);

            if (depthValue == 0) {
                break;
            }
        }
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        // Must be done after View.onUpdate, or layout background will overwrite
        drawSegmentTable(dc);
    }
}
