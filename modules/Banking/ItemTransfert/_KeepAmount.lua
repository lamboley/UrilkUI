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

---Return a table with all the desired items
---@return table
local function GenerateKeepTable()
    return {
        ['Soul Gem'] = true,
        ['Lockpick'] = true,
        ['Equipment Repair Kit'] = true,
        ['Dubious Camoran Throne'] = true,
    }
end

local function GetBackpackComparator()
    return function(itemData)
        if itemData and LibUrilkUIData.keepItemsId[GetItemId(itemData.bagId, itemData.slotIndex)] then
            return true
        end
        return false
    end
end

local function GetBankComparator()
    return function(itemData)
        if itemData and LibUrilkUIData.keepItemsId[GetItemId(itemData.bagId, itemData.slotIndex)] and itemData.stackCount > 50 then
            return true
        end
        return false
    end
end

function Banking.KeepAmount()
    local itemsNotPresent = GenerateKeepTable()
    local itemsAlreadyPresent = {}

    for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(GetBackpackComparator(), BAG_BACKPACK)) do
        itemsNotPresent[slotData.name] = nil
        itemsAlreadyPresent[slotData.name] = true
    end

    if next(itemsNotPresent) ~= nil then
        local itemsBankDataCleaned = {}
        local removeDuplicate = {}

        for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(GetBankComparator(), BAG_BANK, BAG_SUBSCRIBER_BANK)) do
            if not itemsAlreadyPresent[slotData.name] and not removeDuplicate[slotData.name] then
                table_insert(itemsBankDataCleaned, slotData)
                removeDuplicate[slotData.name] = true
            end
        end

        if next(itemsBankDataCleaned) ~= nil then
            Banking.MoveItemOneWay(itemsBankDataCleaned, 1, 50)
        end
    end
end