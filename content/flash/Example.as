package {

	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.Event;
	import flash.display.Bitmap;
	import flash.display.LoaderInfo;
	import flash.geom.Rectangle;

	// Valve Libaries
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	// Used to make nice buttons / doto themed stuff
	import flash.utils.getDefinitionByName;

	// Scaleform stuff
	import scaleform.clik.interfaces.IDataProvider;
	import scaleform.clik.data.DataProvider;
	import flash.display.Loader;
	import flash.net.URLRequest;
	import flash.display.Sprite;

	public class Example extends MovieClip 
	{
		// element details filled out by game engine
		public var gameAPI: Object;
		public var globals: Object;
		public var elementName: String;
		public var heroNameKV: Object;
		public var addedFusionPortraitBorder: Boolean = false;
		public var fusionHeroBitmap:Bitmap;
		public var newFusionSelectBtn:MovieClip;

//------<Constructor>------------------------------------------------------------------------------------------------------
		
		public function Example() {}
		

//------<Events>-----------------------------------------------------------------------------------------------------------

		// called by the game engine when this .swf has finished loading
		public function onLoaded(): void 
		{
			trace ("Example class loaded");
			
			// Actually show the UI
			visible = true;
			// Don't know if necessary since its supposed to autoplay anyway.
			this.gotoAndPlay(1);
			
			// Load Hero name to internal KV fils
			heroNameKV = Globals.instance.GameInterface.LoadKVFile('scripts/fusionKVs/heroDisplayToInternalName.txt');

			Globals.instance.resizeManager.AddListener(this);

			//Subscribe to Game Events ---------------------------------------------
			//gameAPI.SubscribeToGameEvent("CheckHeroName", updateHeroName);
			//----------------------------------------------------------------------

			// Customize the visibility of the Hero Loadout UI to disable the selection functionality and other unnecessary elements.
			setHeroDockVisibility(true)

			//==============================================
			// SETUP FUSION CHOOSE BUTTON
			//==============================================
			// Get reference to the select hero button and copy its position so we can create the fusion hero select button
			var selectButton: MovieClip = getDock().selectButton;
			// Create a proxy object so that the fusion button can be replaced with a Dota button component.
			var proxyFusionSelectBtn: MovieClip = new MovieClip();
			// Add the proxy to the stage
			selectButton.parent.addChild(proxyFusionSelectBtn);
			// Set the x and y for the proxy fusion button
			proxyFusionSelectBtn.x = selectButton.x;
			proxyFusionSelectBtn.y = selectButton.y;
			// NOTE: Currently, this width and height are being ignored volunteraly 
			proxyFusionSelectBtn.width = 500
			proxyFusionSelectBtn.height = 50
			// Create and get reference to the DOTA component replacing the proxy fusion select button
			newFusionSelectBtn = replaceWithValveComponent(proxyFusionSelectBtn, "button_big", false);
			// Set the text for the button
			newFusionSelectBtn.label = "Choose Fusion Hero";
			// Add event listener
			newFusionSelectBtn.addEventListener(MouseEvent.CLICK, selectFusionBtnClicked);
			//==============================================
			
			// Add the Fusion Hero Selection Info movie clip to the hero dock
			selectButton.parent.addChild(fusionLoadoutLabel);
			// Hide it until the player first selects a fusion hero
			(fusionLoadoutLabel as MovieClip).visible = false;

		}

		public function selectFusionBtnClicked(): void 
		{
			trace("Fusion Select Btn was Clicked");

			// Get reference to the hidden select button
			var selectButton: MovieClip = getDock().selectButton;
			// Get the name of the hero
			var selFusionHero: String = globals.Loader_shared_heroselectorandloadout.movieClip.heroDock.selectButton.textField.text;
			
			trace("Fusion hero is : " + selFusionHero);
			
			// If the fusion hero internal name is invalid, then escape so player can choose another
			if (heroNameKV[selFusionHero] == null)
			{
				trace(selFusionHero + " has an invalid internal name pairing");
				return;
			}
			
			// Create loader for loading the hero potrait textures
			var loader: Loader = new Loader();

			// Add the events fot loading the images
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onFusionImageLoadComplete);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onFusionImageLoadError);
			
			// Use the internal hero name to get reference to the hero portrait.
			loader.load(new URLRequest('images/heroes/selection/' + heroNameKV[selFusionHero] + '.png'));
			
			// Set the test of the hero label to that of the hero name
			fusionLoadoutLabel.fusionHeroNameLabel.text = selFusionHero;

			// Shows the fusion hero movie clip
			(fusionLoadoutLabel as MovieClip).visible = true;
			
			//newFusionSelectBtn.visible = false;
			newFusionSelectBtn.removeEventListener(MouseEvent.CLICK, selectFusionBtnClicked);
			newFusionSelectBtn.parent.removeChild(newFusionSelectBtn);

			// Double make sure the select button is visible.
			selectButton.removeChild(selectButton.mask);
			selectButton.visible = true	;
			selectButton.enabled = true	;
			
			// Set the Hero dock to enable the player to choose his/her primary hero
			setHeroDockVisibility(false)
			
			// Add the select button again so it refreshes
			selectButton.parent.addChild(selectButton);
			
			// Tell the server that this player chose a fusion hero and send that info.
			gameAPI.SendServerCommand("PlayerChoseFusionHero " + heroNameKV[selFusionHero]);
					
		}


		public function onFusionImageLoadComplete(e: Event): void 
		{
			trace('Fusion Portrait Image Load Complete');
			
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onFusionImageLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onFusionImageLoadError);

			var bitmap: Bitmap = Bitmap(loaderInfo.content);
			
			// Manually setting w and h because there is a hero portrait that is larger than the rest.
			bitmap.width = 71;
			bitmap.height = 94;
		
			
			// Remove old fusion hero portrait from the fusion hero movie clip
			if(fusionHeroBitmap != null)
			{
				fusionLoadoutLabel.removeChild(fusionHeroBitmap);
			}
			// Add the tex to the fusion hero movie clip.
			fusionLoadoutLabel.addChild(bitmap)
			fusionHeroBitmap = bitmap;
			
			if(addedFusionPortraitBorder == false)
			{
				addBorderToMovieClip(fusionLoadoutLabel, bitmap);
				addedFusionPortraitBorder = true;
				trace("Added Border");
			}			
		}

		public function onFusionImageLoadError(e: IOErrorEvent): void 
		{
			trace('Fusion Portrait Image Load Errors: ' + e.text);
			
			var loaderInfo: LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onFusionImageLoadComplete);
			loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onFusionImageLoadError);
		}
		
		// called by the game engine after onLoaded and whenever the screen size is changed
		public function onScreenSizeChanged(): void 
		{
			// By default, your 1024x768 swf is scaled to fit the vertical resolution of the game
			//   and centered in the middle of the screen.
			// You can override the scaling and positioning here if you need to.
			// stage.stageWidth and stage.stageHeight will contain the full screen size.
			
			// Set the fusion hero movie clip to be below the spin random button UI.  Consider changing to a more static position.
			var spinBtn: MovieClip = globals.Loader_shared_heroselectorandloadout.movieClip.heroDock.spinRandomButton
			fusionLoadoutLabel.y = spinBtn.y + 90;

			trace("Screen size changed");
		}

		
