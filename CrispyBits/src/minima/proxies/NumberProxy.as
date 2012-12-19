package minima.proxies
{
	import minima.proxies.events.NumberProxyEvent;
	
	/**
	 * A Number typed property proxy
	 * 
	 * @author Bruno Tachinardi
	 */
	public class NumberProxy extends PropertyProxy
	{
		private var _value:Number;
		
		/**
		 * Creates a new NumberProxy instance
		 */
		public function NumberProxy(name:String, initialValue:Number = 0, readOnly:Boolean=false, bubbles:Boolean=false)
		{
			super(name, readOnly, bubbles);
			this._value = initialValue;
		}
		
		/**
		 * The current value of this instance
		 */
		public function get value() : Number {
			return this._value;
		}
		
		/**
		 * @private
		 */
		public function set value(value:Number) : void {
			if (this.p_readOnly) 
			{
				throw new Error("Cannot set value: property is read-only.");
			}
			if (this._value == value) return;
			const oldValue:Number = this._value;
			this._value = value;
			NotifyChange(new NumberProxyEvent(this, oldValue, this._value));
		}		
		
		/**
		 * Describes this object
		 */
		override public function ToString(indentation:int=0) : String {
			return GetIndentation(indentation) + "[Number Proxy: " + this.p_name + " = " + this._value + "]";
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new NumberProxy(nameFactory ? nameFactory(this.p_name) : this.p_name, this._value, this.p_readOnly, this.p_bubbles);
		}
	}
}