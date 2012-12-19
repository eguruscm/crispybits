package minima.controls.factories
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import minima.controls.PropertyInspector;
	import minima.proxies.PropertyProxy;

	public class PropertyInspectorFactory
	{
		private static var _buffer:Dictionary = new Dictionary();
		private static var _mappings:Dictionary = new Dictionary();
		private static const MAX_ITEMS_PER_BUFFER:int = 50;
		/**
		 * Creates an inspector to the given property proxy
		 */
		public static function Create(property:PropertyProxy) : PropertyInspector
		{
			var inspector:PropertyInspector;
			var inspectorMappings:Dictionary = GetInspectorMappings(property);
			if (!inspectorMappings) 
			{
				throw new Error("No mappings for class '" +
					getQualifiedClassName(property) + "' were found.");
			}
			var inspectorType:Class = inspectorMappings[property.customInspector];
			if (!inspectorType) 
			{
				throw new Error("No mappings for Custom Inspector '" + property.customInspector + "' in class '" +
					getQualifiedClassName(property) + "' were found.");
			}
			return Get(property, inspectorType);
		}
		
		/**
		 * Gets an inspector from the current buffer
		 */
		public static function Get(property:PropertyProxy, inspectorType:Class) : PropertyInspector
		{
			var inspector:PropertyInspector;
			var classBuffer:Array = _buffer[inspectorType];
			
			if (classBuffer) 
			{
				inspector = classBuffer.pop();
				if (classBuffer.length < 1)
				{
					delete _buffer[inspectorType];
				}
			} 
			else 
			{
				inspector = new inspectorType();
			}
			inspector.property = property;
			return inspector;
		}
		
		private static function GetInspectorMappings(property:PropertyProxy):Dictionary
		{			
			var mappings:Dictionary = _mappings[getDefinitionByName(getQualifiedClassName(property)) as Class];
			if (!mappings) 
			{
				return GetMappingsFromSuperClasses(property);
			}
			return mappings;			
		}
		
		private static function GetMappingsFromSuperClasses(property:PropertyProxy):Dictionary
		{
			var mappings:Dictionary;
			var description:XML = describeType(property);
			var successionTree:XMLList = description..extendsClass;
			
			for each (var node:XML in successionTree) 
			{
				mappings = _mappings[getDefinitionByName(node.@type) as Class];
				if (mappings) 
				{
					break;
				}
			}			
			
			return mappings;
		}
		
		public static function MapInspector(inspectorClass:Class, propertyClass:Class, customType:String="default"):void
		{
			var inspectorMappings:Dictionary = _mappings[propertyClass];
			if (!inspectorMappings) 
			{
				_mappings[propertyClass] = inspectorMappings = new Dictionary();
			}
			inspectorMappings[customType] = inspectorClass;
		}
				
		public static function Return(inspector:PropertyInspector):void
		{
			var inspectorType:Class = getDefinitionByName(getQualifiedClassName(inspector)) as Class;
			var classBuffer:Array = _buffer[inspectorType];
			if (!classBuffer) 
			{
				_buffer[inspectorType] = classBuffer = new Array();
			}
			if (classBuffer.length > MAX_ITEMS_PER_BUFFER) 
			{
				return;
			}
			classBuffer.push(inspector);
		}
	}
}