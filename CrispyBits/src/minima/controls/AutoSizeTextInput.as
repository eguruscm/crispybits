package minima.controls
{
	
	import feathers.controls.TextInput;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	
	import starling.display.DisplayObjectContainer;
	import starling.events.Event;
	
	public class AutoSizeTextInput extends TextInput
	{
		
		public function set textWidth(value:Number) : void {
			this.setSizeInternal(value, actualHeight, false);
		}
		
		/**
		 * @private
		 */
		private function ResizeHandler(event:Event):void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
			var currentParent:DisplayObjectContainer = this;
			while (true) {
				currentParent = currentParent.parent
				if (currentParent == null) return;
				if (currentParent is FeathersControl) {
					(currentParent as FeathersControl).invalidate(INVALIDATION_FLAG_SIZE);
				}
			}
			
		}
		
		/**
		 * @private
		 */
		override protected function createTextEditor():void
		{
			if (this.textEditor) {
				this.textEditor.removeEventListener(FeathersEventType.RESIZE, ResizeHandler);
			}
			super.createTextEditor();
			this.textEditor.addEventListener(FeathersEventType.RESIZE, ResizeHandler);
		}
		
		/**
		 * @private
		 */
		override protected function autoSizeIfNeeded():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);			
			
			this.textEditor.validate();
			
			var newWidth:Number = this.explicitWidth;
			var newHeight:Number = isNaN(this.textEditor.height) ? _originalSkinHeight : this.textEditor.height + this._paddingLeft + this._paddingRight;
			if(needsWidth)
			{
				newWidth = isNaN(this.textEditor.width) ? _originalSkinWidth : this.textEditor.width;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		/**
		 * @private
		 */
		override protected function layout():void
		{			
			if(this.currentBackground)
			{
				this.currentBackground.visible = true;
				this.currentBackground.touchable = true;
				this.currentBackground.width = this.actualWidth;
				this.currentBackground.height = this.actualHeight;
			}
			
			this.textEditor.x = this._paddingLeft;
			this.textEditor.y = this._paddingTop;
			this.textEditor.width = this.actualWidth - this._paddingLeft - this._paddingRight;
		}
	}
}