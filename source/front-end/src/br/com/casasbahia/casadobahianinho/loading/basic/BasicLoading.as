package br.com.casasbahia.casadobahianinho.loading.basic {
	
	import caurina.transitions.Tweener;
	
	import com.avmvc.loader.ILoading;
	import com.avmvc.loader.avMvcLoaderEvent;
	
	import flash.display.Sprite;

	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	
	public class BasicLoading extends Sprite implements ILoading {

		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var _loading:BarraLoading;
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function BasicLoading() {
			init();
		}
		
		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		protected function init():void {
			_loading = new BarraLoading();
			addChild(_loading);
		}
		
		//
		// PUBLIC
		//________________________________________________________________________________________________
		
		public function itemStart(e:avMvcLoaderEvent):void {
			
		}
		
		public function itemProgress(e:avMvcLoaderEvent):void {
			var percent:Number = Math.round(e.percentItem);
			_loading["barra"].gotoAndStop(percent);
		}
		
		public function itemComplete(e:avMvcLoaderEvent):void {
			
		}
		
		public function queueStart():void {
			Tweener.addTween(this, {time: .7, _autoAlpha:1});
		}

		public function queueProgress(e:avMvcLoaderEvent):void {
			var percent:Number = Math.round(e.percentQueue);
			_loading["barra"].gotoAndStop(percent);
		}
		
		public function queueComplete():void {
			Tweener.addTween(this, {time: .7, _autoAlpha:0});
		}
		
		public function error(e:avMvcLoaderEvent):void {
			
		}
		
		protected const Author	:String = 'Allan Avelar';
		protected const Email		:String = 'contato@allanavelar.com.br';
	}
	
}
