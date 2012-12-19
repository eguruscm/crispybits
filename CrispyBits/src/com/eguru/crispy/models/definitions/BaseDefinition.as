package com.eguru.crispy.models.definitions
{
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.StringProxy;
	
	/**
	 * The base class for all definitions
	 * 
	 * @author Bruno Tachinardi
	 */
	public class BaseDefinition extends PropertyContainerProxy
	{
		
		protected var _descriptionProxy:StringProxy;
		
		/**
		 * Creates a new BaseDefinition instance
		 */
		public function BaseDefinition(name:String, 
									   description:String, 
									   saveObject:Object = null,
									   bubbles:Boolean=false)
		{
			super(name, null, true, bubbles);			
			
			//The description proxy
			this._descriptionProxy = new StringProxy("Description", description);
			AddAtInternal(this._descriptionProxy);
		}
		
		/**
		 * The proxy for this definition's description
		 */
		public function get descriptionProxy() : StringProxy {
			return this._descriptionProxy;
		}
	}
}