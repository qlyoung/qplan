import Toybox.Graphics;
import Toybox.Lang;
import Toybox.WatchUi;

class ResultsView extends WatchUi.View {
    private var _settings as SegmentSettings;

    function initialize(settings as SegmentSettings) {
        View.initialize();
        _settings = settings;
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
        dc.drawText(width / 2, height / 6, Graphics.FONT_MEDIUM, "Segment Results", Graphics.TEXT_JUSTIFY_CENTER);
        
        var yPos = height / 3;
        var lineHeight = 25;
        
        var scrText = "SCR: " + _settings.getSCR().format("%.2f") + " cf/min";
        dc.drawText(width / 2, yPos, Graphics.FONT_SMALL, scrText, Graphics.TEXT_JUSTIFY_CENTER);
        yPos += lineHeight;
        
        var depthText = "Depth: " + _settings.getDepth().toString() + " ft";
        dc.drawText(width / 2, yPos, Graphics.FONT_SMALL, depthText, Graphics.TEXT_JUSTIFY_CENTER);
        yPos += lineHeight;
        
        var cylinderText = "Cylinder: " + _settings.getCylinder();
        dc.drawText(width / 2, yPos, Graphics.FONT_SMALL, cylinderText, Graphics.TEXT_JUSTIFY_CENTER);
        yPos += lineHeight;
        
        var tankFactor = (80.0/3000)*100;
        var atm = (_settings.getDepth()/33.3) + 1;
        var segment = ((_settings.getSCR() * atm)/tankFactor) * 100 * 5;

        dc.drawText(width / 2, yPos + lineHeight, Graphics.FONT_SMALL, "Segment: " + segment.toString(), Graphics.TEXT_JUSTIFY_CENTER);
    }

    function onHide() as Void {
    }
}