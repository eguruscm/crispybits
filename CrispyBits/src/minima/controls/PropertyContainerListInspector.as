package minima.controls {
	import feathers.controls.Button;
	
	import minima.commands.EditPropertyProxyCommand;
	import minima.commands.core.CommandsManager;
	import minima.controls.factories.PropertyInspectorFactory;
	import minima.proxies.PropertyProxy;
	import minima.proxies.PropertyProxyProxy;
	import minima.proxies.SelectablePropertyContainerProxy;
	import minima.proxies.events.PropertyProxyProxyEvent;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	public class PropertyContainerListInspector extends PropertyContainerInspector
	{
		private var _currentSelection:PropertyListRenderer;
		private var _currentSelectionProxy:PropertyProxyProxy;
		
		override protected function Commit():void
		{
			super.Commit();
			if (this._currentSelectionProxy)
			{
				if (!this._currentSelection || this._currentSelectionProxy.value != this._currentSelection.property)
				{
					SelectByProperty(this._currentSelectionProxy.value);
				}
			}
		}
		
		override protected function RemovePropertyProxy(index:int):void
		{
			var inspector:PropertyInspector = this._contentContainer.removeChildAt(index) as PropertyInspector;
			inspector.parentInspector = null;
			inspector.removeEventListener(TouchEvent.TOUCH, ItemTouchHandler);
			PropertyInspectorFactory.Return(inspector);
			
			if (inspector == this._currentSelection)
			{
				this._currentSelection.isSelected = false;
				this._currentSelection = null;
			}
		}
		
		override protected function AddPropertyProxy(target:PropertyProxy, index:int=-1):void
		{
			if (target.name == "Name") return;
			var inspector:PropertyInspector = PropertyInspectorFactory.Get(target, PropertyListRenderer);
			inspector.parentInspector = this;
			inspector.addEventListener(TouchEvent.TOUCH, ItemTouchHandler);
			if (index<0) {
				this._contentContainer.addChild(inspector);
			} else {
				this._contentContainer.addChildAt(inspector, index);
			}
		}	
		
		private function ItemTouchHandler(touchEvent:TouchEvent):void
		{
			const inspector:PropertyListRenderer = touchEvent.currentTarget as PropertyListRenderer;
			if (this._currentSelection == inspector || touchEvent.target is Button)
			{
				return;
			}
			if (touchEvent.getTouch(inspector, TouchPhase.ENDED))
			{
				Select(inspector);
				if (this._currentSelectionProxy)
				{
					CommandsManager.global.Do(new EditPropertyProxyCommand(this._currentSelectionProxy, this._currentSelection.property));
				}
				this.dispatchEventWith(Event.CHANGE);
			}
		}
		
		private function SelectByProperty(property:PropertyProxy):void
		{
			if (this._currentSelection)
			{
				this._currentSelection.isSelected = false;
			}
			const inspector:PropertyListRenderer = GetByProperty(property);
			this._currentSelection = inspector;
			if (this._currentSelection)
			{
				this._currentSelection.isSelected = true;
			}
		}
		
		private function GetByProperty(property:PropertyProxy):PropertyListRenderer
		{
			const itemsLength:int = this._contentContainer.numChildren;
			for (var i:int = 0; i < itemsLength; i++) 
			{
				var currentItem:DisplayObject = this._contentContainer.getChildAt(i);
				if (currentItem is PropertyListRenderer)
				{
					if ((currentItem as PropertyListRenderer).property == property)
					{
						return currentItem as PropertyListRenderer;
					}
				}
			}
			return null;			
		}
		
		private function Select(inspector:PropertyListRenderer):void
		{
			if (this._currentSelection)
			{
				this._currentSelection.isSelected = false;
			}
			
			this._currentSelection = inspector;
			
			if (this._currentSelection)
			{
				this._currentSelection.isSelected = true;
			}
		}
		
		private function SelectionProxyChangeHandler(event:PropertyProxyProxyEvent):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		public function get currentSelection():PropertyInspector
		{
			return this._currentSelection;
		}
		
		override public function set property(value:PropertyProxy) : void {
			if (!(value is SelectablePropertyContainerProxy))
			{
				throw new Error("Property must be a SelectablePropertyContainerProxy.");
			}
			
			if (this._property == value)
			{
				return;
			}
			
			if (this._currentSelectionProxy)
			{
				this._currentSelectionProxy.RemoveChangeListener(SelectionProxyChangeHandler);
			}
			
			this._currentSelectionProxy = (value as SelectablePropertyContainerProxy).currentSelection;
			
			if (this._currentSelectionProxy)
			{
				this._currentSelectionProxy.AddChangeListener(SelectionProxyChangeHandler);
			}
			
			super.property = value;					
		}
	}
}