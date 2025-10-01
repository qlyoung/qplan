import Toybox.Lang;

class TimeSelectionView extends NumberSelectionView {

    function initialize(initialTime as Number) {
        NumberSelectionView.initialize(
            initialTime as Float,
            "",
            "",
            "Time"
        );
    }
    function renderValue() as String {
        var nVal = _value.toLong();
        var seconds = nVal % 60;
        var minutes = nVal / 60;
        return Lang.format("$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);
    }
}