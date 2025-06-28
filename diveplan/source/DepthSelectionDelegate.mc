import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DepthSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as DepthSelectionView;
    private var _depthValue as Number = 100;
    private var _settings as SegmentSettings;
    private var _parentDelegate as diveplanSegmentDelegate;

    function initialize(view as DepthSelectionView, settings as SegmentSettings, parentDelegate as diveplanSegmentDelegate) {
        BehaviorDelegate.initialize();
        _view = view;
        _settings = settings;
        _parentDelegate = parentDelegate;
        _depthValue = _settings.getDepth();
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        
        if (key == WatchUi.KEY_UP) {
            _depthValue += 5;
            if (_depthValue > 200) {
                _depthValue = 200;
            }
            _view.setDepthValue(_depthValue);
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _depthValue -= 5;
            if (_depthValue < 10) {
                _depthValue = 10;
            }
            _view.setDepthValue(_depthValue);
            return true;
        }
        
        return false;
    }

    function onSelect() as Boolean {
        _settings.setDepth(_depthValue);
        _parentDelegate.updateMenuLabels();
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}