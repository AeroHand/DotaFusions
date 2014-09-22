--[[
========================================
Dota Fusions game mode by Carlos Giraldo.
========================================
]]

print( "Dota Fusions game mode loaded." )

-- Basically instantiates the game mode using the class as a base class
if DotaFusions == nil then
   DotaFusions = class({})  
end

require( "dotafusions_eventHandlers" )
require( "helpers" )



--------------------------------------------------------------------------------
-- PRECACHE
--------------------------------------------------------------------------------
function Precache( context )

    -- Load all models.  Used to make sure all models all loaded when using skills with models in their particles
    -- Note: I might get away with commenting this line since I'm not sure its fully necessary.
    PrecacheResource( "model_folder", "models/heroes/", context )
    -- Load all particles.  Used to make sure all the particles for the skills are loaded.  Because players can have skills from
    -- other heroes, its necessary to load them here.
    PrecacheResource( "particle_folder", "particles/units/heroes/", context )
    
    --PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context )
    --PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context )
    
   
  
    -- Have not found a more efficient or simpler way of making sure fused heroes play appropriate sounds.
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_antimage.vsndevts", context ) -- 1
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_abaddon.vsndevts", context ) -- 2
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context ) -- 3
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bane.vsndevts", context ) -- 4
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bloodseeker.vsndevts", context ) -- 5
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_crystalmaiden.vsndevts", context ) -- 6
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_drowranger.vsndevts", context ) -- 7
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earthshaker.vsndevts", context ) -- 8
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_juggernaut.vsndevts", context ) -- 9
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_mirana.vsndevts", context ) -- 10
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nevermore.vsndevts", context ) -- 11
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts", context ) -- 12
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_lancer.vsndevts", context ) -- 13
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context ) -- 14
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context ) -- 15
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_razor.vsndevts", context ) -- 16
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sandking.vsndevts", context ) -- 17
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_stormspirit.vsndevts", context ) -- 18
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context ) -- 19
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context ) -- 20
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_vengefulspirit.vsndevts", context ) -- 21
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_windrunner.vsndevts", context ) -- 22
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context ) -- 23
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_kunkka.vsndevts", context ) -- 24
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lina.vsndevts", context ) -- 25
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lich.vsndevts", context ) -- 26
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lion.vsndevts", context ) -- 27
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadowshaman.vsndevts", context ) -- 28
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context ) -- 29
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tidehunter.vsndevts", context ) -- 30
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_witchdoctor.vsndevts", context ) -- 31
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_riki.vsndevts", context ) -- 32
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enigma.vsndevts", context ) -- 33
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tinker.vsndevts", context ) -- 34
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_sniper.vsndevts", context ) -- 35
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_necrolyte.vsndevts", context ) -- 36
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_warlock.vsndevts", context ) -- 37
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_beastmaster.vsndevts", context ) -- 38
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_queenofpain.vsndevts", context ) -- 39
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_venomancer.vsndevts", context ) -- 40
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_faceless_void.vsndevts", context ) -- 41
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skeletonking.vsndevts", context ) -- 42
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_death_prophet.vsndevts", context ) -- 43
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phantom_assassin.vsndevts", context ) -- 44
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_pugna.vsndevts", context ) -- 45
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_templar_assassin.vsndevts", context ) -- 46
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_viper.vsndevts", context ) -- 47
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context ) -- 48
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context ) -- 49
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context ) -- 50
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rattletrap.vsndevts", context ) -- 51
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_leshrac.vsndevts", context ) -- 52
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_furion.vsndevts", context ) -- 53
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context ) -- 54
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_dark_seer.vsndevts", context ) -- 55
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_clinkz.vsndevts", context ) -- 56
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context ) -- 57
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_enchantress.vsndevts", context ) -- 58
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_huskar.vsndevts", context ) -- 59
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nightstalker.vsndevts", context ) -- 60
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_broodmother.vsndevts", context ) -- 61
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context ) -- 62
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_weaver.vsndevts", context ) -- 63
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context ) -- 64
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_batrider.vsndevts", context ) -- 65
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chen.vsndevts", context ) -- 66
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spectre.vsndevts", context ) -- 67
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context ) -- 68
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ancient_apparition.vsndevts", context ) -- 69
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ursa.vsndevts", context ) -- 70
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_spirit_breaker.vsndevts", context ) -- 71
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context ) -- 72
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_alchemist.vsndevts", context ) -- 73
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context ) -- 74
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_silencer.vsndevts", context ) -- 75
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_obsidian_destroyer.vsndevts", context ) -- 76
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lycan.vsndevts", context ) -- 77
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_brewmaster.vsndevts", context ) -- 78
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shadow_demon.vsndevts", context ) -- 79
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_lone_druid.vsndevts", context ) -- 80
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context ) -- 81
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_meepo.vsndevts", context ) -- 82
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_treant.vsndevts", context ) -- 83
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context ) -- 84
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_undying.vsndevts", context ) -- 85
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_rubick.vsndevts", context ) -- 86
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_disruptor.vsndevts", context ) -- 87
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_nyx_assassin.vsndevts", context ) -- 88
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context ) -- 89
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_keeper_of_the_light.vsndevts", context ) -- 90
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_wisp.vsndevts", context ) -- 91
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_visage.vsndevts", context ) -- 92
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_slark.vsndevts", context ) -- 93
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_medusa.vsndevts", context ) -- 94
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_troll_warlord.vsndevts", context ) -- 95
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context ) -- 96
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context ) -- 97
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_shredder.vsndevts", context ) -- 98
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_bristleback.vsndevts", context ) -- 99
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_tusk.vsndevts", context ) -- 100
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_skywrath_mage.vsndevts", context ) -- 101
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_elder_titan.vsndevts", context ) -- 102
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_legion_commander.vsndevts", context ) -- 103
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context ) -- 104
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_earth_spirit.vsndevts", context ) -- 105
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_terrorblade.vsndevts", context ) -- 107
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_phoenix.vsndevts", context ) -- 108
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_oracle.vsndevts", context ) -- 109
    
