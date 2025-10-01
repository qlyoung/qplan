import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class ScrollableView extends WatchUi.View {
    protected var _scrollOffset as Number = 0;
    protected var _maxScrollOffset as Number = 0;

    function initialize() {
        View.initialize();
    }
    
    function onShow() {
        updateScrollIndicators();
    }

    function scrollUp() as Void {
        if (_scrollOffset > 0) {
            _scrollOffset -= 1;
            updateScrollIndicators();
            WatchUi.requestUpdate();
        }
    }

    function scrollDown() as Void {
        if (_scrollOffset < _maxScrollOffset) {
            _scrollOffset += 1;
            updateScrollIndicators();
            WatchUi.requestUpdate();
        }
    }

    protected function updateScrollIndicators() as Void {
        var scrollIndicatorUp = View.findDrawableById("scrollIndicatorUp");
        var scrollIndicatorDown = View.findDrawableById("scrollIndicatorDown");

        if (scrollIndicatorUp != null) {
            scrollIndicatorUp.setVisible(_scrollOffset > 0);
        }

        if (scrollIndicatorDown != null) {
            scrollIndicatorDown.setVisible(_scrollOffset < _maxScrollOffset);
        }
    }

    function setMaxScroll(offset) {
        _maxScrollOffset = offset;
        updateScrollIndicators();
    }
}
