import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class NumberSelectionView extends WatchUi.View {
    protected var _value as Float;
    protected var _title as String;
    protected var _unit as String;
    protected var _fmt as String;

    function initialize(value as Float, fmt as String, unit as String, title as String) {
        View.initialize();
        _value = value;
        _fmt = fmt;
        _unit = unit;
        _title = title;
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.NumberSelectionLayout(dc));
    }

    function renderValue() as String {
        return _value.format(_fmt) + " " + _unit;
    }

    function onUpdate(dc as Dc) as Void {
        var titleLabel = View.findDrawableById("titleLabel") as Text;
        titleLabel.setText(_title);

        var valueLabel = View.findDrawableById("valueLabel") as Text;
        valueLabel.setText(renderValue());

        View.onUpdate(dc);
    }

    function SetValue(value as Float) as Void {
        _value = value;
        WatchUi.requestUpdate();
    }

    function GetValue() as Float {
        return _value;
    }
}