import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class SegmentTableView extends WatchUi.View {
    private var _scrollOffset as Number = 0;
    private var _maxScrollOffset as Number = 0;

    function initialize() {
        View.initialize();
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

        //dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        //dc.drawText(width / 2, 10, Graphics.FONT_SMALL, "Segment Table", Graphics.TEXT_JUSTIFY_CENTER);

        var headerY = 45;
        dc.drawText(width / 4, headerY, Graphics.FONT_TINY, "Depth", Graphics.TEXT_JUSTIFY_CENTER);

        var lineHeight = 20;
        var startY = 75;
        var maxVisibleLines = (height - startY - 10) / lineHeight;

        var segments = DiveCalculations.CalculateSegmentTable();
        _maxScrollOffset = segments.size() - 1;

        for (var i = _scrollOffset; i < segments.size() && i < _scrollOffset + maxVisibleLines; i++) {
            var segment = segments[i];
            var yPos = startY + ((i - _scrollOffset) * lineHeight);

            var unit_depth = "m";
            var unit_pressure = "bar";
            if (DiveSettings.GetCylinder()["unit_type"].equals("standard")) {
                unit_depth = "ft";
                unit_pressure = "psi";
            }

            var depthText = segment["depth"].format("%d") + unit_depth;
            var segmentText = segment["segment"].format("%d") + unit_pressure;

            dc.drawText(5 * width / 6, height / 9, Graphics.FONT_SYSTEM_LARGE, DiveSettings.GetCylinder()["cylinder_type_name"], Graphics.TEXT_JUSTIFY_CENTER);

            dc.drawText(width / 4, yPos, Graphics.FONT_TINY, depthText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(3 * width / 4, yPos, Graphics.FONT_TINY, segmentText, Graphics.TEXT_JUSTIFY_CENTER);
        }

        if (segments.size() > maxVisibleLines) {
            var scrollIndicator = (_scrollOffset + 1).toString() + "/" + (segments.size() - maxVisibleLines + 1).toString();
            dc.drawText(width - 10, height - 15, Graphics.FONT_TINY, scrollIndicator, Graphics.TEXT_JUSTIFY_RIGHT);
        }
    }

    function onHide() as Void {
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
