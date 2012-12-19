package minima.commands.core {
	
	/**
	 * Interface for Command implementations that can be used with the CommandsManager class.
	 * 
	 * @author Bruno Tachinardi
	 */
	public interface ICommand 
	{
		/**
		 * The Do method is called when the operation logic must happen.
		 */
		function Do() : void;
		
		/**
		 * The Undo method is called when the operation must be undone. 
		 */
		function Undo() : void;
		
		/**
		 * The Redo method is called when the operation must be redone.
		 */
		function Redo() : void;
	}
}
