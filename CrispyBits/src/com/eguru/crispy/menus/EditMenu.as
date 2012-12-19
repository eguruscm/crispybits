package com.eguru.crispy.menus
{
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.events.Event;
	
	import minima.commands.core.CommandsManager;

	public class EditMenu extends NativeMenu
	{
		public static const NAME:String = "Edit";
		
		private var _undoItem:NativeMenuItem;
		private var _redoItem:NativeMenuItem;
		
		public function EditMenu()
		{			
			this._undoItem = addItem(new NativeMenuItem("Undo"));
			this._undoItem.keyEquivalent = 'z';
			this._undoItem.data = "Window menu";
			this._undoItem.addEventListener(Event.SELECT, HandleUndoAction);
			
			this._redoItem = addItem(new NativeMenuItem("Redo"));
			this._redoItem.keyEquivalent = 'y';
			this._redoItem.data = "Window menu";
			this._redoItem.addEventListener(Event.SELECT, HandleRedoAction);
			
			
			UpdateMenus();
			CommandsManager.global.addEventListener(Event.CHANGE, UpdateMenus);
		}
		
		protected function UpdateMenus(event:Event=null):void
		{
			this._undoItem.enabled = CommandsManager.global.CanUndo();
		
			this._redoItem.enabled = CommandsManager.global.CanRedo();			
		}
		
		private function HandleUndoAction(event : Event) : void 
		{
			CommandsManager.global.Undo();
		}
		
		private function HandleRedoAction(event : Event) : void 
		{
			CommandsManager.global.Redo();
		}
	}
}