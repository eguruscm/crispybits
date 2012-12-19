package com.eguru.crispy.menus
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	import flash.ui.Keyboard;

	public class FileMenu extends NativeMenu
	{
		public static const NAME:String = "File";
		
		private var _newItem:NativeMenuItem;
		private var _openItem:NativeMenuItem;
		private var _saveItem:NativeMenuItem;
		private var _saveAsItem:NativeMenuItem;
		
		public function FileMenu()
		{			
			this._newItem = addItem(new NativeMenuItem("New"));
			this._newItem.keyEquivalent = 'n';
			this._newItem.data = "Window menu";
			this._newItem.addEventListener(Event.SELECT, HandleNewAction);
			
			this._openItem = addItem(new NativeMenuItem("Open"));
			this._openItem.keyEquivalent = 'o';
			this._openItem.data = "Window menu";
			this._openItem.addEventListener(Event.SELECT, HandleOpenAction);
			
			this._saveItem = addItem(new NativeMenuItem("Save"));
			this._saveItem.keyEquivalent = 's';
			this._saveItem.data = "Window menu";
			this._saveItem.addEventListener(Event.SELECT, HandleSaveAction);
			
			this._saveAsItem = addItem(new NativeMenuItem("Save As"));
			this._saveAsItem.keyEquivalent = 's';
			this._saveAsItem.keyEquivalentModifiers = [Keyboard.CONTROL, Keyboard.SHIFT];
			this._saveAsItem.data = "Window menu";
			this._saveAsItem.addEventListener(Event.SELECT, HandleSaveAsAction);
			
			UpdateMenus();
		}
		
		protected function UpdateMenus(event:Event=null):void
		{
			// TODO Auto-generated method stub
					
		}
		
		private function HandleNewAction(event : Event) : void 
		{
			// TODO Auto-generated method stub
			
		}
		
		private function HandleOpenAction(event : Event) : void 
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function HandleSaveAction(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
		
		protected function HandleSaveAsAction(event:Event):void
		{
			// TODO Auto-generated method stub
			
		}
	}
}