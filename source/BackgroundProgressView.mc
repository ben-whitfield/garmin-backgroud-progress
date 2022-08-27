import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Toybox.ActivityMonitor;
// import Toybox.Time.Gregorian;

class BackgroundProgressView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        var myStats = System.getSystemStats();
        setClockDisplay();
        setBatteryDisplay(myStats.battery);
        setStepCountDisplay();

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() as Void {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() as Void {
    }

    private function setClockDisplay() {
    	var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
	
	    // This	will break if it doesn't match your drawable's id!
        var view = View.findDrawableById("TimeDisplay") as Text;
	    view.setText(timeString);
    }

    private function setBatteryDisplay(battery) {
    	// var battery = Sys.getSystemStats().battery;				
	    var batteryDisplay = View.findDrawableById("BatteryDisplay");      
	    batteryDisplay.setText(battery.format("%d")+"%");	
    }
    
    private function setStepCountDisplay() {
    	var stepCount = ActivityMonitor.getInfo().steps.toString();		
	    var stepCountDisplay = View.findDrawableById("StepCountDisplay");      
	    stepCountDisplay.setText(stepCount);		
    }

}
