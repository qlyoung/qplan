import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Trolling;

class TimeSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as TimeSelectionView;
    private var _set as Invokable;

    function initialize(view as TimeSelectionView, set as Invokable) {
        BehaviorDelegate.initialize();
        _view = view;
        _set = set;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            _view.timeValue += 15;
            // max 99:59
            if (_view.timeValue > 5999) {
                _view.timeValue = 5999;
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.timeValue -= 15;
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