import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class FO2SelectionView extends WatchUi.View {
    public var fo2Value as Float;

    function initialize(initialValue as Float) {
        View.initialize();
        fo2Value = initialValue;
    }

    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    function onShow() as Void {
    }

    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.clear();

        var width = dc.getWidth();
        var height = dc.getHeight();

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(width / 2, height / 4, Graphics.FONT_MEDIUM, "FO2", Graphics.TEXT_JUSTIFY_CENTER);

        var fo2Text = fo2Value.format("%.2f");
        dc.drawText(width / 2, height / 2, Graphics.FONT_LARGE, fo2Text, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(width / 2, 3 * height / 4, Graphics.FONT_SMALL, "UP/DOWN to adjust", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
    }
}