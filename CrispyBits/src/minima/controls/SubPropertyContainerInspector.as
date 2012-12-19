package minima.controls {
	
	
	
	import feathers.controls.Button;
	import feathers.controls.TextInput;
	import feathers.core.ITextEditor;
	import feathers.events.FeathersEventType;
	
	import minima.commands.AddPropertyCommand;
	import minima.commands.EditStringCommand;
	import minima.commands.core.CommandsManager;
	import minima.controls.factories.PropertyInspectorFactory;
	import minima.controls.texts.EnterTextEditor;
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.PropertyProxy;
	import minima.proxies.events.PropertyContainerProxyEvent;
	import minima.proxies.events.PropertyProxyEvent;
	
	import starling.events.Event;
	

	public class SubPropertyContainerInspector extends PropertyInspector
	{		
		private var _contentContainerProperty:PropertyContainerProxy;
		private var _operationsBuffer:Vector.<PropertyProxyEvent> = new Vector.<PropertyProxyEvent>();
		private var _internalChange:Boolean;
		private var _editNameButton:Button;
		private var _addNewButton:Button;
		private var _editNameInput:TextInput;
		private var _lastNameText:String;
			
		
		/**
		 * Commits data to sub-components
		 */
		override protected function Commit():void
		{			
			super.Commit();
			if (this._contentContainerProperty != this._property) {
				
				//Target property changed, we need to remake the whole list
				this._contentContainerProperty = this._property as PropertyContainerProxy;
				
				if (this._contentContainerProperty) {
					//If the name proxy is read-only, we do not give the option to change this proxy's name
					const editIndex:int = this._headerHoverItems.indexOf(this._editNameButton);
					if (!this._contentContainerProperty.nameProxy.readOnly)
					{
						if (editIndex < 0)
						{
							this._headerHoverItems.splice(0, 0, this._editNameButton);
						}
					}
					else 
					{
						if (editIndex > -1)
						{
							this._headerHoverItems.splice(editIndex, 1);
						}
					}
				}
				
				this._contentContainer.removeChildren();
				this._operationsBuffer = new Vector.<PropertyProxyEvent>();
				if (this._contentContainerProperty) 
				{
					//Adds the container's properties
					const itemsLength:int = this._contentContainerProperty.length;
					for (var i:int = 0; i < itemsLength; i++) 
					{					
						AddPropertyProxy(this._contentContainerProperty.Get(i));
					}
					this._contentContainerProperty.AddChangeListener(ContainerChangesHandler);			
					
					
					//Adds the New Item Button if this container is not read-only
					if (!this._contentContainerProperty.readOnly &&
						this._contentContainerProperty.defaultProperty)
					{
						this._contentContainer.addChild(this._addNewButton);
					}
					
					this._contentContainer.invalidate();
					this._contentContainer.validate();
				}
			} else {				
				const operationsLength:int = this._operationsBuffer.length;
				for (var j:int = 0; j < operationsLength; j++) 
				{
					var operationEvent:PropertyContainerProxyEvent = this._operationsBuffer[j];
					if (operationEvent.type == PropertyContainerProxyEvent.PROPERTY_ADDED) 
					{
						AddPropertyProxy(operationEvent.newValue, operationEvent.index);
					} else 
					{
						RemovePropertyProxy(operationEvent.index);
					}
				}
				if (operationsLength) {
					this._contentContainer.invalidate();
					this._contentContainer.validate();
				}
				this._operationsBuffer = new Vector.<PropertyProxyEvent>();
			}
			
		}
		
		protected function RemovePropertyProxy(index:int):void
		{
			var inspector:PropertyInspector = this._contentContainer.removeChildAt(index) as PropertyInspector;
			inspector.parentInspector = null;
			PropertyInspectorFactory.Return(inspector);
		}
		
		protected function AddPropertyProxy(target:PropertyProxy, index:int=-1):void
		{
			if (target.name == "Name") return;
			var inspector:PropertyInspector = PropertyInspectorFactory.Create(target);
			inspector.parentInspector = this;
			if (index<0) {
				this._contentContainer.addChild(inspector);
			} else {
				this._contentContainer.addChildAt(inspector, index);
			}
		}
		
		private function ContainerChangesHandler(event:PropertyProxyEvent):void
		{
			if (this._internalChange || !(event is PropertyContainerProxyEvent)) return;
			_operationsBuffer.push(event);
			this.invalidate(INVALIDATION_FLAG_SIZE);
		}
		
		override protected function initialize() : void {
			super.initialize();
			
			//Edit Name Button
			this._editNameButton = new Button();
			this._editNameButton.label = "Edit";
			this._editNameButton.width = HEADER_BUTTON_WIDTH;
			this._editNameButton.addEventListener(Event.TRIGGERED, EditNameHandler);
			
			//Edit Name Text Input
			this._editNameInput = new TextInput();
			this._editNameInput.textEditorFactory = function():ITextEditor {return new EnterTextEditor();};
			this._editNameInput.addEventListener(FeathersEventType.ENTER, EditNameEnterHandler);
			this._editNameInput.addEventListener(FeathersEventType.FOCUS_OUT, EditNameFocusOutHandler);
			
			//The Add New Item Button
			this._addNewButton = new Button();
			this._addNewButton.label = "Add New Item";
			this._addNewButton.minWidth = 50;
			this._addNewButton.height = 25;
			this._addNewButton.addEventListener(Event.TRIGGERED, AddNewItemHandler);
		}	
		
		private function EditNameFocusOutHandler():void
		{			
			EndNameEditing();				
		}
		
		private function EditNameEnterHandler():void
		{
			EndNameEditing();			
		}
		
		private function EndNameEditing():void
		{	
			const currentText:String = this._editNameInput.text;
			CommandsManager.global.Do(new EditStringCommand(this._contentContainerProperty.nameProxy, currentText));
			this.removeChild(this._editNameInput);
			this._headerHover = false;
			this.invalidate(INVALIDATION_FLAG_LAYOUT);
		}
		
		private function EditNameHandler():void
		{
			this._editNameInput.width = this._header.width;
			this._editNameInput.height = this._header.height;
			this._editNameInput.x = this._header.x;
			this._editNameInput.y = this._header.y;
			this._editNameInput.text = this._header.title;
			this.addChild(this._editNameInput);
			this._editNameInput.setFocus();
		}
		
		private function AddNewItemHandler():void
		{
			CommandsManager.global.Do(new AddPropertyCommand(this._contentContainerProperty));
		}
	}
}