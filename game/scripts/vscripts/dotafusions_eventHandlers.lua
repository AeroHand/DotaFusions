
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
      function gMode:_PlayerChoseFusionHero(cmdName, hero1, playerID)
          
          -- Add fusion hero selection to player who called        
          local player =  PlayerResource:GetPlayer(tonumber(playerID))
          
          -- If player has not chosen a fusion hero and has already chosen his main hero then lets setup the fusion
          if gMode.fusionList[player:GetPlayerID()] == nil then
              
              gMode:SetupFusion(player, hero1)
          
          else
              print( "The player already has a fusion hero" )
          end      
      end
      
----------------------------------------------------------------------------------------------------------------------------      
--      
      function gMode:_PlayerSendFusionAbilityRequest(cmdName, playerID, ability1, ability2, ability3, ability4, ability5, ability6)
      
          -- Add fusion hero selection to player who called        
          local player =  PlayerResource:GetPlayer(tonumber(playerID))
          
          -- If player has chosen his/her fusion hero and also has an main hero assigned, then try to process ability request
          if gMode.fusionList[player:GetPlayerID()] ~= nil and player:GetAssignedHero() ~= nil then
              
              gMode:ProcessAbilityRequest(player, ability1, ability2, ability3, ability4, ability5, ability6)
          
          else
              print( "Player has not chosen a fusion hero. Can't process ability request")
          end  
      
      end   
      
----------------------------------------------------------------------------------------------------------------------------      
-- 

   function gMode:_PlayeSendHeroHero(cmdName, playerIDStr)
   
      print("Player Spawned")
      
      local playerID = tonumber(playerIDStr) 
      print("PLayer fusion hero test")
      print(gMode.fusionList[playerID])
      print(gMode.fusionList[0])
      print(gMode.fusionList[1])
      print(gMode.fusionList[2])
      print(gMode.fusionList[4])
      print(gMode.fusionList[5])
      
      if PlayerResource:GetPlayer(playerID):GetAssignedHero() == nil then return end
      
      local choseFusionHero = {   
          PrimaryHero = string.lower(PlayerResource:GetPlayer(playerID):GetAssignedHero():GetUnitName()),
          --FusionHero = string.lower(PlayerResource:GetPlayer(playerID - 1).df_fusionHero1),
          FusionHero = string.lower(gMode.fusionList[playerID]),
          
          PlayerID = playerID
        }
        
        print(choseFusionHero.PrimaryHero)
        print(choseFusionHero.FusionHero)
        print(choseFusionHero.PlayerID)
        
        FireGameEvent( "ChosenFusionHeroes", choseFusionHero )
         
      end  
      
----------------------------------------------------------------------------------------------------------------------------      
-- 

   function gMode:_EnableHiddenAbilitiesForSoloHeroes(cmdName, playerIDStr)
      
      local playerID = tonumber(playerIDStr) 
      local playerHero = PlayerResource:GetPlayer(playerID):GetAssignedHero()

      if playerHero == nil then 
      
          return 
      
      else
        
          if playerHero:GetUnitName() == "npc_dota_hero_meepo" then
            
              playerHero:AddAbility("fusion_divided_we_stand_hidden")
              
          elseif playerHero:GetUnitName() == "npc_dota_hero_ember_spirit" then
          
               playerHero:AddAbility("fusion_ember_spirit_fire_remnant")
               
          elseif playerHero:GetUnitName() == "npc_dota_hero_visage" then
          
               playerHero:AddAbility("fusion_visage_soul_assumption") 
          
          end
        
      end   
         
   end  

end
