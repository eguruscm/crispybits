package minima.controls.texts
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextFieldAutoSize;
	
	import feathers.controls.text.TextFieldTextEditor;
	
	public class AutoSizeTextEditor extends TextFieldTextEditor
	{
		private var _lastTextFieldHeight:Object;
		override protected function initialize():void {
			super.initialize();
			this._minWidth = 100;
			this._wordWrap = true;
			this.textField.height = 10;
			this.textField.autoSize = TextFieldAutoSize.LEFT;
			this._lastTextFieldHeight = this.textField.height;
		}
		
		override public function set text(value:String):void {
			super.text = value;
		}
		
		/**
		 * @private
		 */
		override protected function textField_changeHandler(event:flash.events.Event):void
		{
			super.textField_changeHandler(event);
			if (this.textField.height != this._lastTextFieldHeight) {
				this.invalidate(INVALIDATION_FLAG_SIZE);
			}
			this._lastTextFieldHeight = this.textField.height;
		}
		
		/**
		 * @private
		 */
		override protected function textField_focusOutHandler(event:FocusEvent):void
		{
			super.textField_focusOutHandler(event);			
			this._savedSelectionIndex = this.textField.selectionBeginIndex;
		}
		
		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = Math.max(this._minWidth, Math.min(this._maxWidth, this.textField.width));
			}
			
			this.textField.width = newWidth;
			var newHeight:Number = Math.max(this._minHeight, Math.min(this._maxHeight, this.textField.height));
			
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		
	}
}