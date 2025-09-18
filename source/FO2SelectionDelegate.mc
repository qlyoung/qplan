import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class FO2SelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as FO2SelectionView;
    private var _set as Method or Null;
    private var _interval as Float;
    private var _minValue as Float;
    private var _maxValue as Float;

    function initialize(view as FO2SelectionView, set as Method or Null, interval as Float, minValue as Float, maxValue as Float) {
        BehaviorDelegate.initialize();
        _view = view;
        _set = set;
        _interval = interval;
        _minValue = minValue;
        _maxValue = maxValue;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key == WatchUi.KEY_UP) {
            _view.fo2Value += _interval;
            if (_view.fo2Value > _maxValue) {
                _view.fo2Value = _maxValue;
            }
            WatchUi.requestUpdate();
            return true;
        } else if (key == WatchUi.KEY_DOWN) {
            _view.fo2Value -= _interval;
            if (_view.fo2Value < _minValue) {
                _view.fo2Value = _minValue;
            }
            WatchUi.requestUpdate();
            return true;
        }

        return false;
    }

    function onSelect() as Boolean {
        if (_set != null) {
            _set.invoke(_view.fo2Value);
            WatchUi.popView(WatchUi.SLIDE_RIGHT);
        } else {
            // Navigate to PO2 table with selected FO2
            var po2View = new PO2CalculationView();
            po2View.setFO2(_view.fo2Value);
            var po2Delegate = new PO2CalculationDelegate(po2View);
            WatchUi.pushView(po2View, po2Delegate, WatchUi.SLIDE_LEFT);
        }
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}