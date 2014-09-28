
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
--
      function gMode:_PlayerChoseFusionHero(cmdName, hero1, hero2)
          
          -- Add fusion hero selection to player who called        
          local player = Convars:GetDOTACommandClient()
          
          -- If player has not chosen a fusion hero and has already chosen his main hero then lets setup the fusion
          if player.df_fusionHero1 == nil then
              
              gMode:SetupFusion(player, hero1, hero2)
          
          else
              print( "The player already has a fusion hero" )
          end      
      end
      
----------------------------------------------------------------------------------------------------------------------------      
--      
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
