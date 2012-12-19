package minima.controls {
	
	import minima.proxies.PropertyProxy;
	import minima.proxies.PropertyProxyProxy;
	import minima.proxies.SelectablePropertyContainerProxy;
	import minima.proxies.events.PropertyProxyProxyEvent;

	public class SelectionInspector extends PropertyContainerInspector
	{
		private var _currentSelectionProxy:PropertyProxyProxy;
		private var _defaultProperty:PropertyProxy;
		
		private function SelectionProxyChangeHandler(event:PropertyProxyProxyEvent):void
		{
			super.property = this._currentSelectionProxy.value;
		}
		
		override public function set property(value:PropertyProxy) : void 
		{
			if (!(value is SelectablePropertyContainerProxy))
			{
				throw new Error("Property must be a SelectablePropertyContainerProxy.");
			}
			
			if (this._currentSelectionProxy)
			{
				this._currentSelectionProxy.RemoveChangeListener(SelectionProxyChangeHandler);
			}
			
			this._currentSelectionProxy = (value as SelectablePropertyContainerProxy).currentSelection;
			
			if (this._currentSelectionProxy)
			{
				this._currentSelectionProxy.AddChangeListener(SelectionProxyChangeHandler);
				super.property = this._currentSelectionProxy.value;	
			}
			else
			{
				super.property = null;
			}
		}
	}
}