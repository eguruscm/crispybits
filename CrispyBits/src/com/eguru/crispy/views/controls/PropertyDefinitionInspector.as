package com.eguru.crispy.views.controls
{
	import minima.controls.SubPropertyContainerInspector;
	
	public class PropertyDefinitionInspector extends SubPropertyContainerInspector
	{
		override protected function initialize():void
		{
			super.initialize();
			this._hidden = true;
		}
	}
}