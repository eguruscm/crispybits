package minima.controls {
	
	import feathers.controls.ScrollContainer;
	import feathers.controls.Scroller;
	
	/**
	 * @author Bruno Tachinardi
	 * @contributor 
	 */
	public class PropertyContainerInspector extends SubPropertyContainerInspector
	{
		private var _scrollContainer:ScrollContainer;
		
		override protected function AutoSizeValidate():void 
		{
			super.AutoSizeValidate();	
			
			const lastScrollPosition:Number = this._scrollContainer.verticalScrollPosition;
			this._scrollContainer.setSize(NaN, NaN);
			this._scrollContainer.validate();
			this._scrollContainer.verticalScrollPosition = lastScrollPosition;
		}
		
		override protected function Layout():void {
			super.Layout();
			
			this._scrollContainer.width = this.actualWidth - (OUTLINE_THICKNESS * 2) - PADDING;
			this._scrollContainer.height = this.actualHeight - HEADER_HEIGHT - (OUTLINE_THICKNESS * 2);
		}
		
		override protected function initialize() : void {
			super.initialize();	
			
			this._scrollContainer = new ScrollContainer();
			this._scrollContainer.scrollerProperties.verticalScrollPolicy = Scroller.SCROLL_POLICY_ON;
			this._scrollContainer.scrollerProperties.snapScrollPositionsToPixels = true;
			this._scrollContainer.scrollerProperties.hasElasticEdges = false;
			this._scrollContainer.scrollerProperties.interactionMode = Scroller.INTERACTION_MODE_MOUSE;
			this._scrollContainer.scrollerProperties.scrollBarDisplayMode = Scroller.SCROLL_BAR_DISPLAY_MODE_FLOAT;
			this._scrollContainer.scrollerProperties.verticalAlign = Scroller.VERTICAL_ALIGN_MIDDLE;
			
			this._scrollContainer.x = this._contentContainer.x;
			this._scrollContainer.y = this._contentContainer.y;
			this._contentContainer.x = this._contentContainer.y = 0;
			
			this.addChild(this._scrollContainer);
			this._contentContainerParent = this._scrollContainer;			
			this._scrollContainer.addChild(this._contentContainer);
			
		}	
	}
}