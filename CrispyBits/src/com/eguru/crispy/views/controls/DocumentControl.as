package com.eguru.crispy.views.controls
{
	import com.eguru.crispy.models.DocumentModel;
	
	import feathers.core.FeathersControl;	
	
	public class DocumentControl extends FeathersControl
	{
		protected var _documentModel:DocumentModel;		
		
		public function get documentModel():DocumentModel
		{
			return this._documentModel;
		}
		
		public function set documentModel(value:DocumentModel):void
		{
			if (this._documentModel == value)
			{
				return;
			}
			
			if (this._documentModel)
			{
				RemoveInvalidationListeners();
			}
			
			this._documentModel = value;
			
			if (this._documentModel)
			{
				AddInvalidationListeners();
			}
			
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		protected function AddInvalidationListeners():void
		{
			
		}
		
		protected function RemoveInvalidationListeners():void
		{
			
		}
		
		protected function DocumentChangedHandler():void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		
		override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(dataInvalid)
			{
				this.Commit();
			}
			
			sizeInvalid = this.AutoSize() || sizeInvalid;
			
			if(dataInvalid || sizeInvalid)
			{	
				this.Layout();	
			}
		}
		
		protected function Commit():void
		{
			
		}
		
		protected function AutoSizeValidate():void
		{
			
		}
		
		protected function Layout():void
		{			
			
		}
		
		
		private function AutoSize():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			AutoSizeValidate();
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = stage.stageWidth;
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = stage.stageHeight;
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
	}
}