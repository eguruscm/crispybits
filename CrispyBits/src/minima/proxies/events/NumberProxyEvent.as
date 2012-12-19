package minima.proxies.events
{
	import minima.proxies.NumberProxy;
	
	/**
	 * Event for the NumberProxy changes
	 * 
	 * @author Bruno Tachinardi
	 */
	public class NumberProxyEvent extends PropertyProxyEvent
	{
		/**
		 * Creates a new NumberProxyEvent instance
		 */
		public function NumberProxyEvent(target:NumberProxy, oldValue:Number, newValue:Number)
		{
			super(target, oldValue, newValue);
		}
		
		/**
		 * The target, as NumberProxy
		 */
		public function get target() : NumberProxy {
			return this._target as NumberProxy;
		}
		
		/**
		 * The new value of the proxy, as Number
		 */
		public function get newValue() : Number {
			return this._newValue;
		}
		
		/**
		 * The old value of the proxy, as Number
		 */
		public function get oldValue() : Number {
			return this._oldValue;
		}
	}
}