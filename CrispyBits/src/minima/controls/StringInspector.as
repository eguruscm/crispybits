package minima.controls
{
	import flash.utils.Timer;
	
	import feathers.core.ITextEditor;
	
	import minima.commands.EditStringCommand;
	import minima.commands.core.CommandsManager;
	import minima.controls.texts.AutoSizeTextEditor;
	import minima.proxies.StringProxy;
	
	import starling.events.Event;

	public class StringInspector extends PropertyInspector
	{
		protected static const SAVE_DELAY:Number = 2000;
		
		protected var _stringProperty:StringProxy;
		protected var _input:AutoSizeTextInput;
		protected var _changeTimer:Timer;
		protected var _internalChange:Boolean;
		protected var _lastText:String;
		protected var _command:EditStringCommand;
		
		/**
		 * Commits data to sub-components
		 */
		override protected function Commit():void
		{
			super.Commit();
			this._stringProperty = this._property as StringProxy;
			this._internalChange = true;
			if (this._input.text != String(this._stringProperty.value))
				this._input.text = String(this._stringProperty.value);
			this._internalChange = false;
		}	
		
		override protected function AutoSizeValidate():void
		{
			this._input.validate();
			super.AutoSizeValidate();
		}
		
		override protected function Layout():void {
			super.Layout();
			this._input.textWidth = this.contentWidth;
		}		
		
		/**
		 * Initialization: create and add sub-components here
		 */
		override protected function initialize():void
		{
			super.initialize();
			this._input = new AutoSizeTextInput();
			this._input.addEventListener(Event.CHANGE, InputChangeHandler);
			this._input.textEditorFactory = function():ITextEditor {return new AutoSizeTextEditor();};
			
			this._contentContainer.addChild(this._input);
			
			this._changeTimer = new Timer(SAVE_DELAY, 1);
		}
		
		/**
		 * @private
		 */
		private function InputChangeHandler(event:Event):void
		{	
			const currentText:String = this._input.text;
			if (this._internalChange) {
				this._lastText = this._input.text;
				return;
			}
			
			
			if (!this._changeTimer.running) {				
				CommandsManager.global.Do(this._command = new EditStringCommand(this._stringProperty, currentText));
				this._changeTimer.reset();
				this._changeTimer.start();
			} else {
				this._command.Update(currentText);
			}		
			
			this._lastText = this._input.text;
		}
	}
}