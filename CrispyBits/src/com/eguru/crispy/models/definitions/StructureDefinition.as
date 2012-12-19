package com.eguru.crispy.models.definitions
{
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.PropertyProxy;
	
	/**
	 * Defines a Structure object
	 * 
	 * @author Bruno Tachinardi
	 */
	public class StructureDefinition extends BaseDefinition
	{
		private var _propertiesProxy:PropertyContainerProxy;
		private var _defaultPropertyDefinition:PropertyProxy;
		
		/**
		 * Creates a new StructureDefinition instance
		 */
		public function StructureDefinition(name:String, 
											description:String, 
											bubbles:Boolean=false)
		{
			
			super(name, description, bubbles);

			this._defaultPropertyDefinition = new PropertyDefinition(
				"New Property", 
				"Property Description", 
				NativeStructureDefinition.STRING_DEFINITION,
				1,
				null,
				true,
				false
			);
			
			
			//The properties list proxy
			_propertiesProxy = new PropertyContainerProxy("Properties", this._defaultPropertyDefinition, false, false, true);
			AddAtInternal(_propertiesProxy);
			
		}
		
		/**
		 * Adds a new PropertyDefinition to this structure
		 */
		public function AddPropertyDefinition(propertyDefinition : PropertyDefinition):PropertyDefinition {
			_propertiesProxy.Add(propertyDefinition);
			return propertyDefinition;
		}
		
		/**
		 * Removes a PropertyDefinition from this structure
		 */
		public function RemovePropertyDefinition(propertyDefinition : PropertyDefinition):PropertyDefinition {
			_propertiesProxy.Remove(propertyDefinition);
			return propertyDefinition;
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new StructureDefinition(
				nameFactory ? nameFactory(this.p_name) : this.p_name,
				this._descriptionProxy.value,
				this.p_bubbles
			);
		}
	}
}