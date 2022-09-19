import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

import Toybox.ActivityMonitor;
using Toybox.SensorHistory;

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
        // var myStats = System.getSystemStats();
        // setClockDisplay();
        // setBatteryDisplay();
        // setStepCountDisplay();
        dc.setColor(Graphics.COLOR_BLACK,Graphics.COLOR_BLACK);
		dc.clear();
    	dc.setColor(Graphics.COLOR_WHITE,Graphics.COLOR_TRANSPARENT);
    	
    	dc.drawRectangle(50,50,14,14);
    	
    	dc.fillRectangle(50,100,14,14);
        // drawProgressCircle(dc);

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

    // Create a method to get the SensorHistoryIterator object
    function getIterator() {
        // Check device for SensorHistory compatibility
        if ((Toybox has :SensorHistory) && (Toybox.SensorHistory has :getBodyBatteryHistory)) {
            // Set up the method with parameters
            return Toybox.SensorHistory.getBodyBatteryHistory({});
        }
        return null;
    }

    // private function drawProgressCircle(dc) {
    //     dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_RED);
    //     dc.fillRectangle(100, 100, 100, 100);
    // }

    private function setClockDisplay() {
    	var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
	
	    // This	will break if it doesn't match your drawable's id!
        var timeDisplay = View.findDrawableById("TimeDisplay") as Text;
	    timeDisplay.setText(timeString);
    }

    private function setBatteryDisplay() {
    	var battery = System.getSystemStats().battery;				
	    var batteryDisplay = View.findDrawableById("BatteryDisplay");      
	    batteryDisplay.setText(battery.format("%d")+"%");	
    }

    private function setBodyBatteryDisplay() {
        // get the body battery iterator object
        var bbIterator = getIterator();
        var sample = bbIterator.next();
        while (sample != null) {  
    	    var bBatteryDisplay = View.findDrawableById("BBatteryDisplay");      
	        bBatteryDisplay.setText(sample.toString());	
            sample = bbIterator.next();
        }
    }
    
    private function setStepCountDisplay() {
    	var stepCount = ActivityMonitor.getInfo().steps.toString();		
	    var stepCountDisplay = View.findDrawableById("StepCountDisplay");      
	    stepCountDisplay.setText(stepCount);		
    }

    private function setTimeToRecoverDisplay() {
    	var timeToRecovery = ActivityMonitor.getInfo().timeToRecovery.toString(); //could be null
        System.println("Sample: " + timeToRecovery); 
        var timeToRecoveryDisplay = View.findDrawableById("TimeToRecoverDisplay");      
	    timeToRecoveryDisplay.setText(timeToRecovery);		
    }

}
