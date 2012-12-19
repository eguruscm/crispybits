package minima.serialization
{
	
	/**
	 * The <code>ISerializableDocument</code> interface defines 
	 * the required functionality for serializable documents
	 * to be compliant with the <code>FileSerializer</code>
	 * class.
	 * 
	 * @see FileSerializer
	 * @see ISerializableNode
	 */
	public interface ISerializableDocument extends ISerializableNode
	{
		/**
		 * Retrieves the document's Uniform Resource Identifier (URI),
		 * used for the document's file manipulation.
		 */
		function get documentUri():String;
	}
}