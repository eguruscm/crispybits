package minima.commands
{
	import minima.commands.core.ICommand;
	import minima.proxies.PropertyProxy;
	import minima.proxies.PropertyProxyProxy;
	
	public class EditPropertyProxyCommand implements ICommand
	{
		private var _target:PropertyProxyProxy;
		private var _newValue:PropertyProxy;
		private var _oldValue:PropertyProxy;
		
		public function EditPropertyProxyCommand(target:PropertyProxyProxy, value:PropertyProxy)
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