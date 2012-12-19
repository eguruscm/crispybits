package minima.controls
{
	public class PropertyListRenderer extends SubPropertyContainerInspector
	{
		protected var _isSelected:Boolean;
		protected var SELECTED_OUTLINE_COLOR:uint = 0xAEAEE8;
		
		override protected function initialize():void 
		{
			super.initialize();
			this.removeChild(this._hiddenToggle);
			this.hidden = true;
			this._hiddenToggleEnabled = false;
		}
		
		public function get isSelected():Boolean
		{
			return this._isSelected;
		}
		
		public function set isSelected(value:Boolean):void
		{
			if (this._isSelected == value)
			{
				return;
			}
			this._isSelected = value;
			if (this._isSelected)
			{				
				this._backgroundOutliner.color = SELECTED_OUTLINE_COLOR;
			}
			else 
			{
				this._backgroundOutliner.color = OUTLINE_COLOR;
			}
		}
	}
}