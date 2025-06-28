import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class SegmentTableView extends WatchUi.View {
    private var _settings as SegmentSettings;
    private var _segments as Array<Dictionary>;
    private var _scrollOffset as Number = 0;

    function initialize(settings as SegmentSettings) {
        View.initialize();
        _settings = settings;
        _segments = [];
        calculateSegments();
    }

    function calculateSegments() as Void {
        _segments = [];
        var startDepth = _settings.getDepth();
        var tankFactor = (80.0/3000)*100;
        
        for (var depth = startDepth; depth >= 20; depth -= 10) {
            var atm = (depth/33.3) + 1;
            var segment = ((_settings.getSCR() * atm)/tankFactor) * 100 * 5;
            
            _segments.add({
                "depth" => depth,
                "segment" => segment
            });
        }
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();
        
        var width = dc.getWidth();
        var height = dc.getHeight();
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, 10, Graphics.FONT_SMALL, "Segment Table", Graphics.TEXT_JUSTIFY_CENTER);
        
        var headerY = 30;
        dc.drawText(width / 4, headerY, Graphics.FONT_TINY, "Depth", Graphics.TEXT_JUSTIFY_CENTER);
        dc.drawText(3 * width / 4, headerY, Graphics.FONT_TINY, "Segment", Graphics.TEXT_JUSTIFY_CENTER);
        
        var lineHeight = 20;
        var startY = 50;
        var maxVisibleLines = (height - startY - 10) / lineHeight;
        
        for (var i = _scrollOffset; i < _segments.size() && i < _scrollOffset + maxVisibleLines; i++) {
            var segment = _segments[i];
            var yPos = startY + ((i - _scrollOffset) * lineHeight);
            
            var depthText = segment["depth"].toString() + " ft";
            var segmentText = segment["segment"].format("%.1f");
            
            dc.drawText(width / 4, yPos, Graphics.FONT_TINY, depthText, Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(3 * width / 4, yPos, Graphics.FONT_TINY, segmentText, Graphics.TEXT_JUSTIFY_CENTER);
        }
        
        if (_segments.size() > maxVisibleLines) {
            var scrollIndicator = (_scrollOffset + 1).toString() + "/" + (_segments.size() - maxVisibleLines + 1).toString();
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
        var height = 240;
        var lineHeight = 20;
        var maxVisibleLines = (height - 60) / lineHeight;
        
        if (_scrollOffset < _segments.size() - maxVisibleLines) {
            _scrollOffset += 1;
            WatchUi.requestUpdate();
        }
    }
}