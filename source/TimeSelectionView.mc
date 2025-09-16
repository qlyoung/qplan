import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class TimeSelectionView extends WatchUi.View {
    public var timeValue as Number; // in seconds

    function initialize(initialTimeSeconds as Number) {
        View.initialize();
        timeValue = initialTimeSeconds;
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
        dc.drawText(width / 2, height / 4, Graphics.FONT_MEDIUM, "Time", Graphics.TEXT_JUSTIFY_CENTER);

        var minutes = timeValue / 60;
        var seconds = timeValue % 60;
        var timeText = Lang.format("$1$:$2$", [minutes.format("%02d"), seconds.format("%02d")]);
        dc.drawText(width / 2, height / 2, Graphics.FONT_LARGE, timeText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(width / 2, 3 * height / 4, Graphics.FONT_SMALL, "UP/DOWN to adjust", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
    }
}