import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Trolling;

class NumberSelectionDelegate extends WatchUi.BehaviorDelegate {
    private var _view as NumberSelectionView;
    private var _setcb as Invokable;
    private var _interval as Float;
    private var _max as Float;
    private var _min as Float;

    function initialize(
        view as NumberSelectionView,
        setcb as Invokable,
        interval as Float,
        min as Float,
        max as Float
    ) {
        BehaviorDelegate.initialize();
        _view = view;
        _setcb = setcb;
        _interval = interval;
        _min = min;
        _max = max;
    }

    function onKey(keyEvent as KeyEvent) as Boolean {
        var key = keyEvent.getKey();

        if (key != WatchUi.KEY_UP && key != WatchUi.KEY_DOWN) {
            return false;
        }

        var newValue = _view.GetValue();

        switch (key) {
            case WatchUi.KEY_UP:
                newValue += _interval;
                break;
            case WatchUi.KEY_DOWN:
                newValue -= _interval;
                break;
        }

        if (newValue > _max) { newValue = _max; }
        if (newValue < _min) { newValue = _min; }

        _view.SetValue(newValue);

        return true;
    }

    function onSelect() as Boolean {
        // Must pop ourselves first; if callback pushes a view and
        // we pop after, we will pop them
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        _setcb.invoke(_view.GetValue());
        return true;
    }

    function onBack() as Boolean {
        WatchUi.popView(WatchUi.SLIDE_RIGHT);
        return true;
    }
}