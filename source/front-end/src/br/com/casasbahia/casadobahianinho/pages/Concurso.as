package br.com.casasbahia.casadobahianinho.pages {
	
	import br.com.allanavelar.utils.CPFCheck;
	import br.com.allanavelar.utils.JsonLoader;
	import br.com.allanavelar.utils.ObjectLoader;
	import br.com.allanavelar.youtubeplayer.YoutubePlayer;
	import br.com.casasbahia.casadobahianinho.cadastro.BrazillianCities;
	import br.com.casasbahia.casadobahianinho.cadastro.BrazillianStates;
	import br.com.casasbahia.casadobahianinho.cadastro.UploadImagem;
	
	import caurina.transitions.Tweener;
	
	import com.adobe.serialization.json.JSON;
	import com.avmvc.avMvc;
	import com.avmvc.events.PageEvent;
	import com.avmvc.interfaces.IPage;
	import com.avmvc.loader.avMvcLoaderEvent;
	import com.avmvc.view.Page;
	import com.debug.arthropod.Debug;
	
	import fl.controls.ComboBox;
	import fl.controls.RadioButton;
	import fl.controls.TextArea;
	import fl.controls.TextInput;
	import fl.data.DataProvider;
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.system.System;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/** 
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	
	public class Concurso extends Page implements IPage {

		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var mcConcurso:MovieClip;
		
		private var btnParticipe1:MovieClip;
		private var btnParticipe2:MovieClip;
		private var btnParticipe3:MovieClip;
		private var btnParticipe4:MovieClip;
		private var btnParticipe5:MovieClip;
		private var btnParticipe6:MovieClip;
		private var btnParticipe7:MovieClip;
		
		private var btnCadastro1:MovieClip;
		private var btnCadastro2:MovieClip;
		private var btnCadastro3:MovieClip;
		private var formCadastro1:MovieClip;
		private var formCadastro2:MovieClip;
		private var msgCadastro1:MovieClip;
		
		private var btnGaleria1:MovieClip;
		private var btnGaleria2:MovieClip;
		private var btnGaleria3:MovieClip;
		private var btnGaleria4:MovieClip;
		private var btnGaleria5:MovieClip;
		private var btnGaleria6:MovieClip;
		private var btnGaleria7:MovieClip;
		private var btnGaleria8:MovieClip;
		private var btnGaleria9:MovieClip;
		private var btnGaleria10:MovieClip;
		private var BarraBusca:MovieClip;
		private var pagination:MovieClip;
		
		private var btnRanking1:MovieClip;
		private var btnRanking2:MovieClip;
		private var btnRanking3:MovieClip;	
		private var btnRanking4:MovieClip;	
		
		private var btnParticipante1:MovieClip;
		private var btnParticipante2:MovieClip;
		private var playerParticipante:MovieClip;
		private var boxParticipante:MovieClip;
		
		private var btnRegulamento1:MovieClip;
		
		private var ListaProdutos:MovieClip;
		
		private var Logo:MovieClip;
		
		private var jsonParticipante:Object;
		private var jsonProdutos:Object;
		private var jsonParticipe:Object;
		private var jsonRanking:Object;
		private var jsonGaleria:Object;
		
		private var pageProd:int = 1;
		private var paramsGaleria:Object = { page:1, filtro:0 };
		
		private var youtubePlayer:YoutubePlayer;
		
		private var upImagem:UploadImagem;
		
		private var mcAlert:MovieClip;
		
		private var arrPatterns:Array;
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		public var blocked:Boolean = false;
		
		public var pBack:String;
		public var pAtual:String;
		
		public var objPlayer:Object = {
			tipo:0, url:0
		};
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Concurso() {
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
			try {
				removeEventListener(PageEvent.INITIALIZED, initialized, false);
				removeEventListener(PageEvent.CONTENT_PARSED, contentParsed, false);
				removeEventListener(PageEvent.CONTENT_COMPLETE, contentComplete, false);
				mcConcurso.removeEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
				avMvc.getInstance().loader.removeEventListener(avMvcLoaderEvent.ERROR, itemError);
				avMvc.getInstance().loader.removeEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
				removeChild(mcConcurso);
				youtubePlayer ? youtubePlayer.stop() : 0;
			} catch(e:Error) {
				Debug.log("disposeError: " + e);
			}
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
			avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.COMPLETE, itemComplete);
			avMvc.getInstance().loader.addEventListener(avMvcLoaderEvent.ERROR, itemError);
			avMvc.getInstance().loader.add("inc/concurso.swf");
			avMvc.getInstance().loader.start();
			
			if (!arrPatterns) {
				arrPatterns = new Array();
				arrPatterns.push( { pattern:/[äáàâãª]/g,  char:'a' } );
				arrPatterns.push( { pattern:/[ÄÁÀÂÃ]/g,  char:'A' } );
				arrPatterns.push( { pattern:/[ëéèê]/g,   char:'e' } );
				arrPatterns.push( { pattern:/[ËÉÈÊ]/g,   char:'E' } );
				arrPatterns.push( { pattern:/[íîïì]/g,   char:'i' } );
				arrPatterns.push( { pattern:/[ÍÎÏÌ]/g,   char:'I' } );
				arrPatterns.push( { pattern:/[öóòôõº]/g,  char:'o' } );
				arrPatterns.push( { pattern:/[ÖÓÒÔÕ]/g,  char:'O' } );
				arrPatterns.push( { pattern:/[üúùû]/g,   char:'u' } );
				arrPatterns.push( { pattern:/[ÜÚÙÛ]/g,   char:'U' } );
				arrPatterns.push( { pattern:/[ç]/g,   char:'c' } );
				arrPatterns.push( { pattern:/[Ç]/g,   char:'C' } );
				arrPatterns.push( { pattern:/[ñ]/g,   char:'n' } );
				arrPatterns.push( { pattern:/[Ñ]/g,   char:'N' } );
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
				if(event.item.url == "inc/concurso.swf") {
					mcConcurso = (event.item.file as MovieClip).concurso, addChild(mcConcurso);
					mcConcurso.addEventListener("MOTION_IN_COMPLETE", onAnimationComplete);
					for( var i:int = 1; i<=5; i++) { mcConcurso.mcMenu["bt"+i].addEventListener(MouseEvent.CLICK, onClickMenu); }
				} else if(event.item.url == avMvc.getInstance().config.params.concurso.urlParticipe) {
					onloadJsonParticipe(event);
				} else if(event.item.url == (avMvc.getInstance().config.params.concurso.urlGaleria+ "?pagina=" + paramsGaleria.page + paramsGaleria.filtro)) {
					onloadJsonGaleria(event);
				} else if(event.item.url == avMvc.getInstance().config.params.concurso.urlRanking) {
					onloadJsonRanking(event);
				} else if(event.item.url == avMvc.getInstance().config.params.concurso.urlProdutos) {
					onloadJsonProdutos(event);
				} else if(event.item.url == (avMvc.getInstance().config.params.concurso.urlParticipante + "?id=" + objPlayer.id)) {
					onloadJsonParticipante(event);
				} else if(event.item.url == (avMvc.getInstance().config.params.concurso.urlParticipante + "?codigo=" + avMvc.getInstance().config.params.codigo)) {
					onloadJsonParticipante(event);
				}
			} catch(e:Error) {
				Debug.log("itemCompleteError: " + e);
			}
		}
		
		internal function onClickMenu(e:MouseEvent):void {
			try{
				switch(e.currentTarget) {
				case mcConcurso.mcMenu["bt1"]:
					showInternal("Participe");
					break;
				case mcConcurso.mcMenu["bt2"]:
					showInternal("Cadastro");
					break;
				case mcConcurso.mcMenu["bt3"]:
					showInternal("Galeria");
					break;
				case mcConcurso.mcMenu["bt4"]:
					showInternal("Ranking");
					break;
				case mcConcurso.mcMenu["bt5"]:
					showRegulamento();
					break;
				}
			} catch(e:Error) {
				Debug.log("onClickMenuError: " + e);
			}
		}
		
		private var tfRegul:TextFormat;
		private var txtRegul:TextArea;
		internal function showRegulamento(init:Boolean = false):void {
			try{
				if (tfRegul == null) {
					tfRegul = new TextFormat();
					tfRegul.font = "Verdana";
					tfRegul.color = 0xFFFFFF;
					tfRegul.size = 10;
					
					txtRegul = new TextArea(); txtRegul.name = "txtRegul";
					txtRegul.width = 485; txtRegul.height = 200; styleRegulamento();
					mcConcurso["Regulamento"]["texto"].addChild(txtRegul);
					txtRegul.setStyle("textFormat", tfRegul);
					
					function onloadRegul(texto:String):void {
						txtRegul.htmlText = texto;						
						txtRegul.height = 200;
						txtRegul.width = 485;
					}
					
					var loadRegul:JsonLoader = new JsonLoader("REGULAMENTO");
					loadRegul.load({
						url:avMvc.getInstance().config.params.concurso.urlRegulamento,
						onComplete:onloadRegul
					});
				}
				if (!init) {
					mcConcurso["Regulamento"].alpha = 1; mcConcurso["Regulamento"].visible = true;
					mcConcurso["Regulamento"].gotoAndPlay(2);
					buttonRegister(btnRegulamento1);
					styleRegulamento();
				}else{
					mcConcurso["Regulamento"].gotoAndPlay(2);
					styleRegulamento(); Tweener.addTween(mcConcurso["Regulamento"], {time:0, delay:1, onComplete:function():void {
						mcConcurso["Regulamento"].gotoAndStop(1);
						if(avMvc.getInstance().config.params.regulamento == true) {
							showRegulamento();
						}
					}});
				}
			} catch(e:Error) {
				Debug.log("showRegulamentoError: " + e);
			}
		}
		internal function styleRegulamento():void {			
			txtRegul.setStyle("upSkin", TextArea_upSkin2);
			txtRegul.setStyle("focusRectSkin", focusRectSkin2);
			txtRegul.verticalScrollBar.setStyle("focusRectSkin", focusRectSkin2);
			txtRegul.verticalScrollBar.setStyle("downArrowUpSkin", ScrollArrowDown_upSkin2);
			txtRegul.verticalScrollBar.setStyle("downArrowOverSkin", ScrollArrowDown_overSkin2);
			txtRegul.verticalScrollBar.setStyle("downArrowDownSkin", ScrollArrowDown_downSkin2);
			txtRegul.verticalScrollBar.setStyle("upArrowUpSkin", ScrollArrowUp_upSkin2);
			txtRegul.verticalScrollBar.setStyle("upArrowOverSkin", ScrollArrowUp_overSkin2);
			txtRegul.verticalScrollBar.setStyle("upArrowDownSkin", ScrollArrowUp_downSkin2);
			txtRegul.verticalScrollBar.setStyle("thumbOverSkin", ScrollThumb_overSkin2);
			txtRegul.verticalScrollBar.setStyle("thumbDownSkin", ScrollThumb_downSkin2);
			txtRegul.verticalScrollBar.setStyle("thumbIcon", ScrollBar_thumbIcon2);
			txtRegul.verticalScrollBar.setStyle("thumbUpSkin", ScrollThumb_upSkin2);
			txtRegul.verticalScrollBar.setStyle("trackUpSkin", ScrollTrack_skin2);
			txtRegul.verticalScrollBar.setStyle("trackOverSkin", ScrollTrack_skin2);
			txtRegul.verticalScrollBar.setStyle("trackDownSkin", ScrollTrack_skin2);
		}
		
		internal function hideRegulamento():void {
			try{
				Tweener.addTween(mcConcurso["Regulamento"], {time:.3, alpha:0, onComplete:function():void {
					mcConcurso["Regulamento"].visible = false; mcConcurso["Regulamento"].alpha = 1;
					mcConcurso["Regulamento"].gotoAndStop(1);
					buttonRemove(btnRegulamento1);
				}});
			} catch(e:Error) {
				Debug.log("hideRegulamentoError: " + e);
			}
		}
		
		internal function onAnimationComplete(e:Event):void {
			try{
				btnParticipe1 = mcConcurso["Participe"].desenho_centro_info_participe;
				btnParticipe2 = mcConcurso["Participe"].btn_galeria;
				btnParticipe3 = mcConcurso["Participe"].dest1;
				btnParticipe4 = mcConcurso["Participe"].dest2;
				btnParticipe5 = mcConcurso["Participe"].dest3;
				btnParticipe6 = mcConcurso["Participe"].dest4;
				btnParticipe7 = mcConcurso["Participe"].dest5;
				
				btnCadastro1 = mcConcurso["Cadastro"].btn_voltar;
				btnCadastro2 = mcConcurso["Cadastro"].btn_enviar;
				btnCadastro3 = mcConcurso["Cadastro"].box_cadastro.btnRegulamento;
				formCadastro1 = mcConcurso["Cadastro"].box_cadastro.formulario.form1;
				formCadastro2 = mcConcurso["Cadastro"].box_cadastro.formulario.form2;
				msgCadastro1 = mcConcurso["Cadastro"].box_cadastro.iMsg;
				
				btnGaleria1 = mcConcurso["Galeria"].box_galeria.desenho_centro_info_participe;			
				btnGaleria2 = mcConcurso["Galeria"].box_galeria.btn_regulamento;
				btnGaleria3 = mcConcurso["Galeria"].dest1;
				btnGaleria4 = mcConcurso["Galeria"].dest2;
				btnGaleria5 = mcConcurso["Galeria"].dest3;
				btnGaleria6 = mcConcurso["Galeria"].dest4;
				btnGaleria7 = mcConcurso["Galeria"].dest5;
				btnGaleria8 = mcConcurso["Galeria"].dest6;
				btnGaleria9 = mcConcurso["Galeria"].dest7;
				btnGaleria10 = mcConcurso["Galeria"].dest8;
				pagination = mcConcurso["Galeria"].pagination;
				BarraBusca = mcConcurso["Galeria"].barra_busca;
				pagination["iNext"].alpha = pagination["iPrev"].alpha = .5;
				
				function focusIN(e:FocusEvent):void { Debug.log(e); BarraBusca["Busca"].text = ""; };
				function focusOUT(e:FocusEvent):void { Debug.log(e); BarraBusca["Busca"].text == "" ? BarraBusca["Busca"].text = "buscar" : 0; };
				BarraBusca["Busca"].addEventListener(FocusEvent.FOCUS_IN, focusIN);
				BarraBusca["Busca"].addEventListener(FocusEvent.FOCUS_OUT, focusOUT);
				
				Logo = mcConcurso["Logo"];
				Logo.mouseChildren = false; Logo.buttonMode = true;
				Logo.addEventListener(MouseEvent.CLICK, function():void {
					showInternal("Participe");
				});
				
				btnRanking1 = mcConcurso["Ranking"].btn_galeria;
				btnRanking2 = mcConcurso["Ranking"].box_galeria.btn_regulamento;
				btnRanking3 = mcConcurso["Ranking"].box_galeria.desenho_centro_info_participe;
				btnRanking4 = mcConcurso["Ranking"].barra_ranking.lista_galeria;
				
				btnParticipante1 = mcConcurso["Participante"].btn_votar;
				btnParticipante2 = mcConcurso["Participante"].btn_voltar;
				playerParticipante = mcConcurso["Participante"].player;
				boxParticipante = mcConcurso["Participante"].box_participante;
				
				btnRegulamento1 = mcConcurso["Regulamento"].btn_voltar;
				
				ListaProdutos = mcConcurso["Produtos"];
				
				showRegulamento(true); configListaProdutos();
				
				if(avMvc.getInstance().config.params.codigo) {
					showInternal("Participante");
				} else {
					showInternal("Participe");
				}	
			} catch(e:Error) {
				Debug.log("onAnimationCompleteError: " + e);
			}
		}
		
		internal function showInternal(p:String):void {
			try{
				Debug.log("showInternal: p:" + p + " pAtual:" + pAtual);
				if(pAtual == p) return;
				if(pAtual) {
					Tweener.addTween(mcConcurso[pAtual], {
						onComplete:onOutInternal, onCompleteParams:[p],
						time:.3, alpha:0
					});
				} else {
					configInternalPage(p);
					pBack = "Galeria";
					pAtual = p;
				}
				youtubePlayer ? youtubePlayer.stop() : 0;
			} catch(e:Error) {
				Debug.log("showInternalError: " + e);
			}
		}
		internal function onOutInternal(p:String):void {
			try{
				Debug.log("onOutInternal: p:" + p + " pAtual:" + pAtual);
				removeInternalPage(pAtual); configInternalPage(p);
				pBack = pAtual; pAtual = p;
			} catch(e:Error) {
				Debug.log("onOutInternalError: " + e);
			}
		}
		
		internal function configInternalPage(p:String):void {
			try{
				mcConcurso[p].alpha = 1; mcConcurso[p].visible = true;
				mcConcurso[p].gotoAndPlay(2);
				switch(p) {
					case "Participe":
						buttonRegister(btnParticipe1);
						buttonRegister(btnParticipe2);
						configPageParticipe();
					break;
					case "Cadastro":
						buttonRegister(btnCadastro1);
						buttonRegister(btnCadastro2);
						buttonRegister(btnCadastro3);
						configCadastro();
					break;
					case "Galeria":
						buttonRegister(btnGaleria1);
						buttonRegister(btnGaleria2);
						buttonRegister(BarraBusca["Recentes"]);
						buttonRegister(BarraBusca["btn_ok"]);
						buttonRegister(BarraBusca["Videos"]);
						buttonRegister(BarraBusca["Fotos"]);						
						configPageGaleria();
					break;
					case "Ranking":
						buttonRegister(btnRanking1);
						buttonRegister(btnRanking2);
						buttonRegister(btnRanking3);
						configPageRanking();
					break;
					case "Participante":
						buttonRegister(btnParticipante1);
						buttonRegister(btnParticipante2);
						configParticipantePlayer();
					break;
					case "Regulamento":				
						buttonRegister(btnRegulamento1);
					break;				
				}
			} catch(e:Error) {
				Debug.log("configInternalPageError: " + e);
			}
		}
		
		internal function removeInternalPage(p:String):void {
			try{
				mcConcurso[p].alpha = 1; mcConcurso[p].visible = false;
				mcConcurso[p].gotoAndPlay(1);
				switch(p) {
					case "Participe":
						buttonRemove(btnParticipe1);
						buttonRemove(btnParticipe2);
						buttonItemRemove(btnParticipe3);
						buttonItemRemove(btnParticipe4);
						buttonItemRemove(btnParticipe5);
						buttonItemRemove(btnParticipe6);
						buttonItemRemove(btnParticipe7);
					break;
					case "Cadastro":
						buttonRemove(btnCadastro1);
						buttonRemove(btnCadastro2);
						buttonRemove(btnCadastro3);
					break;
					case "Galeria":
						buttonRemove(btnGaleria1);
						buttonRemove(btnGaleria2);
						buttonItemRemove(btnGaleria3);
						buttonItemRemove(btnGaleria4);
						buttonItemRemove(btnGaleria5);
						buttonItemRemove(btnGaleria6);
						buttonItemRemove(btnGaleria7);
						buttonItemRemove(btnGaleria8);
						buttonItemRemove(btnGaleria9);
						buttonItemRemove(btnGaleria10);
						buttonItemRemove(BarraBusca["Recentes"]);
						buttonItemRemove(BarraBusca["btn_ok"]);
						buttonItemRemove(BarraBusca["Videos"]);
						buttonItemRemove(BarraBusca["Fotos"]);
					break;
					case "Ranking":
						buttonRemove(btnRanking1);
						buttonRemove(btnRanking2);
						buttonRemove(btnRanking3);
					break;
					case "Participante":
						buttonRemove(btnParticipante1);
						buttonRemove(btnParticipante2);
					break;
					case "Regulamento":
						buttonRemove(btnRegulamento1);
					break;
				}
			} catch(e:Error) {
				Debug.log("removeInternalPageError: " + e);
			}
		}
		
		internal function buttonRegister(mc:MovieClip):void {
			try{
				mc.addEventListener(MouseEvent.MOUSE_OVER, onOver);
				mc.addEventListener(MouseEvent.MOUSE_OUT, onOut);
				mc.addEventListener(MouseEvent.CLICK, onClicInternal);
				mc.mouseChildren = false; mc.buttonMode = true;
			} catch(e:Error) {
				Debug.log("buttonRegisterError: " + e);
			}
		}
		internal function buttonRemove(mc:MovieClip):void {
			try{
				mc.removeEventListener(MouseEvent.MOUSE_OVER, onOver);
				mc.removeEventListener(MouseEvent.MOUSE_OUT, onOut);
				mc.removeEventListener(MouseEvent.CLICK, onClicInternal);
				mc.mouseChildren = false; mc.buttonMode = false;
			} catch(e:Error) {
				Debug.log("buttonRemoveError: " + e);
			}
		}
		
		internal function onOver(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("over");
		}
		internal function onOut(e:MouseEvent):void {
			e.currentTarget.gotoAndPlay("out");
		}
		internal function onClicInternal(e:MouseEvent):void {
			try{
				if(!blocked) {
				switch(e.currentTarget) {
					//Clicks Participe
					case btnParticipe1:
						showInternal("Cadastro");
						break;
					case btnParticipe2:
						showInternal("Galeria");
						break;
					
					//Clicks Cadastro
					case btnCadastro1:
						if(formCadastro2.visible) {
							btnCadastro2.removeEventListener(MouseEvent.CLICK, checkCadastro2);
							btnCadastro2.addEventListener(MouseEvent.CLICK, checkCadastro);
							formCadastro2.visible = false; formCadastro1.visible = true;
							var c1X:Number = mcConcurso["Cadastro"].box_cadastro.aba1.x;
							mcConcurso["Cadastro"].box_cadastro.aba1.x = mcConcurso["Cadastro"].box_cadastro.aba2.x;
							mcConcurso["Cadastro"].box_cadastro.aba2.x = c1X;
							mcConcurso["Cadastro"].box_cadastro.aba1.gotoAndStop(1);
							mcConcurso["Cadastro"].box_cadastro.aba2.gotoAndStop(2);
						} else {
							showInternal(pBack);
						}						
						break;
					case btnCadastro2:
						
						break;
					case btnCadastro3:
						showRegulamento();
						break;
					
					//Clicks Galeria
					case btnGaleria1:
						showInternal("Cadastro");
						break;
					case btnGaleria2:
						showRegulamento();
						break;
					case BarraBusca["btn_ok"]:
						paramsGaleria.page = 1;
						configPageGaleria("&filtro=" + BarraBusca["Busca"].text);
						BarraBusca["Busca"].text = "buscar"
						break;
					case BarraBusca["Recentes"]:
						paramsGaleria.page = 1;
						configPageGaleria();
						break;
					case BarraBusca["Videos"]:
						paramsGaleria.page = 1;
						configPageGaleria("&videos=1");
						break;
					case BarraBusca["Fotos"]:
						paramsGaleria.page = 1;
						configPageGaleria("&fotos=1");
						break;
						
					//Clicks Ranking
					case btnRanking1:
						showInternal("Galeria");
						break;
					case btnRanking2:
						showRegulamento();
						break;
					case btnRanking3:
						showInternal("Cadastro");
						break;
					
					//Clicks Regulamento
					case btnRegulamento1:
						hideRegulamento();
						break;
						
					//Clicks Participante
					case btnParticipante1:
						newVoto();
						break;
					case btnParticipante2:
						showInternal(pBack);
						break;
						
					//Clicks Produtos
					case ListaProdutos["iForward"]:
						pageProd+=5; outListaProdutos();
						break;
					case ListaProdutos["iBack"]:
						pageProd-=5; outListaProdutos();
						break;
					case pagination["iNext"]:
						paramsGaleria.page+=1; outListaGaleria();
						break;
					case pagination["iPrev"]:
						paramsGaleria.page-=1; outListaGaleria();
						break;
						
				}}
			} catch(e:Error) {
				Debug.log("onClicInternalError: " + e);
			}
		}
		
		internal function configPageParticipe():void {
			try{
				if(!jsonParticipe) {
					avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlParticipe);
					avMvc.getInstance().loader.start();
				} else {
					if(jsonParticipe.status != 1) {
						avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlParticipe);
						avMvc.getInstance().loader.start();
					} else {
						createItemParticipe();
					}
				}
			} catch(e:Error) {
				Debug.log("configPageParticipeError: " + e);
			}
		}
		internal function onloadJsonParticipe(event:avMvcLoaderEvent):void {
			try{
				var source:String = event.item.file;
				jsonParticipe = JSON.decode(source);
				if(jsonParticipe.status == 1) {
					createItemParticipe();
				} else {
					showAlert(jsonParticipe.mensagem);
				}
			} catch(e:Error) {
				Debug.log("onloadJsonParticipeError: " + e);
			}
		}
		internal function createItemParticipe():void {
			try{
				jsonParticipe.total < 1 ? showAlert("Não há resultados para sua busca.") : 0;
				
				for(var i:int = 3; i <= 7; i++) {
					if(jsonParticipe.users[(i-3)]) {
						this["btnParticipe" + i].titulosup.texto.text = jsonParticipe.users[i-3].nomeCrianca;
						this["btnParticipe" + i].tituloinf.texto.text = jsonParticipe.users[i-3].nomeCrianca;
						
						var item:ObjectLoader = new ObjectLoader("user" + i);
						item.load({
							item:this["btnParticipe" + i], id:jsonParticipe.users[i-3].id,
							tipo:jsonParticipe.users[i-3].tipoMedia, image:jsonParticipe.users[i-3].link,
							url:(jsonParticipe.users[i-3].tipoMedia == 0 ? jsonParticipe.users[i-3].urlMedia : jsonParticipe.users[i-3].link),
							onComplete:objLoaderComplete
						});
					}else{
						buttonItemRemove(this["btnParticipe" + i]);
						this["btnParticipe" + i].alpha = 0;
					}
				}
			} catch(e:Error) {
				Debug.log("createItemParticipeError: " + e);
			}
		}
		
		internal function configPageGaleria(filtros:String = ""):void {
			try{
				paramsGaleria.filtro = filtros;
				Debug.log(avMvc.getInstance().config.params.concurso.urlGaleria + "?pagina=" + paramsGaleria.page + paramsGaleria.filtro);
				avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlGaleria + "?pagina=" + paramsGaleria.page + paramsGaleria.filtro);
				avMvc.getInstance().loader.start();
			} catch(e:Error) {
				Debug.log("configPageGaleriaError: " + e);
			}
		}
		internal function onloadJsonGaleria(event:avMvcLoaderEvent):void {
			try{
				Debug.log("onloadJsonGaleria()");
				var source:String = event.item.file;
				jsonGaleria = JSON.decode(source);
				if(jsonGaleria.status == 1) {
					createItemGaleria();
				} else {
					showAlert(jsonGaleria.mensagem);
				}
			} catch(e:Error) {
				Debug.log("onloadJsonGaleriaError: " + e);
			}
		}
		internal function createItemGaleria():void {
			try{
				Debug.log("createItemGaleria()");
				blocked = true; pagination.page.iNum.iNum.text = paramsGaleria.page;
				pagination.total.iNum.iNum.text = jsonGaleria.totalPaginas;
				if(jsonGaleria.totalPaginas > 1) {
					pagination.visible = true;
					if(paramsGaleria.page < jsonGaleria.totalPaginas){
						buttonRegister(pagination["iNext"]);
						pagination["iNext"].alpha = 1;
					} else {
						buttonRemove(pagination["iNext"]);
						pagination["iNext"].alpha = .5;
					}
					if(paramsGaleria.page > 1){
						buttonRegister(pagination["iPrev"]);
						pagination["iPrev"].alpha = 1;
					} else {
						buttonRemove(pagination["iPrev"]);
						pagination["iPrev"].alpha = .5;
					}
				} else {
					pagination.visible = false;
				}
				
				if(jsonGaleria.total == 1) {
					BarraBusca["Msg"].text = "Foi encotrado " + jsonGaleria.total + " resultado na busca";
				} else {
					BarraBusca["Msg"].text = "Foram encotrados " + jsonGaleria.total + " resultados na busca";
				}
				
				if(BarraBusca["Busca"].text != "buscar") {
					BarraBusca["Msg"].text += " por " + BarraBusca["Busca"].text;
				}
				
				for(var i:int = 3; i <= 10; i++) {
					if(jsonGaleria.users[(i-3)]) {
						this["btnGaleria" + i].titulosup.texto.text = jsonGaleria.users[(i-3)].titulo;
						this["btnGaleria" + i].tituloinf.texto.text = jsonGaleria.users[(i-3)].nomeCrianca;
						this["btnGaleria" + i].alpha = 1;
						var item:ObjectLoader = new ObjectLoader("user" + i);
						item.load({
							item:this["btnGaleria" + i], id:jsonGaleria.users[(i-3)].id,
							tipo:jsonGaleria.users[(i-3)].tipoMedia, image:jsonGaleria.users[(i-3)].link,
							url:(jsonGaleria.users[i-3].tipoMedia == 0 ? jsonGaleria.users[i-3].urlMedia : jsonGaleria.users[i-3].link),
							onComplete:objLoaderComplete
						});
					}else{
						(i == 10) ? blocked = false : 0;
						buttonItemRemove(this["btnGaleria" + i]);
						this["btnGaleria" + i].alpha = 0;
					}
				}
			} catch(e:Error) {
				Debug.log("createItemGaleriaError: " + e);
			}
		}
		internal function outListaGaleria():void {
			try{
				for(var i:int = 3; i <= 10; i++) {
					this["btnGaleria" + i].titulosup.texto.text = "carregando";
					this["btnGaleria" + i].tituloinf.texto.text = "carregando";
					buttonItemRemove(this["btnGaleria" + i]);
					this["btnGaleria" + i].alpha = 0;
				}
				configPageGaleria();
			} catch(e:Error) {
				Debug.log("outListaGaleriaError: " + e);
			}
		}
		
		internal function configPageRanking():void {
			try{
				if(!jsonRanking) {
					avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlRanking);
					avMvc.getInstance().loader.start();
				} else {
					if(jsonRanking.status != 1) {
						avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlRanking);
						avMvc.getInstance().loader.start();
					} else {
						createItemRanking();
					}
				}
			} catch(e:Error) {
				Debug.log("configPageRankingError: " + e);
			}
		}
		internal function onloadJsonRanking(event:avMvcLoaderEvent):void {
			try{
				var source:String = event.item.file;
				jsonRanking = JSON.decode(source);
				if(jsonRanking.status == 1) {
					createItemRanking();
				} else {
					showAlert(jsonRanking.mensagem);
				}
			} catch(e:Error) {
				Debug.log("onloadJsonRankingError: " + e);
			}
		}
		internal function createItemRanking():void {
			try{
				jsonRanking.total < 1 ? showAlert("Não há resultados para sua busca.") : 0;
				
				for(var i:int = 1; i <= 10; i++) {
					if(jsonRanking.users[i-1]) {
						btnRanking4["dest" + i].titulosup.texto.text = i + "° lugar";
						btnRanking4["dest" + i].tituloinf.texto.text = jsonRanking.users[i-1].nomeCrianca;
						
						var item:ObjectLoader = new ObjectLoader("user" + i);
						item.load({
							item:btnRanking4["dest" + i], id:jsonRanking.users[i-1].id, ranking:true,
							tipo:jsonRanking.users[i-1].tipoMedia, image:jsonRanking.users[i-1].link,
							url:(jsonRanking.users[i-1].tipoMedia == 0 ? jsonRanking.users[i-1].urlMedia : jsonRanking.users[i-1].link),
							onComplete:objLoaderComplete
						});
					}else{
						buttonItemRemove(btnRanking4["dest" + i]);
						btnRanking4["dest" + i].alpha = 0;
					}
				}
			} catch(e:Error) {
				Debug.log("createItemRankingError: " + e);
			}
		}
		
		internal function buttonItemRegister(mc:MovieClip):void {
			mc.addEventListener(MouseEvent.CLICK, onClicInternalItem);
			mc.mouseChildren = false; mc.buttonMode = true;
		}
		internal function buttonItemRemove(mc:MovieClip):void {
			while( mc.thumb.numChildren ) { mc.thumb.removeChildAt(0); };
			mc.removeEventListener(MouseEvent.CLICK, onClicInternalItem);
			mc.mouseChildren = false; mc.buttonMode = false;
		}
		internal function objLoaderComplete(event:Object):void {
			Debug.log(this + ">>objLoaderComplete( " + event.item.data.image + " ): id: " + event.item.data.id + " url: " + event.item.data.url );
			try{				
				var dados:Object = event.item.data;
				var bitmap:Bitmap = event.item.file as Bitmap;
				bitmap.width = 90; bitmap.height = 64;
				bitmap.smoothing = true; dados.item.thumb.addChild(bitmap);
				dados.item.id = event.item.data.id; dados.item.url = event.item.data.url;
				(dados.item == btnGaleria10) ? blocked = false : 0;
				dados.item.tipo = event.item.data.tipo;
				event.item.data.ranking ? dados.item.ranking = event.item.data.ranking : 0;
				buttonItemRegister(dados.item);
			} catch(e:Error) {
				Debug.log("objLoaderCompleteError: " + e);
			}
		}
		
		internal function getYoutubePlayer(url:String, width:Number = 320, height:Number = 240):YoutubePlayer {
			if (youtubePlayer == null) {
				youtubePlayer = new YoutubePlayer(url,width,height);
			} else {
				youtubePlayer.loadMovie(url);
			}
			return youtubePlayer;
		}
		internal function configParticipantePlayer():void {
			try{
				Debug.log("configParticipantePlayer: " + objPlayer.url);
				//Carrega dados do Participante
				if(avMvc.getInstance().config.params.codigo) {
					Debug.log(avMvc.getInstance().config.params.concurso.urlParticipante + "?codigo=" + avMvc.getInstance().config.params.codigo);
					avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlParticipante + "?codigo=" + avMvc.getInstance().config.params.codigo);
					mcConcurso["Participante"].gotoAndStop(2);
				} else {
					Debug.log(avMvc.getInstance().config.params.concurso.urlParticipante + "?id=" + objPlayer.id);
					avMvc.getInstance().loader.add(avMvc.getInstance().config.params.concurso.urlParticipante + "?id=" + objPlayer.id);
					mcConcurso["Participante"].gotoAndStop(2);
				}				
				avMvc.getInstance().loader.start();
			} catch(e:Error) {
				Debug.log("configParticipantePlayerError: " + e);
			}
		}
		internal function removeAcentos(str:String):String {
			for( var i:uint = 0; i < arrPatterns.length; i++ ) {
				str = str.replace( arrPatterns[i].pattern, arrPatterns[i].char );
			}
			
			return str;
		}
		internal function configParticipanteInfo():void {
			try{
				mcConcurso["Participante"]["iLink"].text = avMvc.getInstance().config.params.concurso.urlSite + "#/?codigo=" + jsonParticipante.user.codigo;
				mcConcurso["Participante"]["iLink"].alwaysShowSelection = true;
				mcConcurso["Participante"]["iLink"].addEventListener(MouseEvent.CLICK, copyText);
				
				boxParticipante["iText"]["iText"].autoSize = TextFieldAutoSize.LEFT;
				boxParticipante["iText"]["iText"].htmlText = "<font size='22' color='#FFFFFF'>" + jsonParticipante.user.titulo + "</font><br>";
				boxParticipante["iText"]["iText"].htmlText += "<font size='12' color='#FFFFFF'>" + jsonParticipante.user.descricao + "</font><br>";
				boxParticipante["iText"]["iText"].htmlText += "<font size='16' color='#F9BB58'>" + jsonParticipante.user.nomeCrianca + "</font><br>";
				boxParticipante["iText"]["iText"].htmlText += "<font size='12' color='#F77701'>filho(a) de: </font><font size='16' color='#F77701'>" + jsonParticipante.user.nome + "</font>";
				
				objPlayer.id = jsonParticipante.user.id;
				
				//Carrega media do Participante
				while ( playerParticipante.numChildren ) { playerParticipante.removeChildAt(0); }
				if (jsonParticipante.user.tipoMedia == 0) {
					objPlayer.url = jsonParticipante.user.urlMedia;
					playerParticipante.addChild(getYoutubePlayer(jsonParticipante.user.urlMedia,340,200))
				} else {
					objPlayer.url = jsonParticipante.user.link;
					var userImagem:ObjectLoader = new ObjectLoader("userImagem");
					userImagem.load({
						item:playerParticipante, image:jsonParticipante.user.link,
						onComplete:userLoaderComplete
					});
				}
				
				avMvc.getInstance().config.params.codigo ? avMvc.getInstance().config.params.codigo = null : 0;
				mcConcurso["Participante"].gotoAndPlay(3);
				
				mcConcurso["Participante"]["iCaptcha"].text = "";
				var item:ObjectLoader = new ObjectLoader("captcha");
				item.load({
					item:mcConcurso["Participante"]["captcha"], image:avMvc.getInstance().config.params.concurso.urlCaptcha,
					onComplete:userLoaderComplete
				});
				
			} catch(e:Error) {
				Debug.log("configParticipanteInfoError: " + e);
			}
		}
		internal function copyText ( event:MouseEvent ):void {
			event.currentTarget.setSelection(0, event.currentTarget.text.length);
			System.setClipboard ( event.currentTarget.text );
			Debug.log("copyText: " + event.currentTarget.text);
		}
		internal function onloadJsonParticipante(event:avMvcLoaderEvent):void {
			try{
				var source:String = event.item.file;
				jsonParticipante = JSON.decode(source);
				if(jsonParticipante.status == 1) {
					configParticipanteInfo();
				} else {
					showAlert(jsonParticipante.mensagem);
				}
			} catch(e:Error) {
				Debug.log("onloadJsonParticipanteError: " + e);
			}
		}
		internal function userLoaderComplete(event:Object):void {
			try{
				Debug.log ( this + ">>userLoaderComplete( " + event.item.data.image + " )" );
				var dados:Object = event.item.data;
				var bitmap:Bitmap = event.item.file as Bitmap; 
				while ( dados.item.numChildren ) { dados.item.removeChildAt(0); }
				bitmap.smoothing = true; dados.item.addChild(bitmap);
				if(dados.item == playerParticipante) {
					//bitmap.width = 340; bitmap.height = 200;
					redimensionaImg(bitmap, 340, 200);
				}
			} catch(e:Error) {
				Debug.log("userLoaderCompleteError: " + e);
			}
		}
		internal function redimensionaImg(mcImg:Bitmap, maxWidth:Number, maxHeight:Number):void {
			if (mcImg.width > mcImg.height) {
				mcImg.height =  mcImg.height/(mcImg.width/maxWidth);
				mcImg.width = maxWidth;
				mcImg.y += (maxHeight/2 - mcImg.height/2);
				if (mcImg.height > maxHeight) {
					mcImg.width =  mcImg.width/(mcImg.height/maxHeight);
					mcImg.height = maxHeight;
					mcImg.x += (maxWidth/2 - mcImg.width/2);
					mcImg.y = 0;
				}
			} else {
				mcImg.width =  mcImg.width/(mcImg.height/maxHeight);
				mcImg.height = maxHeight;
				mcImg.x += (maxWidth/2 - mcImg.width/2);		
			}
		}
		internal function newVoto():void {
			try{
				if(mcConcurso["Participante"]["iCaptcha"].text != "") {
					var sendVoto:JsonLoader = new JsonLoader("VOTO");
					sendVoto.load({
						url:avMvc.getInstance().config.params.concurso.urlVoto
						+ "?id=" + objPlayer.id + "&captcha=" + mcConcurso["Participante"]["iCaptcha"].text,
						onComplete:onloadJsonVoto
					});
					showAlert("Enviando voto...<br>Aguarde","Aviso:",true);
				} else {
					showAlert("Preencha corretamente o campo código.");
					mcConcurso["Participante"]["iCaptcha"].text = "";
					var item:ObjectLoader = new ObjectLoader("captcha");
					item.load({
						item:mcConcurso["Participante"]["captcha"], image:avMvc.getInstance().config.params.concurso.urlCaptcha,
						onComplete:userLoaderComplete
					});
				}
			} catch(e:Error) {
				Debug.log("newVotoError: " + e);
			}
		}
		internal function onloadJsonVoto(json:String):void {
			try{
				jsonProdutos = JSON.decode(json);
				if(jsonProdutos.status == 1) {
					showAlert("Seu voto foi cadastrado com sucesso!","Mensagem:",false);
					mcConcurso["Participante"].btn_votar.visible = false;
					mcConcurso["Participante"].barra_cod.visible = false;
					mcConcurso["Participante"].iCaptcha.visible = false;
					mcConcurso["Participante"].captcha.visible = false;
					mcConcurso["Participante"].boxes.visible = false;
				} else {
					showAlert(jsonProdutos.mensagem);
					mcConcurso["Participante"]["iCaptcha"].text = "";
					var item:ObjectLoader = new ObjectLoader("captcha");
					item.load({
						item:mcConcurso["Participante"]["captcha"], image:avMvc.getInstance().config.params.concurso.urlCaptcha,
						onComplete:userLoaderComplete
					});
				}
			} catch(e:Error) {
				Debug.log("onloadJsonVotoError: " + e);
			}
		}
		
		internal function onClicInternalItem(e:MouseEvent):void {
			try{
				e.currentTarget.ranking ? objPlayer.ranking = e.currentTarget.ranking : objPlayer.ranking = false;
				objPlayer.tipo = e.currentTarget.tipo;
				objPlayer.url = e.currentTarget.url;
				objPlayer.id = e.currentTarget.id;
				showInternal("Participante");
			} catch(e:Error) {
				Debug.log("onClicInternalItemError: " + e);
			}
		}
		
		//------------------------------------
		// Cadastro
		//------------------------------------
		private var tfCadastro:TextFormat;
		private var dadosCadastro:Object;
		internal function configCadastro():void {
			
			if(tfCadastro == null) {
				tfCadastro = new TextFormat();
				tfCadastro.font = "Verdana";
				tfCadastro.color = 0x000000;
				tfCadastro.size = 10;
				
				var txt1:TextInput = new TextInput();
				txt1.setStyle("textFormat", tfCadastro); txt1.name = "txt";
				txt1.width = 270; txt1.height = 16; txt1.maxChars = 30;
				formCadastro1.iNome.addChild(txt1);
				
				var txt2:TextInput = new TextInput();
				txt2.setStyle("textFormat", tfCadastro); txt2.name = "txt";
				txt2.width = 270; txt2.height = 16;
				formCadastro1.iEmail.addChild(txt2);
				
				var txt3:TextInput = new TextInput(); txt3.maxChars = 11;
				txt3.setStyle("textFormat", tfCadastro); txt3.name = "txt";
				txt3.width = 270; txt3.height = 16; txt3.restrict = "0-9";
				formCadastro1.iCPF.addChild(txt3);
				
				var cb1:ComboBox = new ComboBox(); cb1.name = "cb";
				cb1.width = 52; cb1.height = 20; cb1.restrict = "0-9";
				cb1.prompt = "Dia"; cb1.rowCount = 5; cb1.editable = false;
				cb1.dataProvider = new DataProvider(listDias());
				formCadastro1.cbDia.addChild(cb1);
				
				var cb2:ComboBox = new ComboBox(); cb2.name = "cb";
				cb2.width = 52; cb2.height = 20; cb2.restrict = "0-9";
				cb2.prompt = "Mês"; cb2.rowCount = 5; cb2.editable = false;
				cb2.dataProvider = new DataProvider(listMes());
				formCadastro1.cbMes.addChild(cb2);
				
				var cb3:ComboBox = new ComboBox(); cb3.name = "cb";
				cb3.width = 80; cb3.height = 20; cb3.restrict = "0-9";
				cb3.prompt = "Ano"; cb3.rowCount = 5; cb3.editable = false;
				cb3.dataProvider = new DataProvider(listAno());
				formCadastro1.cbAno.addChild(cb3);
				
				var cb4:ComboBox = new ComboBox(); cb4.name = "cb";
				cb4.width = 52; cb4.height = 20; cb4.editable = false;
				cb4.prompt = "UF"; cb4.rowCount = 5; cb4.labelField = "uf";
				cb4.dataProvider = new DataProvider(BrazillianStates.getAll());
				cb4.addEventListener(Event.CHANGE, mudouEstado, false, 0, true);
				formCadastro1.cbEstado.addChild(cb4);
				
				var cb5:ComboBox = new ComboBox(); cb5.name = "cb";
				cb5.width = 195; cb5.height = 20; cb5.editable = false;
				cb5.prompt = "Escolha o estado primeiro"; cb5.rowCount = 5;
				formCadastro1.cbCidade.addChild(cb5);
							
				btnCadastro2.addEventListener(MouseEvent.CLICK, checkCadastro);
			}
		}
		internal function configCadastro2():void {
			try{
				msgCadastro1.msg.text = "";
				
				btnCadastro2.removeEventListener(MouseEvent.CLICK, checkCadastro);
				btnCadastro2.addEventListener(MouseEvent.CLICK, checkCadastro2);
				
				var c2X:Number = mcConcurso["Cadastro"].box_cadastro.aba2.x;
				mcConcurso["Cadastro"].box_cadastro.aba2.x = mcConcurso["Cadastro"].box_cadastro.aba1.x;
				mcConcurso["Cadastro"].box_cadastro.aba1.x = c2X;
				
				mcConcurso["Cadastro"].box_cadastro.aba1.gotoAndStop(2);
				mcConcurso["Cadastro"].box_cadastro.aba2.gotoAndStop(1);
				
				formCadastro2.btnBuscar.visible = false;
				
				if(!MovieClip(formCadastro2.btnPartFoto).getChildByName("rb")) {
					var rb1:RadioButton = new RadioButton();
					rb1.name = "rb"; rb1.width = 133; rb1.height = 22; rb1.label = "";
					rb1.addEventListener(MouseEvent.CLICK, sessaoParticipeComFoto, false, 0, true);
					formCadastro2.btnPartFoto.addChild(rb1);
					
					var rb2:RadioButton = new RadioButton(); rb2.selected = true;
					rb2.name = "rb"; rb2.width = 133; rb2.height = 22; rb2.label = "";
					rb2.addEventListener(MouseEvent.CLICK, sessaoParticipeComVideo, false, 0, true);
					formCadastro2.btnPartVideo.addChild(rb2);
					
					var txt1:TextInput = new TextInput();
					txt1.setStyle("textFormat", tfCadastro); txt1.maxChars = 25;
					txt1.name = "txt"; txt1.width = 270; txt1.height = 16;
					formCadastro2.inputTitulo.addChild(txt1);
					
					var txt2:TextInput = new TextInput();
					txt2.setStyle("textFormat", tfCadastro);
					txt2.name = "txt"; txt2.width = 270; txt2.height = 16;
					formCadastro2.inputLink.addChild(txt2);
					
					var txt3:TextInput = new TextInput();
					txt3.setStyle("textFormat", tfCadastro); txt3.maxChars = 40;
					txt3.name = "txt"; txt3.width = 270; txt3.height = 16;
					formCadastro2.inputFilhos.addChild(txt3);
					
					var txt4:TextArea = new TextArea();
					txt4.setStyle("textFormat", tfCadastro); txt4.maxChars = 150;
					txt4.name = "txt"; txt4.width = 270; txt4.height = 65;
					formCadastro2.inputDescricao.addChild(txt4);
					
					upImagem = new UploadImagem({
						urlServer:avMvc.getInstance().config.params.concurso.urlUpload,
						onSelect:selectedFile, onUploadComplete:completeDataUpload
					});
					
					sessaoParticipeComVideo();
				}				
				formCadastro2.visible = true; formCadastro1.visible = false;
			} catch(e:Error) {
				Debug.log("configCadastro2Error: " + e);
			}
		}
		internal function buscarImagem(ev:MouseEvent):void {
			try{
				upImagem.browse();
			} catch(e:Error) {
				Debug.log("buscarImagemError: " + e);
			}
		}
		internal function selectedFile(e:Object):void {
			Debug.log("selectedFile: " + e);
			formCadastro2.inputLink.getChildByName("txt").text = e.name;
		}
		internal function completeDataUpload(e:Object):void {
			try{
				Debug.log("data: " + e.data);
				var dados:Object = JSON.decode(e.data);
				if (dados.status == 1) {
					objPlayer.tipo = 1;
					var params:URLVariables = new URLVariables();
					params.nascimento = dadosCadastro.nascimento;
					params.cidade = dadosCadastro.cidade;
					params.estado = dadosCadastro.estado;
					params.email = dadosCadastro.email;
					params.nome = dadosCadastro.nome;
					params.cpf = dadosCadastro.cpf;
					
					params.titulo = formCadastro2.inputTitulo.getChildByName("txt").text;
					params.descricao = formCadastro2.inputDescricao.getChildByName("txt").text;
					params.nomeCrianca = formCadastro2.inputFilhos.getChildByName("txt").text;
					params.link = dados.foto;
					
					params.tipo = 2;
					
					var sendCadastro:JsonLoader = new JsonLoader("CADASTRO");
					sendCadastro.load({
						url:avMvc.getInstance().config.params.concurso.urlCadastro,
						data:params, method:URLRequestMethod.POST,
						onComplete:onloadJsonCadastro
					});
					
					showAlert("Foto enviada com sucesso.<br>Realizando cadastro...<br>Aguarde", "Aviso:", true);
				} else {
					showAlert(dados.mensagem);
				}
			} catch(e:Error) {
				Debug.log("completeFileUpload: " + e);
			}
		}
		internal function saibaComo(ev:MouseEvent):void {
			showAlert("Para mandar um vídeo para o YouTube, é simples:<br><br>Entre no www.youtube.com, faça o seu cadastro, faça o upload do vídeo no próprio Youtube, copie o link e cole ele aqui no nosso site.", "Saiba como enviar seu vídeo:");
		}
		
		internal function sessaoParticipeComFoto(ev:MouseEvent = null):void {
			formCadastro2.btnSaibaComo.visible = false; formCadastro2.btnBuscar.visible = true;
			formCadastro2.btnBuscar.addEventListener(MouseEvent.CLICK, buscarImagem);
			formCadastro2.inputLink.getChildByName("txt").editable = false;
			formCadastro2.txtDescricao.text = "Descrição da foto";
			formCadastro2.txtTitulo.text = "Título da foto*";
			formCadastro2.txtLink.text = "Buscar foto*";
		}		
		internal function sessaoParticipeComVideo(ev:MouseEvent = null):void {
			formCadastro2.btnSaibaComo.visible = true; formCadastro2.btnBuscar.visible = false;
			formCadastro2.btnSaibaComo.addEventListener(MouseEvent.CLICK, saibaComo);
			formCadastro2.inputLink.getChildByName("txt").editable = true;
			formCadastro2.txtLink.text = "Link do vídeo no Youtube*";
			formCadastro2.txtDescricao.text = "Descrição do vídeo";
			formCadastro2.txtTitulo.text = "Título do vídeo*";
		}
		internal function limpaCamposCadastro():void {
			formCadastro2.inputDescricao.getChildByName("txt").text = "";
			formCadastro2.inputFilhos.getChildByName("txt").text = "";
			formCadastro2.inputTitulo.getChildByName("txt").text = "";
			formCadastro2.inputLink.getChildByName("txt").text = "";
			
			formCadastro1.cbEstado.getChildByName("cb").selectedIndex = -1;
			formCadastro1.cbCidade.getChildByName("cb").selectedIndex = -1;
			formCadastro1.cbDia.getChildByName("cb").selectedIndex = -1;
			formCadastro1.cbMes.getChildByName("cb").selectedIndex = -1;
			formCadastro1.cbAno.getChildByName("cb").selectedIndex = -1;
			formCadastro1.iEmail.getChildByName("txt").text = "";
			formCadastro1.iNome.getChildByName("txt").text = "";
			formCadastro1.iCPF.getChildByName("txt").text = "";
			
			btnCadastro2.removeEventListener(MouseEvent.CLICK, checkCadastro2);
			btnCadastro2.addEventListener(MouseEvent.CLICK, checkCadastro);
		}
		
		internal function checkCadastro(event:MouseEvent):void {
			try{
				var cbDia:ComboBox = formCadastro1.cbDia.getChildByName("cb");
				var cbMes:ComboBox = formCadastro1.cbMes.getChildByName("cb");
				var cbAno:ComboBox = formCadastro1.cbAno.getChildByName("cb");
				var cbEstado:ComboBox = formCadastro1.cbEstado.getChildByName("cb");
				var cbCidade:ComboBox = formCadastro1.cbCidade.getChildByName("cb");
				if(formCadastro1.iNome.getChildByName("txt").text == "") {
					msgCadastro1.msg.text = "Preencha o campo Nome.";
				} else if(String(formCadastro1.iEmail.getChildByName("txt").text).indexOf("@") == -1 || String(formCadastro1.iEmail.getChildByName("txt").text).indexOf(".") == -1) {
					msgCadastro1.msg.text = "Preencha corretamente o campo E-mail.";
				} else if(formCadastro1.iCPF.getChildByName("txt").text == "") {
					msgCadastro1.msg.text = "Preencha o campo CPF.";
				} else if(!CPFCheck.load(formCadastro1.iCPF.getChildByName("txt").text)) {
					msgCadastro1.msg.text = "Preencha corretamente o campo CPF.";
				} else if(!cbDia.selectedItem || !cbMes.selectedItem || !cbAno.selectedItem) {
					msgCadastro1.msg.text = "Preencha o campo Data de Nascimento.";
				} else if(!cbEstado.selectedItem) {
					msgCadastro1.msg.text = "Preencha o campo Estado.";
				} else if(!cbCidade.selectedItem) {
					msgCadastro1.msg.text = "Preencha o campo Cidade.";
				} else {
					dadosCadastro = {
						nome:formCadastro1.iNome.getChildByName("txt").text,
						email:formCadastro1.iEmail.getChildByName("txt").text,
						cpf:formCadastro1.iCPF.getChildByName("txt").text,
						nascimento:cbDia.selectedItem.label + "/" + cbMes.selectedItem.label + "/" + cbAno.selectedItem.label,
						estado:cbEstado.selectedItem.uf, cidade:cbCidade.selectedItem.label
					};
					Debug.log("DadosCadastro: " + JSON.encode(dadosCadastro));
					configCadastro2();
				}
			} catch(e:Error) {
				Debug.log("checkCadastroError: " + e);
			}
		}
		internal function checkCadastro2(event:MouseEvent):void {
			
			try{
				if(RadioButton(formCadastro2.btnPartFoto.getChildByName("rb")).selected) {
					if(formCadastro2.inputTitulo.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Preencha o campo Título da foto.";
					} else if(formCadastro2.inputLink.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Envie uma imagem para concluir.";
					} else if(formCadastro2.inputDescricao.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Preencha o campo Descrição da foto.";
					} else if(formCadastro2.inputFilhos.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Preencha o campo Nome dos filhos.";
					} else {
						finalizaCadastro(1);
					}
				} else {
					if(formCadastro2.inputTitulo.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Preencha o campo Título do vídeo.";
					} else if(formCadastro2.inputLink.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Preencha o campo Link do vídeo no Youtube.";
					} else if(formCadastro2.inputDescricao.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Preencha o campo Descrição do vídeo.";
					} else if(formCadastro2.inputFilhos.getChildByName("txt").text == "") {
						msgCadastro1.msg.text = "Preencha o campo Nome dos filhos.";
					} else {
						finalizaCadastro(0);
					}
				}				
			} catch(e:Error) {
				Debug.log("checkCadastro2Error: " + e);
			}
		}
		internal function finalizaCadastro(tipo:int):void {
			if(tipo == 1) {
				upImagem.upload();
				showAlert("Enviando foto...<br>Aguarde", "Aviso:", true);
			} else {
				objPlayer.tipo = tipo;			
				var params:URLVariables = new URLVariables();
				params.nascimento = dadosCadastro.nascimento;
				params.cidade = dadosCadastro.cidade;
				params.estado = dadosCadastro.estado;
				params.email = dadosCadastro.email;
				params.nome = dadosCadastro.nome;
				params.cpf = dadosCadastro.cpf;
				
				params.titulo = formCadastro2.inputTitulo.getChildByName("txt").text;
				params.descricao = formCadastro2.inputDescricao.getChildByName("txt").text;
				params.nomeCrianca = formCadastro2.inputFilhos.getChildByName("txt").text;
				params.link = formCadastro2.inputLink.getChildByName("txt").text;
				
				params.tipo = 1;				
				
				var sendCadastro:JsonLoader = new JsonLoader("CADASTRO");
				sendCadastro.load({
					url:avMvc.getInstance().config.params.concurso.urlCadastro,
					data:params, method:URLRequestMethod.POST,
					onComplete:onloadJsonCadastro
				});
				
				showAlert("Realizando cadastro...<br>Aguarde","Mensagem:",true);
			}
		}
		internal function onloadJsonCadastro(json:String):void {
			try {
				var jsonCadastro:Object = JSON.decode(json);
				if(jsonCadastro.status == 1) {
					showAlert("Sua participação foi enviada com sucesso e passará pela moderação. Em breve, você receberá um e-mail dizendo se foi aprovada ou não.","Mensagem:");
					limpaCamposCadastro(); showInternal("Participe");
				} else {
					showAlert(jsonCadastro.mensagem);
				}
			} catch(e:Error) {
				Debug.log("onloadJsonCadastroError: " + e);
			}
		}
		
		internal function mudouEstado(ev:Event):void {
			var cbEstado:ComboBox = formCadastro1.cbEstado.getChildByName("cb");
			var cbCidade:ComboBox = formCadastro1.cbCidade.getChildByName("cb");
			if (ev.target == cbEstado) {
				if (cbEstado.selectedItem) {
					cbCidade.dataProvider = new DataProvider(BrazillianCities.getCitiesOf(cbEstado.selectedItem.uf));
					cbCidade.selectedIndex = 0;
				}
			}
		}
		
		internal function listDias():Array {
			var listaDia:Array = new Array();
			var cont:uint = 0;
			var dia:uint = 1;
			
			for (cont; cont < 31; cont++) {
				listaDia[cont] = { label:String(dia), data:String(dia) };
				dia++;
			}
			return listaDia;
		}		
		internal function listMes():Array {
			var listaMes:Array = new Array();
			var cont:uint = 0;
			var mes:uint = 1;
			
			for (cont; cont < 12; cont++) {
				listaMes[cont] = { label:String(mes), data:String(mes) };
				mes++
			}
			return listaMes;
		}		
		internal function listAno():Array {
			var listaAno:Array = new Array();
			var cont:uint = 0;
			var anoInicial:uint = 2010;
			
			for (cont=0; cont < 120; cont++) {
				listaAno[cont] = { label:String(anoInicial), data:String(anoInicial) };
				anoInicial--;
			}
			return listaAno;
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