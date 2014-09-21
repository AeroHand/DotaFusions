
print("game events file loaded")

if DotaFusionsEvents == nil then
   DotaFusionsEvents = class({})  
end


--------------------------------------------------------------------------------
-- GAME EVENT HANDLERS
--------------------------------------------------------------------------------

-- Adds all the event handlers to the supplied table, Used for the DotaFusions GameMode
function DotaFusionsEvents.AddEventHandlers(gMode)

----------------------------------------------------------------------------------------------------------------------------
      function gMode:_PlayerChoseFusionHero(cmdName, hero1, hero2)
          
          -- Add fusion hero selection to player who called        
          local player = Convars:GetDOTACommandClient()
          
          -- If player has not chosen a fusion hero and has already chosen his main hero then lets setup the fusion
          if player.df_fusionHero1 == nil and player:GetAssignedHero() ~= nil then
              
              gMode:SetupFusion(player, hero1, hero2)
          
          else
              print( "either the player already has a fusion hero, or player has not selected a main hero" )
          end      
      end
----------------------------------------------------------------------------------------------------------------------------      
      function gMode:_PlayerSendFusionAbilityRequest(cmdName, ability1, ability2, ability3, ability4, ability5, ability6)
      
          -- Add fusion hero selection to player who called        
          local player = Convars:GetDOTACommandClient()
          
          -- If player has chosen his/her fusion hero and also has an main hero assigned, then try to process ability request
          if player.df_fusionHero1 ~= nil and player:GetAssignedHero() ~= nil then
              
              gMode:ProcessAbilityRequest(player, ability1, ability2, ability3, ability4, ability5, ability6)
          
          else
              print( "Player has not chosen a fusion hero. Can't process ability request")
          end  
      
      end

end

--------------------------------------------------------------------------------
-- SPECIAL CASE ABILITY EVENT HANDLERS
--------------------------------------------------------------------------------

-- Ember Spirit Fire Remnant Show hidden ability
function ShowFireRemantHidden(keys)

    local player = EntIndexToHScript(keys.caster_entindex)
    
    for i = 0, 16 do
    
        if player:GetAbilityByIndex(i) ~= nil then
          
            local ability = player:GetAbilityByIndex(i)
            
            if ability:GetName() == "ember_spirit_fire_remnant" then
                
                ability:SetHidden(false)
                
                local index = keys.ability:GetAbilityIndex()
                
                player:RemoveAbility(keys.ability:GetName())
                
                ability:SetAbilityIndex(index)
                ability:UpgradeAbility()          
            end
        end
    end
end

-- Visage Soul Assumption Show hidden ability
function ShowSoulAssumptionHidden(keys)

    -- Get Hero
    local player = EntIndexToHScript(keys.caster_entindex)
    
    for i = 0, 16 do
    
        if player:GetAbilityByIndex(i) ~= nil then
          
            local ability = player:GetAbilityByIndex(i)
            
            if ability:GetName() == "visage_soul_assumption" then
                
                ability:SetHidden(false)
                
                local index = keys.ability:GetAbilityIndex()
                
                player:RemoveAbility(keys.ability:GetName())
                
                ability:SetAbilityIndex(index)
                ability:UpgradeAbility()          
            end
        end
    end
end

-- Adds the invoker spells via dummy invoke ability while real invoke is hidden
function AddInvokerSpell(keys)
  
    -- Get Hero
    local playerHero = EntIndexToHScript(keys.caster_entindex)  
    -- Get the empty containers
    local invokerEmpty1 = playerHero:FindAbilityByName("invoker_empty1")
    local invokerEmpty2 = playerHero:FindAbilityByName("invoker_empty2")
    -- In case we are cycling an ability out of a container, then store a refernce so we can remove it
    local spellToRemove = nil
  
    -- Count the number of instances of invoker mods to find out which ability to add
    local quasCount = GameRules:GetGameModeEntity():CountNumOfModsAndRemoveThem(playerHero, "modifier_invoker_quas_instance")
    local wexCount = GameRules:GetGameModeEntity():CountNumOfModsAndRemoveThem(playerHero, "modifier_invoker_wex_instance") * 10
    local exortCount = GameRules:GetGameModeEntity():CountNumOfModsAndRemoveThem(playerHero, "modifier_invoker_exort_instance") * 100
    
    -- Using the counts, find out the ability we are supposed to add
    spellToUse = GameRules:GetGameModeEntity():ChooseInvokerSpellBasedOnInstanceCalc(quasCount + wexCount + exortCount)
 
    -- We have a valid spell
    if spellToUse then
        
        -- If we don't already have that ability then add it, if not, lets not do anything else
        -- ====================================================================================
        if playerHero:FindAbilityByName(spellToUse) == nil then
                
            -- Add the ability
            playerHero:AddAbility(spellToUse) 
            -- If the first empty container already has an ability
            if invokerEmpty1:GetContext("SpellInUse") then
                -- If the second empty container also contains an ability
                if invokerEmpty2:GetContext("SpellInUse") then
                    -- Set to remove the ability stored in the second container since we are about tho shift it out
                    spellToRemove = invokerEmpty2:GetContext("SpellInUse")
                  
                end
                -- Set the ability from the first container to be registered in the second container since its about to be moved there       
                invokerEmpty2:SetContext("SpellInUse", invokerEmpty1:GetContext("SpellInUse"), 0)
            
            end
          
            -- Register the ability we just added to the first container
            invokerEmpty1:SetContext("SpellInUse", spellToUse, 0)
            -- Upgrade the ability we just added so that it can be used
            playerHero:FindAbilityByName(spellToUse):UpgradeAbility()
            -- Get a reference to the ability that got moved to the second container
            local secondAbi = invokerEmpty2:GetContext("SpellInUse")
            -- Remmoved and added so that it can reset.  We are re-sending the upgrade callbacks so that they can match properly
            if secondAbi then 
                playerHero:RemoveAbility(secondAbi) 
                playerHero:AddAbility(secondAbi) 
                playerHero:FindAbilityByName(secondAbi):UpgradeAbility() 
            end
                   
          -- EXECUTES THE INVOKE ABILITY
          -- *********************************************************
          playerHero:FindAbilityByName("invoker_invoke"):CastAbility()  
          -- *********************************************************
          
          -- Removes the ability that got moved out of the containers
          if spellToRemove then 
              playerHero:RemoveAbility(spellToRemove)
          end
          
          -- Set up a think function so that we can call the upgrade callbacks on a subsequent loop
          -- This is because doing it on the same loop was not working.
          playerHero:SetThink("UpdateInvokeSpellLevels", self, 0.1)
          
          -- ==================================================================================== 
        end          
    end
end

-- Ogre Magi Unrefined Fireblast Item Confirmation Addition Thinker
function CheckForScepter(keys)

    local player = EntIndexToHScript(keys.caster_entindex)
    
    -- Stop thinker if the multicast ability is removed
    if player:HasAbility("ogre_magi_multicast") == false then
        return nil
    end
    
    local hasScepter = player:HasItemInInventory("item_ultimate_scepter")
    
    if hasScepter then
    
        local ability = player:FindAbilityByName("ogre_magi_unrefined_fireblast")
        
        if ability and ability:IsHidden() then
            
            ability:SetHidden(false)
            ability:UpgradeAbility()

            player:RemoveAbility("fusion_ogre_magi_unrefined_fireblast_listener")
            return nil
        end
    end
end


