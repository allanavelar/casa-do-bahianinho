package br.com.casasbahia.casadobahianinho.pages {
	
	import caurina.transitions.Tweener;
	
	import com.avmvc.avMvc;
	import com.avmvc.events.PageEvent;
	import com.avmvc.interfaces.IPage;
	import com.avmvc.loader.avMvcLoaderEvent;
	import com.avmvc.view.Page;
	import com.debug.arthropod.Debug;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	
	public class Inicio extends Page implements IPage {

		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var mcHome:MovieClip;
		
		private var desenho_centro_info_participe:MovieClip;
		private var bt_regulamento:MovieClip;
		private var desenho_comecar:MovieClip;
		private var figurinha_comecar:MovieClip;
		private var craque_comecar:MovieClip;
		
		private var mcProfissoes:MovieClip;
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Inicio() {
			alpha = 0;
			visible = false;
			addEventListener(PageEvent.INITIALIZED, initialized, false, 0, true);
			addEventListener(PageEvent.CONTENT_PARSED, contentParsed, false, 0, true);
			addEventListener(PageEvent.CONTENT_COMPLETE, contentComplete, false, 0, true);
		}
		
		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		private function initialized(e:PageEvent = null):void {
			removeEventListener(PageEvent.INITIALIZED, initialized, false);
			// initialization complete, build page elements here
			startBuild();
		}
		
		private function contentParsed(e:PageEvent):void {
			removeEventListener(PageEvent.CONTENT_PARSED, contentParsed, false);
			// assets parsed and ready (except the assets that need to be loaded), retrieve the assets using: getAssetByID(myAssetID)
		}
		
		private function contentComplete(e:PageEvent):void {
			removeEventListener(PageEvent.CONTENT_COMPLETE, contentComplete, false);
			// assets fully parsed and loaded, retrieve the assets using: getAssetByID(myAssetID)
		}
		
		private function dispose():void {
			// remove and destroy everything in the page
			try{
				removeEventListener(PageEvent.INITIALIZED, initialized, false);
				removeEventListener(PageEvent.CONTENT_PARSED, contentParsed, false);
				removeEventListener(PageEvent.CONTENT_COMPLETE, contentComplete, false);
				avMvc.getInstance().loader.removeEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
				mcHome.removeEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
				mcProfissoes.removeEventListener("MUDA", mudaProfissao);
			} catch(e:Error) {
				Debug.log("disposeError: " + e);
			}
		}
		
		// PUBLIC
		//________________________________________________________________________________________________
		
		override public function transitionIn():void {
			// start of the transition to show the page, then call super.transitionIn
			Tweener.addTween(this, {time:0, _autoAlpha:1, onComplete:super.transitionIn});
		}

		override public function transitionInComplete():void {
			// end of the transition to show the page, then call super.transitionInComplete
			super.transitionInComplete();
		}
		
		override public function transitionOut():void {
			// start of the transition to hide the page, then call super.transitionOut
			Tweener.addTween(this, {time:.3, _autoAlpha:0, onComplete:super.transitionOut});
		}
		
		override public function transitionOutComplete():void {
			// end of the transition to hide the page, then call super.transitionOutComplete
			dispose();
			super.transitionOutComplete();
		}
		
		//
		// INTERNAL
		//________________________________________________________________________________________________
		
		internal function startBuild():void {
			avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
			avMvc.getInstance().loader.add("inc/home.swf");
			avMvc.getInstance().loader.start();
		}
		
		internal function itemComplete(event:avMvcLoaderEvent):void {
			if(event.item.url == "inc/home.swf") {
				mcHome = (event.item.file as MovieClip).homepage, addChild(mcHome);
				mcHome.addEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
			}
		}
		
		internal function mudaProfissao(event:Event = null):void {
			var ran:int = Math.round(Math.random()*10);
			ran == mcProfissoes.currentFrame ? ran++ : 0;
			ran <= 1 ? ran = 2 : ran > 11 ? ran = 11 : 0;
			
			if(ran == mcProfissoes.currentFrame) {
				mudaProfissao();
				return;
			}
			
			Debug.log("mudaProfissao de " +
			mcProfissoes.currentFrame +
			" para " + ran);
			
			mcProfissoes.gotoAndStop(ran);
		}
		internal function onAnimationComplete(e:Event):void {
			mcProfissoes = mcHome["animacao"]["mcProfissoes"];
			mcProfissoes.addEventListener("MUDA", mudaProfissao);
			mudaProfissao();
			
			mcHome["animacao"].mouseChildren = false; mcHome["animacao"].buttonMode = true;
			mcHome["animacao"].addEventListener(MouseEvent.CLICK, function():void {
				new PageEvent(PageEvent.SHOW, "Concurso").dispatch();
			});
			
			desenho_centro_info_participe = mcHome["desenho_centro_info"]["desenho_centro_info_participe"];
			desenho_centro_info_participe.mouseChildren = false;
			desenho_centro_info_participe.buttonMode = true;
			buttonRegister(desenho_centro_info_participe);
			
			bt_regulamento = mcHome["desenho_centro_info"]["bt_regulamento"];
			bt_regulamento.mouseChildren = false;
			bt_regulamento.buttonMode = true;
			buttonRegister(bt_regulamento);
			
			desenho_comecar = mcHome["desenho"]["desenho_comecar"];
			desenho_comecar.mouseChildren = false;
			desenho_comecar.buttonMode = true;
			buttonRegister(desenho_comecar);
			
			figurinha_comecar = mcHome["figurinha"]["figurinha_comecar"];
			figurinha_comecar.mouseChildren = false;
			figurinha_comecar.buttonMode = true;
			buttonRegister(figurinha_comecar);
			
			craque_comecar = mcHome["craque"]["craque_comecar"];
			craque_comecar.mouseChildren = false;
			craque_comecar.buttonMode = true;
			buttonRegister(craque_comecar);
		}
		internal function buttonRegister(mc:MovieClip):void {
			mc.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			mc.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			mc.addEventListener(MouseEvent.CLICK, onClick);
		}
		internal function onOver(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("over");
		}
		internal function onOut(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("out");
		}
		internal function onClick(e:MouseEvent):void {
			switch(e.currentTarget) {
				case desenho_centro_info_participe:
					new PageEvent(PageEvent.SHOW, "Concurso").dispatch();
					break;
				case bt_regulamento:
					avMvc.getInstance().config.params.regulamento = true;
					new PageEvent(PageEvent.SHOW, "Concurso").dispatch();
					break;
				case desenho_comecar:
					new PageEvent(PageEvent.SHOW, "Desenho").dispatch();
					break;
				case figurinha_comecar:
					new PageEvent(PageEvent.SHOW, "Figurinha").dispatch();
					break;
				case craque_comecar:
					new PageEvent(PageEvent.SHOW, "Jogos").dispatch();
					break;
			}
		}
		
		protected const Author	:String = 'Allan Avelar';
		protected const Email	:String = 'contato@allanavelar.com.br';
	}
}
