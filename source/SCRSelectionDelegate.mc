import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SCRSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as SCRSelectionView;

    function initialize(view as SCRSelectionView) {
        BehaviorDelegate.initialize();
        _view = view;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            _view.displayedSCR += 0.05;
            if (_view.displayedSCR > 10.0) {
                _view.displayedSCR = 10.0;
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.displayedSCR -= 0.05;
            if (_view.displayedSCR < 0.0) {
                _view.displayedSCR = 0.0;
            }
            WatchUi.requestUpdate();
            return true;
        }

        return false;
    }

    function onSelect() as Boolean {
        // Commit displayed SCR to actual SCR
        DiveSettings.SCR = _view.displayedSCR;
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}