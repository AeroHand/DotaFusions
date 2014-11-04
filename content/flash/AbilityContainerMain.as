package  
{
	
	import flash.display.MovieClip;
	import fl.motion.AdjustColor;
	import flash.filters.ColorMatrixFilter;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	
	
	public class AbilityContainerMain extends MovieClip 
	{

		public var SheenEffect:MovieClip;
		public var AbilityIcon:MovieClip;
		public var AbilityName:String;
		public var RowPosition:int;
		public var LinkedAbility:AbilityContainerMain;
		public var SharedIcon:Bitmap;
		public var IsDefault:Boolean = true;
		public var IsHidden:Boolean = false;
		
		public var defaultIcon:Bitmap;
		var hiddenOverlay:MovieClip;
		var button:SimpleButton;
		
		public var initializationData:AbilityInitData;
		
		var pairedSelectFrame:Number = 4;
		var requiredFrame:Number = 2;
		var blockedFrame:Number = 3;
		
		var colorFilter:AdjustColor = new AdjustColor();
		var mColorMatrix:ColorMatrixFilter;
		var mMatrix:Array = [];
		
	    public var Clickable:Boolean = false;
		
		public function AbilityContainerMain() 
		{
			// constructor code
			SheenEffect = sheenEffect;
			AbilityIcon = abilityIcon;
			defaultIcon = new Bitmap(new invoker_empty1());
			hiddenOverlay = hidden_Overlay;
			button = abilityBtn;
			SetAsHidden();
		}
		
		//TODO: the internal name to set the tooltip 
		public function SetInitializationData(initData:AbilityInitData) : void
		{
			initializationData = initData;
			AbilityName = initializationData.InternalName;
			ReplaceAbilityIcon(initializationData.AbilityIcon);
			SharedIcon = new Bitmap(initializationData.AbilityIcon.bitmapData);
			SetAsAvailable();
			IsDefault = false;
			
			if (initData.BlockedBy != null)
			{
				SetAsBlocked();
			}
		}
		
		public function GetInitializationData(): AbilityInitData
		{
			return initializationData;
		}
		
		public function SetAsBlocked(): void
		{
			gotoAndStop(blockedFrame);
			//this.mouseEnabled = false;
			//this.mouseChildren = false;
			hiddenOverlay.gotoAndStop(1);
			blockedOverlay.mouseEnabled = false;
			button.enabled = false;
			Clickable = false;
			IsHidden = false;
		}
		
		public function SetAsRequired():void
		{
			gotoAndStop(requiredFrame);
			hiddenOverlay.gotoAndStop(1);
		}
		
		public function SetAsPairedSelect():void
		{
			gotoAndStop(pairedSelectFrame);
			hiddenOverlay.gotoAndStop(1);
		}
		
		public function SetAsHidden():void 
		{
			this.mouseEnabled = false;
			this.mouseChildren = false;
			SetColorFilterHidden();		
			hiddenOverlay.gotoAndStop(2);
			button.enabled = false;
			Clickable = false;
			IsHidden = true;
		}
		
		public function SetAsAvailable():void
		{
			this.mouseEnabled = true;
			this.mouseChildren = true;
			gotoAndStop(1);
			SetColorFilterNormal();
			hiddenOverlay.gotoAndStop(1);
			button.enabled = true;
			Clickable = true;
			IsHidden = false;
		}
		
		public function GetRequiredAbilities() : Array
		{
			return initializationData.BlockedBy;
			hiddenOverlay.gotoAndStop(1);
		}
		
		public function GetPairedAbilities(): Object
		{
			return initializationData.PairedBy;
			hiddenOverlay.gotoAndStop(1);
		}
		
		public function ReplaceAbilityIcon(icon:DisplayObject): void
		{
			// Get width, height and position and apply it to the icon we are going to add.
			if ( AbilityIcon.numChildren != 0)
			{
				var dummyIcon:DisplayObject = AbilityIcon.getChildAt(0);
				
				if(icon == dummyIcon)
					return;
				
				// remove dummy icon
				if(dummyIcon != null)
				{
					icon.width = dummyIcon.width;
					icon.height = dummyIcon.height;
					icon.x = dummyIcon.x;
					icon.y = dummyIcon.y;
					
					AbilityIcon.removeChild(dummyIcon);
				}
			}

				
			// Add ability to ability container
			AbilityIcon.addChild(icon);			
		}
		
		public function ResetToDefault()
		{
			gotoAndStop(1);
			ReplaceAbilityIcon(defaultIcon);
			SetAsHidden();
			IsDefault = true;
			AbilityName = "";
			LinkedAbility = null;
			
		}
		
		public function PlaySheen():void
		{
			SheenEffect.gotoAndPlay(1);
		}
		
		private function SetColorFilterHidden():void
		{
			colorFilter = new AdjustColor();
			
			colorFilter.brightness = -28;
			colorFilter.contrast = -32;
			colorFilter.saturation = -93;
			colorFilter.hue = 0;
			
			mMatrix = colorFilter.CalculateFinalFlatArray();
			mColorMatrix = new ColorMatrixFilter(mMatrix);

			AbilityIcon.filters = [mColorMatrix];
		}
		
		private function SetColorFilterBlocked():void
		{
			colorFilter = new AdjustColor();
			
			colorFilter.brightness = -14;
			colorFilter.contrast = -6;
			colorFilter.saturation = 100;
			colorFilter.hue = 180;
			
			mMatrix = colorFilter.CalculateFinalFlatArray();
			mColorMatrix = new ColorMatrixFilter(mMatrix);

			AbilityIcon.filters = [mColorMatrix];
		}
		
		private function SetColorFilterNormal():void
		{
			colorFilter = new AdjustColor();
			
			colorFilter.brightness = 0;
			colorFilter.contrast = 0;
			colorFilter.saturation = 0;
			colorFilter.hue = 0;
			
			mMatrix = colorFilter.CalculateFinalFlatArray();
			mColorMatrix = new ColorMatrixFilter(mMatrix);

			AbilityIcon.filters = [mColorMatrix];
		}
		

	}
	
}
