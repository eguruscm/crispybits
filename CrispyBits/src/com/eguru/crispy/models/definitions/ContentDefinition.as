package com.eguru.crispy.models.definitions
{
	import minima.proxies.PropertyProxy;

	/**
	 * Defines a Content object
	 * 
	 * @author Bruno Tachinardi
	 */
	public class ContentDefinition extends BaseDefinition
	{
		/**
		 * Creates a new ContentDefinition instance
		 */
		public function ContentDefinition(name:String="", 
										  description:String="",
										  bubbles:Boolean=false)
		{
			super(name, description, bubbles);
		}
		
		/**
		 * Generates a raw Object representation of this content
		 */
		public function ToObject() : Object {
			//TODO: NOT IMPLEMENTED!
			return null;
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties, like 'owner', that 
		 * requires the object to be added to a container.
		 */
		override public function Clone(nameFactory:Function=null) : PropertyProxy {
			return new ContentDefinition(
				nameFactory ? nameFactory(this.p_name) : this.p_name,
				this._descriptionProxy.value,
				this.p_bubbles
			);
		}
	}
}