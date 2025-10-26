import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Application.Storage;
import Toybox.System;

import Globals;

class QplannerApp extends Application.AppBase {

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
            if (diveDict instanceof Dictionary) {
                // Q: Why is this parameter cast necessary?
                // A: Moron C
                Globals.dive.fromDictionary(diveDict as Dictionary);
            } else {
                System.error("Dive dictionary failed type check");
            }
        }
    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void {
        Storage.setValue("dive", Globals.dive.toDictionary() as PropertyValueType);
    }

    // Return the initial view of your application here
    function getInitialView() as [Views] or [Views, InputDelegates] {
        return [ new MainMenu(), new MainMenuDelegate() ];
    }

}

function getApp() as QplannerApp {
    return Application.getApp() as QplannerApp;
}