package minima.commands
{
	import minima.commands.core.ICommand;
	import minima.proxies.BooleanProxy;
	
	public class EditBooleanCommand implements ICommand
	{
		private var _target:BooleanProxy;
		private var _newValue:Boolean;
		private var _oldValue:Boolean;
		
		public function EditBooleanCommand(target:BooleanProxy, value:Boolean)
		{
			this._target = target;
			this._newValue = value;
			this._oldValue = target.value;
		}
		
		public function Do():void
		{		
			this._target.value = this._newValue;
		}
		
		public function Undo():void
		{	
			this._target.value = this._oldValue;
		}
		
		public function Redo():void
		{		
			this._target.value = this._newValue;
		}
	}
}