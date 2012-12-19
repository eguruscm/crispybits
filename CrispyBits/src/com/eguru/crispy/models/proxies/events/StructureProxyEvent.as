package com.eguru.crispy.models.proxies.events
{
	import com.eguru.crispy.models.proxies.StructureProxy;
	
	import minima.proxies.events.PropertyProxyEvent;
	import com.eguru.crispy.models.definitions.BaseDefinition;
	
	/**
	 * Event for the StructureProxy changes
	 * 
	 * @author Bruno Tachinardi
	 */
	public class StructureProxyEvent extends PropertyProxyEvent
	{
		/**
		 * Creates a new StructureProxyEvent instance
		 */
		public function StructureProxyEvent(target:StructureProxy, oldValue:BaseDefinition, newValue:BaseDefinition)
		{
			super(target, oldValue, newValue);
		}
		
		/**
		 * The target, as StructureProxy
		 */
		public function get target() : StructureProxy {
			return this._target as StructureProxy;
		}
		
		/**
		 * The new value of the proxy, as StructureDefinitionModel
		 */
		public function get newValue() : BaseDefinition {
			return this._newValue;
		}
		
		/**
		 * The old value of the proxy, as StructureDefinitionModel
		 */
		public function get oldValue() : BaseDefinition {
			return this._oldValue;
		}
	}
}