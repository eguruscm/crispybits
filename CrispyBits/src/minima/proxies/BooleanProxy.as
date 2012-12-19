package minima.proxies
{
	import minima.proxies.events.BooleanProxyEvent;
	
	/**
	 * A Boolean typed property proxy
	 * 
	 * @author Bruno Tachinardi
	 */
	public class BooleanProxy extends PropertyProxy
	{
		private var _value:Boolean;
		
		/**
		 * Creates a new BooleanProxy instance
		 */
		public function BooleanProxy(name:String, initialValue:Boolean = false, readOnly:Boolean=false, bubbles:Boolean=false)
		{
			super(name, readOnly, bubbles);
			this._value = initialValue;
		}
		
		/**
		 * The value of this property
		 */
		public function get value() : Boolean {
			return this._value;
		}
		
		/**
		 * @private
		 */
		public function set value(value:Boolean) : void {
			if (this.p_readOnly) 
			{
				throw new Error("Cannot set value: property is read-only.");
			}
			if (this._value == value) return;			
			this._value = value;
			NotifyChange(new BooleanProxyEvent(this, this._value));
		}
		
		/**
		 * Describes this object
		 */
		override public function ToString(indentation:int=0) : String {
			return GetIndentation(indentation) + "[Boolean Proxy: " + this.p_name + " = " + this._value + "]";
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new BooleanProxy(nameFactory ? nameFactory(this.p_name) : this.p_name, this._value, this.p_readOnly, this.p_bubbles);
		}
	}
}