end

--------------------------------------------------------------------------------
-- ACTIVATE
--------------------------------------------------------------------------------
function Activate()

    GameRules.DotaPvP_F = DotaFusions()
    GameRules.DotaPvP_F:InitGameMode()
    
end

--------------------------------------------------------------------------------
-- INIT
--------------------------------------------------------------------------------
function DotaFusions:InitGameMode()

  local GameMode = GameRules:GetGameModeEntity()

  -- Enable the standard Dota PvP game rules
  GameRules:GetGameModeEntity():SetTowerBackdoorProtectionEnabled( true )

  -- Register Think
  GameMode:SetContextThink( "DotaPvP:GameThink", function() return self:GameThink() end, 0.25 )

  -- Register Game Events  
  Convars:RegisterCommand( "PlayerChoseFusionHero", function(...) return self:_PlayerChoseFusionHero( ... ) end, "Player has selected fusion hero", 0 )
  Convars:RegisterCommand( "PlayerSendFusionAbilityRequest", function(...) return self:_PlayerSendFusionAbilityRequest( ... ) end, "Player has sent a fusion ability request", 0 )
  
  
  
  -- Add Event Handlers
  DotaFusionsEvents.AddEventHandlers(DotaFusions)
  
  -- Modify Base Classes
  CDOTAPlayer.df_fusionHero1 = nil
  
end

replacedPlayerHero = true

--------------------------------------------------------------------------------
-- MAIN THINK
--------------------------------------------------------------------------------
function DotaFusions:GameThink()

    if GameRules:GetGameTime() > 10 and replacedPlayerHero then
    
         Msg("Pizza Time!")
         
       
         hero = PlayerResource:GetPlayer(0):GetAssignedHero()
   
         
         replacedPlayerHero = false
         
         PlayerResource:GetPlayer(0):GetAssignedHero():AddExperience(100000, false)
     
     end

  return 0.25
  
