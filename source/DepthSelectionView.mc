import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class DepthSelectionView extends WatchUi.View {
    public var depthValue as Number = 100;

    function initialize(initialDepth as Number) {
        View.initialize();
        depthValue = initialDepth;
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
        dc.drawText(width / 2, height / 4, Graphics.FONT_MEDIUM, "Depth", Graphics.TEXT_JUSTIFY_CENTER);

        var depthText = depthValue.toString() + " ft";
        dc.drawText(width / 2, height / 2, Graphics.FONT_LARGE, depthText, Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(width / 2, 3 * height / 4, Graphics.FONT_SMALL, "UP/DOWN to adjust", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
    }
}