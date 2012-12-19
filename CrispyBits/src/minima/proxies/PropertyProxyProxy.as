package minima.proxies
{
	import minima.proxies.events.PropertyProxyProxyEvent;
	
	/**
	 * A String typed property proxy
	 * 
	 * @author Bruno Tachinardi
	 */
	public class PropertyProxyProxy extends PropertyProxy
	{
		private var _value:PropertyProxy;
		
		/**
		 * Creates a new PropertyProxyProxy instance
		 */
		public function PropertyProxyProxy(name:String, initialValue:PropertyProxy = null, readOnly:Boolean=false, bubbles:Boolean=false)
		{
			super(name, readOnly, bubbles);
			this._value = initialValue;
		}
		
		/**
		 * The current value of this instance
		 */
		public function get value() : PropertyProxy {
			return this._value;
		}
		
		/**
		 * @private
		 */
		public function set value(value:PropertyProxy) : void {
			if (this.p_readOnly) 
			{
				throw new Error("Cannot set value: property is read-only.");
			}
			if (this._value == value) return;
			const oldValue:PropertyProxy = this._value;
			this._value = value;
			NotifyChange(new PropertyProxyProxyEvent(this, oldValue, this._value));
		}		
		
		/**
		 * Describes this object.
		 */
		override public function ToString(indentation:int=0) : String {
			return GetIndentation(indentation) + "[String Proxy: " + this.p_name + " = " + this._value + "]";
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new PropertyProxyProxy(nameFactory ? nameFactory(this.p_name) : this.p_name, this._value, this.p_readOnly, this.p_bubbles);
		}
	}
}