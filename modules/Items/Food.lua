local UUI = UUI

local println = UUI.println
local Items = UUI.Items

-- ESO API Locals
local IsUnitInCombat = IsUnitInCombat
local GetNumBuffs = GetNumBuffs
local GetBagSize= GetBagSize
local IsItemUsable = IsItemUsable

-- TODO: There is probably a better way to do that.
local foodAbilityID = {
    [61255] = 'Braised Rabbit with Spring Vegetables',
    -- 61255 = "Orzorga's Tripe Trifle Pocket",
}

local unitTag = 'player'
function Items.FoodBuff()
	if IsUnitInCombat(unitTag) or Items.SV.foodToConsumme == nil or Items.SV.foodToConsumme == '' then
        return
    end

    local isBuffPresent = false
    
    for i = 1, GetNumBuffs(unitTag) do
        local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, deprecatedBuffType, effectType, abilityType, statusEffectType, abilityId, _, castByPlayer = GetUnitBuffInfo(unitTag, i)
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
                println('Eating', slotData.name)
                return
            end
	    end
    end
end