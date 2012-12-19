package com.eguru.crispy.models.proxies
{
	import com.eguru.crispy.models.definitions.BaseDefinition;
	import com.eguru.crispy.models.proxies.events.StructureProxyEvent;
	
	import minima.proxies.PropertyProxy;
	
	/**
	 * Proxy for a property definition type, that maps to the StructureDefinition,
	 * responsible for defining this type.
	 * 
	 * @author Bruno Tachinardi
	 */
	public class StructureProxy extends PropertyProxy
	{
		private var _value:BaseDefinition;
		
		/**
		 * Creates a new StructureProxy instance.
		 */
		public function StructureProxy(name:String, value:BaseDefinition, readOnly:Boolean=false, bubbles:Boolean=false)
		{
			super(name, readOnly, bubbles);
			this._value = value;
		}
		
		/**
		 * The current value of this instance
		 */
		public function get value() : BaseDefinition {
			return this._value;
		}
		
		/**
		 * @private
		 */
		public function set value(value:BaseDefinition) : void {
			if (this._value == value) return;
			const oldValue:BaseDefinition = this._value;
			this._value = value;
			NotifyChange(new StructureProxyEvent(this, oldValue, this._value));
		}		
		
		/**
		 * Describes this object
		 */
		override public function ToString(indentation:int=0) : String {
			return GetIndentation(indentation) + "[Structure Proxy: " + this.p_name + " = " + this._value.name + "]";
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new StructureProxy(nameFactory ? nameFactory(this.p_name) : this.p_name, this._value, this.p_readOnly, this.p_bubbles);
		}
	}
}