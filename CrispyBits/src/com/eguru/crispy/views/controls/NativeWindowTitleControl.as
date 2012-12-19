package com.eguru.crispy.views.controls
{
	import flash.desktop.NativeApplication;

	public class NativeWindowTitleControl extends DocumentControl
	{
		private static const TITLE_PREFIX:String = "Document - ";
		private static const TITLE_SUFIX:String = " - Crispy Bits";
		
		override protected function AddInvalidationListeners():void
		{
			this._documentModel.hasUnsavedChanges.AddChangeListener(DocumentChangedHandler);
			this._documentModel.nameProxy.AddChangeListener(DocumentChangedHandler);
		}
		
		override protected function RemoveInvalidationListeners():void
		{
			this._documentModel.hasUnsavedChanges.RemoveChangeListener(DocumentChangedHandler);
			this._documentModel.nameProxy.RemoveChangeListener(DocumentChangedHandler);
		}
		
		override protected function Commit():void
		{
			NativeApplication.nativeApplication.activeWindow.title = 
				TITLE_PREFIX +
				this._documentModel.name + 
				(this._documentModel.hasUnsavedChanges.value ? " [*]" : "") + 
				TITLE_SUFIX;
		}
	}
}