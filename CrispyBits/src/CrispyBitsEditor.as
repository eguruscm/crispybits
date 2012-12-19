package
{
	import com.eguru.crispy.CrispyBits;
	import com.eguru.crispy.menus.RootMenu;
	
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.ContextMenu;
	
	import starling.core.Starling;
	
	[SWF(width="800", height="600", frameRate="60")]
	public class CrispyBitsEditor extends Sprite
	{
		private var _starling:Starling;
		public function CrispyBitsEditor()
		{
			NativeApplication.nativeApplication.addEventListener(Event.ACTIVATE, ApplicationActivatedHandler);
		}
		
		protected function ApplicationActivatedHandler(event:Event):void
		{
			
			NativeApplication.nativeApplication.activeWindow.maximize();
			NativeApplication.nativeApplication.activeWindow.minSize = new Point(300, 100);
			NativeApplication.nativeApplication.removeEventListener(Event.ACTIVATE, ApplicationActivatedHandler);
			if (this.stage) 
				InitializeStage();
			else 
				addEventListener(Event.ADDED_TO_STAGE, InitializeStage);
		}
		
		protected function InitializeStage(event:Event = null):void
		{
			stage.nativeWindow.menu = new RootMenu();
			
			var menu:ContextMenu = new ContextMenu();
			menu.hideBuiltInItems();
			this.contextMenu = menu;
			
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.addEventListener(Event.RESIZE, StageResizedHandler, false, int.MAX_VALUE, true);
			
			_starling = new Starling(CrispyBits, this.stage);
			_starling.start();
		}
		
		protected function StageResizedHandler(event:Event):void
		{
			_starling.stage.stageWidth = this.stage.stageWidth;
			_starling.stage.stageHeight = this.stage.stageHeight;
			
			const viewPort:Rectangle = _starling.viewPort;
			viewPort.width = this.stage.stageWidth;
			viewPort.height = this.stage.stageHeight;
			try
			{
				_starling.viewPort = viewPort;
			}
			catch(error:Error) {
				trace("Unable to set Starling's ViewPort.");
			}
			
		}
	}
}