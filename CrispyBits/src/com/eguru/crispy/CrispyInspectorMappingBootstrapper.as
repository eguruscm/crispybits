package com.eguru.crispy
{
	import com.eguru.crispy.models.definitions.PropertyDefinition;
	import com.eguru.crispy.views.controls.PropertyDefinitionInspector;
	
	import minima.bootstrappers.InspectorMappingBootstrapper;
	import minima.controls.BooleanInspector;
	import minima.controls.factories.PropertyInspectorFactory;
	import minima.proxies.BooleanProxy;
	
	public class CrispyInspectorMappingBootstrapper extends InspectorMappingBootstrapper
	{
		public function CrispyInspectorMappingBootstrapper()
		{
			super();			
			PropertyInspectorFactory.MapInspector(PropertyDefinitionInspector, PropertyDefinition);
		}
	}
}