package com.eguru.crispy.models.proxies
{
	import com.eguru.crispy.models.definitions.ContentDefinition;
	import com.eguru.crispy.models.proxies.events.ContentProxyEvent;
	
	import minima.proxies.PropertyProxy;
	
	/**
	 * Proxy for a content object, that maps to the ContentDefinition,
	 * responsible for defining this content.
	 * 
	 * @author Bruno Tachinardi
	 */
	public class ContentProxy extends PropertyProxy
	{
		private var _value:ContentDefinition;
		
		/**
		 * Creates a new ContentProxy instance.
		 */
		public function ContentProxy(name:String, value:ContentDefinition, readOnly:Boolean=false, bubbles:Boolean=false)
		{
			super(name, readOnly, bubbles);
			this._value = value;
		}
		
		/**
		 * The current value of this instance
		 */
		public function get value() : ContentDefinition {
			return this._value;
		}
		
		/**
		 * @private
		 */
		public function set value(value:ContentDefinition) : void {
			if (this._value == value) return;
			const oldValue:ContentDefinition = this._value;
			this._value = value;
			NotifyChange(new ContentProxyEvent(this, oldValue, this._value));
		}		
		
		/**
		 * Describes this object
		 */
		override public function ToString(indentation:int=0) : String {
			return GetIndentation(indentation) + "[Content Proxy: " + this.p_name + " = " + this._value.ToObject() + "]";
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new ContentProxy(nameFactory ? nameFactory(this.p_name) : this.p_name, this._value, this.p_readOnly, this.p_bubbles);
		}
	}
}