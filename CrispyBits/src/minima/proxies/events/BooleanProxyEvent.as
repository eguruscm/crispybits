package minima.proxies.events
{
	import minima.proxies.BooleanProxy;
	
	/**
	 * Event for the BooleanProxy changes
	 * 
	 * @author Bruno Tachinardi
	 */
	public class BooleanProxyEvent extends PropertyProxyEvent
	{
		/**
		 * Creates a new BooleanProxyEvent instance
		 */
		public function BooleanProxyEvent(target:BooleanProxy, newValue:Boolean)
		{
			super(target, !newValue, newValue);
		}
		
		/**
		 * The target, as BooleanProxy
		 */
		public function get target() : BooleanProxy {
			return this._target as BooleanProxy;
		}
		
		/**
		 * The new value of the proxy, as Boolean
		 */
		public function get newValue() : Boolean {
			return this._newValue;
		}
		
		/**
		 * The old value of the proxy, as Boolean
		 */
		public function get oldValue() : Boolean {
			return this._oldValue;
		}
	}
}