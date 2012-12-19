package minima.commands
{
	import minima.commands.core.ICommand;
	import minima.proxies.StringProxy;
	
	public class EditStringCommand implements ICommand
	{
		private var _target:StringProxy;
		private var _newValue:String;
		private var _oldValue:String;
		
		public function EditStringCommand(target:StringProxy, value:String)
		{
			this._target = target;
			this._newValue = value;
			this._oldValue = target.value;
		}
		
		public function Update(value:String):void
		{			
			this._newValue = value;
			this._target.value = this._newValue;
			this._newValue = this._target.value;
		}
		
		public function Do():void
		{
			this._target.value = this._newValue;
			this._newValue = this._target.value;
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