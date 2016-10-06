package br.com.casasbahia.casadobahianinho.menu.basic {
	
	import com.avmvc.interfaces.IMenu;
	import com.avmvc.view.Menu;
	
	import flash.utils.Timer;		

	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	
	public class BasicMenu extends Menu implements IMenu {

		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		public var xml:XML;
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function BasicMenu() {
			init();
		}

		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		private function init():void {
			name = "basicMenu";
			visible = false;
		}
		
		// PUBLIC
		//________________________________________________________________________________________________
		
		override public function openMenu(id:String):void {
			
		}
		
		public function dispose():void {
			while (numChildren > 0) {
				removeChildAt(0);
			}
		}
		
		public function update():void {
			dispose();
		}
		
		protected const Author	:String = 'Allan Avelar';
		protected const Email		:String = 'contato@allanavelar.com.br';
	}
	
}
