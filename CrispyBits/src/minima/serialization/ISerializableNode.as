package minima.serialization
{
	/**
	 * This is the interface that shows an object compliance with the 
	 * <code>FileSerializer</code> serialization. After correctly implementing 
	 * this interface, you will be able to save/load your objects to/from 
	 * persistent file objects through the <code>FileSerializer</code> API.
	 * 
	 * <p>By design, ISerializableNode objects should not have any
	 * constructor arguments. They should, instead, initialize member properties 
	 * in the <code>FromObject</code> method by extracting initialization data
	 * from the provided object.</p>
	 * 
	 * @see FileSerializer
	 * @see ISerializableDocument
	 */
	public interface ISerializableNode
	{
		/**
		 * Returns the current object to a raw representation that can be
		 * recovered by the <code>FromObject</code> method. Every meaningful
		 * data that should stay persistent should be included in this object.
		 * 
		 * @see #FromObject
		 */
		function ToObject():Object;
		
		/**
		 * Recovers the current object from a raw representation that was
		 * created by the <code>ToObject</code> method. 
		 * 
		 * <p>The <code>FromObject</code> method should also predict default 
		 * values to reduce redundancy in the serialized object.</p>
		 * 
		 * @see ToObject
		 */
		function FromObject(object:Object):void;
	}
}