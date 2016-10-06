package br.com.casasbahia.casadobahianinho.menu
{
	import caurina.transitions.Tweener;
	
	import com.avmvc.events.PageEvent;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	 
	public class Footer extends EventDispatcher
	{
		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var params:Object;
		
		protected var backgroundSound:Sound;
		protected var backgroundSoundChannel:SoundChannel;
		
		protected var soundLoaded:Boolean = false;
		protected var _soundEnabled:Boolean = true;
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		public static const START_SOUND:String = "startSound";
		public static const OFF_SOUND:String = "offSound";
		public static const ON_SOUND:String = "onSound";
		
		public var iMenu:MovieClip;
		public var iIcon:MovieClip;
		public var iCB:MovieClip;
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Footer(parans:Object) {
			params = parans;
			buildMovieclips();
		}
		private function buildMovieclips():void {
			iIcon = params["mc"].iIcon; iCB = params["mc"].iCB;
			iIcon.buttonMode = iCB.buttonMode = true; iIcon.mouseChildren = false;
			
			iMenu = params["mc"].mcMenu;
			iMenu.btn_contato.buttonMode = iMenu.btn_cb.buttonMode = true;
			iMenu.btn_contato.mouseChildren = iMenu.btn_cb.mouseChildren = false;
			
			params["mc"].addEventListener(MouseEvent.CLICK, mouseHandler, false, 0, true);
			params["mc"].addEventListener(MouseEvent.MOUSE_OVER, mouseOver, false, 0, true);
			params["mc"].addEventListener(MouseEvent.MOUSE_OUT, mouseOut, false, 0, true);
		}
		protected function mouseHandler(ev:MouseEvent):void {
			if (ev.target == iIcon) {
				soundEnabled = !_soundEnabled;
			}
			if (ev.target == iCB || ev.target == iMenu.btn_cb) {
				new PageEvent(PageEvent.SHOW_EXTERNAL_LINK, null, "http://www.casasbahia.com.br/").dispatch();
			}
			if (ev.target == iMenu.btn_contato) {
				navigateToURL(new URLRequest("mailto:sac@casasbahia.com.br"), "_self");
			}
		}
		protected function mouseOver(ev:MouseEvent):void {
			if(ev.target == iMenu.btn_contato || ev.target == iMenu.btn_cb) {
				ev.target.gotoAndStop(2);
			}
		}
		protected function mouseOut(ev:MouseEvent):void {
			if(ev.target == iMenu.btn_contato || ev.target == iMenu.btn_cb) {
				ev.target.gotoAndStop(1);
			}
		}
		public function destroy():void  {
			params = null;
		}
		public function remove():void {
		}
		public function start():void { 
			config();
		}
		
		public function get soundEnabled():Boolean {
			return this._soundEnabled;
		}
		public function set soundEnabled(value:Boolean):void {
			if (!soundLoaded) return;
			_soundEnabled = value;
			if (value) {
				iIcon.gotoAndStop(1);
				unmute();
			} else {
				iIcon.gotoAndStop(2);
				mute();
			}
		}
		
		public function mute():void {
			var sTrans:SoundTransform = new SoundTransform();
            sTrans.volume = backgroundSoundChannel.soundTransform.volume;
			Tweener.addTween(sTrans, {time:1, volume:0, onUpdate:function():void{backgroundSoundChannel.soundTransform = sTrans;}});
		}
		
		public function unmute():void {
			if (!_soundEnabled) return;
			var sTrans:SoundTransform = new SoundTransform();
            sTrans.volume = backgroundSoundChannel.soundTransform.volume;
			Tweener.addTween(sTrans, {time:1, volume:1, onUpdate:function():void{backgroundSoundChannel.soundTransform = sTrans;}});			
		}
		
		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		private function config():void { 
			if (!backgroundSound) {
				backgroundSound = new Sound();
				backgroundSound.addEventListener(Event.COMPLETE, soundLoadingHandler, false, 0, true);
				backgroundSound.load(new URLRequest("inc/background-fx.mp3"));
			}
		}
		
		protected function soundLoadingHandler(ev:Event):void {
			backgroundSound.removeEventListener(Event.COMPLETE, soundLoadingHandler);
			backgroundSoundChannel = backgroundSound.play(0, 10000, new SoundTransform(0));
			soundLoaded = true; soundEnabled = true;
		}

	}
}