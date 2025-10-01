import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class ScrollableDelegate extends WatchUi.BehaviorDelegate {
    private var _view as ScrollableView;

    function initialize(view as ScrollableView) {
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

    function onNextPage() as Boolean {
        _view.scrollDown();
        return true;
    }

    function onPreviousPage() as Boolean {
        _view.scrollUp();
        return true;
    }

    function onSelect() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}
