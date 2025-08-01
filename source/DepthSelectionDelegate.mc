import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

typedef HasDepth as interface {
    var depth as Number;
};

class DepthSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as DepthSelectionView;
    private var _target as HasDepth;

    function initialize(view as DepthSelectionView, target as HasDepth) {
        BehaviorDelegate.initialize();
        _target = target;
        _view = view;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();
        
        if (key == WatchUi.KEY_UP) {
            _view.depthValue += 5;
            if (_view.depthValue > 200) {
                _view.depthValue = 200;
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.depthValue -= 5;
            if (_view.depthValue < 10) {
                _view.depthValue = 10;
            }
            WatchUi.requestUpdate();
            return true;
        }
                
        return false;
    }

    function onSelect() as Boolean {
        DiveSettings.Segments.MaxDepth = _view.depthValue;
        _target.depth = _view.depthValue;
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}