package minima.commands
{
	import minima.commands.core.ICommand;
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.PropertyProxy;
	import minima.proxies.SelectablePropertyContainerProxy;
	
	public class AddPropertyCommand implements ICommand
	{
		private var _target:PropertyProxy;
		private var _owner:PropertyContainerProxy;
		private var _originalIndex:int;
		private var _selectableOwner:SelectablePropertyContainerProxy;
		private var _originalSelection:PropertyProxy;
		
		public function AddPropertyCommand(container:PropertyContainerProxy, index:int=-1)
		{
			this._owner = container;
			this._selectableOwner = container as SelectablePropertyContainerProxy;
			this._originalIndex = index;
		}
		
		public function Do():void
		{
			if (this._selectableOwner)
			{
				this._originalSelection = this._selectableOwner.currentSelection.value;
			}
			
			if (this._originalIndex == -1)
			{
				this._target = this._owner.Create();
				this._originalIndex = this._owner.IndexOf(this._target);
			}
			else
			{
				this._target = this._owner.CreateAt(this._originalIndex);
			}
		}
		
		public function Undo():void
		{
			if (this._selectableOwner)
			{
				this._selectableOwner.LockSelection();
			}
			
			if (this._owner.RemoveAt(this._originalIndex) != this._target)
			{
				throw new Error("AddPropertyCommand removed the wrong property: invalid index");
			}
			
			if (this._selectableOwner)
			{
				this._selectableOwner.UnlockSelection();
				this._selectableOwner.currentSelection.value = this._originalSelection;
			}
		}
		
		public function Redo():void
		{
			this._owner.AddAt(this._target, this._originalIndex);			
		}
	}
}