package minima.proxies.events
{
	import minima.proxies.PropertyProxyProxy;
	import minima.proxies.PropertyProxy;
	
	/**
	 * Event for the StringProxy changes
	 * 
	 * @author Bruno Tachinardi
	 */
	public class PropertyProxyProxyEvent extends PropertyProxyEvent
	{
		/**
		 * Creates a new PropertyProxyProxyEvent instance
		 */
		public function PropertyProxyProxyEvent(target:PropertyProxyProxy, oldValue:PropertyProxy, newValue:PropertyProxy)
		{
			super(target, oldValue, newValue);
		}
		
		/**
		 * The target, as StringProxy
		 */
		public function get target() : PropertyProxyProxy {
			return this._target as PropertyProxyProxy;
		}
		
		/**
		 * The new value of the proxy, as PropertyProxy
		 */
		public function get newValue() : PropertyProxy {
			return this._newValue;
		}
		
		/**
		 * The old value of the proxy, as PropertyProxy
		 */
		public function get oldValue() : PropertyProxy {
			return this._oldValue;
		}
	}
}