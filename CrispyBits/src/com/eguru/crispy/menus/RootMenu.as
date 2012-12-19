package com.eguru.crispy.menus
{
	import flash.display.NativeMenu;

	public class RootMenu extends NativeMenu
	{
		private var _editMenu:EditMenu;
		private var _fileMenu:FileMenu;
		public function RootMenu()
		{
			this._fileMenu = addSubmenu(new FileMenu(),FileMenu.NAME) as FileMenu;
			this._editMenu = addSubmenu(new EditMenu(),EditMenu.NAME) as EditMenu;
		}
	}
}