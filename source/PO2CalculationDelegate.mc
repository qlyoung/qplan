import Toybox.Lang;
import Toybox.WatchUi;

class PO2CalculationDelegate extends WatchUi.BehaviorDelegate {
    private var _view as PO2CalculationView;

    function initialize(view as PO2CalculationView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        if (key == WatchUi.KEY_UP) {
            _view.scrollUp();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.scrollDown();
            return true;
        }
        return false;
    }

    function onSwipe(swipeEvent as SwipeEvent) as Boolean {
        var direction = swipeEvent.getDirection();
        if (direction == WatchUi.SWIPE_UP) {
            _view.scrollDown();
            return true;
        } else if (direction == WatchUi.SWIPE_DOWN) {
            _view.scrollUp();
            return true;
        }
        return false;
    }

    function onSelect() as Boolean {
        // No action needed - table is view-only
        return false;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}