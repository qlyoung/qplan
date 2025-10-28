import Toybox.Lang;

class TimeSelectionDelegate extends NumberSelectionDelegate {

    const MIN_TIME as Number = 0;
    // max 99:59
    const MAX_TIME as Number = 5999;
    const INTERVAL as Number = 15;

    function initialize(view as TimeSelectionView, setcb as Invokable) {
        NumberSelectionDelegate.initialize(
            view,
            setcb,
            INTERVAL.toFloat(),
            MIN_TIME.toFloat(),
            MAX_TIME.toFloat()
        );
    }
}
