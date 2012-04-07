/*
	Desktop Web Analytics
	
	Link http://www.desktop-web-analytics.com
	Link https://github.com/DesktopWebAnalytics
	License http://www.gnu.org/licenses/gpl-3.0-standalone.html GPL v3 or later
	
	$Id: LaunchCheck.as 333 2012-04-02 13:23:26Z benoit $
*/
package com.dwa
{
	import com.dwa.common.database.DataBase;
	import com.dwa.common.languages.Languages;
	import com.dwa.common.settings.SettingsFile;
	
	import flash.desktop.NativeApplication;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;

	[Event(name="complete", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	public class LaunchCheck implements IEventDispatcher
	{
		protected var dispatcher:EventDispatcher;
		
		private var checkDB:DataBase;
		private var checkSet:SettingsFile;
		
		public var locale:Object;
		public var listWebsites:Array;
		
		private var localeSystem:String;
		private var dBChecked:Boolean=false;
		private var setChecked:Boolean=false;
		private var getWebsites:Boolean=false;
		
		public function LaunchCheck(locale:Array)
		{
			dispatcher = new EventDispatcher(this);
			localeSystem = locale[0];
		}
		
		public function checkAll(currentVersion:String):void{
			//checkFileAssociate();
			checkSettings(currentVersion);
			checkDataBase();
		}
		
		private function checkFileAssociate():void{
			if(NativeApplication.nativeApplication.isSetAsDefaultApplication("dwa") == false){
				NativeApplication.nativeApplication.setAsDefaultApplication("dwa");
			}
		}
		private function checkSettings(version:String):void{
			checkSet = new SettingsFile();
			
			checkSet.addEventListener(Event.COMPLETE, resultSet);
			checkSet.addEventListener(ErrorEvent.ERROR, errorSet);
			checkSet.checkSettings(version);
		}
		private function removeSetListeners():void{
			checkSet.removeEventListener(Event.COMPLETE, resultSet);
			checkSet.removeEventListener(ErrorEvent.ERROR, errorSet);
			checkSet = null;
		}
		private function resultSet(event:Event):void{
			var language:Languages = new Languages();
			
			locale = language.getLocale(checkSet.locale, localeSystem);
			language = null;
			
			removeSetListeners();
			setChecked=true;
			finish();
		}
		private function errorSet(event:ErrorEvent):void{
			error(event.text);
			removeSetListeners();
		}
		private function checkDataBase():void{
			checkDB = new DataBase();
			
			checkDB.addEventListener(Event.COMPLETE, resultDB);
			checkDB.addEventListener(ErrorEvent.ERROR, error);
			checkDB.dataBaseExist();
		}
		private function removeDBListeners():void{
			checkDB.removeEventListener(Event.COMPLETE, resultDB);
			checkDB.removeEventListener(ErrorEvent.ERROR, errorDB);
			checkDB = null;
		}
		private function errorDB(event:ErrorEvent):void{
			error(event.text);
			removeDBListeners();
		}
		private function resultDB(event:Event):void{
			removeDBListeners();
			dBChecked=true;
			//finish();
			
			checkDB = new DataBase();
			
			checkDB.addEventListener(Event.COMPLETE, resultGetWebsites);
			checkDB.addEventListener(ErrorEvent.ERROR, errorGetWebsites);
			checkDB.getAllWebsites(true);
		}
		private function removeDBGetWebsitesListeners():void{
			checkDB.removeEventListener(Event.COMPLETE, resultGetWebsites);
			checkDB.removeEventListener(ErrorEvent.ERROR, errorGetWebsites);
			checkDB = null;
		}
		private function errorGetWebsites(event:ErrorEvent):void{
			error(event.text);
			removeDBGetWebsitesListeners();
		}
		private function resultGetWebsites(event:Event):void{
			listWebsites = checkDB.websitesList;
			
			removeDBGetWebsitesListeners();
			getWebsites = true;
			
			finish();
		}
		
		
		private function error(msg:String):void{
			dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, msg));
		}
		private function finish():void{
			if(dBChecked && setChecked && getWebsites) dispatcher.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		//--
		//-- IEventDispatcher
		//--
		
		public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			dispatcher.addEventListener( type, listener, useCapture, priority, useWeakReference );
		}
		
		public function dispatchEvent( event:Event ):Boolean
		{
			return dispatcher.dispatchEvent( event );
		}
		
		public function hasEventListener( type:String ):Boolean
		{
			return dispatcher.hasEventListener( type );
		}
		
		public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			dispatcher.removeEventListener( type, listener, useCapture );
		}
		
		public function willTrigger( type:String ):Boolean
		{
			return dispatcher.willTrigger( type );
		}
	}
}