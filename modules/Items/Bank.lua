local UUI = UUI

local print_message = UUI.print_message
local Items = UUI.Items

-- ESO API Locals
local GetItemType = GetItemType
local GetBagSize = GetBagSize
local CallSecureProtected = CallSecureProtected

--- Return the last empty slot index of the bagpack.
-- @param prevIndex number: The previous slot tested.
-- @param lastIndex number: The last index in the bagpack
-- @return number or nil: The index number matching ITEMTYPE_NONE or nothing.
local function find_empty_slot_in_bagpack(prevIndex, lastIndex)
    local slotIndex = prevIndex or -1
    while slotIndex < lastIndex do
        slotIndex = slotIndex + 1
        if GetItemType(BAG_BACKPACK, slotIndex) == ITEMTYPE_NONE then
            return slotIndex
        end
    end
    return nil
end

--- TODO: There is something to change here, but I don't know what yet.
-- ZO_SharedInventoryManager:GenerateFullSlotData(optFilterFunction, ...)
-- https://esoapi.uesp.net/current/src/ingame/inventory/sharedinventory.lua.html#337
function Items.WithdrawWristItems(eventCode, bankBag)
    if not Items.SV.itemWithdrawWristEnabled then return end

    local itemToTransfert = {
        ['Damage Health Poison IX'] = true,
        ['Damage Magicka Poison IX'] = true,
        ['Damage Stamina Poison IX'] = true,
        ['Drain Health Poison IX'] = true,
        ['Essence of Health'] = true,
        ['Essence of Magicka'] = true,
        ['Essence of Stamina'] = true,
        ['Essence of Ravage Health'] = true,
        ['Firsthold Fruit and Cheese Plate'] = true,
        ["Hagraven's Tonic"] = true,
        ['Hearty Garlic Corn Chowder'] = true,
        ['Lilmoth Garlic Hagfish'] = true,
        ['Markarth Mead'] = true,
        ["Muthsera's Remorse"] = true,
    }

    local bagSlots = GetBagSize(BAG_BACKPACK)
    for slotIndex = 0, bagSlots - 1 do
        local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
        if slotData and slotData.stackCount > 0 and slotData.name and LibUrilkUIData.wristItemsName[slotData.name] then
            itemToTransfert[slotData.name] = nil
        end
    end

    if itemToTransfert then
        local bagSlots = GetBagSize(BAG_BANK)
        local destSlot = find_empty_slot_in_bagpack(nil, bagSlots - 1)
        for slotIndex = 0, bagSlots - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BANK, slotIndex)

            if slotData and slotData.stackCount > 0 and slotData.name then
                if itemToTransfert[slotData.name] and destSlot then
                    CallSecureProtected('RequestMoveItem', BAG_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
                    itemToTransfert[slotData.name] = nil

                    destSlot = find_empty_slot_in_bagpack(destSlot, bagSlots - 1)
                end
            end
        end

        bagSlots = GetBagSize(BAG_SUBSCRIBER_BANK)
        destSlot = find_empty_slot_in_bagpack(nil, bagSlots - 1)
        for slotIndex = 0, bagSlots - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_SUBSCRIBER_BANK, slotIndex)

            if slotData and slotData.stackCount > 0 and slotData.name then
                if itemToTransfert[slotData.name] and destSlot then
                    CallSecureProtected('RequestMoveItem', BAG_SUBSCRIBER_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
                    itemToTransfert[slotData.name] = nil

                    destSlot = find_empty_slot_in_bagpack(destSlot, bagSlots - 1)
                end
            end
        end
    end
end