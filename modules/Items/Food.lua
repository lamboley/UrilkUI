local UUI = UUI

local PrintMessage = UUI.PrintMessage
local Items = UUI.Items

-- Lua Locals
local tonumber = tonumber

-- ESO API Locals
local IsUnitInCombat = IsUnitInCombat
local GetNumBuffs = GetNumBuffs
local GetUnitBuffInfo = GetUnitBuffInfo
local GetBagSize= GetBagSize
local IsItemUsable = IsItemUsable
local CallSecureProtected = CallSecureProtected

--- TODO: Find a way to use the name of the buff in the setting.
local foodAbilityID = {
    [61255] = 'Braised Rabbit with Spring Vegetables',
    -- [61255] = "Orzorga's Tripe Trifle Pocket",
}

local unitTag = 'player'

local function FoodBuff()
	if IsUnitInCombat(unitTag) then return end

    local isBuffPresent = false

    for i = 1, GetNumBuffs(unitTag) do
        local _, _, _, _, _, _, _, _, _, _, abilityId = GetUnitBuffInfo(unitTag, i)
        if abilityId and foodAbilityID[abilityId] then
            isBuffPresent = true
        end
    end

    if not isBuffPresent then
        for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
            if slotData and slotData.stackCount > 0 and slotData.name and slotData.name == foodAbilityID[tonumber(Items.SV.foodToConsumme)] and IsItemUsable(BAG_BACKPACK, slotIndex) then
                CallSecureProtected('UseItem', BAG_BACKPACK, slotIndex)
                PrintMessage('Consumme '..slotData.name)
                return
            end
        end
    end
end

Items.FoodBuff = FoodBuff