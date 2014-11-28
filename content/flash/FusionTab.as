package  {
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.geom.Rectangle;

	// Used to make nice buttons / doto themed stuff
	import flash.utils.getDefinitionByName;
	
	// Valve Libaries
	import ValveLib.Globals;
	import ValveLib.ResizeManager;
	
	    // Timer
    import flash.utils.Timer;
    import flash.events.TimerEvent;

	// Scaleform stuff
	import scaleform.clik.interfaces.IDataProvider;
	import scaleform.clik.data.DataProvider;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Sprite;
	
	public class FusionTab extends MovieClip 
	{
		
		// element details filled out by game engine
		public var gameAPI: Object;
		public var globals: Object;
		public var elementName: String;
		
		// Reference to the Hero Abilities KV file
		var heroAbilitiesKV: Object;
		
		var fusionHero:String;
		var primaryHero:String;
		
		// Reference to the main fusion panel
		var fusionPanel:MainPanel = f_Panel;
		// Reference to the open / close button
		var openCloseButton:MovieClip;
		// Timer that ticks every so often to check if the player is within
		// Rangeof a fountain.  Controls the visibility of the panels
		var fountainCheckTimer:Timer;
		// Makes sure that if we are already closing, let it finish
		var closingPanel:Boolean = false;
		// Supposed to prevent an error that ocurrs when trying to replace the 
		// Main panel's fusion button with a dota skinned one.
		var waitForAnimFinish:Boolean = false;
		
		//--
		var p_HeroPortrait:Bitmap = null;
		var f_HeroPortrait:Bitmap = null;
		
		var p_Ability1:Bitmap = null;
		var p_Ability2:Bitmap = null;
		var p_Ability3:Bitmap = null;
		var p_Ability4:Bitmap = null;
		var p_Ability5:Bitmap = null;
		var p_Ability6:Bitmap = null;
		
		var f_Ability1:Bitmap = null;
		var f_Ability2:Bitmap = null;
		var f_Ability3:Bitmap = null;
		var f_Ability4:Bitmap = null;
		var f_Ability5:Bitmap = null;
		var f_Ability6:Bitmap = null;
		
		var p_abiName1:String = null;
		var p_abiName2:String = null;
		var p_abiName3:String = null;
		var p_abiName4:String = null;
		var p_abiName5:String = null;
		var p_abiName6:String = null;
		
		var f_abiName1:String = null;
		var f_abiName2:String = null;
		var f_abiName3:String = null;
		var f_abiName4:String = null;
		var f_abiName5:String = null;
		var f_abiName6:String = null;
		
		var p_Ability1_BlockedBy:Array = null;
		var p_Ability2_BlockedBy:Array = null;
		var p_Ability3_BlockedBy:Array = null;
		var p_Ability4_BlockedBy:Array = null;
		var p_Ability5_BlockedBy:Array = null;
		var p_Ability6_BlockedBy:Array = null;
		
		var f_Ability1_BlockedBy:Array = null;
		var f_Ability2_BlockedBy:Array = null;
		var f_Ability3_BlockedBy:Array = null;
		var f_Ability4_BlockedBy:Array = null;
		var f_Ability5_BlockedBy:Array = null;
		var f_Ability6_BlockedBy:Array = null;
		
		var p_Ability1_PairedBy:Array = null;
		var p_Ability2_PairedBy:Array = null;
		var p_Ability3_PairedBy:Array = null;
		var p_Ability4_PairedBy:Array = null;
		var p_Ability5_PairedBy:Array = null;
		var p_Ability6_PairedBy:Array = null;
		
		var f_Ability1_PairedBy:Array = null;
		var f_Ability2_PairedBy:Array = null;
		var f_Ability3_PairedBy:Array = null;
		var f_Ability4_PairedBy:Array = null;
		var f_Ability5_PairedBy:Array = null;
		var f_Ability6_PairedBy:Array = null;
		
		var p_Ability1_IndexPos:int = -1;
		var p_Ability2_IndexPos:int = -1;
		var p_Ability3_IndexPos:int = -1;
		var p_Ability4_IndexPos:int = -1;
		var p_Ability5_IndexPos:int = -1;
		var p_Ability6_IndexPos:int = -1;
		
		var f_Ability1_IndexPos:int = -1;
		var f_Ability2_IndexPos:int = -1;
		var f_Ability3_IndexPos:int = -1;
		var f_Ability4_IndexPos:int = -1;
		var f_Ability5_IndexPos:int = -1;
		var f_Ability6_IndexPos:int = -1;
		
		var pairedIndexes:Object = new Object();
		
		

		// Constructor
		public function FusionTab() 
		{
			fusionPanel = f_Panel;
			//initializeFusionPanel();
			trace("Initializing Fusion Panel");
		}
		
		// Called when SWF is loaded
		public function onLoaded(): void 
		{
			// Actually show the UI
			visible = false;
			
			// Create Fountain timer
			fountainCheckTimer = new Timer(500);
			fountainCheckTimer.addEventListener(TimerEvent.TIMER, ShowHideBasedOnFountainRange,false, 0, true);
			fountainCheckTimer.start();
			
			gameAPI.SubscribeToGameEvent( "ChosenFusionHeroes", onChosenFusionHero );
			heroAbilitiesKV = Globals.instance.GameInterface.LoadKVFile('scripts/fusionKVs/heroAbilities.txt');
		}
		
		// called by the game engine after onLoaded and whenever the screen size is changed
		public function onScreenSizeChanged(): void 
		{
			// By default, your 1024x768 swf is scaled to fit the vertical resolution of the game
			//   and centered in the middle of the screen.
			// You can override the scaling and positioning here if you need to.
			// stage.stageWidth and stage.stageHeight will contain the full screen size.
			
		//	f_Panel.x = (stage.stageWidth / 2) + (f_Panel.width / 2);
		//	openCloseBtn.x = (stage.stageWidth / 2) + (openCloseBtn.width / 2);
		}
		
		private function TraceCombinedAbilities(e:MouseEvent)
		{
			var abilitiesArray:Array = f_Panel.GetCombinedAbilityNames();
			
			
			gameAPI.SendServerCommand( "PlayerSendFusionAbilityRequest "  + globals.Players.GetLocalPlayer() + " " + abilitiesArray[0] + " " + abilitiesArray[1] + " " + abilitiesArray[2] + " " + abilitiesArray[3] + " " + abilitiesArray[4] + " " + abilitiesArray[5])
			
			MainPanel(f_Panel).visible = false;
			
			play();
			
			f_Panel.mouseEnabled = false;
			f_Panel.mouseChildren = false;
			openCloseButton.removeEventListener(MouseEvent.CLICK, fl_MouseClickHandler_2);
			f_Panel.ApplyFusionBtn.removeEventListener(MouseEvent.CLICK, TraceCombinedAbilities);
		}		
		
		private function onChosenFusionHero(e:Object)
		{
			trace("Chosen Fusion Hero yay");
			
			if(e.PlayerID == globals.Players.GetLocalPlayer())
			{
				fusionHero = e.FusionHero;
				primaryHero = e.PrimaryHero;
				
				trace("UI Names");
				trace(fusionHero);
				trace(primaryHero);
				
				if(primaryHero == fusionHero)
				{
					fountainCheckTimer.stop();
					gameAPI.SendServerCommand( "EnableHiddenAbilitiesForSoloHeroes " + e.PlayerID);
					visible = false;
				}
				else
				{
					CreateAbilityInitData();
				}
			}
		}
		
		private function ShowHideBasedOnFountainRange(e:TimerEvent): void
		{
			var playerID:Number = globals.Players.GetLocalPlayer();
			
			if( playerID == -1)
				return
			
			if(primaryHero == null || fusionHero == null)
			{
				var heroName:String = globals.Players.GetPlayerSelectedHero(playerID);
				if(heroName != "" && heroName != null) 
					gameAPI.SendServerCommand( "PlayerWantToKnowHeroSelection " + playerID);
			}
			
			if (globals.Entities.IsInRangeOfFountain( globals.Players.GetPlayerHeroEntityIndex(playerID )))
			{
				visible = true;
				openCloseButton.visible = true;
			}
			else
			{
				if(currentFrame < 40 && currentFrame > 1)
				{
					//waitForAnimFinish = true
					globals.Loader_rad_mode_panel.gameAPI.OnHideAbilityTooltip();
				}
				else if(currentFrame == 40 && closingPanel == false)
				{
					fl_MouseClickHandler_2(null);
					globals.Loader_rad_mode_panel.gameAPI.OnHideAbilityTooltip();
					gotoAndPlay(79);
				}
				else if (currentFrame == 1)
					visible = false;
				
				openCloseButton.visible = false;
				
			}
		}		
		
		// Opens the main panel
		function fl_MouseClickHandler_3(event:MouseEvent):void
		{
			closingPanel = false;
			f_Panel.mouseEnabled = false;
			f_Panel.mouseChildren = false;
			
			if (f_Panel != null && f_Panel.applyFusion_Btn != null)
			{
				f_Panel.ApplyFusionBtn = replaceWithValveComponent(f_Panel.applyFusion_Btn, "chrome_button_primary");	
				f_Panel.ApplyFusionBtn.label = "Apply Fusion";
			}
			
			initializeFusionPanel();
			play();

			openCloseButton.removeEventListener(MouseEvent.CLICK, fl_MouseClickHandler_3);
			trace("Removed Open Event Handler");
			openCloseButton.label = "Close Fusion Panel";
			f_Panel.visible = true;
			
			if(waitForAnimFinish)
			{
				gotoAndPlay(79);
				waitForAnimFinish = false;
			}
			// End your custom code
		}
		
		// Closes the Main Panel
		function fl_MouseClickHandler_2(event:MouseEvent):void
		{
			closingPanel = true;
			// Start your custom code
			// This example code displays the words "Mouse clicked" in the Output panel.
			//trace("Mouse clicked");
			play();
			f_Panel.mouseEnabled = false;
			f_Panel.mouseChildren = false;
			openCloseButton.removeEventListener(MouseEvent.CLICK, fl_MouseClickHandler_2);
			trace("Removed Open Event Handler");
			f_Panel.ApplyFusionBtn.removeEventListener(MouseEvent.CLICK, TraceCombinedAbilities);
			// End your custom code
		}
		
		private function CreateAbilityInitData()
		{
			// Get Abilities for primary Hero
			var primaryHeroAbis = heroAbilitiesKV[primaryHero];
			var fusionHeroAbis = heroAbilitiesKV[fusionHero];
			
			var p_abilityNames:Array = [];
			var f_abilityNames:Array = [];
			var counter:uint = 0;
			
			// Create loader for loading the Primary hero potrait textures
			var p_PortraitLoader: Loader = new Loader();
			// Add the events fot loading the images
			p_PortraitLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);
			// Use the internal hero name to get reference to the hero portrait.
			p_PortraitLoader.load(new URLRequest('images/heroes/selection/' + primaryHero + '.png'));
			
			// Create loader for loading the Fusion hero potrait textures
			var f_PortraitLoader: Loader = new Loader();
			// Add the events fot loading the images
			f_PortraitLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionImageLoadComplete);
			// Use the internal hero name to get reference to the hero portrait.
			f_PortraitLoader.load(new URLRequest('images/heroes/selection/' + fusionHero + '.png'));
			
			trace("Loading ability order");
			for (var abiName_p:String in primaryHeroAbis)
			{
				p_abilityNames[getAbilityOrderIndex( abiName_p, primaryHeroAbis )] = abiName_p;
			}
			
			for (var abiName_f:String in fusionHeroAbis)
			{
				f_abilityNames[getAbilityOrderIndex( abiName_f, fusionHeroAbis )] = abiName_f;		
			}
			
			for (var i:uint = 0; i < p_abilityNames.length; i++)
			{
				var abiName:String = p_abilityNames[i];
				
				// Create loader for loading the Primary hero potrait textures
				var AbiLoader: Loader = new Loader();
				// Add the events fot loading the images
				trace("Current P Index: " + i);
				trace("Ability Nane: " + abiName);
				
				var returnObject:Object = FillBlockedAndPairedIfNecessary(primaryHeroAbis[abiName]);
				
				
				switch(i)
				{
					case 0:
					p_abiName1 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrimaryAbility1Complete);


					p_Ability1_BlockedBy = returnObject["b"];
					p_Ability1_PairedBy = returnObject["p"];
					
					break;
					
					case 1:
					p_abiName2 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrimaryAbility2Complete);
					
					p_Ability2_BlockedBy = returnObject["b"];
					p_Ability2_PairedBy = returnObject["p"];
					
					break;
					
					case 2:
					p_abiName3 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrimaryAbility3Complete);

					p_Ability3_BlockedBy = returnObject["b"];
					p_Ability3_PairedBy = returnObject["p"];
					
					break;
					
					case 3:
					p_abiName4 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrimaryAbility4Complete);

					p_Ability4_BlockedBy = returnObject["b"];
					p_Ability4_PairedBy = returnObject["p"];
					
					break;
					
					case 4:
					p_abiName5 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrimaryAbility5Complete);
					
					p_Ability5_BlockedBy = returnObject["b"];
					p_Ability5_PairedBy = returnObject["p"];
					
					break;
					
					case 5:
					p_abiName6 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onPrimaryAbility6Complete);

					p_Ability6_BlockedBy = returnObject["b"];
					p_Ability6_PairedBy = returnObject["p"];
					
					break;
						
				}
				
				AbiLoader.load(new URLRequest('images/spellicons/' + f_Panel.specialCaseConvertAbilityName(abiName) + '.png'));
				
				counter++;
			}
			
			counter = 0;
			
			for (var f:uint = 0; f < f_abilityNames.length; f++)
			{
				var abiName:String = f_abilityNames[f]
				
				// Create loader for loading the Primary hero potrait textures
				var AbiLoader: Loader = new Loader();
				// Add the events fot loading the images
				
				trace("Current F Index: " + f);
				trace("Ability Nane: " + abiName);
				
				var returnObject:Object = FillBlockedAndPairedIfNecessary(fusionHeroAbis[abiName]);
				
				switch(f)
				{
					case 0:
					f_abiName1 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionAbility1Complete);

					f_Ability1_BlockedBy = returnObject["b"];
					f_Ability1_PairedBy = returnObject["p"];
					
					break;
					
					case 1:
					f_abiName2 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionAbility2Complete);
					
					f_Ability2_BlockedBy = returnObject["b"];
					f_Ability2_PairedBy = returnObject["p"];
					
					break;
					
					case 2:
					f_abiName3 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionAbility3Complete);
					
					f_Ability3_BlockedBy = returnObject["b"];
					f_Ability3_PairedBy = returnObject["p"];
					
					break;
					
					case 3:
					f_abiName4 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionAbility4Complete);
					
					f_Ability4_BlockedBy = returnObject["b"];
					f_Ability4_PairedBy = returnObject["p"];
					
					break;
					
					case 4:
					f_abiName5 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionAbility5Complete);

					f_Ability5_BlockedBy = returnObject["b"];
					f_Ability5_PairedBy = returnObject["p"];
					break;
					
					case 5:
					f_abiName6 = abiName;
					AbiLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionAbility6Complete);

					f_Ability6_BlockedBy = returnObject["b"];
					f_Ability6_PairedBy = returnObject["p"];
					break;
				}
				
				AbiLoader.load(new URLRequest('images/spellicons/' + f_Panel.specialCaseConvertAbilityName(abiName) + '.png'));
				
				counter++;
			}
			
		}

		public function initializeFusionPanel()
		{
			// Get hero names fore primary and fusion portrait
			//var fBitmap:Bitmap = new Bitmap(new abaddon(0,0));
			//var pBitmap:Bitmap = new Bitmap(new nevermore(0,0));
			
			// Load the portrait bitmaps
			trace("Initializing Fusion Panel Baby");
			f_Panel.SetFusionHeroPortrait(f_HeroPortrait);
			f_Panel.SetPrimaryHeroPortrait(p_HeroPortrait);
			
			//---
			
			// Get the ability names for both primary and fusion heroes
			
			// Abaddon
			var f_abi_1:AbilityInitData = new AbilityInitData(f_Ability1, f_abiName1, f_Ability1_BlockedBy, f_Ability1_PairedBy, f_Ability1_IndexPos);
			var f_abi_2:AbilityInitData = new AbilityInitData(f_Ability2, f_abiName2, f_Ability2_BlockedBy, f_Ability2_PairedBy, f_Ability2_IndexPos);
			var f_abi_3:AbilityInitData = new AbilityInitData(f_Ability3, f_abiName3, f_Ability3_BlockedBy, f_Ability3_PairedBy, f_Ability3_IndexPos);
			var f_abi_4:AbilityInitData = new AbilityInitData(f_Ability4, f_abiName4, f_Ability4_BlockedBy, f_Ability4_PairedBy, f_Ability4_IndexPos);
			var f_abi_5:AbilityInitData = null;
			var f_abi_6:AbilityInitData = null;
			
			if(f_Ability5 != null)
				f_abi_5 = new AbilityInitData(f_Ability5, f_abiName5, f_Ability5_BlockedBy, f_Ability5_PairedBy, f_Ability5_IndexPos);
			
			if(f_Ability6 != null)
				f_abi_6 = new AbilityInitData(f_Ability6, f_abiName6, f_Ability6_BlockedBy, f_Ability6_PairedBy, f_Ability6_IndexPos);
			
			
			
			//Nevermore
			var p_abi_1:AbilityInitData = new AbilityInitData(p_Ability1, p_abiName1, p_Ability1_BlockedBy, p_Ability1_PairedBy, p_Ability1_IndexPos);
			var p_abi_2:AbilityInitData = new AbilityInitData(p_Ability2, p_abiName2, p_Ability2_BlockedBy, p_Ability2_PairedBy, p_Ability2_IndexPos);
			var p_abi_3:AbilityInitData = new AbilityInitData(p_Ability3, p_abiName3, p_Ability3_BlockedBy, p_Ability3_PairedBy, p_Ability3_IndexPos);
			var p_abi_4:AbilityInitData = new AbilityInitData(p_Ability4, p_abiName4, p_Ability4_BlockedBy, p_Ability4_PairedBy, p_Ability4_IndexPos);
			var p_abi_5:AbilityInitData = null;
			var p_abi_6:AbilityInitData = null;
			
			if(p_Ability5 != null)
				p_abi_5 = new AbilityInitData(p_Ability5, p_abiName5, p_Ability5_BlockedBy, p_Ability5_PairedBy, p_Ability5_IndexPos);
			
			if(p_Ability6)
				p_abi_6 = new AbilityInitData(p_Ability6, p_abiName6, p_Ability6_BlockedBy, p_Ability6_PairedBy, p_Ability6_IndexPos);
			
			
			var tempAbilityInitArray:Array = [f_abi_1, f_abi_2, f_abi_3, f_abi_4, f_abi_5, f_abi_6, p_abi_1, p_abi_2, p_abi_3, p_abi_4, p_abi_5, p_abi_6];
			
			for (var abiName:String in pairedIndexes)
			{
				for each (var ability:AbilityInitData in tempAbilityInitArray)
				{
					if (ability != null)
					{
						if(ability.InternalName == abiName)
						{
							ability.IndexSpecific = pairedIndexes[abiName];
							break;
						}
					}
				}
			}
			
		
			MainPanel(f_Panel).SetPrimaryAbilities(p_abi_1, p_abi_2, p_abi_3, p_abi_4, p_abi_5, p_abi_6);
			MainPanel(f_Panel).SetFusionAbilities(f_abi_1, f_abi_2, f_abi_3, f_abi_4, f_abi_5, f_abi_6);
			
			// Load all the bitmaps
			
			// Replace dummy ability icons
			
			// Read the ability KV file and initialize the ability container with those values
			
		}
		
		private function getAbilityOrderIndex(abilityName:String, kvFile:Object): int
		{
			trace(kvFile[abilityName]);
			trace(typeof(kvFile[abilityName]));
			
			if (isNaN(Number(kvFile[abilityName])))
			{
				trace("Is Object");
				return kvFile[abilityName]["OrderPosition"];
			}
			else
				return kvFile[abilityName];
		}
		
		private function FillBlockedAndPairedIfNecessary(ability:Object) : Object
		{
			var returnObject:Object = new Object();
			returnObject["b"] = null
			returnObject["p"] = null;
			
			if (ability.hasOwnProperty("Required"))
			{
				returnObject["b"] = new Array();
				
				trace("Before Looping through blocked");
				for (var abi:String in ability["Required"])
				{
					trace(abi);
					returnObject["b"].push(abi);
				}
				
				trace("Succesful block set");
			}
			
			if (ability.hasOwnProperty("PairedWithIndexSpecific"))
			{
				returnObject["p"] = new Array();
				
				for (var index in ability["PairedWithIndexSpecific"])
				{
					returnObject["p"].push(ability["PairedWithIndexSpecific"][index]);
					pairedIndexes[ability["PairedWithIndexSpecific"][index]] = Number(index) - 1;
				}
			}
			
			return returnObject;
		}
		
		public function replaceWithValveComponent(mc:MovieClip, type:String, keepDimensions:Boolean = false) : MovieClip 
		{
			var parent = mc.parent;
			var oldx = mc.x;
			var oldy = mc.y;
			var oldwidth = mc.width;
			var oldheight = mc.height;
			
			var newObjectClass = getDefinitionByName(type);
			var newObject = new newObjectClass();
			newObject.x = oldx;
			newObject.y = oldy;
			if (keepDimensions) 
			{
				newObject.width = oldwidth;
				newObject.height = oldheight;
			}
			
			parent.removeChild(mc);
			parent.addChild(newObject);
			
			return newObject;
		}		
		
		public function onPrimaryImageLoadComplete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			p_HeroPortrait = Bitmap(loaderInfo.content);
		}
		
		public function onFusionImageLoadComplete(e: Event): void 
		{			
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			f_HeroPortrait = Bitmap(loaderInfo.content);
		}
		
		public function onPrimaryAbility1Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			p_Ability1 = Bitmap(loaderInfo.content);
		}
		
		public function onPrimaryAbility2Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			p_Ability2 = Bitmap(loaderInfo.content);
		}

		public function onPrimaryAbility3Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			p_Ability3 = Bitmap(loaderInfo.content);
		}
		
		public function onPrimaryAbility4Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			p_Ability4 = Bitmap(loaderInfo.content);
		}
		
		public function onPrimaryAbility5Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			p_Ability5 = Bitmap(loaderInfo.content);
		}
		
		public function onPrimaryAbility6Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			p_Ability6 = Bitmap(loaderInfo.content);
		}	
		
		public function onFusionAbility1Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			f_Ability1 = Bitmap(loaderInfo.content);
		}
		
		public function onFusionAbility2Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			f_Ability2 = Bitmap(loaderInfo.content);
		}

		public function onFusionAbility3Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			f_Ability3 = Bitmap(loaderInfo.content);
		}
		
		public function onFusionAbility4Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			f_Ability4 = Bitmap(loaderInfo.content);
		}
		
		public function onFusionAbility5Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			f_Ability5 = Bitmap(loaderInfo.content);
		}
		
		public function onFusionAbility6Complete(e: Event): void 
		{
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onPrimaryImageLoadComplete);

			f_Ability6 = Bitmap(loaderInfo.content);
		}	

	}	
}
