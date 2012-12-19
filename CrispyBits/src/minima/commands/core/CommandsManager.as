package minima.commands.core {
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * A manager that handles Do, Undo and Redo operations.
	 * 
	 * <p>Operations must implement the ICommand interface.</p>
	 * 
	 * @author Bruno Tachinardi
	 * @see minima.commands.core.ICommand
	 */
	public class CommandsManager extends EventDispatcher
	{
		//Protected static variables
		protected static var _instance : CommandsManager;		
		
		//Protected member variables
		protected var _commands : Vector.<ICommand>;
		protected var _currentIndex : int;
		protected var _lock : Boolean;
		protected var _historyLimit:int;
		
		/**
		 * Creates a new commands manager instance. 
		 * 
		 * <p>You can also use the CommandsManager.global property for global operations.</p>
		 * 
		 * @see minima.commands.core.ICommand
		 */
		public function CommandsManager() 
		{
			this._commands = new Vector.<ICommand>;
			this._currentIndex = -1;
			this._historyLimit = int.MAX_VALUE;
		}
		
		/**
		 * A global static instance of CommandsManager. Use this to easily access a centralized global manager.
		 * 
		 * <listing>Note: you will not initialize it: if the global instance does not yet exist when it is requested,
		 * a new one will automatically be created.</listing>
		 */
		public static function get global() : CommandsManager
		{
			if (!CommandsManager._instance) CommandsManager._instance = new CommandsManager();			
			return CommandsManager._instance;
		}
		
		/**
		 * Locks the manager, refusing any Do, Undo or Redo requests. Useful when your application is in a special mode
		 * and you mustn't perform any operations until its mode changes, in which case you should call the Unlock method
		 * to unlock the manager.
		 */
		public function Lock() : void
		{
			if (this._lock) return;
			this._lock = true;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Unlocks the manager, if it is locked.
		 */
		public function Unlock() : void
		{
			if (!this._lock) return;
			this._lock = false;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Returns the locked state of the manager. If the manager is locked, it cannot perform any of 
		 * the Do, Undo and Redo operations.
		 */
		public function get locked() : Boolean
		{
			return this._lock;
		}
		
		/**
		 * The maximum number of items that will be kept in memory
		 * for Undo/Redo operations.
		 */
		public function get historyLimit() : int {
			return this._historyLimit;
		}
		
		/**
		 * @private
		 */
		public function set historyLimit(value:int) : void {
			if (this._historyLimit == value) return;
			this._historyLimit = value;
			
			//Deletes items if necessary
			const itemsCount:int = this._commands.length;
			if (itemsCount > this._historyLimit) {
				const deletionCount:int =  itemsCount - this._historyLimit;
				this._commands.splice(0, deletionCount);
			}
			
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		/**
		 * Performs the provided command operation and adds it to the commands list.
		 * 
		 * Returns true if the operation succeeds, false if not 
		 * (manager is locked).
		 */
		public function Do(command : ICommand) : Boolean
		{
			if (this._lock) {
				return false;
			}
			
			//Removes all the commands after the current command index.
			//These were the 'Redo' operations that will be lost when you 
			//perform a new operation after undoing others.
			for (var i : int = this._commands.length - 1; i > this._currentIndex; i--) 
			{
				this._commands.splice(i, 1);
			}					
						
			//Removes the oldest command in the list if the total number
			//of items after the addition would be greater than the maximum
			if (this._commands.length + 1 > this._historyLimit) {
				this._commands.splice(0, 1);
			} else {
				//If the oldest command in the list was not removed,
				//the current index will increase
				this._currentIndex++;				
			}
			
			//Adds the command to the end of the list
			this._commands.push(command);	
			
			command.Do();
			this.dispatchEvent(new Event(Event.CHANGE));
			return true;
		}
		
		/**
		 * Undo the last operation done/redone.
		 * 
		 * Returns true if the operation succeeds, false if not 
		 * (no operation to be undone or manager is locked).
		 */
		public function Undo() : Boolean
		{
			if (this._lock || this._currentIndex < 0) return false;
			this._commands[this._currentIndex--].Undo();		
			this.dispatchEvent(new Event(Event.CHANGE));	
			return true;
		}
		
		/**
		 * Returns whether calling the Undo method will
		 * actually undo anything.
		 * 
		 * If ignoreLock is set to true, the manager lock's state
		 * will not be taken into account.
		 */
		public function CanUndo(ignoreLock:Boolean=false) : Boolean {
			return ((ignoreLock || !this._lock ) && this._currentIndex > -1);
		}
		
		/**
		 * Redo the last operation undone.
		 * 
		 * Returns true if the operation succeeds, false if not 
		 * (no operation to be redone or manager is locked).
		 */
		public function Redo() : Boolean
		{
			if (this._lock || this._currentIndex >= this._commands.length - 1) return false;
			this._commands[++this._currentIndex].Redo();
			this.dispatchEvent(new Event(Event.CHANGE));	
			return true;	
		}
		
		/**
		 * Returns whether calling the Redo method will
		 * actually redo anything.
		 * 
		 * If ignoreLock is set to true, the manager lock's state
		 * will not be taken into account.
		 */
		public function CanRedo(ignoreLock:Boolean=false) : Boolean {
			return ((ignoreLock || !this._lock ) && (this._currentIndex < this._commands.length - 1));
		}
		
		/**
		 * Returns the next operation to be undone.
		 * 
		 * If ignoreLock is set to false, the method will return null 
		 * if the manager is locked.
		 */
		public function PeekUndo(ignoreLock:Boolean=true) : ICommand
		{			
			if (!(CanUndo(ignoreLock))) return null;
			return this._commands[this._currentIndex];
		}
		
		/**
		 * Returns the next operation to be redone.
		 * 
		 * If ignoreLock is set to false, the method will return null 
		 * if the manager is locked.
		 */
		public function PeekRedo(ignoreLock:Boolean=true) : ICommand
		{			
			if (!(CanRedo(ignoreLock))) return null;
			return this._commands[this._currentIndex + 1];
		}
	}
}
