package minima.proxies.events
{
	import minima.proxies.PropertyProxy;

	/**
	 * Base class for all property proxies change events.
	 * 
	 * @author Bruno Tachinardi
	 */
	public class PropertyProxyEvent
	{
		protected var _oldValue : *;
		protected var _newValue : *;
		protected var _target : PropertyProxy;
		
		/**
		 * Creates a new PropertyProxyEvent instance
		 */
		public function PropertyProxyEvent(target : PropertyProxy, oldValue : *, newValue : *)
		{
			this._target = target;
			this._oldValue = oldValue;
			this._newValue = newValue;
		}
		
		/**
		 * The target of this event, generically typed as PropertyProxy
		 */
		public function get genericTarget() : PropertyProxy {
			return this._target;
		}
		
		/**
		 * The new value of the proxy, generically typed
		 */
		public function get genericNewValue() : * {
			return this._newValue;
		}
		
		/**
		 * The old value of the proxy, generically typed
		 */
		public function get genericOldValue() : * {
			return this._oldValue;
		}
		
		/**
		 * Describes this event
		 */
		public function ToString() : String {
			return "Target '" + this._target.name + "' changed from '" + this._oldValue + "' to '" + this._newValue + "'";
		}
	}
}