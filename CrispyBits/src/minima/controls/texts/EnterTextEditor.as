package minima.controls.texts
{
	import flash.events.TextEvent;
	
	import feathers.controls.text.TextFieldTextEditor;
	import feathers.events.FeathersEventType;
	
	public class EnterTextEditor extends TextFieldTextEditor
	{
		override protected function initialize():void 
		{
			super.initialize();
			this.textField.addEventListener(TextEvent.TEXT_INPUT, TextInputHandler);
			this.textField.multiline = true;
		}
		
		protected function TextInputHandler(event:TextEvent):void
		{
			if (event.text == "\n") {
				dispatchEventWith(FeathersEventType.ENTER);
				event.preventDefault();
			}
		}
	}
}