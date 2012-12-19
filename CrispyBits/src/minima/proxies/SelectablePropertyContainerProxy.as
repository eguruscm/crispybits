package minima.proxies
{	
	import minima.serialization.ISerializableNode;
	
	/**
	 * A Container for property proxies, that is a property proxy itself;
	 * 
	 * @author Bruno Tachinardi
	 */
	public class SelectablePropertyContainerProxy extends PropertyContainerProxy
	{
		protected var _currentSelection:PropertyProxyProxy;
		protected var _selectionLocked:Boolean;
		
		public function SelectablePropertyContainerProxy(name : String, 
														 defaultProperty:PropertyProxy=null, 
														 readOnly:Boolean=false, 
														 bubbles:Boolean=false, 
														 nameReadOnly:Boolean=false) 
		{
			super(name, defaultProperty, readOnly, bubbles, nameReadOnly);
			this._currentSelection = new PropertyProxyProxy("Selection");
		}
		
		public function LockSelection():void{
			this._selectionLocked = true;
		}
		
		public function UnlockSelection():void{
			this._selectionLocked = false;
		}
		
		public function get selectionLocked():Boolean
		{
			return this._selectionLocked;
		}
		
		public function get currentSelection():PropertyProxyProxy
		{
			return this._currentSelection;
		}
		
		override protected function CreateAtInternal(index:int=-1):PropertyProxy
		{
			const result:PropertyProxy =  super.CreateAtInternal(index);
			if (!this._selectionLocked)
			{
				this._currentSelection.value = result;				
			}
			return result;
		}
		
		override protected function AddAtInternal(property:PropertyProxy, index:int=-1):PropertyProxy
		{
			const result:PropertyProxy =  super.AddAtInternal(property, index);
			if (!this._selectionLocked)
			{
				this._currentSelection.value = result;
			}
			return result;
		}
		
		override protected function RemoveAtInternal(index:int, notify:Boolean=true):PropertyProxy
		{	var a:ISerializableNode;
			a.
			const result:PropertyProxy =  super.RemoveAtInternal(index, notify);
			if (!this._selectionLocked)
			{
				if (this._currentSelection.value == result)
				{
					if (this._properties.length > index)
					{
						this._currentSelection.value = this._properties[index];
					}
					else if (index > 0)
					{
						this._currentSelection.value = this._properties[index-1];
					}
					else
					{
						this._currentSelection.value = null;
					}
				}
			}
			return result;
		}
		
	}
}