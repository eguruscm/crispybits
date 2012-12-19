package minima.controls
{
	import flash.utils.Timer;
	
	import feathers.controls.TextInput;
	
	import minima.commands.EditNumberCommand;
	import minima.commands.core.CommandsManager;
	import minima.proxies.NumberProxy;
	
	import starling.events.Event;

	public class NumberInspector extends PropertyInspector
	{
		protected static const SAVE_DELAY:Number = 2000;
		
		protected var _numberProperty:NumberProxy;
		protected var _input:TextInput;
		protected var _changeTimer:Timer;
		protected var _internalChange:Boolean;
		protected var _lastText:String;
		protected var _command:EditNumberCommand;
		
		/**
		 * Commits data to sub-components
		 */
		override protected function Commit():void
		{
			super.Commit();
			this._numberProperty = this._property as NumberProxy;
			this._internalChange = true;
			this._input.text = String(this._numberProperty.value);
			this._internalChange = false;
		}	
		
		/**
		 * Initialization: create and add sub-components here
		 */
		override protected function initialize():void
		{
			super.initialize();
			this._input = new TextInput();
			this._input.addEventListener(Event.CHANGE, InputChangeHandler);
			this._contentContainer.addChild(this._input);
			
			this._changeTimer = new Timer(SAVE_DELAY, 1);
		}
		
		/**
		 * @private
		 */
		private function InputChangeHandler(event:Event):void
		{	
			const currentText:String = this._input.text;
			const value:Number = Number(this._input.text);
			if (this._internalChange) {
				this._lastText = this._input.text;
				return;
			}
			
			if (isNaN(value) || (value > int.MAX_VALUE) || (value < int.MIN_VALUE))
			{
				this._internalChange = true;
				this._input.text = this._lastText;
				this._internalChange = false;
				return;
			}
			
			
			this._internalChange = true;
			this._input.text = value + "";
			this._internalChange = false;
			
			if (!this._changeTimer.running) {				
				CommandsManager.global.Do(this._command = new EditNumberCommand(this._numberProperty, value));
				this._changeTimer.reset();
				this._changeTimer.start();
			} else {
				this._command.Update(value);
			}		
			
			this._lastText = this._input.text;
		}
	}
}