local UUI = UUI

-----------------------------------------------------------------------------
-- ESO API Locals
local eventManager = GetEventManager()
local GetUnitClassId = GetUnitClassId

local Auras = {}
Auras.moduleName = UUI.name .. 'Auras'
Auras.SV = {}
Auras.Defaults = {
    -- _Crux
    hideNotInCombat = true,

    -- _FoodBuff
    autoFoodName = 'Dubious Camoran Throne',
}

local function LoadSavedVars()
    Auras.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Auras', Auras.Defaults)
end

local function Initialize()
    LoadSavedVars()

    if GetUnitClassId('player') == 117 then
        Auras.CreateCruxTexture()

        eventManager:RegisterForEvent(Auras.moduleName, EVENT_EFFECT_CHANGED, Auras.OnEffectChangedCruxStack)
        eventManager:AddFilterForEvent(Auras.moduleName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, 184220)
        eventManager:AddFilterForEvent(Auras.moduleName, EVENT_EFFECT_CHANGED, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)
        eventManager:RegisterForUpdate(Auras.moduleName .. 'OnUpdate', 100, Auras.OnUpdate)
    end

    eventManager:RegisterForUpdate(Auras.moduleName .. 'FoodBuff', 60000, Auras.FoodBuff)
end

Auras.Initialize = Initialize
UUI.Auras = Auras