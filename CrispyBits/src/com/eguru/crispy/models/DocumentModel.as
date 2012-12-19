package com.eguru.crispy.models
{	
	import com.eguru.crispy.models.definitions.StructureDefinition;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import minima.proxies.BooleanProxy;
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.SelectablePropertyContainerProxy;
	
	/**
	 * Defines a Structure object
	 * 
	 * @author Bruno Tachinardi
	 */
	public class DocumentModel extends SelectablePropertyContainerProxy
	{
		private var _structuresProxy:SelectablePropertyContainerProxy;
		private var _hasUnsavedChanges:BooleanProxy;
		private var _documentFile:File;
		
		/**
		 * Creates a new StructureDefinition instance
		 */
		public function DocumentModel(name:String = "NewDocument", uri:String = null)
		{			
			super(name, null, true, false, false);
			if (uri)
			{
				LoadDocument(uri);
			}
			else 
			{
				SetNewDocument();
			}
		}
		
		/**
		 * Loads the document from the provided uri
		 */
		public function LoadDocument(uri:String):void
		{			
			this._documentFile = new File(uri);
			var stream:FileStream = new FileStream();
			stream.open(this._documentFile, FileMode.READ);
			FromObject(JSON.parse(stream.readUTFBytes(stream.bytesAvailable)));
			stream.close(); 
		}
		
		/**
		 * Sets this document as a new document
		 */
		public function SetNewDocument():void
		{
			this.RemoveAll();
			const defaultStructureDefinition:StructureDefinition = new StructureDefinition(
				"NewStructure", 
				"This structure has no description yet."
			);			
			
			//The structures list proxy
			_structuresProxy = new SelectablePropertyContainerProxy("Structures", defaultStructureDefinition, false, false, true);
			AddAtInternal(_structuresProxy);
			
			
			//The unsaved changes proxy
			this._hasUnsavedChanges = new BooleanProxy("Unsaved Changes");
		}
		
		protected function DocumentLoadErrorHandler(event:IOErrorEvent):void
		{
			CreateNewDocument();
		}
		
		
		
		protected function DocumentLoadedHandler(event:Event):void
		{
			var data:Object = JSON.parse(this._documentLoader.data);
			super.FromObject(data);
			
		}
		
		public function get hasUnsavedChanges():BooleanProxy
		{
			return this._hasUnsavedChanges;
		}
		
		
		public function get structures():PropertyContainerProxy 
		{
			return this._structuresProxy;
		}
		
		override protected function NotifyRootChange():void
		{
			super.NotifyRootChange();
			if (this._hasUnsavedChanges)
			{
				this._hasUnsavedChanges.value = true;				
			}
		}
	}
}