end

--------------------------------------------------------------------------------
-- MAIN METHODS
--------------------------------------------------------------------------------

function DotaFusions:SetupFusion(localPlayer, fusionHero)
    
    -- Get Main Hero
    local mainHero = localPlayer:GetAssignedHero()
    -- Set the Fusion Hero
    localPlayer.df_fusionHero1 = fusionHero
    -- Load the KV file
    heroAbilities = LoadKeyValues( "scripts/fusionKVs/heroAbilities.txt")
    -- If the fusion hero is valid then continue.  Else then set it to nil
    if heroAbilities[fusionHero] then   
        print("Player has selected valid fusion hero: " .. fusionHero)
    else
        print("Player has not selected valid fusion hero: " .. fusionHero)
        localPlayer.df_fusionHero1 = nil
    end
    
end

function DotaFusions:ProcessAbilityRequest(localPlayer, ability1, ability2, ability3, ability4, ability5, ability6)

    -- Get the Main Hero
    local mainHero = localPlayer:GetAssignedHero()
    -- Get the fusion Hero
    local fusionHero = localPlayer.df_fusionHero1
    
    
    -- Check if hero is in fountain aura
    if mainHero:HasModifier("modifier_fountain_aura_buff") == false then print("Not in Fountain") return end
    -- Load Hero Abilities KV file
    local heroAbilities = LoadKeyValues( "scripts/fusionKVs/heroAbilities.txt")
    
    local validAbis = {}
    local abiTable = {}
    
    local counter = 0   
    
    print(ability1)
    print(ability2)
    print(ability3)
    print(ability4)
    print(ability5)
    print(ability6)
    
    -- If the passed in ability is not nil, then add it to a table to later process
    if ability1 then counter = counter + 1; validAbis[counter] = ability1;  end
    if ability2 then counter = counter + 1; validAbis[counter] = ability2;  end
    if ability3 then counter = counter + 1; validAbis[counter] = ability3;  end
    if ability4 then counter = counter + 1; validAbis[counter] = ability4;  end
    if ability5 then counter = counter + 1; validAbis[counter] = ability5;  end
    if ability6 then counter = counter + 1; validAbis[counter] = ability6;  end
    
    print(counter)
    
    -- Get the ability info stored in the KV file
    for i = 1, counter do  
 
        -- Checks to see if the abilities belong to either fusion or main hero
        local abi, info = GetAbilityInfo(validAbis[i], heroAbilities, mainHero:GetUnitName(), fusionHero)    
        abiTable[i] = {name = abi, content = info}       
    
    end

    -- Check to see if there are any abilities that are invalid.  If there are, then stop
    for i, v in ipairs(abiTable) do
    
        if v.name == nil then print("Invalid ability fusion: Offending ability = " .. v.content); return end
    
    end
        
    -- Verify abilities who have special requirements.  Make sure they are valid, if not then stop
    if CheckForRequiredOptionalsAndIndexAbilities(abiTable) then print("missing abilities") return end
    -- Cleares the current Hero abilties.
    ClearCurrentHeroAbilities(mainHero)
    -- Process and add all abilities in the ability table
    for i, v in ipairs(abiTable) do   
        ProcessAbilityIntoHero(i, v, mainHero)  
    end    
    
    -- If there is space available, add attribute bonus
    AddAttributeBonusIfAble(mainHero)
    
  
end

function GetAbilityInfo(ability, kvTable, ...)
    
    -- For every hero passed
    for k,v in orderedPairs{...} do    
       
        -- If the ability name exists in the KV table for the specific hero, then return its info
        if kvTable[v][ability] then       
            return ability, kvTable[v][ability]     
        end   
        
    end
    -- If it doesn't exists, then return nil for its name and for its content, the ability name
    return nil, ability

end

