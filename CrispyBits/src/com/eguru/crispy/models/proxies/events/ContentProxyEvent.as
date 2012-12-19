package com.eguru.crispy.models.proxies.events
{
	import com.eguru.crispy.models.proxies.ContentProxy;
	import minima.proxies.events.PropertyProxyEvent;
	import com.eguru.crispy.models.definitions.ContentDefinition;
	
	/**
	 * Event for the ContentProxy changes
	 * 
	 * @author Bruno Tachinardi
	 */
	public class ContentProxyEvent extends PropertyProxyEvent
	{
		/**
		 * Creates a new ContentProxyEvent instance
		 */
		public function ContentProxyEvent(target:ContentProxy, oldValue:ContentDefinition, newValue:ContentDefinition)
		{
			super(target, oldValue, newValue);
		}
		
		/**
		 * The target, as ContentProxy
		 */
		public function get target() : ContentProxy {
			return this._target as ContentProxy;
		}
		
		/**
		 * The new value of the proxy, as ContentDefinitionModel
		 */
		public function get newValue() : ContentDefinition {
			return this._newValue;
		}
		
		/**
		 * The old value of the proxy, as ContentDefinitionModel
		 */
		public function get oldValue() : ContentDefinition {
			return this._oldValue;
		}
	}
}