import Toybox.Application;
import Toybox.Graphics;
import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.SensorHistory;

typedef Numeric as Number or Float or Long or Double;

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
        // Get the device dimensions
        var deviceHeight = getScreenHeight(dc);
        var deviceWidth = getScreenWidth(dc);
        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
        dc.clear();

        // var backgroundLayer = new WatchUi.Layer({:x=>0, :y=>0, width=>260, height=>260});
        // backgroundLayer.getDc().setColor(Graphics.COLOR_RED, Graphics.COLOR_BLACK);
        // backgroundLayer.getDc().fillRectangle(25, 25, 25, 25);
        // addLayer(backgroundLayer);

        // var foregroundLayer = new WatchUi.Layer({:x=>0, :y=>0, width=>260, height=>260});
        // backgroundLayer.getDc().setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        // backgroundLayer.getDc().fillRectangle(30, 30, 25, 25);
        // addLayer(foregroundLayer);
    	setBodyBatteryValue();
        drawIndicator(dc, deviceHeight, deviceWidth);
        setTimeLabel();
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

    

    private function setTimeLabel() {
        // Get the current time and format it correctly
        var timeFormat = "$1$:$2$";
        var clockTime = System.getClockTime();
        var hours = clockTime.hour;
        if (!System.getDeviceSettings().is24Hour) {
            if (hours > 12) {
                hours = hours - 12;
            }
        } else {
            if (getApp().getProperty("UseMilitaryFormat")) {
                timeFormat = "$1$$2$";
                hours = hours.format("%02d");
            }
        }
        var timeString = Lang.format(timeFormat, [hours, clockTime.min.format("%02d")]);

        // Update the view
        var view = View.findDrawableById("TimeLabel") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(timeString);
    }

    private function setBodyBatteryValue() {
        // Set the body battery value to placeholder
        var bBatteryValue = getBodyBatteryValue();
        var view = View.findDrawableById("BodyBatteryLabel") as Text;
        view.setColor(getApp().getProperty("ForegroundColor") as Number);
        view.setText(bBatteryValue.format("%d")+"%");
    }

    private function drawIndicator(dc, deviceHeight, deviceWidth) {
        // draw the indicator shape
        System.println( "------draw--------" );
        var bbatteryValue = getBodyBatteryValue();
        var indicatorHeight = deviceHeight*(bbatteryValue/100);  
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_BLACK);
        dc.fillRectangle(0, indicatorHeight, deviceWidth, deviceHeight);
    }

    // Getters
    private function getBodyBatteryValue() {
        // get the body battery iterator object
        var bbIterator = getIterator();
        var sample = bbIterator.next();
        if (sample != null) {  
    	    return sample.data;
        }
        return 0;
    }
    private function getScreenHeight(dc) {
        return dc.getHeight();
    }
    private function getScreenWidth(dc) {
        return dc.getWidth();
    }
    private function getCentre(val) {
        return val / 2;
    }
    private function negateValue(val) {
        return val - (val * 2);
    }

    // private function drawProgressCircle(dc) {
    //     dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_RED);
    //     dc.fillCircle(getCentre(getScreenHeight(dc)), getCentre(getScreenWidth(dc)), 25);
    // }

    // private function setBatteryDisplay() {
    // 	var battery = System.getSystemStats().battery;				
	//     var batteryDisplay = View.findDrawableById("BatteryDisplay");      
	//     batteryDisplay.setText(battery.format("%d")+"%");	
    // }
    
    // private function setStepCountDisplay() {
    // 	var stepCount = ActivityMonitor.getInfo().steps.toString();		
	//     var stepCountDisplay = View.findDrawableById("StepCountDisplay");      
	//     stepCountDisplay.setText(stepCount);		
    // }

    // private function setTimeToRecoverDisplay() {
    // 	var timeToRecovery = ActivityMonitor.getInfo().timeToRecovery.toString(); //could be null
    //     System.println("Sample: " + timeToRecovery); 
    //     var timeToRecoveryDisplay = View.findDrawableById("TimeToRecoverDisplay");      
	//     timeToRecoveryDisplay.setText(timeToRecovery);		
    // }

}
