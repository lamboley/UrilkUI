---@class UrilkUI
local UrilkUI = UrilkUI

local GetSlotIndexFromNameInBackpack = UrilkUI.GetSlotIndexFromNameInBackpack
local CallUseItem = UrilkUI.CallUseItem

-- Lua APIs
local select = select

-- ESO APIs
local eventManager = GetEventManager()

local moduleName = UrilkUI.name .. 'Auras'

---@class UrilkUI.Auras
local Auras = {}
Auras.__index = Auras
UrilkUI.Auras = Auras

Auras.Defaults = {
    -- _Crux
    hideNotInCombat = true,

    -- _FoodBuff
    autoFoodName = 'Dubious Camoran Throne',
}

Auras.SV = {}
Auras.moduleName = moduleName

local unitTag = 'player'



local function RefreshFoodBuff()
    if IsUnitInCombat(unitTag) then return end

    local desiredBuffId = LibUrilkUIData.buffInfo[Auras.SV.autoFoodName]
    if desiredBuffId then
        local isBuffPresent = false

        for i=1, GetNumBuffs(unitTag) do
            local buffId = select(11, GetUnitBuffInfo(unitTag, i))
            if buffId and buffId == desiredBuffId then
                isBuffPresent = true
            end
        end

        if not isBuffPresent then
            local slotIndex = GetSlotIndexFromNameInBackpack(Auras.SV.autoFoodName)
            if slotIndex and IsItemUsable(BAG_BACKPACK, slotIndex) then
                CallUseItem(BAG_BACKPACK, slotIndex)
            end
        end
    end
end

local function LoadSavedVars()
    Auras.SV = ZO_SavedVars:NewAccountWide(UrilkUI.SVName, UrilkUI.SVVer, 'Auras', Auras.Defaults)
end

local function RegisterEvents()
    eventManager:RegisterForUpdate(moduleName .. 'FoodBuff', 60000, RefreshFoodBuff)
end

function Auras.Initialize(enabled)
    LoadSavedVars()

    if enabled then
        Auras.CreateCruxTexture()
        RegisterEvents()
    end
end