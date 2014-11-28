package  {
	
	import flash.display.MovieClip;
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.display.DisplayObject;
	import flash.display.SimpleButton;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	// Timer
    import flash.utils.Timer;
    import flash.events.TimerEvent;

	public class MainPanel extends MovieClip 
	{
		public var ApplyFusionBtn:MovieClip;
		
		// Reference to all the fusion hero ability container MCs
		var fusionAbility1:AbilityContainerMain;
		var fusionAbility2:AbilityContainerMain;
		var fusionAbility3:AbilityContainerMain;
		var fusionAbility4:AbilityContainerMain;
		var fusionAbility5:AbilityContainerMain;
		var fusionAbility6:AbilityContainerMain;
		
		// Array created to help iterate through the fusion ability containers
		var fusionAbilitiesArray:Array;
		var fusionAbilitiesContainer:MovieClip = new MovieClip();
		
		// Reference to all the primary hero ability container MCs
		var primaryAbility1:AbilityContainerMain;
		var primaryAbility2:AbilityContainerMain;
		var primaryAbility3:AbilityContainerMain;
		var primaryAbility4:AbilityContainerMain;
		var primaryAbility5:AbilityContainerMain;
		var primaryAbility6:AbilityContainerMain;
		
		// Array created to help iterate through the primary ability containers
		var primaryAbilitiesArray:Array;
		var primaryAbilitiesContainer:MovieClip = new MovieClip();
		
		// Reference to all the combined hero ability container MCs
		var combinedAbility1:AbilityContainerMain;
		var combinedAbility2:AbilityContainerMain;
		var combinedAbility3:AbilityContainerMain;
		var combinedAbility4:AbilityContainerMain;
		var combinedAbility5:AbilityContainerMain;
		var combinedAbility6:AbilityContainerMain;
		
		// Array created to help iterate through the combined ability containers
		var combinedAbilitiesArray:Array;
		var combinedAbilitiesContainer:MovieClip = new MovieClip();
		
		var primaryHeroPortraitMC:MovieClip = p_heroPortrait;
		var fusionHeroPortraitMC:MovieClip = f_heroPortrait;
		
		var portraitSizeWidth:int = 58;
		var portraitSizeHeight:int = 77;
		
		var portraitOffsetX:int = 4;
		var portraitOffsetY:int = 4;
		
		// Max number of available slots;
		public var maxAvailableSlots = 6;
		// Points to the next available ability slot.
		var currentlyAvailableSlot:int = 0;
		
		// Temp array for holding the abilities that are currently set as required during a mouse hover
		var currentlySetRequiredAbilities:Array = [];
		// Temp array for holding the abilities that are currently set as paired during a mouse hover
		var currentlySetPairdAbilities:Array = [];
		// KV pair object that helps storing relationships between the paired abilities
		var currentlyEquippedPairedAbilities:Object = new Object();
		// KV pair object for storing bitmaps when doing index specific previewing
		var currentLySetIndexSpecificPreviewImages:Object = new Object();
		
		var toolTipTimer:Timer = new Timer(200, 0);
		var currentHoveredButton:DisplayObject = null;
		
		
		public function MainPanel() 
		{
			ApplyFusionBtn = applyFusion_Btn;
			
			fusionAbility1 = f_ability1;
			fusionAbility2 = f_ability2;
			fusionAbility3 = f_ability3;
			fusionAbility4 = f_ability4;
			fusionAbility5 = f_ability5;
			fusionAbility6 = f_ability6;
			
			primaryAbility1 = p_ability1;
		    primaryAbility2 = p_ability2;
			primaryAbility3 = p_ability3;
			primaryAbility4 = p_ability4;
			primaryAbility5 = p_ability5;
			primaryAbility6 = p_ability6;
			
			combinedAbility1 = c_ability1;
			combinedAbility2 = c_ability2;
			combinedAbility3 = c_ability3;
			combinedAbility4 = c_ability4;
			combinedAbility5 = c_ability5;
		    combinedAbility6 = c_ability6;
			
			combinedAbility1.RowPosition = 0;
			combinedAbility2.RowPosition = 1;
			combinedAbility3.RowPosition = 2;
			combinedAbility4.RowPosition = 3;
			combinedAbility5.RowPosition = 4;
			combinedAbility6.RowPosition = 5;
	
			fusionAbilitiesArray = [fusionAbility1,fusionAbility2,fusionAbility3,fusionAbility4,fusionAbility5,fusionAbility6];
			primaryAbilitiesArray = [primaryAbility1, primaryAbility2, primaryAbility3, primaryAbility4, primaryAbility5, primaryAbility6];
			combinedAbilitiesArray = [combinedAbility1, combinedAbility2, combinedAbility3, combinedAbility4, combinedAbility5, combinedAbility6];
			
			addChild(fusionAbilitiesContainer);
			addChild(primaryAbilitiesContainer);
			addChild(combinedAbilitiesContainer);
			
			// Add all the ability mcs to containers so we can easily set event handlers.
			for (var i:uint = 0; i < combinedAbilitiesArray.length; i++) 
			{ 
				fusionAbilitiesContainer.addChild(fusionAbilitiesArray[i]);
				primaryAbilitiesContainer.addChild(primaryAbilitiesArray[i]);
				combinedAbilitiesContainer.addChild(combinedAbilitiesArray[i]);
			} 
			
			// On Clicks
			fusionAbilitiesContainer.addEventListener(MouseEvent.MOUSE_DOWN, onClick_fusionOrPrimaryAbility, true);
			primaryAbilitiesContainer.addEventListener(MouseEvent.MOUSE_DOWN, onClick_fusionOrPrimaryAbility, true);
			combinedAbilitiesContainer.addEventListener(MouseEvent.MOUSE_DOWN, onClick_combinedAbility, true);
			// On Hovers
			fusionAbilitiesContainer.addEventListener(MouseEvent.MOUSE_OVER, onHover_fusionOrPrimaryAbility, true);
			primaryAbilitiesContainer.addEventListener(MouseEvent.MOUSE_OVER, onHover_fusionOrPrimaryAbility, true);
			combinedAbilitiesContainer.addEventListener(MouseEvent.MOUSE_OVER, onHover_combinedAbility, true);
			// On Mouse Out
			fusionAbilitiesContainer.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut_FusionOrPrimaryAbility, true);
			primaryAbilitiesContainer.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut_FusionOrPrimaryAbility, true);
			combinedAbilitiesContainer.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut_CombinedAbility, true);
		}
		
		// Called when the mouse exits a fusion ability container
		private function onMouseOut_FusionOrPrimaryAbility(e:MouseEvent): void
		{
			// Get the fusion or primary ability btn that was hovered
			var targetBtn:DisplayObject = e.target as DisplayObject;
			
			// If the we don't have an ability container object. return
			if ((targetBtn.parent is AbilityContainerMain) == false)
				return;
			
			var hoveredAbility:AbilityContainerMain = AbilityContainerMain(targetBtn.parent);
			
			clearIndexSpecificPreviewImages();
			
			// If we have some required abilities highlighted set, clear them
			if(currentlySetRequiredAbilities.length != 0)
			{
				for(var i:uint = 0; i < currentlySetRequiredAbilities.length; i++)
				{
					// If the currently set required ability is not hidden, then set it as available
					if (AbilityContainerMain(currentlySetRequiredAbilities[i]).IsHidden == false)
					{
						AbilityContainerMain(currentlySetRequiredAbilities[i]).SetAsAvailable();
					}
				}
				
				// Clear the array
				currentlySetRequiredAbilities = [];
			}
			
			// If we have some paired abilities highlighted set, clear them
			if(currentlySetPairdAbilities.length != 0)
			{
				for(var p:uint = 0; p < currentlySetPairdAbilities.length; p++)
				{
					// If the currently set required ability is not hidden, then set it as available
					if (AbilityContainerMain(currentlySetPairdAbilities[p]).IsHidden == false)
					{
						AbilityContainerMain(currentlySetPairdAbilities[p]).SetAsAvailable();
					}
				}
				
				// Clear the array
				currentlySetPairdAbilities = [];
			}
			
			FusionTab(parent).globals.Loader_rad_mode_panel.gameAPI.OnHideAbilityTooltip();
			currentHoveredButton = null;
			toolTipTimer.stop();
			toolTipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, tunOnToolTip);
		}
		
		private function onMouseOut_CombinedAbility(e:MouseEvent): void
		{
			// Get the fusion or primary ability btn that was hovered
			var targetBtn:DisplayObject = e.target as DisplayObject;
			
			// If the we don't have an ability container object. return
			if ((targetBtn.parent is AbilityContainerMain) == false)
				return;
			
			// If we have some required abilities set, clear them
			if(currentlySetPairdAbilities.length != 0)
			{
				for(var i:uint = 0; i < currentlySetPairdAbilities.length; i++)
				{
					// If the currently set required ability is not hidden, then set it as available
					if (AbilityContainerMain(currentlySetPairdAbilities[i]).IsHidden == false)
					{
						AbilityContainerMain(currentlySetPairdAbilities[i]).SetAsAvailable();
					}
				}
				
				// Clear the array
				currentlySetPairdAbilities = [];
			}
			
			FusionTab(parent).globals.Loader_rad_mode_panel.gameAPI.OnHideAbilityTooltip();
			currentHoveredButton = null;
			toolTipTimer.stop();
			toolTipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, tunOnToolTip);
		}
				
		// When the player clicks on either the fusion or primary abilities
		private function onClick_fusionOrPrimaryAbility(e:MouseEvent): void
		{
			// Get the fusion or primary ability btn that was clicked
			var targetBtn:DisplayObject = e.target as DisplayObject;
			
			if ((targetBtn.parent is AbilityContainerMain) == false)
				return;
			
			if (AbilityContainerMain(targetBtn.parent).Clickable == false)
				return;
			
			// If we have no available slots to fill, simply exit
			if(getTotalAvailableSlots() == 0)
				return;
			
			var clickedAbility:AbilityContainerMain = AbilityContainerMain(targetBtn.parent);
			
			// Disable and set to hidden this fusion or primary ability container since its already being added
			clickedAbility.SetAsHidden();
			clickedAbility.LinkedAbility = null;
			
			// Add to the combined ability row
			addAbilityToCombinedRow(clickedAbility);
			
			if(clickedAbility.initializationData.BlockedBy != null)
			{
				for (var i:uint = 0; i < clickedAbility.initializationData.BlockedBy.length; i++)
				{
					if(currentlyEquippedPairedAbilities[clickedAbility.initializationData.BlockedBy[i]] == null ||
					   currentlyEquippedPairedAbilities[clickedAbility.initializationData.BlockedBy[i]] == undefined)
					{
						currentlyEquippedPairedAbilities[clickedAbility.initializationData.BlockedBy[i]] = [clickedAbility.AbilityName];
					}
					else
					{
						currentlyEquippedPairedAbilities[clickedAbility.initializationData.BlockedBy[i]] = currentlyEquippedPairedAbilities[clickedAbility.initializationData.BlockedBy[i]].concat(clickedAbility.AbilityName);
					}
				}
			}
			
			if(clickedAbility.initializationData.PairedBy != null)
			{
				for (var i:uint = 0; i < clickedAbility.initializationData.PairedBy.length; i++)
				{
				//	if(currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]] == null ||
				//	   currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]] == undefined)
				//	{
						if ( currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]] != undefined)
							currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]] = currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]].concat(clickedAbility.AbilityName);
						else
							currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]] = [clickedAbility.AbilityName];
						
						var pairedAbi:AbilityContainerMain = findAbilityOfName(clickedAbility.initializationData.PairedBy[i]);
						
						if (pairedAbi.initializationData.PairedBy != null)
						{
							for (var b:uint = 0; b < pairedAbi.initializationData.PairedBy.length; b++)
							{
								if( currentlyEquippedPairedAbilities[pairedAbi.initializationData.PairedBy[b]] != undefined)
									currentlyEquippedPairedAbilities[pairedAbi.initializationData.PairedBy[b]] = currentlyEquippedPairedAbilities[pairedAbi.initializationData.PairedBy[b]].concat(pairedAbi.AbilityName);
								else
									currentlyEquippedPairedAbilities[pairedAbi.initializationData.PairedBy[b]] = [pairedAbi.AbilityName];
							}
						}
						
						addAbilityToCombinedRow(pairedAbi);
						pairedAbi.SetAsAvailable();
						pairedAbi.SetAsHidden();
						pairedAbi.LinkedAbility = null;
				//	}
					//else
				//	{
					//	currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]] = currentlyEquippedPairedAbilities[clickedAbility.initializationData.PairedBy[i]].concat(clickedAbility.AbilityName);
					//}
				}
			}
			
			if(getTotalAvailableSlots() == 0)
			{
				disableAbilities(primaryAbilitiesArray);
				disableAbilities(fusionAbilitiesArray);
			}
			
			checkBlockedAbilities();
			removePairedAbilities();
		}
		
		private function onClick_combinedAbility(e:MouseEvent): void
		{
			if(getTotalAvailableSlots() == 0)
			{
				enableNonUsedAbilities(primaryAbilitiesArray);
				enableNonUsedAbilities(fusionAbilitiesArray);
			}
			
			removeCombinedAbility(AbilityContainerMain(DisplayObject(e.target).parent));
		}
		
		private function onHover_fusionOrPrimaryAbility(e:MouseEvent): void
		{
			// Get the fusion or primary ability btn that was hovered
			var targetBtn:DisplayObject = e.target as DisplayObject;
			
			if ((targetBtn.parent is AbilityContainerMain) == false)
				return;
			
			//var x=targetBtn.localToGlobal(new Point(targetBtn.width,0)).x;
			//var y=targetBtn.localToGlobal(new Point(0,0)).y;
			
			currentHoveredButton = targetBtn;
			toolTipTimer.start();
			toolTipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, tunOnToolTip);
			//FusionTab(parent).globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(x, y, specialCaseConvertAbilityName(AbilityContainerMain(targetBtn.parent).AbilityName));
			
			if (AbilityContainerMain(targetBtn.parent).initializationData.BlockedBy != null)
			{

				if (isAbilityEquiped(AbilityContainerMain(targetBtn.parent).initializationData.BlockedBy[0]) == false)
				{
					highlightRequiredAbilities(AbilityContainerMain(targetBtn.parent).initializationData.BlockedBy);
					return;
				}
			}
			
			if (AbilityContainerMain(targetBtn.parent).initializationData.PairedBy != null)
			{

				highlightPairedAbilities(AbilityContainerMain(targetBtn.parent).initializationData.PairedBy, AbilityContainerMain(targetBtn.parent));

			}
			

			
			previewAbilityToAdd(AbilityContainerMain(targetBtn.parent), AbilityContainerMain(targetBtn.parent).initializationData.IndexSpecific);
		}
		
		private function onHover_combinedAbility(e:MouseEvent): void
		{
			// Get the fusion or primary ability btn that was hovered
			var targetBtn:DisplayObject = e.target as DisplayObject;
			
			if ((targetBtn.parent is AbilityContainerMain) == false)
				return;
			
			//var x=targetBtn.localToGlobal(new Point(targetBtn.width,0)).x;
			//var y=targetBtn.localToGlobal(new Point(0,0)).y;

			currentHoveredButton = targetBtn;
			toolTipTimer.start();
			toolTipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, tunOnToolTip);
			//FusionTab(parent).globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(x, y, AbilityContainerMain(targetBtn.parent).AbilityName);
			
			if (currentlyEquippedPairedAbilities[AbilityContainerMain(targetBtn.parent).AbilityName] != undefined || 
				currentlyEquippedPairedAbilities[AbilityContainerMain(targetBtn.parent).AbilityName] != null)
			{
				highlightPairedAbilities(currentlyEquippedPairedAbilities[AbilityContainerMain(targetBtn.parent).AbilityName], AbilityContainerMain(targetBtn.parent));
			}
		}
		
		private function tunOnToolTip(e:TimerEvent):void
		{
			if(currentHoveredButton != null && AbilityContainerMain(currentHoveredButton.parent).AbilityName != "")
			{
				var x=currentHoveredButton.localToGlobal(new Point(currentHoveredButton.width,0)).x;
				var y=currentHoveredButton.localToGlobal(new Point(0,0)).y;
				FusionTab(parent).globals.Loader_rad_mode_panel.gameAPI.OnShowAbilityTooltip(x, y, specialCaseConvertAbilityName(AbilityContainerMain(currentHoveredButton.parent).AbilityName));
			}
		}
		
		public function SetFusionHeroPortrait(portrait : Bitmap): void
		{
			portrait.width = portraitSizeWidth;
			portrait.height = portraitSizeHeight;
		    portrait.x = portraitOffsetX;
			portrait.y = portraitOffsetY;
			f_heroPortrait.addChildAt(portrait,0);
		}
		
		public function SetPrimaryHeroPortrait(portrait : Bitmap): void
		{
			portrait.width = portraitSizeWidth;
			portrait.height = portraitSizeHeight;
			portrait.x = portraitOffsetX;
			portrait.y = portraitOffsetY;
			p_heroPortrait.addChildAt(portrait,0);
		}
		
		public function SetPrimaryAbilities(... abilitiesInitData): void
		{
			toolTipTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, tunOnToolTip);
			
			setAbilities(primaryAbilitiesArray, abilitiesInitData);
		}
		
		public function SetFusionAbilities(... abilitiesInitData): void
		{
			setAbilities(fusionAbilitiesArray, abilitiesInitData);
		}
		
		private function setAbilities(containerArray:Array, dataArray:Array): void
		{
			for (var i:uint = 0; i < dataArray.length; i++) 
			{ 
				if ( dataArray[i] != null && dataArray[i] is AbilityInitData)
				{
					var abilityToSet:AbilityContainerMain =  containerArray[i];
					abilityToSet.SetInitializationData(dataArray[i]);
					abilityToSet.RowPosition = i + 1;
				}
			} 
		}
		
		private function disableAbilities(containerArray:Array): void
		{
			for (var i:uint = 0; i < containerArray.length; i++) 
			{ 
				var abilityToSet:AbilityContainerMain =  containerArray[i];
				abilityToSet.SetAsHidden();
			} 
		}
		
		private function enableNonUsedAbilities(containerArray:Array): void
		{
			for (var i:uint = 0; i < containerArray.length; i++) 
			{ 
				if (AbilityContainerMain(containerArray[i]).IsDefault)
					break;
				
				for (var b:uint = 0; b < combinedAbilitiesArray.length; b++) 
				{
					if ( AbilityContainerMain(combinedAbilitiesArray[b]).LinkedAbility != AbilityContainerMain(containerArray[i]))
						AbilityContainerMain(containerArray[i]).SetAsAvailable();
					else
					{
						AbilityContainerMain(containerArray[i]).SetAsHidden();
						break;
					}
				}
			} 
		}
		
		private function addAbilityToCombinedRow(ability:AbilityContainerMain): Boolean
		{
			// The index its going to be added to
			var	indexToAddTo = -1;			
			var checkForRemovedRequiredAbilities:Boolean = false;
			
			// If the ability to be added needs to be added to a specific index position
			if(ability.initializationData.IndexSpecific != -1)
			{
				// Use this as the index to add to
				indexToAddTo = ability.initializationData.IndexSpecific;
				// If the ability index we are adding to already has an ability
				if (combinedAbilitiesArray[indexToAddTo].LinkedAbility != null)
				{
					// Set it as available
					combinedAbilitiesArray[indexToAddTo].LinkedAbility.SetAsAvailable();
					combinedAbilitiesArray[indexToAddTo].LinkedAbility.PlaySheen();
					checkForRemovedRequiredAbilities = true;
				}
			}
			else
			{
				// Choose the available position
				indexToAddTo = getNextAvailablePosition();
				
				// If the index we are adding to means that we are already at the limit, return and exit
				if (indexToAddTo >= maxAvailableSlots)
					return false;
			}
			
			// Replace Icon, play Sheen, set as available, set the linked ability to this one, set the ability name
			combinedAbilitiesArray[indexToAddTo].ReplaceAbilityIcon(ability.SharedIcon);
			combinedAbilitiesArray[indexToAddTo].PlaySheen();
			combinedAbilitiesArray[indexToAddTo].SetAsAvailable();
			combinedAbilitiesArray[indexToAddTo].LinkedAbility = ability;
			combinedAbilitiesArray[indexToAddTo].IsDefault = false;
			combinedAbilitiesArray[indexToAddTo].AbilityName = ability.AbilityName;
			
			// If when we added the index specific, we removed an ability, make sure to remove pairs or blocked abilities.
			if(checkForRemovedRequiredAbilities)
			{
				checkBlockedAbilities();
				removeBlockedAbilities();
			}
			
			currentlyAvailableSlot++;
			
			// Clear from index preview container
			currentLySetIndexSpecificPreviewImages[indexToAddTo] = null;
			
			return checkForRemovedRequiredAbilities;
			
		}
		
		private function previewAbilityToAdd(ability:AbilityContainerMain, indexSpecific:int = -1)
		{
			if (indexSpecific != -1)
			{
				currentLySetIndexSpecificPreviewImages[indexSpecific] = combinedAbilitiesArray[indexSpecific].LinkedAbility;
				combinedAbilitiesArray[indexSpecific].ReplaceAbilityIcon(ability.SharedIcon);

				combinedAbilitiesArray[indexSpecific].SetAsHidden();
				combinedAbilitiesArray[indexSpecific].IsDefault = false;
				ability.LinkedAbility = combinedAbilitiesArray[indexSpecific];
			}
			else
			{
				var indexToAddTo:int = getNextAvailablePosition();
				
				if(indexToAddTo < 6)
				{
					combinedAbilitiesArray[indexToAddTo].ReplaceAbilityIcon(ability.SharedIcon);

					combinedAbilitiesArray[indexToAddTo].SetAsHidden();
					combinedAbilitiesArray[indexToAddTo].IsDefault = false;
					ability.LinkedAbility = combinedAbilitiesArray[indexToAddTo];
				}
			}
		}
		
		private function removeCombinedAbility(ability:AbilityContainerMain)
		{
			
			var abilityToRemove:AbilityContainerMain = ability;
			var linkedAbility:AbilityContainerMain = abilityToRemove.LinkedAbility;
			
			linkedAbility.SetAsAvailable();
			linkedAbility.PlaySheen();
			
			// If the combined ability container we clicked is the last one, simply reset, don't swap.
			if(abilityToRemove.RowPosition == maxAvailableSlots - 1)
			{
				abilityToRemove.ResetToDefault();
				checkBlockedAbilities();
			}
			else
			{
				reoderCombinedAbilityRow(abilityToRemove.RowPosition);
				checkBlockedAbilities();
			}
						
			removeBlockedAbilities();
			
			
			if(currentlySetPairdAbilities.length != 0)
			{
				for(var i:uint = 0; i < currentlySetPairdAbilities.length; i++)
				{
					if(AbilityContainerMain(currentlySetPairdAbilities[i]).IsDefault == false)
					{
						AbilityContainerMain(currentlySetPairdAbilities[i]).SetAsAvailable();
					}
					else
						AbilityContainerMain(currentlySetPairdAbilities[i]).ResetToDefault();
				}
				
				// Clear the array
				currentlySetPairdAbilities = [];
			}
			
			removePairedAbilities();
			
			removeAbilityFromPairedList(linkedAbility);
		}
		
		private function swapAbilityContainers(abi1:AbilityContainerMain, abi2:AbilityContainerMain)
		{
			var abi1Icon:DisplayObject = abi1.AbilityIcon.getChildAt(0);
			var abi2Icon:DisplayObject = abi2.AbilityIcon.getChildAt(0);
			var linkedAbi1:AbilityContainerMain = abi1.LinkedAbility;
			var linkedAbi2:AbilityContainerMain = abi2.LinkedAbility;
			var nameAbi1:String = abi1.AbilityName;
			var nameAbi2:String = abi2.AbilityName;
			abi1.LinkedAbility = linkedAbi2;
			abi2.LinkedAbility = linkedAbi1;
			
			abi1.AbilityName = nameAbi2;
			abi2.AbilityName = nameAbi1;
			
			abi1.ReplaceAbilityIcon(abi2Icon);
			abi2.ReplaceAbilityIcon(abi1Icon);
			
		}
		
		private function reoderCombinedAbilityRow(index:int)
		{

			var skipCount:int = 0;
			var currentSavedIndex:uint = 0;
			
			// For every ability including and above the one that was just clicked
			for(var i:uint = index; i < maxAvailableSlots - 1; i++)
			{
				// Get a reference to the ability on the right from where we are.
				var abiToSwitch:AbilityContainerMain = combinedAbilitiesArray[i+1];
				
				// If the ability we want to switch to has a linked ability and is index specific
				if (abiToSwitch.LinkedAbility != null && abiToSwitch.LinkedAbility.initializationData.IndexSpecific != -1)
				{

					
					// If we haven't skipped, then add to the skip count and save this current index
					if (skipCount == 0)
					{
						skipCount++
						currentSavedIndex = i;
					}
					else
						skipCount++
					
					if(i == maxAvailableSlots  - 2)
					{
						combinedAbilitiesArray[maxAvailableSlots - 1 - skipCount].ResetToDefault();
						combinedAbilitiesArray[maxAvailableSlots - 1 - skipCount].SetAsHidden();
						return;
					}
						
					continue;
				}
				
				
				// If its set to default, don't switch, we have reach the end of the used ability containers
				if(abiToSwitch.IsDefault)
				{
					if (skipCount > 0)
					{
						combinedAbilitiesArray[currentSavedIndex].ResetToDefault();
						combinedAbilitiesArray[currentSavedIndex].SetAsHidden();
						skipCount = 0;
					}
					else
					{
						combinedAbilitiesArray[i].ResetToDefault();
						combinedAbilitiesArray[i].SetAsHidden();
					}
					
					return;
				}
				
				if (skipCount > 0)
				{
					swapAbilityContainers(combinedAbilitiesArray[currentSavedIndex],abiToSwitch);
					skipCount = 0;
					
				}
				else
				{
					swapAbilityContainers(combinedAbilitiesArray[i],abiToSwitch);
				}
				
				
				// we have already swaped the last two abilities, reset the last one.
				if (i == maxAvailableSlots - 2)
				{
					combinedAbilitiesArray[combinedAbilitiesArray.length - 1].ResetToDefault()
					combinedAbilitiesArray[combinedAbilitiesArray.length - 1].SetAsHidden();
				}
			}
			
			currentlyAvailableSlot--;
		}
		
		private function isAbilityEquiped(ability:String): Boolean
		{
			for(var i:uint = 0; i < combinedAbilitiesArray.length; i++)
			{
				if (AbilityContainerMain(combinedAbilitiesArray[i]).AbilityName == ability)
					return true;
			}
			
			return false;
		}
		
		private function checkBlockedAbilities()
		{
			var fusionAndPrimaryAbilities:Array = fusionAbilitiesArray.concat(primaryAbilitiesArray);
			
			for(var i:uint = 0; i < fusionAndPrimaryAbilities.length; i++)
			{
				var currentAbi:AbilityContainerMain = AbilityContainerMain(fusionAndPrimaryAbilities[i]); 				
				
				if(currentAbi.initializationData != null && currentAbi.initializationData.BlockedBy != null && currentAbi.IsHidden == false)
				{
					var missing:Boolean = false;
					
					for(var b:uint = 0; b < currentAbi.initializationData.BlockedBy.length; b++)
					{
						if (isAbilityEquiped(currentAbi.initializationData.BlockedBy[b]) == false)
							missing = true;
					}
					
					if(missing)
						currentAbi.SetAsBlocked();
					else
						currentAbi.SetAsAvailable();
				}
			}
		}
		
		private function removeBlockedAbilities()
		{
			// Go through all combined abilities
			for(var i:uint = 0; i < combinedAbilitiesArray.length; i++)
			{
				var currentAbi:AbilityContainerMain = AbilityContainerMain(combinedAbilitiesArray[i]); 				
				// get a reference to the linked ability
				var linkedAbi:AbilityContainerMain = currentAbi.LinkedAbility;
				// If the linked ability is not null and it has required abilities
				if (linkedAbi != null && linkedAbi.initializationData.BlockedBy != null)
				{
					var missing:Boolean = false;
					// For every required ability in the linked ability
					for(var b:uint = 0; b < linkedAbi.initializationData.BlockedBy.length; b++)
					{
						// If the linked ability doesn't have that ability equipped, set it to missing
						if (isAbilityEquiped(linkedAbi.initializationData.BlockedBy[b]) == false)
							missing = true;
					}
					
					// If it has missing, remove from combined ability tab
					if(missing)
					{
						removeCombinedAbility(currentAbi);
					}
				}
			}
		}
		
		private function removePairedAbilities()
		{
			// Go through all combined abilities
			for(var i:uint = 0; i < combinedAbilitiesArray.length; i++)
			{
				var currentAbi:AbilityContainerMain = AbilityContainerMain(combinedAbilitiesArray[i]); 				
				// get a reference to the linked ability
				var linkedAbi:AbilityContainerMain = currentAbi.LinkedAbility;
				// If the linked ability is not null and it has required abilities
				if (linkedAbi != null && linkedAbi.initializationData.PairedBy != null)
				{
					var missing:Boolean = false;
					// For every required ability in the linked ability
					for(var b:uint = 0; b < linkedAbi.initializationData.PairedBy.length; b++)
					{
						// If the linked ability doesn't have that ability equipped, set it to missing
						if (isAbilityEquiped(linkedAbi.initializationData.PairedBy[b]) == false)
							missing = true;
					}
					
					// If it has missing, remove from combined ability tab
					if(missing)
					{
						removeCombinedAbility(currentAbi);
					}
				}
			}
		}
		
		private function removeAbilityFromPairedList(ability:AbilityContainerMain)
		{
			if (ability.initializationData != null)
			{
				if (ability.initializationData.BlockedBy != null)
				{
					for (var b:uint = 0; b < ability.initializationData.BlockedBy.length; b++)
					{
						var blockedByKey:String = ability.initializationData.BlockedBy[b];
						// Get the key, then find the index of the ability you want to remove and set it to null
						currentlyEquippedPairedAbilities[blockedByKey][currentlyEquippedPairedAbilities[blockedByKey].indexOf(ability.AbilityName)] = null;
					}
				}

				
				if (ability.initializationData.PairedBy != null)
				{
					for (var p:uint = 0; p < ability.initializationData.PairedBy.length; p++)
					{
						var pairedByKey:String = ability.initializationData.PairedBy[p];
						// Get the key, then find the index of the ability you want to remove and set it to null
						//currentlyEquippedPairedAbilities[pairedByKey][currentlyEquippedPairedAbilities[pairedByKey].indexOf(ability.AbilityName)] = null;
						if (currentlyEquippedPairedAbilities[pairedByKey] != null)
							currentlyEquippedPairedAbilities[pairedByKey][currentlyEquippedPairedAbilities[pairedByKey].indexOf(ability.AbilityName)] = null;
					}
				}
				
				
			}
		}
		
		private function highlightRequiredAbilities(abilities:Array)
		{
			var abilityArray:Array = fusionAbilitiesArray.concat(primaryAbilitiesArray);
			
			for (var i:uint = 0; i < abilities.length; i++)
			{
				for (var b:uint = 0; b < abilityArray.length; b++)
				{
					if (String(abilities[i]) == AbilityContainerMain(abilityArray[b]).AbilityName)
					{
						
						if(isAbilityInArray(AbilityContainerMain(abilityArray[b]), currentlySetRequiredAbilities) == false && isAbilityEquiped(String(abilities[i])) == false)
						{
							currentlySetRequiredAbilities[currentlySetRequiredAbilities.length] = AbilityContainerMain(abilityArray[b]);
							AbilityContainerMain(abilityArray[b]).SetAsRequired();
						}
					}
				}
			}
		}
		
		private function highlightPairedAbilities(abilities:Array, callingAbility:AbilityContainerMain)
		{
			// Array of all the abilities
			var abilityArray:Array = fusionAbilitiesArray.concat(primaryAbilitiesArray).concat(combinedAbilitiesArray);
			
			// The paired abilities I want to highlight
			for (var i:uint = 0; i < abilities.length; i++)
			{
				// For every ability in the panel
				for (var b:uint = 0; b < abilityArray.length; b++)
				{
					var currentAbi:AbilityContainerMain = AbilityContainerMain(abilityArray[b]);
					
					// If the name matches && the ability is not hidden && both must be either equiped or not equiped.
					if (String(abilities[i]) == currentAbi.AbilityName && currentAbi.IsHidden == false )
					{
						if (isAbilityEquiped(callingAbility.AbilityName) == isAbilityEquiped(currentAbi.AbilityName))
						{
							// If the ability is not already part of the paired abilities
							if(isAbilityInArray(currentAbi, currentlySetPairdAbilities) == false)
							{
								// Set this ability as part of the paired abilities during this hover
								currentlySetPairdAbilities[currentlySetPairdAbilities.length] = currentAbi;
								currentAbi.SetAsPairedSelect();
								
								if(isAbilityEquiped(callingAbility.AbilityName) == false)
									previewAbilityToAdd(currentAbi, currentAbi.initializationData.IndexSpecific);
							}
						}
					}
				}
			}
			
		}
		
		private function isAbilityInArray(ability:AbilityContainerMain, abilityArray:Array): Boolean
		{
			var returnValue:Boolean = false;
			
			for(var i:uint = 0; i < abilityArray.length; i++)
			{
				if (ability == abilityArray[i])
					returnValue = true;
			}
			
			return returnValue
		}
		
		// Gets the next available position in the combined ability bar
		private function getNextAvailablePosition(): int
		{
			for (var i:uint = 0; i < combinedAbilitiesArray.length; i++)
			{
				if(AbilityContainerMain(combinedAbilitiesArray[i]).IsHidden || AbilityContainerMain(combinedAbilitiesArray[i]).IsDefault)
					return i;
			}
			
			return maxAvailableSlots;
		}
		
		// Used for finding the total number of available slots in the combined ability bar
		private function getTotalAvailableSlots(): int
		{
			var slotsAvailable:int = 0;
			
			for (var i:uint = 0; i < combinedAbilitiesArray.length; i++)
			{
				if(AbilityContainerMain(combinedAbilitiesArray[i]).IsHidden || AbilityContainerMain(combinedAbilitiesArray[i]).IsDefault)
					slotsAvailable++;
			}
			
			return slotsAvailable;
		}
		
		private function clearIndexSpecificPreviewImages()
		{

			for(var i:uint = 0; i < combinedAbilitiesArray.length; i++)
			{
				// If the row position of the linked ability exists in the current set index specified image container
				if (currentLySetIndexSpecificPreviewImages[i] != undefined ||
					currentLySetIndexSpecificPreviewImages[i] != null)
				{
					// Replace the icon to the one set in the container
					combinedAbilitiesArray[i].ReplaceAbilityIcon(currentLySetIndexSpecificPreviewImages[i].SharedIcon);
					
					if(combinedAbilitiesArray[i].AbilityName != "" && combinedAbilitiesArray[i].AbilityName != null)
					{
						combinedAbilitiesArray[i].SetAsAvailable();
					}
					else
					{
						combinedAbilitiesArray[i].ResetToDefault();
						combinedAbilitiesArray[i].SetAsHidden();
					}
					
					// Clear from the container
					currentLySetIndexSpecificPreviewImages[i] == null;
				}
				else if (combinedAbilitiesArray[i].AbilityName == "" || combinedAbilitiesArray[i].AbilityName == null)
				{
					// Reset to default
					combinedAbilitiesArray[i].ResetToDefault();
					combinedAbilitiesArray[i].SetAsHidden();
				
				}
			}
		}
		
		private function findAbilityOfName(abiName:String): AbilityContainerMain
		{
			// Array of all the abilities
			var abilityArray:Array = fusionAbilitiesArray.concat(primaryAbilitiesArray);
			
			// The paired abilities I want to highlight
			for (var i:uint = 0; i < abilityArray.length; i++)
			{
				if(AbilityContainerMain(abilityArray[i]).AbilityName == abiName)
					return AbilityContainerMain(abilityArray[i]);
			}
			return null
		}
		
		public function GetCombinedAbilityNames(): Array
		{
			var abilityNameArray:Array = [];
			
			for (var i:uint = 0; i < combinedAbilitiesArray.length; i++)
			{
				abilityNameArray[i] = AbilityContainerMain(combinedAbilitiesArray[i]).AbilityName;
			}
			
			return abilityNameArray;
		}
		
		public function specialCaseConvertAbilityName(abilityName:String) : String
		{
			if (abilityName == "fusion_visage_soul_assumption")
				return "visage_soul_assumption";
			
			else if (abilityName == "fusion_ember_spirit_fire_remnant")
				return "ember_spirit_fire_remnant";
			
			else if (abilityName =="fusion_invoker_invoke")
				return "invoker_invoke";
			
			else if (abilityName == "fusion_divided_we_stand_hidden")
				return "meepo_divided_we_stand";
			
			else if (abilityName == "fusion_lina_fiery_soul")
				return "lina_fiery_soul";
			
			else
				return abilityName;
		}
	}
	
}
