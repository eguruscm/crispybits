package minima.proxies.events
{
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.PropertyProxy;
	
	/**
	 * Event for the PropertyContainerProxy changes
	 * 
	 * @author Bruno Tachinardi
	 */
	public class PropertyContainerProxyEvent extends PropertyProxyEvent
	{	
		
		/**
		 * Events will be of the PROPERTY_ADDED type when a new property was added to the list.
		 */
		public static const PROPERTY_ADDED:String = "property_added";
		
		/**
		 * Events will be of the PROPERTY_REMOVED type when an already existing property was removed from the list.
		 */
		public static const PROPERTY_REMOVED:String = "property_removed";
		
		private var _index:int;
		private var _type:String;
		
		/**
		 * Creates a new PropertyContainerProxyEvent instance
		 */
		public function PropertyContainerProxyEvent(target:PropertyContainerProxy, type:String, oldValue:PropertyProxy, newValue:PropertyProxy, index : int)
		{
			super(target, oldValue, newValue);
			this._index = index;
			this._type = type;
		}
		
		/**
		 * The container that was changed
		 */
		public function get target() : PropertyContainerProxy {
			return this._target as PropertyContainerProxy;
		}
		
		/**
		 * The new value (if property was removed, this will return null)
		 */
		public function get newValue() : PropertyProxy {
			return this._newValue;
		}
		
		/**
		 * The old value (if property was added, this will return null)
		 */
		public function get oldValue() : PropertyProxy {
			return this._oldValue;
		}
		
		/**
		 * The type of changed that occured. Types might be either of the following:
		 * - PropertyContainerProxyEvent.PROPERTY_ADDED
		 * - PropertyContainerProxyEvent.PROPERTY_REMOVED
		 */
		public function get type() : String {
			return this._type;
		}
		
		/**
		 * The index position of where the change occured in the container's list.
		 */
		public function get index() : int {
			return this._index;
		}
		
		/**
		 * Describes this event
		 */
		override public function ToString() : String {
			return this.type + " at " + this._index;
		}
	}
}