function ProcessAbilityIntoHero(abilityIndex, abilityInfo, hero)
   
   -- Adds the ability to the hero
   hero:AddAbility(abilityInfo.name)
    
    -- If the content of the ability info is a table, then lets add other abilities
    if type(abilityInfo.content) == "table" then

        for k,v in pairs(abilityInfo.content) do
       
            if k == "PairedWithHidden" then
        
                AddAbilities(v, hero)
        
            end      
        end     
    end
end

function AddAbilities(table, hero)

    -- For each ability in the table passed, add it to the hero if it doesn't have it already
    for k,v in orderedPairs(table) do 
        
        if hero:HasAbility(k) == false then
        
            hero:AddAbility(k)           
        end
    end
end

function AddAttributeBonusIfAble(hero)

    for i = 0, 12 do              
            currentAbi = hero:GetAbilityByIndex(i)   
            if currentAbi == nil then hero:AddAbility("attribute_bonus") return end
    end
end

function ClearCurrentHeroAbilities(hero)

    --[[
    
    print("Current Hero abilities before reset")
    

    for i = 0, 15 do       
        currentAbi = hero:GetAbilityByIndex(i)       
        
        if currentAbi then                   
            print(currentAbi:GetAbilityName() .. " :" .. i)            
        else
            print("nil :" .. i)
        end
    end
    ]]

    -- For each index not currently occupied by the special hidden abilities
    for i = 0, 12 do   
           
        currentAbi = hero:GetAbilityByIndex(i)   
        -- If the current index isn't null, then check to see it isn't one of the special abilities
        if currentAbi then
            
            if currentAbi:GetAbilityName() == "visage_soul_assumption" then           
  
            elseif currentAbi:GetAbilityName() == "ember_spirit_fire_remnant" then            
            
            elseif currentAbi:GetAbilityName() == "meepo_divided_we_stand" then            

            else
                             
                hero:RemoveAbility(currentAbi:GetAbilityName())  
            
            end
        end
    end
    
    --[[
    print("Current Hero abilities after reset")
    
       for i = 0, 15 do      
        currentAbi = hero:GetAbilityByIndex(i)       
        if currentAbi then
            print(currentAbi:GetAbilityName())  
        else
            print("nil")
        end
    end
    ]]
    
    -- Reset players ability points
    local currentLevel = hero:GetLevel()
    hero:SetAbilityPoints(currentLevel)
    
end

function CheckForRequiredOptionalsAndIndexAbilities(abilityTable)

    requiredMissing = {}
    requiredOptionalsMissing = {}
    pairedIndexMissing = {}
    -- Return value
    returnFailure = false

    -- Make sure the passed ability table is not nil
    if abilityTable == nil then print("ability table is nil") return true end

    -- Iterate through all abilities
    for i, v in ipairs(abilityTable) do
    
        -- If the ability info (v) is a table then check table key
        if type(v.content) == "table" then
        
            -- Iterate through all keys in the table, checking for Required, RequiredOptionals, and PairedWithIndexSpecific
            for key,value in pairs(v.content) do
           
                if key == "Required" then
            
                    for rKey, rValue in pairs(value) do                  
                        if abilityTable[rKey] == false then table.insert(requiredMissing, rKey); returnFailure = true;  end                   
                    end
                    
                elseif key == "RequiredOptionals" then   
                
                 local foundAtLeastOne = false
                           
                    for rKey, rValue in pairs(value) do                 
                        if abilityTable[rKey] == false then table.insert(requiredOptionalsMissing, rKey) else foundAtLeastOne = true  end                    
                    end
                    
                    if foundAtLeastOne == false then returnFailure = true end
                    
                elseif key == "PairedWithIndexSpecific" then                   
                
                     local counter = 1
                     local missingIndex = false
 
                     -- For ability index pair 
                     for rKey, rValue in pairs(value) do
                    
                        -- Check against every ability in the ability table passed
                        for iIndex, iValue in ipairs(abilityTable) do
                        
                            -- If the matching index doesn't match with the name
                            if counter == tonumber(rKey) then print("Found Matching key") if iValue.name ~= rValue then table.insert(pairedIndexMissing, rValue); print("Index Mismatch")  returnFailure = true; end end
                        
                            counter = counter + 1
                        end
                        
                        -- If we simply don't have the index filled up with anything
                        if tonumber(rKey) > counter then
                        
                            returnFailure = true
                            print("Could not find ability: " .. rValue .. " at index" .. rKey)
                            table.insert(pairedIndexMissing, rValue)
                        
                        end
                        
                        counter = 1
                    
                    end                                
                end      
            end     
        end  
    end
    
    -- Error Messages
    if returnFailure then
    
        print("Required Missing: ")
        tprint(requiredMissing)
        
        print("Required Optionals Missing: ")
        tprint(requiredOptionalsMissing)
        
        print("Paired With Index Specific Missing: ")
        tprint(pairedIndexMissing)
    
    end
    
    return returnFailure
    
