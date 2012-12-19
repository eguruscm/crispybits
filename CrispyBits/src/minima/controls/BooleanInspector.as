package minima.controls
{
	import feathers.controls.Check;
	
	import minima.commands.EditBooleanCommand;
	import minima.commands.core.CommandsManager;
	import minima.proxies.BooleanProxy;
	
	import starling.events.Event;

	public class BooleanInspector extends PropertyInspector
	{
		protected static const CHECKBOX_HEIGHT:Number = 30;
		
		protected var _booleanProxy:BooleanProxy;
		private var _checkbox:Check;
		private var _internalChange:Boolean;
		
		/**
		 * Commits data to sub-components
		 */
		override protected function Commit():void
		{
			super.Commit();
			this._booleanProxy = this._property as BooleanProxy;
			this._internalChange = true;
			this._checkbox.isSelected = this._booleanProxy.value;
			this._internalChange = false;
			this._checkbox.label = this._booleanProxy.value ? "True" : "False";
		}		
		
		/**
		 * Initialization: create and add sub-components here
		 */
		override protected function initialize():void
		{
			super.initialize();
			this._checkbox = new Check();
			this._checkbox.horizontalAlign = "left";
			this._checkbox.addEventListener(Event.CHANGE, CheckBoxTriggerHandler);
			this._contentContainer.addChild(this._checkbox);
		}
		
		/**
		 * @private
		 */
		private function CheckBoxTriggerHandler(event:Event):void
		{
			if (this._internalChange) return
			CommandsManager.global.Do(new EditBooleanCommand(this._booleanProxy, this._checkbox.isSelected));
		}
	}
}