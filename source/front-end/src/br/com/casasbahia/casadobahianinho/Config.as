package br.com.casasbahia.casadobahianinho {
	
	import br.com.casasbahia.casadobahianinho.loading.basic.*;
	import br.com.casasbahia.casadobahianinho.menu.basic.*;
	import br.com.casasbahia.casadobahianinho.pages.*;
	
	import caurina.transitions.properties.ColorShortcuts;
	import caurina.transitions.properties.DisplayShortcuts;
	
	import com.avmvc.avMvc;
	import com.avmvc.interfaces.IConfig;
	import com.avmvc.view.avMvcText;

	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	
	public class Config implements IConfig {

		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var _siteName:String;
		private var _landingPageID:String;
		private var _loadingClass:String;
		private var _menuClass:String;
		
		private var _params:Object;

		//------------------------------------
		// public properties
		//------------------------------------
		
		
		//------------------------------------
		// constructor
		//------------------------------------
		
		public function Config() {}

		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		private function registerClasses():void {
			avMvc.getInstance().registerClass(Inicio);
			avMvc.getInstance().registerClass(Concurso);
			avMvc.getInstance().registerClass(Desenho);
			avMvc.getInstance().registerClass(Jogos);
			avMvc.getInstance().registerClass(BasicLoading);
			avMvc.getInstance().registerClass(BasicMenu);

		}

		// PUBLIC
		//________________________________________________________________________________________________

		public function init():void {
			_siteName = "CasaDoBahianinho";
			_loadingClass = "BasicLoading";
			_menuClass = "BasicMenu";
			_landingPageID = "";
			
			_params = {};
			
			avMvcText.DEFAULT_EMBED_FONT = true;
			avMvcText.DEFAULT_CONDENSE_WHITE = true;
			XML.ignoreWhitespace = true;
			registerClasses();
			// tweener settings
			DisplayShortcuts.init();
			ColorShortcuts.init();
		}

		public function get loadingClassName():String {
			return _loadingClass;
		}
		
		public function get menuClassName():String {
			return _menuClass;
		}
		
		public function get siteName():String {
			return _siteName;
		}
		
		public function get landingPageID():String {
			return _landingPageID;
		}
		
		public function set params(o:Object):void {
			_params = o;
		}
		public function get params():Object {
			return _params;
		}
		
		protected const Author	:String = 'Allan Avelar';
		protected const Email	:String = 'contato@allanavelar.com.br';
	}
}
