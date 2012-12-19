package minima.commands
{
	import minima.commands.core.ICommand;
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.PropertyProxy;
	import minima.proxies.SelectablePropertyContainerProxy;
	
	public class RemovePropertyCommand implements ICommand
	{
		private var _target:PropertyProxy;
		private var _owner:PropertyContainerProxy;
		private var _originalIndex:int;
		private var _selectableOwner:SelectablePropertyContainerProxy;
		private var _originalSelection:PropertyProxy;
		public function RemovePropertyCommand(target:PropertyProxy)
		{
			this._target = target;
			this._owner = this._target.owner;
			this._selectableOwner = this._owner as SelectablePropertyContainerProxy;
			this._originalIndex = this._owner.IndexOf(this._target);
			
		}
		
		public function Do():void
		{
			if (this._selectableOwner)
			{
				this._originalSelection = this._selectableOwner.currentSelection.value;
			}
			
			if (this._owner.RemoveAt(this._originalIndex) != this._target)
				throw new Error("RemovePropertyCommand removed the wrong property: invalid index");
		}
		
		public function Undo():void
		{
			if (this._selectableOwner)
			{
				this._selectableOwner.LockSelection();
			}
			
			this._owner.AddAt(this._target, this._originalIndex);
			
			if (this._selectableOwner)
			{
				this._selectableOwner.UnlockSelection();
				this._selectableOwner.currentSelection.value = this._originalSelection;
			}
		}
		
		public function Redo():void
		{
			if (this._owner.RemoveAt(this._originalIndex) != this._target)
				throw new Error("RemovePropertyCommand removed the wrong property: invalid index");
		}
	}
}