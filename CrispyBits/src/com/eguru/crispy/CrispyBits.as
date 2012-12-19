package com.eguru.crispy
{
	import com.eguru.crispy.models.DocumentModel;
	import com.eguru.crispy.models.definitions.ContentDefinition;
	import com.eguru.crispy.models.definitions.NativeStructureDefinition;
	import com.eguru.crispy.models.definitions.PropertyDefinition;
	import com.eguru.crispy.models.definitions.StructureDefinition;
	import com.eguru.crispy.views.controls.DocumentInspector;
	import com.eguru.crispy.views.controls.NativeWindowTitleControl;
	
	import minima.MinimaMetalWorksMobileTheme;
	import minima.bootstrappers.InspectorMappingBootstrapper;
	import minima.controls.BooleanInspector;
	import minima.controls.NumberInspector;
	import minima.controls.PropertyContainerListInspector;
	import minima.controls.PropertyInspector;
	import minima.controls.SelectionInspector;
	import minima.controls.StringInspector;
	import minima.proxies.BooleanProxy;
	import minima.proxies.NumberProxy;
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.PropertyProxy;
	import minima.proxies.PropertyProxyProxy;
	import minima.proxies.SelectablePropertyContainerProxy;
	import minima.proxies.StringProxy;
	import minima.proxies.events.PropertyProxyEvent;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class CrispyBits extends Sprite
	{
		//Views
		private var _theme:MinimaMetalWorksMobileTheme;
		private var _documentModel:DocumentModel;
		private var _documentControl:DocumentInspector;
		private var _windowTitleControl:NativeWindowTitleControl;
		
		public function CrispyBits()
		{			
			new CrispyInspectorMappingBootstrapper();
			addEventListener(Event.ADDED_TO_STAGE, Initialize);
		}		
		
		private function Debug():void
		{
			//DebugModels();
			//DebugViews();			
		}
		
		private function DebugModels():void
		{
			//Models Debugging
			const pointStructure : StructureDefinition = new StructureDefinition("Point", "A beautiful point");
			pointStructure.AddPropertyDefinition(new PropertyDefinition(
				"X", "The X coordinate", NativeStructureDefinition.NUMBER_DEFINITION, 1, new ContentDefinition(), false
			));
			pointStructure.AddPropertyDefinition(new PropertyDefinition(
				"Y", "The Y coordinate", NativeStructureDefinition.NUMBER_DEFINITION, 1, new ContentDefinition(), false
			));
			
			trace(pointStructure.ToString());
			pointStructure.AddChangeListener(function(event:PropertyProxyEvent):void{
				//trace(event.ToString());
			});
			
			var properties : PropertyContainerProxy = pointStructure.GetByName("Properties") as PropertyContainerProxy;
			var xProperty : PropertyDefinition = properties.GetByName("X") as PropertyDefinition;
			xProperty.descriptionProxy.value = "Na, x, just change description";
			
		}
		
		private function DebugViews():void
		{			
			//Inspectors Debugging
			CreateDebugInspectors(StringInspector, new StringProxy("String Proxy", "Hello World"), 0);
			
			CreateDebugInspectors(BooleanInspector, new BooleanProxy("Boolean Proxy", false), 185);
			CreateDebugInspectors(NumberInspector, new NumberProxy("Number Proxy", 250), 300);
			
			var container:PropertyContainerProxy = new PropertyContainerProxy("SubContainer Proxy", new StringProxy("Default Item", "Hello Default World"));
			container.Add(new StringProxy("String Proxy", "Hello World"));
			container.Add(new BooleanProxy("Boolean Proxy", false));
			container.Add(new NumberProxy("Number Proxy", 250));
			
			var containerMaster:SelectablePropertyContainerProxy = new SelectablePropertyContainerProxy("Container Proxy",  container.Clone());
			containerMaster.Add(container.Clone());
			containerMaster.Add(container.Clone());
			
			CreateDebugInspectors(PropertyContainerListInspector, containerMaster, 550);
			CreateDebugInspectors(SelectionInspector, containerMaster, 1000);
		}
		
		private function CreateDebugSelectionInspector(inspectorClass:Class, proxy:PropertyProxy, selProxy:PropertyProxyProxy, posX:int):void
		{
			const propertyInspector:* = new inspectorClass();
			propertyInspector.property = proxy;
			propertyInspector.currentSelectionProxy = selProxy;
			propertyInspector.x = posX;
			propertyInspector.height = 290;
			propertyInspector.width = 250;
			addChild(propertyInspector);
			
			const propertyInspector2:* = new inspectorClass();
			propertyInspector2.property = propertyInspector.property
			propertyInspector2.currentSelectionProxy = selProxy;
			propertyInspector2.x = posX;
			propertyInspector2.y = 300;
			propertyInspector2.width = 250;
			propertyInspector2.maxHeight = 290;
			addChild(propertyInspector2);
		}
		
		private function CreateDebugInspectors(inspectorClass:Class, proxy:PropertyProxy, posX:int):void
		{
			const propertyInspector:PropertyInspector = new inspectorClass();
			propertyInspector.property = proxy;
			propertyInspector.x = posX;
			propertyInspector.height = 290;
			propertyInspector.maxWidth = 250;
			addChild(propertyInspector);
			
			const propertyInspector2:PropertyInspector = new inspectorClass();
			propertyInspector2.property = proxy
			propertyInspector2.x = posX;
			propertyInspector2.y = 300;
			propertyInspector2.maxWidth = 250;
			propertyInspector2.maxHeight = 290;
			addChild(propertyInspector2);
		}
		
		private function Initialize(event:Event):void
		{
			_theme = new MinimaMetalWorksMobileTheme(this.stage);
			//Debug();
			
			//Document Model
			this._documentModel = new DocumentModel("New Document", null, false);
			
			//Document Control
			this._documentControl = new DocumentInspector();			
			this._documentControl.documentModel = this._documentModel;
			this.addChild(this._documentControl);
			
			//Document Title Control
			this._windowTitleControl = new NativeWindowTitleControl();
			this._windowTitleControl.documentModel = this._documentModel;
			this.addChild(this._windowTitleControl);
		}
		
		private function InitializeView():void
		{
			
		}
		
		private function InitializeControllers():void
		{
			
		}
		
		private function InitializeModels():void
		{
			
		}
		
		private function MapViews():void
		{
			
		}
		
		private function MapControllers():void
		{
			
		}
	}
}