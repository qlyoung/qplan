import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.System;

import Globals;

class diveplanApp extends Application.AppBase {

    function initialize() {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void {
        var diveDict = Storage.getValue("dive");
        if (diveDict == null) {
            var units = Units.GetSystem();
            if (units == Units.METRIC) { Globals.dive.setMetricDefaults(); }
            if (units == Units.IMPERIAL) { Globals.dive.setImperialDefaults(); }
        } else {
            Globals.dive.fromDictionary(diveDict);
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        Storage.setValue("dive", Globals.dive.toDictionary());
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new MainMenu(), new MainMenuDelegate() ];
    }

}

function getApp() as diveplanApp {
    return Application.getApp() as diveplanApp;
}