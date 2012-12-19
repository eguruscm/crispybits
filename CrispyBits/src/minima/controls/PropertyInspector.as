package minima.controls
{
	import feathers.controls.Button;
	import feathers.controls.Header;
	import feathers.controls.supportClasses.LayoutViewPort;
	import feathers.core.FeathersControl;
	import feathers.events.FeathersEventType;
	import feathers.layout.VerticalLayout;
	
	import minima.commands.RemovePropertyCommand;
	import minima.commands.core.CommandsManager;
	import minima.proxies.PropertyProxy;
	import minima.proxies.events.PropertyProxyEvent;
	
	import starling.display.DisplayObject;
	import starling.display.DisplayObjectContainer;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	public class PropertyInspector extends FeathersControl
	{
		protected var HEADER_BUTTON_WIDTH:Number = 30;
		protected var HEADER_HEIGHT:Number = 30;
		protected var OUTLINE_THICKNESS:int = 4;
		protected var PADDING:int = 8;
		protected var CONTENT_PADDING:int = 5;
		protected var CONTENT_OFFSET:int = (OUTLINE_THICKNESS*2) + PADDING;
		protected var TOGGLE_BUTTON_HEIGHT:int = HEADER_HEIGHT;
		protected var TOGGLE_BUTTON_WIDTH:int = PADDING;
		
		/**
		 * Invalidation flag to indicate that the inspectorParent has changed.
		 *
		 * @see #isEnabled
		 */
		public static const INVALIDATION_FLAG_INSPECTOR_PARENT:String = "inspector_parent";
		
		//Darker Background colors
		/*
		protected static const OUTLINE_COLOR:uint = 0x1C1B13;
		protected static const BACKGROUND_COLOR:uint = 0x5E5E5E;
		protected static const PADDING_COLOR:uint = 0x1C1B13;
		*/
		
		//Lighter background colors
		protected var OUTLINE_COLOR:uint = 0xE6E6F7;
		protected var BACKGROUND_COLOR:uint = 0xFCFCFF;
		protected var PADDING_COLOR:uint = 0xE6E6F7;
		
		
		protected var _background:Quad;
		protected var _backgroundOutliner:Quad;
		protected var _paddingBar:Quad;
		
		protected var _property:PropertyProxy;
		protected var _header:Header;
		protected var _contentLayout:VerticalLayout;
		protected var _contentContainer:LayoutViewPort;
		protected var _parentInspector:SubPropertyContainerInspector;
		protected var _headerHoverItems:Vector.<DisplayObject>;
		protected var _headerHover:Boolean;
		protected var _targetVerticalScroll:Number = 0;
		protected var _contentContainerParent:DisplayObjectContainer;	
		protected var _contentWidth:Number;
		protected var _contentHeight:Number;
		protected var _hidden:Boolean;
		protected var _hiddenToggle:Button;
		protected var _deleteButton:Button;
		protected var _hiddenToggleEnabled:Boolean = true;
		
		/**
		 * Draw is being set to final. Override the following functions instead:
		 * - Commit: For data updates in sub-components 
		 * - ValidateState: For state changes (e.g. inspector changed to hidden)
		 * - ValidateParent: For inspectorParent changes
		 * - AutoSizeValidate: For validating sub-components automatic size
		 * - AutoSizeWidth: For determining an ideal width for this inspector
		 * - AutoSizeHeight: For determining an ideal height for this inspector
		 * - Layout: For final sub-components sizes and positions
		 */
		final override protected function draw():void
		{
			const dataInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_DATA);
			const selectionInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SELECTED);
			const stateInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_STATE);
			const parentInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_INSPECTOR_PARENT);
			const layoutInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_LAYOUT);
			var sizeInvalid:Boolean = this.isInvalid(INVALIDATION_FLAG_SIZE);
			
			if(dataInvalid)
			{
				this.Commit();
			}
						
			if(stateInvalid) 
			{
				this.ValidateState();
			}
			
			if(parentInvalid)
			{
				this.ValidateParent()					
			}
			
			sizeInvalid = this.AutoSize() || sizeInvalid;
			
			this._contentWidth = this.actualWidth - (OUTLINE_THICKNESS * 2) - PADDING;
			this._contentHeight = this._hidden ? 0 : (actualHeight - HEADER_HEIGHT - (OUTLINE_THICKNESS * 2));
			if(dataInvalid || sizeInvalid || stateInvalid || parentInvalid || layoutInvalid)
			{	
				this.Layout();	
			}
		}
		
		protected function ValidateParent():void
		{
			if (this._parentInspector && this._hiddenToggleEnabled)
			{
				if (!this._hiddenToggle.parent)
				{
					this.addChild(this._hiddenToggle);
				}
			}
			else
			{
				this._hiddenToggle.removeFromParent();
			}
		}
		
		protected function ValidateState():void
		{
			if (this._hidden)
			{
				this._contentContainerParent = this._contentContainer.parent;
				this._contentContainer.removeFromParent();
			}
			else 
			{
				if (!this._contentContainerParent) 
				{
					this._contentContainerParent = this;
				}
				this._contentContainerParent.addChild(this._contentContainer);
			}
		}
		
		/**
		 * Commits data to sub-components
		 */
		protected function Commit():void
		{		
			if (this._property)
			{
				this._header.title = this._property.name;
			}
			else
			{
				this._headerHoverItems = new Vector.<DisplayObject>();
				this._header.title = "Unknown";
			}			
			
			//The Delete button is avaiable if the inspected object belongs to a not-read-only list
			const deleteIndex:int = this._headerHoverItems.indexOf(this._deleteButton);
			if (this._property && this._property.owner && !this._property.owner.readOnly)
			{
				if (deleteIndex < 0)
				{
					this._headerHoverItems.push(this._deleteButton);	
				}
			}
			else
			{				
				if (deleteIndex > -1)
				{
					this._headerHoverItems.splice(deleteIndex, 1);
				}
			}
		}		
		
		/**
		 * Gets an ideal height for this component. 
		 * Internal use of the AutoSize method.
		 */
		protected function AutoSizeIdealHeight():Number
		{
			return (this._hidden ? 0 : this._contentContainer.height) + (OUTLINE_THICKNESS*2) + HEADER_HEIGHT;
		}
		
		/**
		 * Gets an ideal width for this component. 
		 * Internal use of the AutoSize method.
		 */
		protected function AutoSizeIdealWidth():Number
		{
			return Math.max(this._contentContainer.width + CONTENT_OFFSET, this._header.width + CONTENT_OFFSET);
		}
		
		/**
		 * Validates all sub-components automatic sizes and positions. 
		 * Remember to request autosizes only for non explicit sizes.
		 */
		protected function AutoSizeValidate():void
		{			
			this._header.setSize(NaN, NaN);
			this._header.validate();
			
			if (!this._hidden) 
			{
				this._contentContainer.width = NaN;
				this._contentContainer.height = NaN;
				this._contentContainer.validate();		
			}
		}
		
		/**
		 * Final sub-components sizes and positions determination
		 */
		protected function Layout():void
		{	
			
			this._header.width = this.contentWidth;			
			if (this._headerHover)
			{
				this._header.rightItems = this._headerHoverItems;
			}
			else
			{
				this._header.rightItems = null;
			}
			
			this._backgroundOutliner.width = this.actualWidth;
			this._backgroundOutliner.height = this.actualHeight;
			
			this._background.width = this.actualWidth - (OUTLINE_THICKNESS*2);
			this._background.height = this.contentHeight;
			
			this._paddingBar.height = this.actualHeight - (OUTLINE_THICKNESS*2);			
			
			if (!this._hidden) 
			{
				this._contentContainer.visibleWidth = this.contentWidth;
				this._contentContainer.visibleHeight = this.contentHeight;
			}
			
					
			this._hiddenToggle.height = actualHeight - (OUTLINE_THICKNESS*2);			
			
		}
		
		/**
		 * Initialization: create and add sub-components here
		 */
		override protected function initialize():void
		{		
			this.addEventListener(Event.REMOVED_FROM_STAGE, RemovedFromStageHandler);
			this._headerHoverItems = new Vector.<DisplayObject>();
			//Outliner
			this._backgroundOutliner = new Quad(20, 20, OUTLINE_COLOR);
			this.addChild(this._backgroundOutliner);
			
			//Internal Background
			this._background = new Quad(20, 20, BACKGROUND_COLOR);
			this._background.x = OUTLINE_THICKNESS;
			this._background.y = HEADER_HEIGHT + OUTLINE_THICKNESS;
			this.addChild(this._background);
			
			//Header
			this._header = new Header();
			this._header.gap = 5;
			this._header.x = OUTLINE_THICKNESS + PADDING;
			this._header.y = OUTLINE_THICKNESS;
			this._header.height = HEADER_HEIGHT;
			this._header.titleAlign = Header.TITLE_ALIGN_PREFER_LEFT;
			this.stage.addEventListener(TouchEvent.TOUCH, HeaderTouchHandler);
			this.addChild(this._header);		
			
			//The content layout
			this._contentLayout = new VerticalLayout();
			this._contentLayout.gap = 5;
			this._contentLayout.paddingLeft = this._contentLayout.paddingRight =
				this._contentLayout.paddingBottom = this._contentLayout.paddingTop = CONTENT_PADDING;
			this._contentLayout.hasVariableItemDimensions = true;
			this._contentLayout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_JUSTIFY;
			
			//The content container
			this._contentContainer = new LayoutViewPort();
			this._contentContainer.layout = this._contentLayout;
			this._contentContainer.y = HEADER_HEIGHT + OUTLINE_THICKNESS;
			this._contentContainer.x = OUTLINE_THICKNESS + PADDING;
			this._contentContainer.minWidth = this._contentContainer.minHeight = 20;
			this._contentContainer.addEventListener(FeathersEventType.RESIZE, ContentResizeHandler);
			this.addChild(this._contentContainer);
			
			//The padding bar
			this._paddingBar = new Quad(PADDING, 20, PADDING_COLOR);
			this._paddingBar.x = OUTLINE_THICKNESS;
			this._paddingBar.y = OUTLINE_THICKNESS;
			this.addChild(this._paddingBar);
			
			//Toggle hidden button
			this._hiddenToggle = new Button();
			this._hiddenToggle.width = TOGGLE_BUTTON_WIDTH;
			
			this._hiddenToggle.x = ((OUTLINE_THICKNESS + PADDING) /2) - (TOGGLE_BUTTON_WIDTH/2);
			this._hiddenToggle.y = ((OUTLINE_THICKNESS + HEADER_HEIGHT) /2) - (TOGGLE_BUTTON_HEIGHT/2);
			this._hiddenToggle.isToggle = true;
			this._hiddenToggle.addEventListener(Event.TRIGGERED, HiddenToggleHandler);
			this.addChild(this._hiddenToggle);	
			
			//Delete property button
			this._deleteButton = new Button();
			this._deleteButton.label = "X"
			this._deleteButton.width = HEADER_BUTTON_WIDTH;
			this._deleteButton.addEventListener(Event.TRIGGERED, DeletePropertyHandler);
			
		}
		
		private function ContentResizeHandler(event:Event):void
		{
			if (this._isValidating) 
			{
				return;
			}
			
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		private function RemovedFromStageHandler(event:Event):void
		{
			this._headerHover = false;
			this.stage.removeEventListener(TouchEvent.TOUCH, HeaderTouchHandler);
		}
		
		protected function HeaderTouchHandler(touchEvent:TouchEvent):void
		{
			if (touchEvent.getTouch(this._header, TouchPhase.HOVER) || 
				touchEvent.getTouch(this._header, TouchPhase.ENDED) ||
				touchEvent.getTouch(this._header, TouchPhase.BEGAN) ||
				touchEvent.getTouch(this._header, TouchPhase.MOVED))
			{
				if (this._headerHover) return;
				this._headerHover = true;
				this.invalidate(INVALIDATION_FLAG_LAYOUT);
			}
			else
			{
				if (!this._headerHover) return;
				this._headerHover = false;
				this.invalidate(INVALIDATION_FLAG_LAYOUT);
			}
		}
		
		private function HiddenToggleHandler(event:Event):void
		{
			this.hidden = !this._hidden;
		}
		
		/**
		 * The property currently being inspected
		 */
		public function get property() : PropertyProxy {
			return this._property;
		}
		
		public function set property(value:PropertyProxy) : void {
			if (this._property == value) return;
			if (this._property) this._property.RemoveChangeListener(PropertyChangeHandler);
			this._property = value;
			if (this._property) this._property.AddChangeListener(PropertyChangeHandler);
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * The current property container inspector that contains this property inspector
		 */
		public function get parentInspector() : SubPropertyContainerInspector {
			return this._parentInspector;
		}
		
		public function set parentInspector(value:SubPropertyContainerInspector) : void {
			if (this._parentInspector == value) return;
			this._parentInspector = value;
			this.invalidate(INVALIDATION_FLAG_INSPECTOR_PARENT);
		}
		
		/**
		 * The property change handler
		 */
		protected function PropertyChangeHandler(event:PropertyProxyEvent):void
		{
			this.invalidate(INVALIDATION_FLAG_DATA);
		}
		
		/**
		 * The calculated content width
		 */
		public function get contentWidth() : Number {
			return this._contentWidth;
		}
		
		/**
		 * The calculated content height
		 */
		public function get contentHeight() : Number {
			return this._contentHeight;
		}
		
		/**
		 * The hidden flag
		 */
		public function get hidden() : Boolean {
			return this._hidden;
		}
		
		/**
		 * @private
		 */
		public function set hidden(value:Boolean) : void {
			if (this._hidden == value) return;
			this._hidden = value;
			
			this.invalidate(INVALIDATION_FLAG_STATE);
		}
		
		/**
		 * @private
		 * Auto sizes this inspector based on its children
		 */
		private function AutoSize():Boolean
		{
			const needsWidth:Boolean = isNaN(this.explicitWidth);
			const needsHeight:Boolean = isNaN(this.explicitHeight);
			if(!needsWidth && !needsHeight)
			{
				return false;
			}
			AutoSizeValidate();
			var newWidth:Number = this.explicitWidth;
			if(needsWidth)
			{
				newWidth = AutoSizeIdealWidth();
			}
			var newHeight:Number = this.explicitHeight;
			if(needsHeight)
			{
				newHeight = AutoSizeIdealHeight();
			}
			return this.setSizeInternal(newWidth, newHeight, false);
		}
		
		/**
		 * Commands
		 */
		private function DeletePropertyHandler():void
		{
			CommandsManager.global.Do(new RemovePropertyCommand(this._property));
		}
	}
}