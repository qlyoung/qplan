import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class TimeSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as TimeSelectionView;
    private var _set as Lang.Method;

    function initialize(view as TimeSelectionView, set as Lang.Method) {
        BehaviorDelegate.initialize();
        _view = view;
        _set = set;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            _view.timeValue += 15; // increment by 15 seconds
            if (_view.timeValue > 5999) { // max 99:59
                _view.timeValue = 5999;
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.timeValue -= 15; // decrement by 15 seconds
            if (_view.timeValue < 0) {
                _view.timeValue = 0;
            }
            WatchUi.requestUpdate();
            return true;
        }

        return false;
    }

    function onSelect() as Boolean {
        _set.invoke(_view.timeValue);
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}