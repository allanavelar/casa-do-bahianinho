package br.com.casasbahia.casadobahianinho {
	
	import flash.display.StageScaleMode;	
	import flash.display.StageAlign;	
	import flash.display.Sprite;
	
	import com.debug.arthropod.Debug;
	import br.com.casasbahia.casadobahianinho.loading.SiteLoader;
	
	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */

	public class Preloader extends Sprite {
		
		//------------------------------------
		// private, protected properties
		//------------------------------------

		//------------------------------------
		// public properties
		//------------------------------------
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Preloader() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate = 41;
			
			if(this.root.loaderInfo.parameters.codigo) {
				Debug.log(this.root.loaderInfo.parameters);
				addChild(new SiteLoader("Main.swf?codigo="+this.root.loaderInfo.parameters.codigo, this));
			}else{
				addChild(new SiteLoader("Main.swf", this));
			}
		}
		
		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		
		// PUBLIC
		//________________________________________________________________________________________________	
		
	}
	
}