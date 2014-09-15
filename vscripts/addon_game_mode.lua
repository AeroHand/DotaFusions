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
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_weaver.vsndevts", context ) -- 63
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_jakiro.vsndevts", context ) -- 64
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_batrider.vsndevts", context ) -- 65
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_chen.vsndevts", context ) -- 66
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_spectre.vsndevts", context ) -- 67
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_doombringer.vsndevts", context ) -- 68
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_ancient_apparition.vsndevts", context ) -- 69
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_ursa.vsndevts", context ) -- 70
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_spirit_breaker.vsndevts", context ) -- 71
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_gyrocopter.vsndevts", context ) -- 72
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_alchemist.vsndevts", context ) -- 73
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_invoker.vsndevts", context ) -- 74
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_silencer.vsndevts", context ) -- 75
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_obsidian_destroyer.vsndevts", context ) -- 76
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_lycan.vsndevts", context ) -- 77
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_brewmaster.vsndevts", context ) -- 78
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_shadow_demon.vsndevts", context ) -- 79
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_lone_druid.vsndevts", context ) -- 80
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_chaos_knight.vsndevts", context ) -- 81
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_meepo.vsndevts", context ) -- 82
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_treant.vsndevts", context ) -- 83
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_ogre_magi.vsndevts", context ) -- 84
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_undying.vsndevts", context ) -- 85
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_rubick.vsndevts", context ) -- 86
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_disruptor.vsndevts", context ) -- 87
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_nyx_assassin.vsndevts", context ) -- 88
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_naga_siren.vsndevts", context ) -- 89
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_keeper_of_the_light.vsndevts", context ) -- 90
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_wisp.vsndevts", context ) -- 91
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_visage.vsndevts", context ) -- 92
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_slark.vsndevts", context ) -- 93
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_medusa.vsndevts", context ) -- 94
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_troll_warlord.vsndevts", context ) -- 95
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_centaur.vsndevts", context ) -- 96
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_magnataur.vsndevts", context ) -- 97
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_shredder.vsndevts", context ) -- 98
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_bristleback.vsndevts", context ) -- 99
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_tusk.vsndevts", context ) -- 100
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_skywrath_mage.vsndevts", context ) -- 101
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_elder_titan.vsndevts", context ) -- 102
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_legion_commander.vsndevts", context ) -- 103
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_ember_spirit.vsndevts", context ) -- 104
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_earth_spirit.vsndevts", context ) -- 105
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_terrorblade.vsndevts", context ) -- 107
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_phoenix.vsndevts", context ) -- 108
    PrecacheResource( "soundfile", "soundevents/game_sounds_heroes/game_sounds_hero_oracle.vsndevts", context ) -- 109
    
    
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
  
  -- Add Event Handlers
  DotaFusionsEvents.AddEventHandlers(DotaFusions)
  
  -- Modify Base Classes
  CDOTAPlayer.df_fusionHero1 = nil
  
end

--------------------------------------------------------------------------------
-- MAIN THINK
--------------------------------------------------------------------------------
function DotaFusions:GameThink()

  return 0.25
  
end

--------------------------------------------------------------------------------
-- MAIN METHODS
--------------------------------------------------------------------------------

function DotaFusions:SetupFusion(localPlayer, fusionHero)
    
    local mainHero = localPlayer:GetAssignedHero()
    localPlayer.df_fusionHero1 = fusionHero
    
    

    print("Current Hero Fusion: ".. mainHero:GetUnitName() .. " | " .. fusionHero)
    
    heroAbilities = LoadKeyValues( "scripts/fusionKVs/heroAbilities.txt")
    
    if heroAbilities[mainHero:GetUnitName()] then
    
        tprint(heroAbilities)
      
    end
    

end


function tprint (tbl, indent)
  if not indent then indent = 0 end
  for k, v in pairs(tbl) do
    formatting = string.rep("  ", indent) .. k .. ": "
    if type(v) == "table" then
      print(formatting)
      tprint(v, indent+1)
    else
      print(formatting .. v)
    end
  end
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


