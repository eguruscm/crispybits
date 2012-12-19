package minima.bootstrappers
{
	import minima.controls.BooleanInspector;
	import minima.controls.NumberInspector;
	import minima.controls.PropertyInspector;
	import minima.controls.StringInspector;
	import minima.controls.SubPropertyContainerInspector;
	import minima.controls.factories.PropertyInspectorFactory;
	import minima.proxies.BooleanProxy;
	import minima.proxies.NumberProxy;
	import minima.proxies.PropertyContainerProxy;
	import minima.proxies.PropertyProxy;
	import minima.proxies.StringProxy;

	/**
	 * Basic Bootstrapping for mapping proxies to their basic inspectors.
	 * 
	 * @author Bruno Tachinardi
	 */
	public class InspectorMappingBootstrapper
	{
		/**
		 * Simply create a new Bootstrapper instance to map proxies to inspectors.
		 * 
		 * <p>There is no need to keep any references to this instance.</p>
		 * 
		 * <listing><code>new InspectorMappingBootstrapper();</code></listing>
		 * 
		 * @see minima.controls.factories.PropertyInspectorFactory
		 */
		public function InspectorMappingBootstrapper()
		{
			PropertyInspectorFactory.MapInspector(BooleanInspector, BooleanProxy);
			PropertyInspectorFactory.MapInspector(StringInspector, StringProxy);
			PropertyInspectorFactory.MapInspector(NumberInspector, NumberProxy);
			PropertyInspectorFactory.MapInspector(SubPropertyContainerInspector, PropertyContainerProxy);
			PropertyInspectorFactory.MapInspector(PropertyInspector, PropertyProxy);
		}
	}
}