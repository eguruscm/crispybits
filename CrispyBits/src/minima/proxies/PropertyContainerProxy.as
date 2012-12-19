package minima.proxies
{
	
	import minima.proxies.events.PropertyContainerProxyEvent;
	import minima.proxies.events.StringProxyEvent;
	
	
	/**
	 * A Container for property proxies, that is a property proxy itself;
	 * 
	 * @author Bruno Tachinardi
	 */
	public class PropertyContainerProxy extends PropertyProxy
	{
		public static const CONTAINER_NAME_PROPERTY:String = "Name";
		
		protected var _properties:Vector.<PropertyProxy>;
		protected var _nameProxy:StringProxy;
		protected var _defaultProperty:PropertyProxy;
		private var _internalChange:Boolean;
		
		/**
		 * Creates a new PropertyContainerProxy instance
		 */
		public function PropertyContainerProxy(name : String, defaultProperty:PropertyProxy=null, readOnly:Boolean=false, bubbles:Boolean=false, nameReadOnly:Boolean=false)
		{
			super(name, readOnly, bubbles);
			this._properties = new Vector.<PropertyProxy>();			
			
			//The name proxy
			this._nameProxy = new StringProxy(CONTAINER_NAME_PROPERTY, name, nameReadOnly);
			this._nameProxy.AddChangeListener(this.NameChangedhandler);
			
			this._defaultProperty = defaultProperty;
		}
		
		/**
		 * Creates a new property by cloning the current default proxy.
		 */
		public function Create() : PropertyProxy {
			if (this.p_readOnly)
			{
				throw new Error("Cannot create properties in this container: container is read-only.");
			}
			return CreateAtInternal();
		}
		
		/**
		 * Creates a new property by cloning the current default proxy.
		 * This property will be placed at the specified index.
		 */
		public function CreateAt(index:int) : PropertyProxy {
			if (this.p_readOnly)
			{
				throw new Error("Cannot create properties in this container: container is read-only.");
			}
			return CreateAtInternal(index);
		}
		
		protected function CreateAtInternal(index:int=-1):PropertyProxy
		{
			if (!this._defaultProperty)
			{
				throw new Error("Cannot create properties in this container: default property is null.");
			}
			var property:PropertyProxy = this._defaultProperty.Clone(ChildrenNameFactory);
			return AddAtInternal(property, index);
		}
		
		private function ChildrenNameFactory(newName:String):String
		{
			var counter:int = 0;
			var currentName:String = newName;
			while(GetByName(currentName))
			{
				counter++;
				currentName = newName + " " + counter;
			}
			return currentName;
		}
		
		/**
		 * Adds a new property to this container. If the property is already inside another container (including this one)
		 * it will firstly be removed from its current owner before it will be added to this container.
		 */
		public function Add(property:PropertyProxy) : PropertyProxy {			
			if (this.p_readOnly) 
			{
				throw new Error("Cannot add properties to this container: container is read-only.");
			}
			return AddAtInternal(property);
		}
		
		/**
		 * Adds a new property to this container at the provided index. If the property is already inside another container 
		 * (including this one) it will firstly be removed from its current owner before it will be added to this container.
		 */
		public function AddAt(property:PropertyProxy, index:int = 0) : PropertyProxy {
			if (this.p_readOnly) 
			{
				throw new Error("Cannot add properties to this container: container is read-only.");
			}
			return AddAtInternal(property, index);
		}
		
		protected function AddAtInternal(property:PropertyProxy, index:int=-1):PropertyProxy
		{
			index = index < 0 ? this._properties.length : index;
			if (property.owner) 
			{
				property.owner.Remove(property);
			}
			
			if (property is PropertyContainerProxy)
			{
				(property as PropertyContainerProxy).nameProxy.AddChangeListener(ChildNameChangeHandler);
			}
			
			this._properties.splice(index, 0, property);
			property.SetOwner(this);
			
			NotifyChange(new PropertyContainerProxyEvent(this, PropertyContainerProxyEvent.PROPERTY_ADDED,
				null, property, index));
			return property;
		}
		
		private function ChildNameChangeHandler(event:StringProxyEvent):void
		{
			if (this._internalChange)
			{
				return;
			}
			
			var counter:int = 0;
			var currentName:String = event.newValue.replace(/ /g, "");
			const totalItems:int = this._properties.length;
			var breakWhile:Boolean;
			while(!breakWhile)
			{
				breakWhile = true;
				for (var i:int = 0; i < totalItems; i++) 
				{
					var currentProperty:PropertyContainerProxy = this._properties[i];
					if (currentProperty && 
						currentProperty.name == currentName && 
						currentProperty.nameProxy != event.target)
					{
						counter++;
						currentName = event.newValue + " " + counter;
						breakWhile = false;
						break;
					}
				}
			}
			
			if (event.newValue != currentName)
			{
				this._internalChange = true;
				event.target.value = currentName;
				this._internalChange = false;
			}
		}
		
		/**
		 * Removes the target property from this container. If the property is not inside this container, nothing will happen.
		 */
		public function Remove(property:PropertyProxy):PropertyProxy
		{
			if (this.p_readOnly) 
			{
				throw new Error("Cannot remove properties from this container: container is read-only.");
			}
			const index:int = this._properties.indexOf(property);
			if (index < 0) return property;		
			return RemoveAtInternal(index);
		}
		
		/**
		 * Removes the target property that is located at the specified index.
		 */
		public function RemoveAt(index:int = 0):PropertyProxy
		{
			if (this.p_readOnly) 
			{
				throw new Error("Cannot remove properties from this container: container is read-only.");
			}
			return RemoveAtInternal(index);
		}
		
		/**
		 * Removes all the children from this container
		 */
		public function RemoveAll():void
		{
			if (this.p_readOnly) 
			{
				throw new Error("Cannot remove properties from this container: container is read-only.");
			}
			const propertiesLength:int = this._properties.length - 1;
			for (var i:int = propertiesLength; i >= 0; i--) 
			{
				RemoveAtInternal(i);
			}
		}
		
		protected function RemoveAtInternal(index:int, notify:Boolean=true):PropertyProxy
		{			
			index = index < 0 ? this._properties.length - 1 : index;
			const property:PropertyProxy = this._properties.splice(index, 1)[0];
			property.SetOwner(null);
			
			if (property is PropertyContainerProxy)
			{
				(property as PropertyContainerProxy).nameProxy.RemoveChangeListener(ChildNameChangeHandler);
			}
			
			if (notify)
			{
				NotifyChange(new PropertyContainerProxyEvent(
					this, PropertyContainerProxyEvent.PROPERTY_REMOVED,	property, null, index)
				);				
			}
			return property;
		}
		
		/**
		 * Returns the number of properties this container has.
		 */
		public function get length():int
		{
			return this._properties.length;
		}
		
		/**
		 * Returns property located at the given index.
		 */
		public function Get(index:int):PropertyProxy
		{
			return this._properties[index];
		}
		
		/**
		 * Returns the property that has the provided name
		 */
		public function GetByName(name:String):PropertyProxy
		{
			const propertiesLength:int = this._properties.length;
			for (var i:int = 0; i < propertiesLength; i++) 
			{
				if (this._properties[i].name == name) return _properties[i];				
			}
			return null;
		}
		
		/**
		 * Returns the index number of the provided element
		 */
		public function IndexOf(property:PropertyProxy):int
		{
			return this._properties.indexOf(property);
		}
		
		/**
		 * Returns true if this container has the provided property
		 */
		public function Has(property:PropertyProxy):Boolean
		{
			return this._properties.indexOf(property) > -1;
		}
		
		/**
		 * Sets the property at the given index
		 */
		public function Set(property:PropertyProxy, index:int):PropertyProxy
		{
			if (this.p_readOnly) 
			{
				throw new Error("Cannot set properties in this container: container is read-only.");
			}
			return SetInternal(property, index);
		}
		
		protected function SetInternal(property:PropertyProxy, index:int):PropertyProxy
		{
			this.RemoveAtInternal(index);
			this.AddAtInternal(property, index);
			return property;
		}
		
		/**
		 * Sets the property that has the provided name
		 */
		public function SetByName(property:PropertyProxy, name:String):PropertyProxy
		{
			if (this.p_readOnly) 
			{
				throw new Error("Cannot set properties in this container: container is read-only.");
			}
			return SetByNameInternal(property, name);
		}
		
		protected function SetByNameInternal(property:PropertyProxy, name:String):PropertyProxy
		{
			const currentProperty:PropertyProxy = this.GetByName(name);
			var addIndex:int = this._properties.length;
			if (currentProperty) 
			{
				addIndex = this._properties.indexOf(currentProperty);
				this.RemoveAt(addIndex);
			}
			this.AddAt(property, addIndex);
			return property;
		}
		
		/**
		 * Describes this object.
		 */
		override public function ToString(indentation:int=0) : String {
			var propertiesDescriptions:String = "";
			const propertiesLength:int = this._properties.length;
			for (var i:int = 0; i < propertiesLength; i++) 
			{
				propertiesDescriptions += this._properties[i].ToString(indentation+1) + "\n";
			}
			
			
			return GetIndentation(indentation) + "[Property Container Proxy: " + this.p_name + " = {\n" +
				propertiesDescriptions + 
				GetIndentation(indentation) + "}]";
		}
		
		/**
		* The proxy for this definition's name
		*/
		public function get nameProxy() : StringProxy {
			return this._nameProxy;
		}
		
		/**
		 * The default object used to create new properties when
		 * calling the Create() and CreateAt() methods
		 */
		public function get defaultProperty() : PropertyProxy {
			return this._defaultProperty;
		}
		
		/**
		 * @private
		 */
		protected function NameChangedhandler(event:StringProxyEvent):void
		{
			this.p_name = event.newValue;
			NotifyChange(event);
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			var clone:PropertyContainerProxy = new PropertyContainerProxy(nameFactory ? nameFactory(this.p_name) : this.p_name, this._defaultProperty.Clone(), this.p_readOnly, this.p_bubbles);
			
			const elementsLength:int = this._properties.length;
			for (var i:int = 0; i < elementsLength; i++) 
			{
				clone.Add(this._properties[i].Clone());
			}		
			
			return clone;
		}
	}
}