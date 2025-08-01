import Toybox.WatchUi;

class SegmentMenu extends WatchUi.Menu2 {

    function initialize() {
        Menu2.initialize({:title => "Segments"});
        buildMenu();
    }

    function buildMenu() as Void {
        var depthText = DiveSettings.Segments.MaxDepth.toString() + " ft";
        var depthItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_depth),
            depthText,
            :depth,
            {}
        );
        
        var viewItem = new WatchUi.MenuItem(
            WatchUi.loadResource(Rez.Strings.menu_label_view),
            "",
            :view,
            {}
        );

        addItem(depthItem);
        addItem(viewItem);
    }

    function updateLabels() as Void {
        var depthItem = getItem(findItemById(:depth));
        if (depthItem != null) {
            var depthText = DiveSettings.Segments.MaxDepth.toString() + " ft";
            depthItem.setSubLabel(depthText);
        }
    }

    function onShow() as Void {
        updateLabels();
    }
}