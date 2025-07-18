local UUI = UUI

local print_message = UUI.print_message
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

function Items.FoodBuff()
	if IsUnitInCombat(unitTag) then return end

    local isBuffPresent = false

    for i = 1, GetNumBuffs(unitTag) do
        local _, _, _, _, _, _, _, _, _, _, abilityId = GetUnitBuffInfo(unitTag, i)
        if abilityId and foodAbilityID[abilityId] then
            isBuffPresent = true
        end
    end

    if not isBuffPresent then
        local bagSlots = GetBagSize(BAG_BACKPACK)
        for slotIndex = 0, bagSlots - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
            if slotData and slotData.stackCount > 0 and slotData.name and slotData.name == foodAbilityID[tonumber(Items.SV.foodToConsumme)] and IsItemUsable(BAG_BACKPACK, slotIndex) then
                CallSecureProtected('UseItem', BAG_BACKPACK, slotIndex)
                print_message('Consumme '..slotData.name)
                return
            end
        end
    end
end