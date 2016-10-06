package br.com.casasbahia.casadobahianinho.metrics
{
	import com.adobe.serialization.json.JSON;
	import com.debug.arthropod.Debug;
	import com.omniture.ActionSource;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	* <b>Author:</b> Allan Avelar<br />
	* <b>Site:</b> www.allanavelar.com.br<br />
	* <b>Class version:</b> 1.0<br />
	* <b>Actionscript version:</b> 3.0<br />
	*/
	
	public class Metrics
	{
		//------------------------------------
		// private, protected properties
		//------------------------------------
		protected static var _instance:Metrics;
		
		private var myPath:QueryString = new QueryString();
		private var campID:String = "";
		private var request:URLRequest;
		private var loader:URLLoader;
		private var s:ActionSource;
		
		//
		// PUBLIC
		//________________________________________________________________________________________________
		
		public static function config(mc:Sprite):void { getInstance().config(mc); }
		private function config(mc:Sprite):void {
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, completeHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            
            s = new ActionSource();
			
			/* Specify the Report Suite ID(s) to track here */
			s.account = "unica-casasbahia";
			
			/* You may add or alter any code config here */
			s.pageName = ""; // Definir o paganame padrao
			s.channel = "DiaDasCriancas2010";  // Definir o canal ou área do site
			s.pageURL = "";  // Definir a url da página
			
			s.charSet = "UTF-8";
			s.currencyCode = "USD";
			s.cookieDomainPeriods = 3;
			
			/* Turn on and configure ClickMap tracking here */
			s.trackClickMap = true;
			s.autoTrack = true;
			s.movieID = "";
			
			if (myPath.parameters.s_cid) {
			  s.campaign = unescape(myPath.parameters.s_cid);
			  campID = s.campaign;
			  s.prop1 = "DiaDasCriancas2010";
			  s.prop2 = "DiaDasCriancas2010";
			  s.prop3 = "DiaDasCriancas2010";
			  s.prop4 = "HotSite";
			  s.prop5 = "DiaDasCriancas2010";
			  s.prop7 = "DiaDasCriancas2010";
			}
			
			/* Turn on and configure debugging here */
			s.debugTracking = true;
			s.trackLocal = true;
			
			/* WARNING: Changing any of the below variables will cause drastic changes
			to how your visitor data is collected.  Changes should only be made
			when instructed to do so by your account manager.*/
			s.visitorNamespace = "unica";
			s.dc = 112;
		}
		
		public static function ping(url:String):void { getInstance().ping(url); }
		private function ping(url:String):void {
			request = new URLRequest(url);
            try {
                loader.load(request);
            } catch (error:Error) {
                Debug.log("TagError: " + url);
            }
		}
		
		public static function track(params:Object):void { getInstance().track(params); }
		private function track(params:Object):void {
			//Debug.log("track: " + JSON.encode(params));
			return;
			params.pageName ? s.pageName = params.pageName : 0;
			s.channel = "DiaDasCriancas2010"; s.campaign = campID;
			s.prop10 = campID + ":" + s.pageName;
			
			params.events ? s.events = params.events : s.events = "";
			params.prop16 ? s.prop16 = params.prop16 : s.prop16 = "";
			params.prop17 ? s.prop17 = params.prop17 : s.prop17 = "";
			params.prop18 ? s.prop18 = params.prop18 : s.prop18 = "";
			params.prop20 ? s.prop20 = params.prop20 : s.prop20 = "";
			params.prop21 ? s.prop21 = params.prop21 : s.prop21 = "";
			params.prop22 ? s.prop22 = params.prop22 : s.prop22 = "";
			params.pageName ? s.pageName = params.pageName : 0;
			
			s.track();
		}
		
		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
        private function completeHandler(event:Event):void {
            var loader:URLLoader = URLLoader(event.target);
            Debug.log("completeHandler: " + loader.data);
        }
        private function securityErrorHandler(event:SecurityErrorEvent):void {
            Debug.log("securityErrorHandler: " + event);
        }

        private function httpStatusHandler(event:HTTPStatusEvent):void {
            Debug.log("httpStatusHandler: " + event);
        }

        private function ioErrorHandler(event:IOErrorEvent):void {
            Debug.log("ioErrorHandler: " + event);
        }
        
        protected static function getInstance():Metrics {
			if (_instance == null) { _instance= new Metrics(); }
			return _instance;
		}
		
		protected const Author	:String = 'Allan Avelar';
		protected const Email	:String = 'contato@allanavelar.com.br';
	}
}