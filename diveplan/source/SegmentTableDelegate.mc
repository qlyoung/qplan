import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class SegmentTableDelegate extends WatchUi.BehaviorDelegate {
    private var _view as SegmentTableView;

    function initialize(view as SegmentTableView) {
        BehaviorDelegate.initialize();
        _view = view;
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