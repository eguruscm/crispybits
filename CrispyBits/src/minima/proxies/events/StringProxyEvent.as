package minima.proxies.events
{
	import minima.proxies.StringProxy;
	
	/**
	 * Event for the StringProxy changes
	 * 
	 * @author Bruno Tachinardi
	 */
	public class StringProxyEvent extends PropertyProxyEvent
	{
		/**
		 * Creates a new StringProxyEvent instance
		 */
		public function StringProxyEvent(target:StringProxy, oldValue:String, newValue:String)
		{
			super(target, oldValue, newValue);
		}
		
		/**
		 * The target, as StringProxy
		 */
		public function get target() : StringProxy {
			return this._target as StringProxy;
		}
		
		/**
		 * The new value of the proxy, as String
		 */
		public function get newValue() : String {
			return this._newValue;
		}
		
		/**
		 * The old value of the proxy, as String
		 */
		public function get oldValue() : String {
			return this._oldValue;
		}
	}
}