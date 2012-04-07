/*
	Desktop Web Analytics
	
	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/gpl-3.0-standalone.html GPL v3 or later
	
	$Id: AppUpdater.as 333 2012-04-02 13:23:26Z benoit $
*/
package com.dwa.updater
{
	import air.update.ApplicationUpdaterUI;
	import air.update.events.DownloadErrorEvent;
	import air.update.events.StatusFileUpdateErrorEvent;
	import air.update.events.StatusFileUpdateEvent;
	import air.update.events.StatusUpdateErrorEvent;
	import air.update.events.StatusUpdateEvent;
	import air.update.events.UpdateEvent;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	
	public class AppUpdater
	{
		private var appUpdater:ApplicationUpdaterUI = new ApplicationUpdaterUI();
		
		public function initUpdate():void {
			checkUpdate();
		}
		private function checkUpdate():void {
			// we set the URL for the update.xml file
			//appUpdater.updateURL = "http://www.desktop-web-analytics.com/download/updater.php";
			
			appUpdater.updateURL = "http://www.desktop-web-analytics.com/download/v1/updater.php";
			//we can hide the dialog asking for permission for checking for a new update;
			//if you want to see it just leave the default value (or set true).
			appUpdater.isCheckForUpdateVisible = false;
			//we set the event handlers for INITIALIZED nad ERROR
			appUpdater.addEventListener(UpdateEvent.INITIALIZED, onUpdate);
			appUpdater.addEventListener(StatusUpdateEvent.UPDATE_STATUS, onStatusUpdate);
			appUpdater.addEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, onStatusError);
			appUpdater.addEventListener(UpdateEvent.CHECK_FOR_UPDATE, onCheck);
			appUpdater.addEventListener(UpdateEvent.DOWNLOAD_START, onDownloadStart);
			appUpdater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, onDownloadError);
			appUpdater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, onDownloadComplete);
			appUpdater.addEventListener(UpdateEvent.BEFORE_INSTALL, onBeforeInstall);
			appUpdater.addEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS, onFileUpdateStatus);
			appUpdater.addEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, onFileUpdateError);
			appUpdater.addEventListener(ErrorEvent.ERROR, onError);
			
			//we initialize the updater
			appUpdater.initialize();
		}
		
		private function onUpdate(event:UpdateEvent):void {
			//start the process of checking for a new update and to install
			appUpdater.checkNow();
		}
		private function onCheck(event:UpdateEvent):void{
			trace('check update: ' + event.target.toString());
		}
		private function onStatusUpdate(event:StatusUpdateEvent):void{
			trace('update version: ' + event.version);
			if(event.available){
				trace('find update');
				log('find update');
			}else{
				trace('no update');
				closeEvents();
			}
		}
		private function onDownloadStart(event:UpdateEvent):void{
			trace("start download update");
			log("start downloading update");
		}
		private function onDownloadError(event:DownloadErrorEvent):void{
			trace("download update error");
			log(event.text);
		}
		private function onDownloadComplete(event:UpdateEvent):void{
			trace("download update complete");
			log("download update complete");
		}
		private function onBeforeInstall(event:UpdateEvent):void{
			trace("before update");
		}
		private function onFileUpdateStatus(event:StatusFileUpdateEvent):void{
			trace("status file update: ");
		}
		private function onFileUpdateError(event:StatusFileUpdateErrorEvent):void{
			trace("error status file update: " + event.text);
		}
		private function onStatusError(event:StatusUpdateErrorEvent):void{
			trace('error status update: '+  event.text);
			log(event.text);
			closeEvents();
		}
		
		private function log(msg:String):void{
			var file:File = File.applicationStorageDirectory.resolvePath('log_update.txt');
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.APPEND);
			var today:Date = new Date();
			var write:String = "# " + today.toString() + " - " + msg + "\r\n";
			fileStream.writeUTF(write);
			fileStream.close();
		}
		/**
		 * Handler function for error events triggered by the ApplicationUpdater.initialize
		 * @param ErrorEvent 
		 */ 
		private function onError(event:ErrorEvent):void {
			trace('error updater');
			Alert.show(event.toString());
			log(event.text);
			closeEvents();
		}
		
		private function closeEvents():void{
			trace("close updater");
			appUpdater.removeEventListener(UpdateEvent.INITIALIZED, onUpdate);
			appUpdater.removeEventListener(StatusUpdateEvent.UPDATE_STATUS, onStatusUpdate);
			appUpdater.removeEventListener(StatusUpdateErrorEvent.UPDATE_ERROR, onStatusError);
			appUpdater.removeEventListener(UpdateEvent.CHECK_FOR_UPDATE, onCheck);
			appUpdater.removeEventListener(UpdateEvent.DOWNLOAD_START, onDownloadStart);
			appUpdater.removeEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, onDownloadError);
			appUpdater.removeEventListener(UpdateEvent.DOWNLOAD_COMPLETE, onDownloadComplete);
			appUpdater.removeEventListener(UpdateEvent.BEFORE_INSTALL, onBeforeInstall);
			appUpdater.removeEventListener(StatusFileUpdateEvent.FILE_UPDATE_STATUS, onFileUpdateStatus);
			appUpdater.removeEventListener(StatusFileUpdateErrorEvent.FILE_UPDATE_ERROR, onFileUpdateError);
			appUpdater.removeEventListener(ErrorEvent.ERROR, onError);
			appUpdater = null;
		}

	}
}