//------<Regular Methods>-----------------------------------------------------------------------------------------------------------
		
		private function addBorderToMovieClip(mc: MovieClip, bitmap:Bitmap): void 
		{
			// Create border sprite
			var borderSprite:Sprite = new Sprite();
			// Create border Color
			// Very dark grey
			var borderColor:uint = 0x060606;
			// Begin fill for color
			borderSprite.graphics.beginFill(borderColor, 1);
			
			// Draw a rectangle
			borderSprite.graphics.drawRect(-4.2, -4.2, bitmap.width * 1.12, bitmap.height * 1.095);

			// end fill
			borderSprite.graphics.endFill();

			// Add to fusion hero portrair movie clip.
			mc.addChild(borderSprite);
			// Add the portrait again so its on top of the border.
			mc.addChild(bitmap);
		}

		// Function copied from http://yrrep.me/dota/flash-components.php
		// Used to replace movice clips with valve dota component objects like buttons and sucj.
		private function replaceWithValveComponent(mc: MovieClip, type: String, keepDimensions: Boolean = false): MovieClip 
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
			if (keepDimensions) {
				newObject.width = oldwidth;
				newObject.height = oldheight;
			}

			parent.removeChild(mc);
			parent.addChild(newObject);

			return newObject;
		}

		// Get the hero dock from the Valve Dota UIs.  
		private function getDock(): MovieClip 
		{
			return globals.Loader_shared_heroselectorandloadout.movieClip.heroDock;
		}

		// Used for hiding or unhiding the Dota Hero dock UI elements. Credit to Ash47 
		// vis: true will set for fusion hero selection.  false for primary hero selection
		private function setHeroDockVisibility(fusionSelVis: Boolean) {


			// Grab the hero dock
			var dock: MovieClip = getDock();

			var i: Number;
			var lst: Array;
			
			lst = [
				dock.heroSelectorContainer,
				dock.itemSelection,
				dock.selectedCardOutline,
				dock.selectButton_Grid,
				dock.purchasepreview,
				dock.fullDeckEditButtons,
				dock.backToBrowsingButton,
				dock.repickButton,
				dock.selectButton,
				dock.playButton,
				dock.Message,
				dock.spinRandomButton,
				dock.suggestedHeroes,
				dock.suggestButton,
				dock.randomButton,
				dock.raisedCard,
				dock.viewToggleButton,
				dock.fullDeckLegacy,
				dock.backButton,
				dock.heroLoadout,
				dock.goldleft,
				dock.filterButtons.RolesCombo,
				dock.filterButtons.AttackCombo,
				dock.filterButtons.MyHeroesCombo,
				dock.filterButtons.searchBox
				];
				
				
			// Delete any old masks
			for (i = 0; i < lst.length; i++) {
				// Validate that is exists
				if (lst[i] != null) {
					if (lst[i].mask != null) {
						// Check if this is one of our masks
						if (contains(lst[i].mask)) {
							removeChild(lst[i].mask);
						}

						// Remove the mask
						lst[i].mask = null;
					}
				}
			}

			// Change the visibility of stuff depending on the passed parameter
			if(fusionSelVis)
			{
				lst = [
				//dock.heroSelectorContainer,
				//dock.itemSelection,
				//dock.selectedCardOutline,
				dock.selectButton_Grid,
				//dock.purchasepreview,
				dock.fullDeckEditButtons,
				//dock.backToBrowsingButton,
				//dock.repickButton,
				dock.selectButton,
				//dock.playButton,
				//dock.Message,
				//dock.spinRandomButton,
				dock.suggestedHeroes,
				dock.suggestButton,
				dock.randomButton,
				//dock.raisedCard,
				//dock.viewToggleButton,
				//dock.fullDeckLegacy,
				//dock.backButton,
				//dock.heroLoadout,
				//dock.goldleft,
				//dock.filterButtons.RolesCombo,
				//dock.filterButtons.AttackCombo,
				//dock.filterButtons.MyHeroesCombo,
				//dock.filterButtons.searchBox
				];
			}
			else
			{
				lst = [
				//dock.heroSelectorContainer,
				//dock.itemSelection,
				//dock.selectedCardOutline,
				//dock.selectButton_Grid,
				//dock.purchasepreview,
				dock.fullDeckEditButtons,
				//dock.backToBrowsingButton,
				//dock.repickButton,
				//dock.selectButton,
				//dock.playButton,
				//dock.Message,
				//dock.spinRandomButton,
				dock.suggestedHeroes,
				dock.suggestButton,
				dock.randomButton,
				//dock.raisedCard,
				//dock.viewToggleButton,
				//dock.fullDeckLegacy,
				//dock.backButton,
				//dock.heroLoadout,
				//dock.goldleft,
				//dock.filterButtons.RolesCombo,
				//dock.filterButtons.AttackCombo,
				//dock.filterButtons.MyHeroesCombo,
				//dock.filterButtons.searchBox
				];
			}


			// Store states
			for (i = 0; i < lst.length; i++) {
				// Validate that is exists
				if (lst[i] != null) {
					// Hide it
					var msk = new MovieClip();
					addChild(msk);
					lst[i].mask = msk;
				}
			}
		}
	}
}