import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class NumberSelectionView extends WatchUi.View {
    private var _value as Float;
    private var _title as String;
    private var _unit as String;
    private var _fmt as String;

    function initialize(value as Float, fmt as String, unit as String, title as String) {
        View.initialize();
        _value = value;
        _fmt = fmt;
        _unit = unit;
        _title = title;
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 4, Graphics.FONT_MEDIUM, _title, Graphics.TEXT_JUSTIFY_CENTER);

        var valueText = _value.format(_fmt) + " " + _unit;
        dc.drawText(width / 2, height / 2, Graphics.FONT_LARGE, valueText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(width / 2, 3 * height / 4, Graphics.FONT_SMALL, "UP/DOWN to adjust", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function SetValue(value as Float) {
        _value = value;
        WatchUi.requestUpdate();
    }

    function GetValue() as Float {
        return _value;
    }
}