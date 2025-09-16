import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class DepthSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as DepthSelectionView;
    private var _set as Method;
    private var _minDepth as Number;
    private var _maxDepth as Number;
    private var _interval as Number;

    // view - the selection view
    // set - method to call when the value is set; will be called with the value
    function initialize(view as DepthSelectionView, set as Method, interval as Number, minDepth as Number, maxDepth as Number) {
        BehaviorDelegate.initialize();
        _view = view;
        _set = set;
        _minDepth = minDepth;
        _maxDepth = maxDepth;
        _interval = interval;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            _view.depthValue += _interval;
            if (_maxDepth != -1 && _view.depthValue > _maxDepth) {
                _view.depthValue = _maxDepth;
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.depthValue -= _interval;
            if (_minDepth != -1 && _view.depthValue < _minDepth) {
                _view.depthValue = _minDepth;
            }
            WatchUi.requestUpdate();
            return true;
        }

        return false;
    }

    function onSelect() as Boolean {
        _set.invoke(_view.depthValue);
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_DOWN);
        return true;
    }
}