package br.com.casasbahia.casadobahianinho.pages {
	
	import br.com.allanavelar.utils.ObjectLoader;
	import br.com.casasbahia.casadobahianinho.ferramenta.AppPaint;
	
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

	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	
	public class Desenho extends Page implements IPage {

		//------------------------------------
		// private, protected properties
		//------------------------------------
				
		private var mcFerramenta:MovieClip;
		private var mcPaint:AppPaint;
		
		//------------------------------------
		// public properties
		//------------------------------------
		public var ferramentas:MovieClip;
		public var btn_ajuda:MovieClip;
		public var terminei:MovieClip;
		public var apagar:MovieClip;
        public var cores:MovieClip;
        
        //Feedback
        //public var enviar_amigos:MovieClip;
        public var imprimir:MovieClip;
        public var salvar:MovieClip;
        
        private var ListaProdutos:MovieClip;
        private var jsonProdutos:Object;
        private var pageProd:int = 1;
        
        private var mcAlert:MovieClip;
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Desenho() {
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
			mcFerramenta.removeEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
			avMvc.getInstance().loader.removeEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
		}
		
		// PUBLIC
		//________________________________________________________________________________________________
		
		override public function transitionIn():void {
			// start of the transition to show the page, then call super.transitionIn
			Tweener.addTween(this, {time:.3, _autoAlpha:1, onComplete:super.transitionIn});
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
			try{
				avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
				avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.ERROR, itemError);
				avMvc.getInstance().loader.add("inc/desenho.swf");
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
			try{
				Debug.log("itemComplete: " + event.item.url);
				if(event.item.url == "inc/desenho.swf") {
					mcFerramenta = (event.item.file as MovieClip).ferramenta, addChild(mcFerramenta);
					mcFerramenta.addEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
				} else if(event.item.url == avMvc.getInstance().config.params.concurso.urlProdutos) {
					onloadJsonProdutos(event);
				}
			} catch(e:Error) {
				Debug.log("itemCompleteError: " + e);
			}
		}
		
		internal function onAnimationComplete(e:Event):void {
			try{
				ferramentas = mcFerramenta["Paint"]["ferramentas"];
				terminei = mcFerramenta["Paint"]["btn_terminei"];
				btn_ajuda = mcFerramenta["Paint"]["btn_ajuda"];
		        apagar = mcFerramenta["Paint"]["btn_apagar"];
		        cores = mcFerramenta["Paint"]["cores"];
		        
		        //enviar_amigos = mcFerramenta["Feedback"]["box_feedback"]["btn_enviar"];
		        imprimir = mcFerramenta["Feedback"]["box_feedback"]["btn_imprimir"];
		        salvar = mcFerramenta["Feedback"]["box_feedback"]["btn_salvar"];
		        
		        buttonRegister(apagar);
				buttonRegister(terminei);
				buttonRegister(btn_ajuda);
				
				mcPaint = new AppPaint(mcFerramenta["Paint"]);
				mcFerramenta["Paint"].addChild(mcPaint);
				
				mcFerramenta["Paint"].alpha = 1; mcFerramenta["Paint"].visible = true;
				mcFerramenta["Paint"].gotoAndPlay(2);
				
				ListaProdutos = mcFerramenta["Produtos"];
				
				configListaProdutos();
			} catch(e:Error) {
				Debug.log("onAnimationCompleteError: " + e);
			}
		}
		internal function showFeedbak():void {
			try {
				var printscreenPaint:Bitmap = mcPaint.getPaint() as Bitmap;
				printscreenPaint.scaleX = printscreenPaint.scaleY = 422 / 600;
				printscreenPaint.x = mcFerramenta["Feedback"]["box_feed"].x;
				printscreenPaint.y = mcFerramenta["Feedback"]["box_feed"].y;
				Tweener.addTween(printscreenPaint, { time:.3, delay:2, alpha:1 });	
				printscreenPaint.smoothing = true; printscreenPaint.alpha = 0;
				mcFerramenta["Feedback"].addChild(printscreenPaint);
				
				Tweener.addTween(mcFerramenta["Paint"], {
					onComplete:onOutPaint, time:.3, alpha:0
				});
			} catch(e:Error) {
				Debug.log("showFeedbakError: " + e);
			}
		}
		
		internal function onOutPaint():void {
			try {
				mcFerramenta["Paint"].alpha = 1; mcFerramenta["Paint"].visible = false;
				mcFerramenta["Paint"].gotoAndPlay(1); buttonRemove(apagar);
				buttonRemove(terminei); buttonRemove(btn_ajuda);
				
				mcFerramenta["Feedback"].alpha = 1; mcFerramenta["Feedback"].visible = true;
				mcFerramenta["Feedback"].gotoAndPlay(2); buttonRegister(salvar);
				buttonRegister(imprimir);//buttonRegister(enviar_amigos);
			} catch(e:Error) {
				Debug.log("onOutPaintError: " + e);
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
			try{
				switch(e.currentTarget) {
					case btn_ajuda:
						showAlert("Teste as ferramentas ao lado e deixe tudo bem colorido.<br>Quando tiver bem legal, clique em Terminei.","Como desenhar:");
						break;
					case apagar:
						mcPaint.clearPaint();
						break;
					case terminei:
						showFeedbak();
						break;
					case salvar:
						mcPaint.save();
						break;
					case imprimir:
						mcPaint.print();
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
				Debug.log("onloadJsonProdutosError: " + e);
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
				dados.item.url = event.item.data.url; prodRegister(dados.item);
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