end

function AbilityTableContains(ability, table)

    for k, v in pairs(table) do
    
      if k == ability then return true end
        
    end
    
    return false

end

--------------------------------------------------------------------------------
-- ABILITY SPECIAL CASE METHODS
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-- Invoker ---------------------------------------------------------------------
--------------------------------------------------------------------------------
function CountNumOfModsAndRemoveThem(player, modifierName)
  
    local count = 0
     
    for i = 0, 20 do
    
        local mod = player:GetModifierNameByIndex(i)
        
        if mod == modifierName then    
            count = count + 1
        end
    end
    
    return count
end

function ChooseInvokerSpellBasedOnInstanceCalc(instCalc)
    
    local spellName = nil

    -- Quas / Quas / Quas
    if instCalc == 3 then  
        spellName = "invoker_cold_snap"
    --  Quas / Quas / Wex
    elseif instCalc == 12 then
        spellName = "invoker_ghost_walk"
    -- Quas / Wex / Wex 
    elseif instCalc == 21 then
        spellName = "invoker_tornado"
    -- Wex / Wex / Wex
    elseif instCalc ==30 then
        spellName = "invoker_emp"
    -- Quas / Quas / Exort
    elseif instCalc == 102 then
        spellName = "invoker_ice_wall"
    -- Quas / Wex / Exort
    elseif instCalc == 111 then
        spellName = "invoker_deafening_blast"
    -- Wex / Wex / Exort
    elseif instCalc == 120 then
        spellName = "invoker_alacrity"
    -- Quas / Exort / Exort
    elseif instCalc == 201 then
        spellName = "invoker_forge_spirit"
    -- Wex / Exort / Exort
    elseif instCalc == 210 then
        spellName = "invoker_chaos_meteor"
    -- Exort / Exort / Exort
    elseif instCalc == 300 then
        spellName = "invoker_sun_strike"
    end
    
    return spellName 
end

function UpdateInvokeSpellLevels(self)

    local playerHero = self 
    
    local quas = playerHero:FindAbilityByName("invoker_quas")
    local exort = playerHero:FindAbilityByName("invoker_exort")
    local wex = playerHero:FindAbilityByName("invoker_wex")
    
    if quas then for i = 1, quas:GetLevel() do quas:OnUpgrade() end end
    if exort then for i = 1, exort:GetLevel() do exort:OnUpgrade() end end
    if wex then for i = 1, wex:GetLevel() do wex:OnUpgrade() end end

    return nil
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
    local quasCount = CountNumOfModsAndRemoveThem(playerHero, "modifier_invoker_quas_instance")
    local wexCount = CountNumOfModsAndRemoveThem(playerHero, "modifier_invoker_wex_instance") * 10
    local exortCount = CountNumOfModsAndRemoveThem(playerHero, "modifier_invoker_exort_instance") * 100
    
    -- Using the counts, find out the ability we are supposed to add
    spellToUse = ChooseInvokerSpellBasedOnInstanceCalc(quasCount + wexCount + exortCount)
 
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







