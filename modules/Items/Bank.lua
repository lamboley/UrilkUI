local UUI = UUI

local println = UUI.println
local Items = UUI.Items

-- ESO API Locals
local GetItemType = GetItemType
local GetBagSize = GetBagSize

local function findEmptySlotInBagpack(prevIndex, lastIndex)
    local slotIndex = prevIndex or -1
    while slotIndex < lastIndex do
        slotIndex = slotIndex + 1
        if GetItemType(BAG_BACKPACK, slotIndex) == ITEMTYPE_NONE then
            return slotIndex
        end
    end
    return nil
end

function Items.OpenBank(eventCode, bankBag)
    if Items.SV.itemWithdrawWristEnabled then
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

        --TODO: Improve this parts
        -- ZO_SharedInventoryManager:GenerateFullSlotData(optFilterFunction, ...)
        -- https://esoapi.uesp.net/current/src/ingame/inventory/sharedinventory.lua.html#337
        if itemToTransfert then
            local bagSlots = GetBagSize(BAG_BANK)
            local destSlot = findEmptySlotInBagpack(nil, bagSlots - 1)
            for slotIndex = 0, bagSlots - 1 do
                local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BANK, slotIndex)

                if slotData and slotData.stackCount > 0 and slotData.name then
                    if itemToTransfert[slotData.name] and destSlot then
                        CallSecureProtected('RequestMoveItem', BAG_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
                        println('TransfertBAG_BANK', slotData.name)
                        itemToTransfert[slotData.name] = nil

                        destSlot = findEmptySlotInBagpack(destSlot, bagSlots - 1)
                    end
                end
            end

            bagSlots = GetBagSize(BAG_SUBSCRIBER_BANK)
            destSlot = findEmptySlotInBagpack(nil, bagSlots - 1)
            for slotIndex = 0, bagSlots - 1 do
                local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_SUBSCRIBER_BANK, slotIndex)

                if slotData and slotData.stackCount > 0 and slotData.name then
                    if itemToTransfert[slotData.name] and destSlot then
                        CallSecureProtected('RequestMoveItem', BAG_SUBSCRIBER_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
                        println('TransfertBAG_SUBSCRIBER_BANK', slotData.name)
                        itemToTransfert[slotData.name] = nil

                        destSlot = findEmptySlotInBagpack(destSlot, bagSlots - 1)
                    end
                end
            end
        end
    end
end