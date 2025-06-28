import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class SCRSelectionView extends WatchUi.View {
    private var _scrValue as Float = 0.7;

    function initialize() {
        View.initialize();
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
        dc.drawText(width / 2, height / 4, Graphics.FONT_MEDIUM, "SCR Rate", Graphics.TEXT_JUSTIFY_CENTER);
        
        var scrText = _scrValue.format("%.2f") + " cf/min";
        dc.drawText(width / 2, height / 2, Graphics.FONT_LARGE, scrText, Graphics.TEXT_JUSTIFY_CENTER);
        
        dc.drawText(width / 2, 3 * height / 4, Graphics.FONT_SMALL, "UP/DOWN to adjust", Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
    }

    function setSCRValue(value as Float) as Void {
        _scrValue = value;
        WatchUi.requestUpdate();
    }

    function getSCRValue() as Float {
        return _scrValue;
    }
}