package br.com.casasbahia.casadobahianinho.pages {
	
	import br.com.allanavelar.utils.ObjectLoader;
	
	import caurina.transitions.Tweener;
	
	import com.adobe.serialization.json.JSON;
	import com.avmvc.avMvc;
	import com.avmvc.events.PageEvent;
	import com.avmvc.interfaces.IPage;
	import com.avmvc.loader.avMvcLoaderEvent;
	import com.avmvc.view.Page;
	import com.debug.arthropod.Debug;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.external.ExternalInterface;

	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	
	public class Jogos extends Page implements IPage {

		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var mcJogos:MovieClip;
		private var btn_jogar1:MovieClip;
		private var btn_jogar2:MovieClip;
		private var btn_jogar3:MovieClip;
		
		private var ListaProdutos:MovieClip;
        private var jsonProdutos:Object;
        private var pageProd:int = 1;
        
        private var mcAlert:MovieClip;
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Jogos() {
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
			removeEventListener(PageEvent.INITIALIZED, initialized, false);
			removeEventListener(PageEvent.CONTENT_PARSED, contentParsed, false);
			removeEventListener(PageEvent.CONTENT_COMPLETE, contentComplete, false);
			mcJogos.removeEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
			avMvc.getInstance().loader.removeEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
		}
		
		// PUBLIC
		//________________________________________________________________________________________________
		
		override public function transitionIn():void {
			// start of the transition to show the page, then call super.transitionIn
			Tweener.addTween(this, {time:1, _autoAlpha:1, onComplete:super.transitionIn});
		}

		override public function transitionInComplete():void {
			// end of the transition to show the page, then call super.transitionInComplete
			super.transitionInComplete();
		}
		
		override public function transitionOut():void {
			// start of the transition to hide the page, then call super.transitionOut
			Tweener.addTween(this, {time:1, _autoAlpha:0, onComplete:super.transitionOut});
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
			try{
				avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
				avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.ERROR, itemError);
				avMvc.getInstance().loader.add("inc/jogos.swf");
				avMvc.getInstance().loader.start();
			} catch(e:Error) {
				Debug.log("startBuildError: " + e);
			}
		}
		internal function itemError(event:avMvcLoaderEvent):void {
			showAlert(event.errorMessage);
		}
		internal function showAlert(msg:String, titulo:String = "ALERTA:", block:Boolean = false):void {
			Debug.log("showAlert: " + msg);
			try {
				if(mcAlert == null) {
					mcAlert = MovieClip(avMvc.getInstance().container.getChildByName("alert"));
					mcAlert.texto.htmlText = msg; mcAlert.titulo.htmlText = titulo;
					mcAlert.texto.y = Math.round(-mcAlert.texto.height / 2) + 15;
					
					mcAlert["fechar"].addEventListener(MouseEvent.MOUSE_OVER, onOver);
					mcAlert["fechar"].addEventListener(MouseEvent.MOUSE_OUT, onOut);
					mcAlert["fechar"].addEventListener(MouseEvent.CLICK, hide);
					function hide():void { mcAlert.visible = false; }
					mcAlert["fechar"].mouseChildren = false;
					mcAlert["fechar"].buttonMode = true;
				} else {
					mcAlert.texto.htmlText = msg; mcAlert.titulo.htmlText = titulo;
					mcAlert.texto.y = Math.round(-mcAlert.texto.height / 2) + 15;
				}
				mcAlert["fechar"].visible = !block;
				mcAlert.visible = true; avMvc.getInstance().loader.stop();
			} catch(e:Error) {
				Debug.log("showAlertError: " + e);
			}		
		}
		
		internal function itemComplete(event:avMvcLoaderEvent):void {
			try {
				if(event.item.url == "inc/jogos.swf") {
					mcJogos = (event.item.file as MovieClip).jogos, addChild(mcJogos);
					mcJogos.addEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
				} else if(event.item.url == avMvc.getInstance().config.params.concurso.urlProdutos) {
					onloadJsonProdutos(event);
				}
			} catch(e:Error) {
				Debug.log("itemCompleteError: " + e);
			}
		}
		
		internal function onAnimationComplete(e:Event):void {
			try {
				btn_jogar1 = mcJogos["btn_jogar1"];
				btn_jogar2 = mcJogos["btn_jogar2"];
				btn_jogar3 = mcJogos["btn_jogar3"];
		        
		        buttonRegister(btn_jogar1);
				buttonRegister(btn_jogar2);
				buttonRegister(btn_jogar3);
				
				ListaProdutos = mcJogos["Produtos"];
				
				configListaProdutos();
			} catch(e:Error) {
				Debug.log("onAnimationCompleteError: " + e);
			}
		}
		
		internal function buttonRegister(mc:MovieClip):void {
			mc.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			mc.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			mc.addEventListener(MouseEvent.CLICK, onClick);
			mc.mouseChildren = false; mc.buttonMode = true;
		}
		internal function buttonRemove(mc:MovieClip):void {
			mc.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
			mc.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
			mc.removeEventListener(MouseEvent.CLICK, onClick);
			mc.mouseChildren = false; mc.buttonMode = false;
		}
		internal function onOver(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("over");
		}
		internal function onOut(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("out");
		}
		internal function onClick(e:MouseEvent):void {
			try {
				switch(e.currentTarget) {
					case btn_jogar1:
						externalGame("inc/games/gameCabeca_08_binu.swf","GOL DE CABEÇA");
						break;
					case btn_jogar2:
						externalGame("inc/games/game_embaixadinha_14.swf","EMBAIXADA VIRTUAL");
						break;
					case btn_jogar3:
						externalGame("inc/games/TiroLivre_v3.swf","TIRO LIVRE");
						break;
					case ListaProdutos["iForward"]:
						pageProd+=5; outListaProdutos();
						break;
					case ListaProdutos["iBack"]:
						pageProd-=5; outListaProdutos();
						break;
				}
			} catch(e:Error) {
				Debug.log("onClickError: " + e);
			}
		}
		
		internal function externalGame(swf:String,titulo:String):void {
			try {
				if (ExternalInterface.available) {
					ExternalInterface.call("SWFDelegate",swf,'600','500',titulo);
                }
			} catch (error:Error) {
            	Debug.log("externalGameError: " + swf);
			}
		}
		
		//------------------------------------
		// Produtos
		//------------------------------------
		internal function configListaProdutos():void {
			try{
				if(!jsonProdutos) {
					avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlProdutos);
					avMvc.getInstance().loader.start();
				} else {
					if(jsonProdutos.status != 1) {
						avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlProdutos);
						avMvc.getInstance().loader.start();
					} else {
						createItemProdutos();
					}
				}
			} catch(e:Error) {
				Debug.log("configListaProdutosError: " + e);
			}
		}
		internal function onloadJsonProdutos(event:avMvcLoaderEvent):void {
			try{
				var source:String = event.item.file;
				jsonProdutos = JSON.decode(source);
				if(jsonProdutos.status == 1) {
					createItemProdutos();
				} else {
					showAlert(jsonProdutos.mensagem);
				}
			} catch(e:Error) {
				Debug.log("configListaProdutosError: " + e);
			}
		}
		internal function createItemProdutos():void {
			try{
				if(pageProd+5 < jsonProdutos.produtos.length){
					buttonRegister(ListaProdutos["iForward"]);
					ListaProdutos["iForward"].alpha = 1;
				} else {
					buttonRemove(ListaProdutos["iForward"]);
					ListaProdutos["iForward"].alpha = .5;
				}
				if(pageProd > 1){
					buttonRegister(ListaProdutos["iBack"]);
					ListaProdutos["iBack"].alpha = 1;
				} else {
					buttonRemove(ListaProdutos["iBack"]);
					ListaProdutos["iBack"].alpha = .5;
				}
				for(var i:int = 1; i <= 5; i++) {
					if(jsonProdutos.produtos[(i+pageProd)-2]) {
						ListaProdutos["produto" + i].iProductName.text = jsonProdutos.produtos[(i+pageProd)-2].title;
						var item:ObjectLoader = new ObjectLoader("user" + i);
						item.load({
							item:ListaProdutos["produto" + i], url:jsonProdutos.produtos[(i+pageProd)-2].url,
							image:jsonProdutos.produtos[(i+pageProd)-2].image,
							onComplete:prodLoaderComplete
						});
					}else{
						prodRemove(ListaProdutos["produto" + i]);
						ListaProdutos["produto" + i].alpha = 0;
					}
				}
				
				ListaProdutos.play();
			} catch(e:Error) {
				Debug.log("createItemProdutosError: " + e);
			}
		}
		internal function prodLoaderComplete(event:Object):void {
			try{
				Debug.log ( this + ">>prodLoaderComplete( " + event.item.data.image + " )" );
				var dados:Object = event.item.data;
				var bitmap:Bitmap = event.item.file as Bitmap; 
				bitmap.smoothing = true; dados.item.iProd.addChild(bitmap);
				dados.item.url = event.item.data.url;
				prodRegister(dados.item);
			} catch(e:Error) {
				Debug.log("prodLoaderCompleteError: " + e);
			}
		}
		internal function prodRegister(mc:MovieClip):void {
			mc.addEventListener(MouseEvent.MOUSE_OVER, onProdOver);
			mc.addEventListener(MouseEvent.MOUSE_OUT, onProdOut);
			mc.addEventListener(MouseEvent.CLICK, onClicProd);
			mc.mouseChildren = false; mc.buttonMode = true;
		}
		internal function prodRemove(mc:MovieClip):void {
			while( mc.iProd.numChildren ) { mc.iProd.removeChildAt(0); }
			mc.removeEventListener(MouseEvent.MOUSE_OVER, onProdOver);
			mc.removeEventListener(MouseEvent.MOUSE_OUT, onProdOut);
			mc.removeEventListener(MouseEvent.CLICK, onClicProd);
			mc.mouseChildren = false; mc.buttonMode = false;
		}
		
		internal function onClicProd(e:MouseEvent):void {
			e.currentTarget.url ? new PageEvent(PageEvent.SHOW_EXTERNAL_LINK, null, e.currentTarget.url).dispatch() : 0;
		}
		internal function onProdOver(e:MouseEvent):void {
			e.currentTarget.btn_mais.gotoAndPlay("over");
		}
		internal function onProdOut(e:MouseEvent):void {
			e.currentTarget.btn_mais.gotoAndPlay("out");
		}
		
		internal function listProdPage(event:Event):void {
			try{
				ListaProdutos.removeEventListener("REMOVE_ITENS", listProdPage);
				for(var i:int = 1; i <= 5; i++) {
					prodRemove(ListaProdutos["produto" + i]);
				}
				createItemProdutos();
			} catch(e:Error) {
				Debug.log("listProdPageError: " + e);
			}
		}
		internal function outListaProdutos():void {
			ListaProdutos.addEventListener("REMOVE_ITENS", listProdPage);
			ListaProdutos.play();
		}
		
		protected const Author	:String = 'Allan Avelar';
		protected const Email	:String = 'contato@allanavelar.com.br';
	}
}
