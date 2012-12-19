package minima
{
	import feathers.controls.TextInput;
	import feathers.display.Scale9Image;
	import feathers.system.DeviceCapabilities;
	import feathers.themes.AeonDesktopTheme;
	
	import minima.controls.AutoSizeTextInput;
	
	import starling.display.DisplayObjectContainer;
	
	public class MinimaMetalWorksMobileTheme extends AeonDesktopTheme
	{
		public function MinimaMetalWorksMobileTheme(root:DisplayObjectContainer, scaleToDPI:Boolean=true)
		{
			DeviceCapabilities.dpi = 150;
			super(root);
		}
		
		override protected function initialize():void
		{
			super.initialize();
			this.setInitializerForClass(AutoSizeTextInput, autoSizeTextInputInitializer);
		}
		
		protected function autoSizeTextInputInitializer(input:AutoSizeTextInput):void
		{
			input.minWidth = input.minHeight = 22;
			input.paddingTop = input.paddingBottom = 2;
			input.paddingRight = input.paddingLeft = 4;
			input.textEditorProperties.textFormat = this.defaultTextFormat;
			
			input.backgroundSkin = new Scale9Image(textInputBackgroundSkinTextures);
			input.backgroundDisabledSkin = new Scale9Image(textInputBackgroundDisabledSkinTextures);
		}
		
		/*
		override protected function headerInitializer(header:Header):void
		{
			this.headerTextFormat.size = Math.round(24 * this.scale);
			this.headerTextFormat.color = DARK_TEXT_COLOR;
			
			header.minWidth = 88 * this.scale;
			header.minHeight = 22 * this.scale;
			header.paddingTop = header.paddingRight = header.paddingBottom = 7 * this.scale;
			
			const backgroundSkin:Quad = new Quad(88 * this.scale, 88 * this.scale, 0xE3E1DE);
			header.backgroundSkin = backgroundSkin;
			header.titleProperties.textFormat = this.headerTextFormat;
		}		
		*/
	}
}