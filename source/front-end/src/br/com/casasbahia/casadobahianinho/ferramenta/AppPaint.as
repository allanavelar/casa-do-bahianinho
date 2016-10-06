package br.com.casasbahia.casadobahianinho.ferramenta
{
	import br.com.allanavelar.geom.transform.TransformManager;
	
	import caurina.transitions.Tweener;
	import caurina.transitions.properties.ColorShortcuts;
	
	import com.adobe.images.JPGEncoder;
	import com.debug.arthropod.Debug;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.net.FileReference;
	import flash.printing.PrintJob;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.ui.Mouse;
	import flash.utils.ByteArray;
	
	/**
	 * <b>Author:</b> Allan Avelar<br />
	 * <b>Site:</b> www.allanavelar.com.br<br />
	 * <b>Class version:</b> 1.0<br />
	 * <b>Actionscript version:</b> 3.0<br />
	 */
	 
	public class AppPaint extends MovieClip
	{
		//------------------------------------
		// private, protected properties
		//------------------------------------
		
		private var mcPaint:MovieClip;
		private var transManager:TransformManager;
		
		private var mouseDown:Boolean = false;
		
		private var count:int = 1;
		
		private var listColors:Array = [
			0xFFFFFF,0x000000,0xCAD2D4,0x9AA0A0,0xF92D00,
			0xAA2A63,0xFFFC12,0xB7B46F,0x04FA00,0x00B966,
			0x0632FF,0x0027B6,0xFF3BFF,0xBA6FB0,0xEBF1CB,
			0x5016FF,0x0BF8FF,0x00BAB3,0xF4B977,0x8E128E
		]
		
		public var configPaint:Object = {
			btn:0, color:0xFF0000, thickness:1, alpha:1, size:10
		}
		
		//------------------------------------
		// public properties
		//------------------------------------
		
		public var Tela:Sprite;
		public var Mask:Sprite;
		
		public var mcOutTransform:MovieClip;
		public var mouseIcone:MovieClip;

		//------------------------------------
		// constructor
		//------------------------------------
		
		public function AppPaint(mc:MovieClip) { mcPaint = mc, build(); }
		
		//
		// PRIVATE, PROTECTED
		//________________________________________________________________________________________________
		
		private function build():void {
			ColorShortcuts.init();
			transManager = new TransformManager(this);
			
			Tela = new Sprite();
			Tela.graphics.lineStyle(0,0xFFFFFF);
			Tela.graphics.beginFill(0xFFFFFF);
			Tela.graphics.drawRect(0,0,600,450);
			Tela.graphics.endFill();
			
			Tela.alpha = 0;
			Tweener.addTween(Tela, {alpha:1, time:.5, delay:1});
			
			mcPaint.addChild(Tela);
			
			Mask = new Sprite();
			Mask.graphics.lineStyle(0,0xFFFFFF);
			Mask.graphics.beginFill(0xFFFFFF);
			Mask.graphics.drawRect(0,0,600,450);
			Mask.graphics.endFill();
			
			mcPaint.addChild(Mask);
			
			Tela.mask = Mask;
						
			Tela.addEventListener(MouseEvent.MOUSE_UP, onTelaUp);
			Tela.addEventListener(MouseEvent.MOUSE_DOWN, onTelaDown);
			Tela.addEventListener(MouseEvent.MOUSE_MOVE, onTelaMove);
			Tela.addEventListener(MouseEvent.MOUSE_OUT, showMouse);
			
			for(var i:int = 1; i <= 8; i++) {
				mcPaint["ferramentas"]["bt" + i].addEventListener(MouseEvent.MOUSE_OVER, overBtn);
				mcPaint["ferramentas"]["bt" + i].addEventListener(MouseEvent.MOUSE_OUT, outBtn);
				mcPaint["ferramentas"]["bt" + i].addEventListener(MouseEvent.CLICK, onClickTool);
				mcPaint["ferramentas"]["bt" + i].buttonMode = true;
			}
			
			for(i = 1; i <= 20; i++) {
				mcPaint["cores"]["c" + i].addEventListener(MouseEvent.CLICK, onClickColor);
			}
			
			mcPaint["ferramentas"]["thicknessBox"].t1.addEventListener(MouseEvent.CLICK, function():void { configPaint.thickness = 1, clearThickness(mcPaint["ferramentas"]["thicknessBox"].t1); });
			mcPaint["ferramentas"]["thicknessBox"].t2.addEventListener(MouseEvent.CLICK, function():void { configPaint.thickness = 5, clearThickness(mcPaint["ferramentas"]["thicknessBox"].t2); });
			mcPaint["ferramentas"]["thicknessBox"].t3.addEventListener(MouseEvent.CLICK, function():void { configPaint.thickness = 10, clearThickness(mcPaint["ferramentas"]["thicknessBox"].t3); });
			mcPaint["ferramentas"]["thicknessBox"].visible = false;
			
			function clearThickness(e:MovieClip):void {
				for(var i:int = 1; i <= 3; i++) { mcPaint["ferramentas"]["thicknessBox"]["t" + i].gotoAndStop(1); }
				e.gotoAndStop(2);
			}
			
			mcPaint["ferramentas"]["fontBox"].t1.addEventListener(MouseEvent.CLICK, function():void { configPaint.size = 12, clearThickness(mcPaint["ferramentas"]["fontBox"].t1); });
			mcPaint["ferramentas"]["fontBox"].t2.addEventListener(MouseEvent.CLICK, function():void { configPaint.size = 18, clearThickness(mcPaint["ferramentas"]["fontBox"].t2); });
			mcPaint["ferramentas"]["fontBox"].t3.addEventListener(MouseEvent.CLICK, function():void { configPaint.size = 24, clearThickness(mcPaint["ferramentas"]["fontBox"].t3); });
			mcPaint["ferramentas"]["fontBox"].visible = false;
			
			function clearFont(e:MovieClip):void {
				for(var i:int = 1; i <= 3; i++) { mcPaint["ferramentas"]["fontBox"]["t" + i].gotoAndStop(1); }
				e.gotoAndStop(2);
			}
			
			Tweener.addTween(mcPaint["cores"]["corAtual"], {_color:configPaint.color, time:1, transition:"easeOutQuart"});
			
			mcOutTransform = new quadrado(); mcOutTransform.visible = false;
			mcOutTransform.x = -mcOutTransform.width*3;
			mcOutTransform.y = -mcOutTransform.height*3;
			Tela.addChild(mcOutTransform);
			
			transManager.registerSprite(mcOutTransform, { minScale:1, maxScale:1 } );
			
			mouseIcone = mcPaint["iconsMouse"];
			mouseIcone.mouseEnabled = false, mouseIcone.mouseChildren = false;
			mcPaint.addChild(mouseIcone), setMouseIcone();
		}
		
		private function configPaintFerramenta(o:Object):void {
			for(var i:int = 1; i <= 8; i++) { mcPaint["ferramentas"]["bt" + i].gotoAndStop(1); }
			(o.mc == mcPaint["ferramentas"]["bt7"] || o.mc == mcPaint["ferramentas"]["bt8"]) ? transManager.activateSprite(mcOutTransform, { minScale:1, maxScale:1 } ) : 0;
			mcPaint["ferramentas"]["thicknessBox"].visible = (o.mc == mcPaint["ferramentas"]["bt1"] || o.mc == mcPaint["ferramentas"]["bt2"]);
			mcPaint["ferramentas"]["fontBox"].visible = (o.mc == mcPaint["ferramentas"]["bt3"]);
			configPaint.btn = String(o.mc.name), o.mc.gotoAndStop(2);;
		}
		private function onClickTool(e:MouseEvent):void {
			configPaintFerramenta({mc:e.currentTarget});
		}
		private function onClickColor(e:MouseEvent):void {
			configPaint.color = listColors[Number(String(e.currentTarget.name).substr(1,2)) - 1];
			Tweener.addTween(mcPaint["cores"]["corAtual"], {_color:configPaint.color, time:1, transition:"easeOutQuart"});
			Debug.log("onClickColor: " + configPaint.color);
		}
		private function overBtn(e:MouseEvent):void {
			e.currentTarget.gotoAndStop(2);
		}
		private function outBtn(e:MouseEvent):void {
			configPaint.btn != e.currentTarget.name || configPaint.btn != e.currentTarget.name ? e.currentTarget.gotoAndStop(1) : 0;
		}
		private function onClickLine(e:MouseEvent):void {
			configPaint.thickness = Number(String(e.currentTarget.name).substr(4,1));
		}
		
		private function showMouse(e:MouseEvent = null):void {
			Mouse.show(), setMouseIcone();
		}
		private function hideMouse():void {
			Mouse.hide(), setMouseIcone(mcPaint["ferramentas"][configPaint.btn]);
		}
		private function onTelaMove (e:MouseEvent):void {
			if (mouseDown)  {
				if( configPaint.btn == "bt1" ) {
					configPaint.target.graphics.lineTo (e.localX,e.localY);
				} else if( configPaint.btn == "bt2" ) {
					drawLine(e);
				}
			}
			mouseIcone.x = mcPaint.mouseX, mouseIcone.y = mcPaint.mouseY;
			configPaint.btn != 0 ? hideMouse() : 0;
		}
		private function onTelaUp(e:MouseEvent):void {
			mouseDown = false;
		}
		private function onTelaDown(e:MouseEvent):void {
			Debug.log(e.target.name);
			if( configPaint.btn == "bt1" ) {
				newLinha(e.localX,e.localY);
			}
			else if( configPaint.btn == "bt2" ) {
				newReta(e.localX,e.localY);
			}
			else if( configPaint.btn == "bt3" ) {
				newTextInput(e.localX,e.localY);
				for(var i:int = 1; i <= 8; i++) { mcPaint["ferramentas"]["bt" + i].gotoAndStop(1); }
				configPaint.btn = 0, showMouse(e);
			}
			else if( configPaint.btn == "bt4" ) {
				newTriangulo(e.localX,e.localY);
				for(i = 1; i <= 8; i++) { mcPaint["ferramentas"]["bt" + i].gotoAndStop(1); }
				configPaint.btn = 0, showMouse(e);
			}
			else if( configPaint.btn == "bt5" ) {
				newCirculo(e.localX,e.localY);
				for(i = 1; i <= 8; i++) { mcPaint["ferramentas"]["bt" + i].gotoAndStop(1); }
				configPaint.btn = 0, showMouse(e);
			}
			else if( configPaint.btn == "bt6" ) {
				newQuadrado(e.localX,e.localY);
				for(i = 1; i <= 8; i++) { mcPaint["ferramentas"]["bt" + i].gotoAndStop(1); }
				configPaint.btn = 0, showMouse(e);
			}
			else if( configPaint.btn == "bt7" ) {
				e.target != Tela ? e.target.visible = false : 0;
				transManager.activateSprite(mcOutTransform, { minScale:1, maxScale:1 } );
			}
			else if( configPaint.btn == "bt8" ) {
				if(e.target != Tela) {
					Tweener.addTween(e.target, {_color:configPaint.color, time:1, transition:"easeOutQuart"});
				} else {
					Tela.graphics.clear();
					Tela.graphics.lineStyle(0,0xFFFFFF);
					Tela.graphics.beginFill(configPaint.color);
					Tela.graphics.drawRect(0,0,600,450);
					Tela.graphics.endFill();
				}
				if(e.target.name == "mc_boundingRect"){
					return;
				}else{
					configPaintFerramenta({mc:mcPaint["ferramentas"][configPaint.btn]});	
				}				
			}
			mouseDown = true;
		}
		
		private function newTriangulo(x:Number,y:Number):void {
			var mc:triangulo = new triangulo(); mc.name = "object";
			transManager.registerSprite(mc, { minScale:0.5, maxScale:3 } );
			Tweener.addTween(mc, {_color:configPaint.color});
			configPaint.startX = x, configPaint.startY = y;
			configPaint.target = mc, mc.x = x, mc.y = y;	
			Tela.addChild(mc);
		}
		private function newCirculo(x:Number,y:Number):void {
			var mc:circulo = new circulo(); mc.name = "object";
			transManager.registerSprite(mc, { minScale:0.5, maxScale:3 } );
			Tweener.addTween(mc, {_color:configPaint.color});
			configPaint.startX = x, configPaint.startY = y;
			configPaint.target = mc, mc.x = x, mc.y = y;	
			Tela.addChild(mc);
		}
		private function newQuadrado(x:Number,y:Number):void {
			var mc:quadrado = new quadrado(); mc.name = "object";
			transManager.registerSprite(mc, { minScale:0.5, maxScale:3 } );
			Tweener.addTween(mc, {_color:configPaint.color});
			configPaint.startX = x, configPaint.startY = y;
			configPaint.target = mc, mc.x = x, mc.y = y;
			Tela.addChild(mc); Debug.log( "Tela: " + Tela );
		}
		private function newLinha(x:Number,y:Number):void {
			var linha:Sprite = new Sprite();
			linha.graphics.lineStyle(configPaint.thickness,configPaint.color,configPaint.alpha);
			linha.graphics.moveTo(x,y), linha.name = "sp" + (count++);
			Debug.log(linha.name + " x: " + x + " y: " + y);
			configPaint.target = linha, Tela.addChild(linha);
		}
		private function newReta(x:Number,y:Number):void {
			var reta:Sprite = new Sprite();
			reta.graphics.lineStyle(configPaint.thickness,configPaint.color,configPaint.alpha);
			reta.graphics.moveTo(x,y), reta.name = "sp" + (count++);
			Debug.log(reta.name + " x: " + x + " y: " + y);
			configPaint.target = reta, Tela.addChild(reta);
			configPaint.startX = x, configPaint.startY = y;
		}
		private function newTextInput(x:Number, y:Number):void {
			var txt:TextField = new TextField();
			txt.addEventListener( FocusEvent.FOCUS_IN, function():void { txt.border = true; });
            txt.addEventListener( FocusEvent.FOCUS_OUT, function():void { txt.border = false; });
			txt.type = TextFieldType.INPUT, txt.autoSize = TextFieldAutoSize.LEFT;
			txt.name = "txt" + (count++), txt.x = x, txt.y = y, txt.border = true;
			Debug.log(txt.name + " x: " + x + " y: " + y);
			var format:TextFormat = new TextFormat();
            format.font = "Verdana", format.color = configPaint.color;
            format.size = configPaint.size, txt.defaultTextFormat = format;
            Tela.addChild(txt), mcPaint.stage.focus = txt;
		}

		private function drawLine(e:MouseEvent):void {
			configPaint.target.graphics.clear();
			configPaint.target.graphics.lineStyle(configPaint.thickness,configPaint.color,configPaint.alpha);
			configPaint.target.graphics.moveTo(configPaint.startX,configPaint.startY);
			configPaint.target.graphics.lineTo(e.localX,e.localY);			
		}
		
		private function setMouseIcone(obj:MovieClip = null):void {
			mouseIcone.mouseFont.visible = mouseIcone.mouseLapis.visible = mouseIcone.mouseLine.visible = false;
			mouseIcone.mouseTint.visible = mouseIcone.mouseequilatero.visible = mouseIcone.mousequadrado.visible = false;
			mouseIcone.mousecirculo.visible = Tela.mouseChildren = false;
			switch(obj) {
				case mcPaint["ferramentas"]["bt1"]:
					mouseIcone.mouseLapis.visible = true;
					break;
				case  mcPaint["ferramentas"]["bt2"]:
					mouseIcone.mouseLine.visible = true;
					break;
				case  mcPaint["ferramentas"]["bt3"]:
					mouseIcone.mouseFont.visible = true;
					break;
				case  mcPaint["ferramentas"]["bt4"]:
					Tweener.addTween(mouseIcone.mouseequilatero, {_color:configPaint.color});
					mouseIcone.mouseequilatero.visible = true;
					break;
				case  mcPaint["ferramentas"]["bt5"]:
					Tweener.addTween(mouseIcone.mousecirculo, {_color:configPaint.color});
					mouseIcone.mousecirculo.visible = true;
					break;
				case  mcPaint["ferramentas"]["bt6"]:
					Tweener.addTween(mouseIcone.mousequadrado, {_color:configPaint.color});
					mouseIcone.mousequadrado.visible = true;
					break;
				case  mcPaint["ferramentas"]["bt7"]:
					Mouse.show(), setMouseIcone();
					break;
				case  mcPaint["ferramentas"]["bt8"]:
					Tweener.addTween(mouseIcone.mouseTint.cor, {_color:configPaint.color});
					mouseIcone.mouseTint.visible = true;
					Tela.mouseChildren = true;
					break;
				default:
					Tela.mouseChildren = true;
			}
		}
		
		//
		// PUBLIC
		//________________________________________________________________________________________________
		
		public function clearPaint():void {
			while ( Tela.numChildren ) { Tela.removeChildAt(0); }
			Tela.addChild(transManager), Tela.addChild(mcOutTransform);
			transManager.activateSprite(mcOutTransform, { minScale:1, maxScale:1 } );
		}
		public function getPaint():Bitmap {
			var selo:PrintLogo = new PrintLogo();
			selo.x = 600 - selo.width; selo.y = 0; Tela.addChild(selo);
			var bdata:BitmapData = new BitmapData(600, 450); bdata.draw(mcPaint);
			var copyTela:Bitmap = new Bitmap(bdata);
			return copyTela;
		}
		public function save():void {
			var bdata:BitmapData = new BitmapData(600, 450); bdata.draw(mcPaint);
			var jpegEncoder:JPGEncoder = new JPGEncoder(80);
			var byteArray:ByteArray = jpegEncoder.encode(bdata);
			saveByteArray(byteArray, "desenho.jpg");
		}
		public function print():void {
			var printjb:PrintJob = new PrintJob();
			var bdata:BitmapData = new BitmapData(600, 450); bdata.draw(mcPaint);
			var bmp:Bitmap = new Bitmap(bdata); bmp.smoothing = true;
			var myPrint:Sprite = new Sprite(); myPrint.addChild(bmp);
			myPrint.rotation = 90;
			if (printjb.start()) {
				try  {
					printjb.addPage(myPrint);
				} catch (e:Error) {
					//error
				}
				printjb.send();
			}
		}
		public static function saveByteArray(ba:ByteArray, nome:String):void {
			var fileReference:FileReference = new FileReference();
			fileReference.save(ba, nome);
		}
	}
}