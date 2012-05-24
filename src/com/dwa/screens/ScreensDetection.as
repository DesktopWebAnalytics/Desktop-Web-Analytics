/*
	Desktop Web Analytics
	
	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/gpl-3.0-standalone.html GPL v3 or later
*/
package com.dwa.screens
{
	import flash.display.Screen;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	
	public class ScreensDetection
	{
		private var mainStage:Stage;
		
		public function ScreensDetection(target:Stage)
		{
			mainStage = target;
			
		}
		// Center window on main screen
		public function centerWindow():void {
			var vWidth:Number = Screen.mainScreen.visibleBounds.width;
			var vHeight:Number = Screen.mainScreen.visibleBounds.height;
			
			// Reduce height
			trace("reduce height -> " + mainStage.nativeWindow.height + ' - ' + vHeight);
			if(mainStage.nativeWindow.height > vHeight){
				trace("reduce actived");
				mainStage.nativeWindow.height = vHeight;
			}
			
			var x:Number = vWidth/2 - mainStage.nativeWindow.width/2;
			var y:Number = vHeight/2 - mainStage.nativeWindow.height/2;
			mainStage.nativeWindow.x = (x<0)? 0:x;
			mainStage.nativeWindow.y = (y<0)? 0:y;
		}
	}
}