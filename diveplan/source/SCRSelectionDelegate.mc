import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SCRSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as SCRSelectionView;
    private var _scrValue as Float = 0.7;
    private var _settings as SegmentSettings;
    private var _parentDelegate as diveplanSegmentDelegate;

    function initialize(view as SCRSelectionView, settings as SegmentSettings, parentDelegate as diveplanSegmentDelegate) {
        BehaviorDelegate.initialize();
        _view = view;
        _settings = settings;
        _parentDelegate = parentDelegate;
        _scrValue = _settings.getSCR();
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        
        if (key == WatchUi.KEY_UP) {
            _scrValue += 0.05;
            if (_scrValue > 10.0) {
                _scrValue = 10.0;
            }
            _view.setSCRValue(_scrValue);
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _scrValue -= 0.05;
            if (_scrValue < 0.0) {
                _scrValue = 0.0;
            }
            _view.setSCRValue(_scrValue);
            return true;
        }
        
        return false;
    }

    function onSelect() as Boolean {
        _settings.setSCR(_scrValue);
        _parentDelegate.updateMenuLabels();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}