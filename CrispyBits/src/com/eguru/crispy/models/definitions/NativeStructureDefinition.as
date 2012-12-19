package com.eguru.crispy.models.definitions
{
	import minima.proxies.PropertyProxy;
	import minima.proxies.StringProxy;

	public class NativeStructureDefinition extends BaseDefinition
	{
		/**
		 * The native String type definition
		 */
		public static const STRING_DEFINITION : NativeStructureDefinition = new NativeStructureDefinition(
			"String",
			"A native string object"
		);
		
		/**
		 * The native Number type definition
		 */
		public static const NUMBER_DEFINITION : NativeStructureDefinition = new NativeStructureDefinition(
			"Number",
			"A native number object"
		);
		
		/**
		 * The native Boolean type definition
		 */
		public static const BOOLEAN_DEFINITION : NativeStructureDefinition = new NativeStructureDefinition(
			"Boolean",
			"A native boolean object"
		);
		
		public function NativeStructureDefinition(name:String, description:String)
		{
			super(name, description);
			
			//The name proxy
			if (this._nameProxy) this._nameProxy.RemoveChangeListener(NameChangedhandler);
			this._nameProxy = new StringProxy(CONTAINER_NAME_PROPERTY, name, true);
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new NativeStructureDefinition(
				nameFactory ? nameFactory(this.p_name) : this.p_name,
				this._descriptionProxy.value
			);
		}
	}
}