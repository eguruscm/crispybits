package com.eguru.crispy.views.controls
{
	import com.eguru.crispy.models.DocumentModel;
	
	import feathers.core.FeathersControl;
	
	import minima.controls.PropertyContainerListInspector;
	import minima.controls.SelectionInspector;
	
	import starling.events.Event;
	
	public class DocumentInspector extends DocumentControl
	{
		private static const DOCUMENT_LIST_MIN_WIDTH:Number = 200;
		private static const SELECTION_LIST_MIN_WIDTH:Number = 200;
		private static const SELECTION_INSPECTOR_MIN_WIDTH:Number = 300;
		
		private var _documentList:PropertyContainerListInspector;
		private var _selectionList:PropertyContainerListInspector;
		private var _selectionInspector:SelectionInspector;
		
		
		override protected function AddInvalidationListeners():void
		{
			this._documentModel.currentSelection.AddChangeListener(DocumentChangedHandler);
		}
		
		override protected function RemoveInvalidationListeners():void
		{
			this._documentModel.currentSelection.RemoveChangeListener(DocumentChangedHandler);
		}
		
		override protected function initialize():void
		{
			this.stage.addEventListener(Event.RESIZE, StageResizeHandler);
			
			this._documentList = new PropertyContainerListInspector();
			this._documentList.minWidth = DOCUMENT_LIST_MIN_WIDTH;
			this.addChild(this._documentList);
			
			this._selectionList = new PropertyContainerListInspector();
			this._selectionList.minWidth = SELECTION_LIST_MIN_WIDTH;
			this.addChild(this._selectionList);
			
			this._selectionInspector = new SelectionInspector();
			this._selectionInspector.minWidth = SELECTION_INSPECTOR_MIN_WIDTH;
			this.addChild(this._selectionInspector);
		}	
		
		override protected function Commit():void
		{
			this._documentList.property = this._documentModel;
			this._selectionList.property = this._documentModel.currentSelection.value;
			this._selectionInspector.property = this._documentModel.currentSelection.value;
		}
		
		override protected function AutoSizeValidate():void
		{
			var spaceLeft:Number = stage.stageWidth;
			
			this._selectionInspector.setSize(NaN, NaN);
			this._selectionInspector.validate();
			spaceLeft -= this._selectionInspector.width;
			
			this._selectionList.maxWidth = Math.max(this._selectionList.minWidth, spaceLeft);
			this._selectionList.setSize(NaN, NaN);
			this._selectionList.validate();
			spaceLeft -= this._selectionList.width;
			
			this._documentList.maxWidth = Math.max(this._documentList.minWidth, spaceLeft);
			this._documentList.setSize(NaN, NaN);
			this._documentList.validate();
		}
		
		override protected function Layout():void
		{			
			this._selectionInspector.height = this._selectionList.height = this._documentList.height = this.actualHeight;
						
			this._selectionList.x = this._documentList.width;
			
			this._selectionInspector.x = this._selectionList.x + this._selectionList.width;
			this._selectionInspector.width = this.actualWidth - this._selectionInspector.x;
		}
		
		private function StageResizeHandler():void
		{
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}	
		
	}
}