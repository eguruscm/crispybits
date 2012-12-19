package minima.proxies
{
	import minima.proxies.events.PropertyProxyEvent;
	
	/**
	 * The base class for all Property Proxies.
	 * 
	 * <p>Property Proxies follow a unique naming convention meant to clarify
	 * protected properties roles: Persistent properties (properties that should 
	 * be serialized to the document save file) starts with a <code>_p</code> prefix. 
	 * This means that a property named <code>_pProperty</code> should be serialized,
	 * while <code>_property</code> is a regular member property.</p>
	 * 
	 * <p>Every Property Proxy 
	 * 
	 * @author Bruno Tachinardi
	 */
	public class PropertyProxy
	{
		//Protected Persistent Properties
		protected var _pName : String;
		protected var p_bubbles:Boolean;
		protected var p_readOnly:Boolean;
		protected var p_customInspector:String = "default";
		
		//Protected Properties
		protected var _callbacks : Array;
		
		//Private Properties		
		private var _owner : PropertyContainerProxy;
		
		/**
		 * Creates a new PropertyProxy instance.
		 */
		public function PropertyProxy(name : String, readOnly:Boolean, bubbles:Boolean, customInspector:String=null)
		{
			this._callbacks;
			this.p_name = name;
			this.p_readOnly = readOnly;
			if (customInspector)
			{
				this._customInspector = customInspector;				
			}
		}
		
		/**
		 * The field name of this property
		 */
		public function get name() : String {
			return this.p_name;
		}
		
		/**
		 * The bubbles flag. When set to true, the Change Events of this proxy will bubble up.
		 * Each element in the chain must have 'bubble' set to true in order for the event
		 * to continue bubbling.
		 */
		public function get bubble() : Boolean {
			return this.p_bubbles;
		}
		
		/**
		 * @private
		 */
		public function set bubble(value:Boolean) : void {
			if (this.p_bubbles == value) return;
			this.p_bubbles = value;
		}
		
		/**
		 * The bubbles flag. When set to true, this proxy will ignore any value change requests.
		 */
		public function get readOnly() : Boolean {
			return this.p_readOnly;
		}
		
		/**
		 * The PropertyInspectorFactory uses this property to check which inspector
		 * it should construct for this specific proxy. If null, the default inspector 
		 * will be used.
		 */
		public function get customInspector() : String {
			return this._customInspector;
		}
		
		/**
		 * The property container proxy that owns this property. A property might not have an owner.
		 */
		public function get owner() : PropertyContainerProxy {
			return this._owner;
		}
		
		/**
		 * @private		 
		 * The owner setter is internal only
		 */
		internal function SetOwner(value:PropertyContainerProxy) : void {
			if (this._owner == value) return; 
			this._owner = value;
		}
		
		/**
		 * Adds a callback as a listener to changes inside this proxy.
		 * 
		 * Callbacks MUST receive a PropertyProxyEvent object as it's single parameter.
		 */
		public function AddChangeListener(callback : Function) : void {
			if (!this._callbacks) 
			{
				this._callbacks = new Array();
			}
			else if (this._callbacks.indexOf(callback) > -1) 
			{
				return;
			}
			this._callbacks.push(callback);
		}
		
		/**
		 * Removes a callback from the callbacks list.
		 */
		public function RemoveChangeListener(callback : Function) : void {
			var index : int = this._callbacks.indexOf(callback);
			if (index < 0) 
			{
				return;
			}
			this._callbacks.splice(index, 1);
			if (this._callbacks.length < 1) 
			{
				this._callbacks = null;
			}
		}
		
		/**
		 * Describes this object
		 */
		public function ToString(indentation:int=0) : String {
			return GetIndentation(indentation) + "[Property Proxy: " + this.p_name + "]";
		}
		
		/**
		 * @private
		 * 
		 * Returns an indentation string to be used as a prefix to Descriptions.
		 */
		protected function GetIndentation(indentation:int):String
		{
			var indentationText:String="";
			for (var i:int = 0; i < indentation; i++) 
			{
				indentationText += "\t";
			}			
			return indentationText;
		}
		
		/**
		 * @private
		 * 
		 * Returns a line break string with indentation
		 */
		protected function GetLineBreak(indentation:int):String
		{
			var indentationText:String="";
			for (var i:int = 0; i < indentation; i++) 
			{
				indentationText += "\t";
			}			
			return "\n" + indentationText;
		}
		
		/**
		 * @private
		 * 
		 * Notifies the listeners about an internal change.
		 * The event will bubble up to this property owner (if any) after triggering all of it's own listeners.
		 */
		protected function NotifyChange(event:PropertyProxyEvent) : void {
			if (this._callbacks) {
				const callbacksCount:int = this._callbacks.length;
				for (var i:int = 0; i < callbacksCount; i++) 
				{
					const currentCallback:Function = this._callbacks[i];
					if (currentCallback.length > 0)
					{
						currentCallback(event);
					}
					else if (currentCallback.length == 0)
					{
						currentCallback();
					}
				}
			}			
			if (this._owner && this.p_bubbles) 
			{
				this._owner.NotifyChange(event);
			}
			else 
			{
				this.NotifyRootChange();
			}
				
		}
		
		/** 
		 * Notifies all the nodes in the tree, up until the root, that this proxy has changed.
		 * 
		 * <p>No Proxy will notify any external observers (to do this, use the NotifyChange method,
		 * with bubbles set to true).</p>
		 * 
		 * <p>This was designed to notify root proxies that something has been changed in the tree
		 * and persistent data updates might be requested.</p>
		 */
		protected function NotifyRootChange() : void {					
			if (this._owner) 
			{
				this._owner.NotifyRootChange();
			}
		}
		
		/**
		 * Clones the current Proxy, returning a new object that is identical
		 * to this one, except subjective properties like 'owner', that 
		 * requires the object to be added to a container.
		 */
		public function Clone(nameFactory:Function=null) : PropertyProxy {
			throw new Error("The Clone method MUST be implemented in subclasses");
		}
		
	}
}