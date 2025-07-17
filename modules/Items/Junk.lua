local UUI = UUI

local println = UUI.println
local Items = UUI.Items

-- ESO API Locals
local CanItemBeMarkedAsJunk = CanItemBeMarkedAsJunk
local IsItemJunk = IsItemJunk
local SetItemIsJunk = SetItemIsJunk
local GetBagSize = GetBagSize
local GetItemType = GetItemType
local GetItemTrait = GetItemTrait

local function setItemInBagAsJunk(slotIndex)
    if CanItemBeMarkedAsJunk(BAG_BACKPACK, slotIndex) and not IsItemJunk(BAG_BACKPACK, slotIndex) then
        SetItemIsJunk(BAG_BACKPACK, slotIndex, true)
    end
end

function Items.CustomJunk()
    local bagSlots = GetBagSize(BAG_BACKPACK)
    for slotIndex = 0, bagSlots - 1 do
        local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
        if slotData and slotData.stackCount > 0 and slotData.name then
            if LibUrilkUIData.customJunk[slotData.name] then
                setItemInBagAsJunk(slotIndex)
            else
                local itemType = GetItemType(BAG_BACKPACK, slotIndex)
                if itemType and (itemType == ITEMTYPE_WEAPON or itemType == ITEMTYPE_ARMOR) then
                    local itemTrait = GetItemTrait(BAG_BACKPACK, slotIndex)
                    if itemTrait and (itemTrait == ITEM_TRAIT_TYPE_WEAPON_ORNATE or itemTrait == ITEM_TRAIT_TYPE_ARMOR_ORNATE  or itemTrait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE)  then
                        setItemInBagAsJunk(slotIndex)
                    end
                end
            end
        end
    end
end