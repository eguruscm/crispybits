package minima.commands
{
	import minima.commands.core.ICommand;
	import minima.proxies.NumberProxy;
	
	public class EditNumberCommand implements ICommand
	{
		private var _target:NumberProxy;
		private var _newValue:Number;
		private var _oldValue:Number;
		
		public function EditNumberCommand(target:NumberProxy, value:Number)
		{
			this._target = target;
			this._newValue = value;
			this._oldValue = target.value;
		}
		
		public function Update(value:Number):void
		{			
			this._newValue = value;
			this._target.value = this._newValue;
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