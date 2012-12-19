package com.eguru.crispy.models.definitions
{
	import com.eguru.crispy.models.proxies.ContentProxy;
	import com.eguru.crispy.models.proxies.StructureProxy;
	
	import minima.proxies.BooleanProxy;
	import minima.proxies.NumberProxy;
	import minima.proxies.PropertyProxy;
	
	/**
	 * Defines a Property object of a Structure
	 * 
	 * @author Bruno Tachinardi
	 */
	public class PropertyDefinition extends BaseDefinition
	{		
		private var _typeProxy:StructureProxy;
		private var _countProxy:NumberProxy;
		private var _defaultValueProxy:ContentProxy;
		private var _uniqueProxy:BooleanProxy;
		
		/**
		 * Creates a new PropertyDefinition instance
		 */
		public function PropertyDefinition(	name:String, 
											description:String,
											type:BaseDefinition, 
											count:int, 
											defaultValue:ContentDefinition,
											unique:Boolean,
											bubbles:Boolean=false)
		{
			super(name, description, bubbles);
			
			//Type proxy
			_typeProxy = new StructureProxy("Type", type);
			AddAtInternal(_typeProxy);
			
			//Count proxy
			_countProxy = new NumberProxy("Count", count);
			AddAtInternal(_countProxy);
			
			//Default value proxy
			_defaultValueProxy = new ContentProxy("Default Value", defaultValue);
			AddAtInternal(_defaultValueProxy);
			
			//Unique proxy
			_uniqueProxy = new BooleanProxy("Unique", unique);
			AddAtInternal(_uniqueProxy);			
		}
		
		/**
		 * The proxy for this definition's 'type' property (Structure)
		 */
		public function get typeProxy() : StructureProxy {
			return _typeProxy;
		}
		
		/**
		 * The proxy for this definition's 'count' property
		 */
		public function get countProxy() : NumberProxy {
			return _countProxy;
		}
		
		/**
		 * The proxy for this definition's 'defaultValue' property 
		 */
		public function get defaultValueProxy() : ContentProxy {
			return _defaultValueProxy;
		}
		
		/**
		 * The proxy for this definition's 'unique' property
		 */
		public function get uniqueProxy() : BooleanProxy {
			return _uniqueProxy;
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new PropertyDefinition(
				nameFactory ? nameFactory(this.p_name) : this.p_name,
				this._descriptionProxy.value,
				this._typeProxy.value,
				this._countProxy.value,
				this._defaultValueProxy.value,
				this._uniqueProxy.value,
				this.p_bubbles
			);
		}
	}
}