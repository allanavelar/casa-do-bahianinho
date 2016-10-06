package br.com.casasbahia.casadobahianinho {
	
	import br.com.allanavelar.utils.MouseSlider;
	import br.com.casasbahia.casadobahianinho.menu.Footer;
	
	import com.adobe.serialization.json.JSON;
	import com.avmvc.avMvc;
	import com.avmvc.events.ContentEvent;
	import com.avmvc.events.PageEvent;
	import com.avmvc.events.avMvcEvent;
	import com.avmvc.loader.avMvcLoaderEvent;
	import com.debug.arthropod.Debug;
	import com.pixelbreaker.ui.osx.MacMouseWheel;
	
	import flash.display.LoaderInfo;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	 
	public class Main extends Sprite {

		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var areaSliderBackground:Sprite;
		private var sliderBackground:MouseSlider;
		private var menuFooter:Footer;
		
		private var alert:Alerta;
		private var news:NewsletterIcon;
		private var logo:LogoSite;
		
		private var wait:int = 50;
		private var start:int = 0;
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		

		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Main() {
			addEventListener(Event.ADDED_TO_STAGE, added, false, 0, true);
			init();
		}

		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		private function init():void {
			// listeners		
			avMvc.getInstance().addEventListener(ContentEvent.LOADED, contentLoaded);
			avMvc.getInstance().addEventListener(avMvcEvent.INITIALIZED, initialized);
			// stylesheet
			avMvc.getInstance().registerGloBalStyleSheet("css/flash_global.css");
			// start
			avMvc.getInstance().start(this, "data/site.xml", new Config());
		}
		
		private function added(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, added, false);
			MacMouseWheel.setup(stage);
		}
		
		private function contentLoaded(e:ContentEvent = null):void {
			// XML and CSS loaded
		}

		private function initialized(e:avMvcEvent = null):void {
			// avMvc initialization process complete (this event is fired after ContentEvent.LOADED)
			avMvc.getInstance().addEventListener( PageEvent.TRANSITION_IN, onTransition );
			avMvc.getInstance().addEventListener( PageEvent.TRANSITION_OUT, onTransition );
			
			stage.addEventListener( Event.RESIZE, onResize );
			
			createSliderBackground(); configFooter();
			
			logo = new LogoSite();
			logo.buttonMode = true;
			logo.addEventListener(MouseEvent.CLICK, function():void {
				new PageEvent(PageEvent.SHOW, "Inicio").dispatch();
			});
			
			alert = new Alerta(); alert.name = "alert"; alert.visible = false;
			avMvc.getInstance().container.addChildAt(logo, avMvc.getInstance().container.numChildren - 1);
			avMvc.getInstance().container.addChildAt(alert, avMvc.getInstance().container.numChildren - 1);
			
			avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.COMPLETE, loadConfig);
			avMvc.getInstance().loader.add("inc/config");
			avMvc.getInstance().loader.start();
		}
		
		private function loadConfig(event:avMvcLoaderEvent):void {
			var source:String = event.item.file;
			avMvc.getInstance().config.params = JSON.decode(source);
			avMvc.getInstance().loader.removeEventListener(avMvcLoaderEvent.COMPLETE, loadConfig);			
			if(LoaderInfo(this.root.loaderInfo).parameters.codigo) {
				avMvc.getInstance().config.params.codigo = LoaderInfo(this.root.loaderInfo).parameters.codigo;
				new PageEvent(PageEvent.SHOW, "Concurso").dispatch();
			}
		}
		private function configFooter():void {
			menuFooter = new Footer({
				mc:avMvc.getInstance().base.container.getChildByName("footer")
			});
			menuFooter.start();
		}
		private function createSliderBackground():void {
			areaSliderBackground = new Sprite();
			addChildAt(areaSliderBackground, 0);
			drawAreaSliderBackground();
			
			sliderBackground = new MouseSlider({
				target:avMvc.getInstance().base.container.getChildByName("bg"),
				mascara:areaSliderBackground, reference:this, sentido:"horizontal"
			});
			sliderBackground.start();
		}
		private function drawAreaSliderBackground():void {
			areaSliderBackground.graphics.clear();
			areaSliderBackground.graphics.beginFill(0x000000, 0);
			areaSliderBackground.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			areaSliderBackground.graphics.endFill();	
		}
		
		private function onTransition (event:PageEvent):void {
			Debug.log( event );
			if(event.id == "Inicio"){
				sliderBackground.start();
			} else {
				sliderBackground.remove();
			}
			if(start == 0) {
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				wait = 100, start = 1;
			}
		}
		private function onEnterFrame(event:Event):void {
			wait > 0 ? wait-- : ( start = 0, removeEventListener(Event.ENTER_FRAME, onEnterFrame));
			onResize(event);
		}
		
		//
		// PUBLIC
		//________________________________________________________________________________________________
		public function onResize(event:Event = null):void {
			//Debug.log("onResize: " + avMvc.getInstance().page.currentPage);
			
			logo.x = Math.round( stage.stageWidth / 2 ) - 520, logo.y = Math.round( stage.stageHeight / 2 ) - 380;
			avMvc.getInstance().base.container.getChildByName("footer").x = Math.round( stage.stageWidth / 2 );

			avMvc.getInstance().page.currentPage.x = Math.round(stage.stageWidth / 2);
			avMvc.getInstance().page.currentPage.y = Math.round(stage.stageHeight / 2) - 60;
			(avMvc.getInstance().loader.loading as Sprite).x = Math.round((stage.stageWidth / 2));
			(avMvc.getInstance().loader.loading as Sprite).y = Math.round((stage.stageHeight / 2));
			
			alert.fundo.width = stage.stageWidth;
			alert.fundo.height = stage.stageHeight;
			alert.x = Math.round(stage.stageWidth / 2);
			alert.y = Math.round(stage.stageHeight / 2);
			
			drawAreaSliderBackground();
		}
		
		protected const Author	:String = 'Allan Avelar';
		protected const Email	:String = 'contato@allanavelar.com.br';
	}
}
