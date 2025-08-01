---@class (partial) UrilkUI
local UrilkUI = UrilkUI

---@class (partial) UrilkUI.Banking
local Banking = UrilkUI.Banking

-- Lua APIs
local table_insert = table.insert
local pairs = pairs
local next = next

-- ESO APIs
local GetItemId = GetItemId

local function GetComparator()
    return function(itemData)
        if itemData and LibUrilkUIData.wristItemsId[GetItemId(itemData.bagId, itemData.slotIndex)] then
            return true
        end
        return false
    end
end

---Return a table with all required wrist items at level 50
---@return table
local function GenerateWristItemsTable()
    return {
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
end

function Banking.WithdrawWrist()
    local wristNotPresent = GenerateWristItemsTable()
    local comparator = GetComparator()
    local wristAlreadyPresent = {}

    for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(comparator, BAG_BACKPACK)) do
        wristNotPresent[slotData.name] = nil
        wristAlreadyPresent[slotData.name] = true
    end

    if next(wristNotPresent) ~= nil then
        local wristBankDataCleaned = {}
        local removeDuplicate = {}

        for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(comparator, BAG_BANK, BAG_SUBSCRIBER_BANK)) do
            if not wristAlreadyPresent[slotData.name] and not removeDuplicate[slotData.name] then
                table_insert(wristBankDataCleaned, slotData)
                removeDuplicate[slotData.name] = true
            end
        end

        if next(wristBankDataCleaned) ~= nil then
            Banking.MoveItemOneWay(wristBankDataCleaned, 1, 1)
        end
    end
end