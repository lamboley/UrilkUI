local UUI = UUI

local PrintMessage = UUI.PrintMessage
local Items = UUI.Items

-- ESO API Locals
local CanItemBeMarkedAsJunk = CanItemBeMarkedAsJunk
local IsItemJunk = IsItemJunk
local SetItemIsJunk = SetItemIsJunk
local GetBagSize = GetBagSize
local GetItemType = GetItemType
local GetItemTrait = GetItemTrait

local function SetItemInBagAsJunk(slotIndex)
    if CanItemBeMarkedAsJunk(BAG_BACKPACK, slotIndex) and not IsItemJunk(BAG_BACKPACK, slotIndex) then
        SetItemIsJunk(BAG_BACKPACK, slotIndex, true)
    end
end

local function CustomJunk()
    if not Items.SV.junkEnabled then return end

    for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
        local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
        if slotData and slotData.stackCount > 0 and slotData.name then
            if LibUrilkUIData.customJunk[slotData.name] then
                SetItemInBagAsJunk(slotIndex) -- Is in custom List
            else
                local itemType = GetItemType(BAG_BACKPACK, slotIndex)
                if itemType then
                    if itemType == ITEMTYPE_WEAPON or itemType == ITEMTYPE_ARMOR then
                        local itemTrait = GetItemTrait(BAG_BACKPACK, slotIndex)
                        if itemTrait and (itemTrait == ITEM_TRAIT_TYPE_WEAPON_ORNATE or itemTrait == ITEM_TRAIT_TYPE_ARMOR_ORNATE or itemTrait == ITEM_TRAIT_TYPE_JEWELRY_ORNATE)  then
                            SetItemInBagAsJunk(slotIndex) -- Is an Ornate item
                        end
                    elseif (itemType == ITEMTYPE_TREASURE and Items.SV.treasureJunkEnabled) or itemType == ITEMTYPE_TRASH and Items.SV.trashJunkEnabled then
                        SetItemInBagAsJunk(slotIndex) -- Is a treasure or a trash
                    end
                end
            end
        end
    end
end

Items.CustomJunk = CustomJunk