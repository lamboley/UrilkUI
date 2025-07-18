local UUI = UUI

local print_message = UUI.print_message
local Items = UUI.Items

-- ESO API Locals
local CanItemBeMarkedAsJunk = CanItemBeMarkedAsJunk
local IsItemJunk = IsItemJunk
local SetItemIsJunk = SetItemIsJunk
local GetBagSize = GetBagSize
local GetItemType = GetItemType
local GetItemTrait = GetItemTrait

local function set_item_in_bag_as_junk(slotIndex)
    if CanItemBeMarkedAsJunk(BAG_BACKPACK, slotIndex) and not IsItemJunk(BAG_BACKPACK, slotIndex) then
        SetItemIsJunk(BAG_BACKPACK, slotIndex, true)
    end
end

function Items.CustomJunk()
    if not Items.SV.junkEnabled then return end

    for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
        local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
        if slotData and slotData.stackCount > 0 and slotData.name then
            if LibUrilkUIData.customJunk[slotData.name] then
                set_item_in_bag_as_junk(slotIndex) -- Is in custom List
            else
                local itemType = GetItemType(BAG_BACKPACK, slotIndex)
                if itemType then
                    if itemType == ITEMTYPE_WEAPON or itemType == ITEMTYPE_ARMOR then
                        local itemTrait = GetItemTrait(BAG_BACKPACK, slotIndex)
                        if itemTrait and (itemTrait == ITEM_TRAIT_TYPE_WEAPON_ORNATE or itemTrait == ITEM_TRAIT_TYPE_ARMOR_ORNATE or itemTrait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE)  then
                            set_item_in_bag_as_junk(slotIndex) -- Is an Ornate item
                        end
                    elseif (itemType == ITEMTYPE_TREASURE and Items.SV.treasureJunkEnabled) or itemType == ITEMTYPE_TRASH and Items.SV.trashJunkEnabled then
                        set_item_in_bag_as_junk(slotIndex) -- Is a treasure or a trash
                    end
                end
            end
        end
    end
end