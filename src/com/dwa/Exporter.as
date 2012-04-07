package com.dwa
{
	import com.dwa.common.profile.Profile;
	import com.dwa.common.reports.Reports;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.FlexGlobals;
	
	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="complete", type="flash.events.Event")]
	public class Exporter implements IEventDispatcher
	{
		protected var dispatcher:EventDispatcher;
		
		private var exportReport:Reports;
		
		private var currentReport:String;
		private var currentWebsite:Profile;
		private var currentDateRange:String;
		
		public var geoIp:Boolean;
		
		public var contentFile:String;
		
		public function Exporter()
		{
			dispatcher = new EventDispatcher(this);
		}
		
		public function initView(report:Object, idGoal:int=0):void{
			currentReport = report.label;
			
			currentWebsite = FlexGlobals.topLevelApplication.selectedWebsite;
			currentDateRange = FlexGlobals.topLevelApplication.dateRange;
			
			exportReport = new Reports(FlexGlobals.topLevelApplication.shortLocale);
			exportReport.addEventListener(Event.COMPLETE, exportReportComplete);
			exportReport.addEventListener(ErrorEvent.ERROR, exportReportError);
			
			switch(report.id){
				case 'visits':
					exportReport.getVisits(currentWebsite, currentDateRange, true);
					break;
				case 'visitsLocal':
					exportReport.getVisitsPerLocalTime(currentWebsite, currentDateRange, true);
					break;
				case 'visitsServer':
					exportReport.getVisitsPerServerTime(currentWebsite, currentDateRange, true);
					break;
				case 'configuration':
					exportReport.getConfiguration(currentWebsite, currentDateRange, true);
					break;
				case 'browserType':
					exportReport.getBrowserType(currentWebsite, currentDateRange, true);
					break;
				case 'browsers':
					exportReport.getBrowser(currentWebsite, currentDateRange, true);
					break;
				case 'os':
					exportReport.getOs(currentWebsite, currentDateRange, true);
					break;
				case 'resolutions':
					exportReport.getResolution(currentWebsite, currentDateRange, true);
					break;
				case 'wideScreen':
					exportReport.getWideScreen(currentWebsite, currentDateRange, true);
					break;
				case 'plugins':
					exportReport.getPlugin(currentWebsite, currentDateRange, true);
					break;
				case 'locations':
					if(geoIp) exportReport.getGeoIPCountry(currentWebsite, currentDateRange, true);
					else exportReport.getCountry(currentWebsite, currentDateRange, true);
					break;
				case 'providers':
					exportReport.getProvider(currentWebsite, currentDateRange, true);
					break;
				case 'pageUrls':
					exportReport.getPageUrls(currentWebsite, currentDateRange, true, true);
					break;
				case 'pageTitles':
					exportReport.getPageTitles(currentWebsite, currentDateRange, true, true);
					break;
				case 'outlinks':
					exportReport.getOutlinks(currentWebsite, currentDateRange, true, true);
					break;
				case 'downloads':
					exportReport.getDownloads(currentWebsite, currentDateRange, true, true);
					break;
				case 'refererType':
					exportReport.getRefererType(currentWebsite, currentDateRange, true);
					break;
				case 'searchEngines':
					exportReport.getSearchEngines(currentWebsite, currentDateRange, true, true);
					break;
				case 'keywords':
					exportReport.getKeywords(currentWebsite, currentDateRange, true, true);
					break;
				case 'websites':
					exportReport.getWebsites(currentWebsite, currentDateRange, true, true);
					break;
				case 'campaigns':
					exportReport.getCampaigns(currentWebsite, currentDateRange, true, true);
					break;
				case 'rankings':
					exportReport.getSeoRankings(currentWebsite, currentWebsite.websiteUrl, true);
					break;
				case 'goals':
					exportReport.getGoal(currentWebsite, currentDateRange, idGoal, true);
					break;
				
			}
			
		}
		private function removeExportReportListeners():void{
			exportReport.removeEventListener(Event.COMPLETE, exportReportComplete);
			exportReport.removeEventListener(ErrorEvent.ERROR, exportReportError);
			exportReport = null;
		}
		private function exportReportError(event:ErrorEvent):void{
			trace("error export report: " + event.text);
			removeExportReportListeners();
			error(event.text);
		}
		private function exportReportComplete(event:Event):void{
			contentFile = exportReport.resultCSV;
			
			removeExportReportListeners();
			
			finish();
		}
		
		private function error(msg:String):void{
			dispatcher.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, msg));
		}
		private function finish():void{
			dispatcher.dispatchEvent(new Event(Event.COMPLETE));
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