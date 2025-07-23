local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local Items = UUI.Items

-----------------------------------------------------------------------------
-- ESO API Locals
local GetBagSize = GetBagSize
local CanItemBeMarkedAsJunk = CanItemBeMarkedAsJunk
local IsItemJunk, SetItemIsJunk = IsItemJunk, SetItemIsJunk
local GetItemTrait, GetItemLink, GetItemType = GetItemTrait, GetItemLink, GetItemType
local HasAnyJunk, SellAllJunk = HasAnyJunk, SellAllJunk

local function OpenStore()
    if HasAnyJunk(BAG_BACKPACK, true) then
        SellAllJunk()
        PrintMessage('Sold all junk.')
    end
end

local function SetItemInBagAsJunk(slotIndex)
    if CanItemBeMarkedAsJunk(BAG_BACKPACK, slotIndex) and not IsItemJunk(BAG_BACKPACK, slotIndex) then
        SetItemIsJunk(BAG_BACKPACK, slotIndex, true)
        PrintMessage('Marked ' .. GetItemLink(BAG_BACKPACK, slotIndex) .. ' as junk')
    end
end

local function JunkHandler()
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
                    elseif (itemType == ITEMTYPE_TREASURE and Items.SV.autoSetTreasureAsJunk) or (itemType == ITEMTYPE_TRASH and Items.SV.autoSetTrashAsJunk) then
                        SetItemInBagAsJunk(slotIndex) -- Is a treasure or a trash
                    end
                end
            end
        end
    end
end

Items.JunkHandler = JunkHandler
Items.OpenStore = OpenStore