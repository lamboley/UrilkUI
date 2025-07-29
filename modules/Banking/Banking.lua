---@class (partial) UrilkUI
local UrilkUI = UrilkUI

local CallRequestMoveItem = UrilkUI.CallRequestMoveItem
local PrintMessage = UrilkUI.PrintMessage

-- Lua APIs
local string_format = string.format
local table_insert = table.insert
local next = next
local pairs = pairs

-- ESO APIs
local eventManager = GetEventManager()

local moduleName = UrilkUI.name .. 'Banking'

---@class (partial) UrilkUI.Banking
local Banking = {}
Banking.__index = Banking
UrilkUI.Banking = Banking

Banking.Defaults = {
    --- _Bank
    autoCurrencyTransfert = true,
    amountGoldInInventory = 250,
    amountAlliancePointsInInventory = 0,
    amountTelvarInInventory = 0,
    amountWritInInventory = 0,
    autoWithdrawWristItems = true,
    autoStackBag = true,
}

Banking.SV = {}
Banking.moduleName = moduleName

local function CreateWristComparator()
    return function(itemData)
        if itemData and LibUrilkUIData.wristItemsName[itemData.name] then
            return true
        end
        return false
    end
end

local function CreateUselessComparator()
    return function(itemData)
        if itemData then
            if itemData.itemType == ITEMTYPE_GLYPH_ARMOR or itemData.itemType == ITEMTYPE_GLYPH_JEWELRY or itemData.itemType == ITEMTYPE_GLYPH_WEAPON or itemData.itemType == ITEMTYPE_WEAPON or itemData.itemType == ITEMTYPE_ARMOR or itemData.itemType == ITEMTYPE_JEWELRY then
                return true
            end
        end
        return false
    end
end

local function CreateKeepComparator()
    return function(itemData)
        if itemData then
            if (itemData.name == 'Soul Gem' and itemData.stackCount > 50) or (itemData.name == 'Lockpick' and itemData.stackCount > 50) or (itemData.name == 'Equipment Repair Kit' and itemData.stackCount > 50)then
                return true
            end
        end
        return false
    end
end

local function ExecuteTransfert(cacheBank, startIndex, stack, toKeep)
    local itemData = cacheBank[startIndex]
    if not itemData.bagId then return end

    local targetBagId, firstEmptySlot, toMove, didItSucced

    if itemData.bagId == BAG_BACKPACK then
        targetBagId = BAG_BANK
        firstEmptySlot = FindFirstEmptySlotInBag(targetBagId)
        if firstEmptySlot == nil and IsESOPlusSubscriber() then
            targetBagId = BAG_SUBSCRIBER_BANK
            firstEmptySlot = FindFirstEmptySlotInBag(targetBagId)
        end
    elseif itemData.bagId == BAG_BANK or (itemData.bagId == BAG_SUBSCRIBER_BANK and IsESOPlusSubscriber()) then
        targetBagId = BAG_BACKPACK
        firstEmptySlot = FindFirstEmptySlotInBag(targetBagId)
    end

    if targetBagId ~= nil and firstEmptySlot ~= nil then
        if stack == nil and toKeep ~= nil then
            toMove = itemData.stackCount-toKeep
        elseif stack ~= nil and toKeep == nil then
            toMove = stack
        else
            toMove = 1
        end

        local itemLink = GetItemLink(itemData.bagId, itemData.slotIndex)
        if itemLink ~= '' then
            PrintMessage('Transfert ' .. toMove .. 'x ' .. itemLink)
            CallRequestMoveItem(itemData.bagId, itemData.slotIndex, targetBagId, firstEmptySlot, toMove)
            didItSucced = true
        else
            PrintMessage('Failed to transfert 1x item')
            didItSucced = false
        end

        if didItSucced then
            local identifier = string_format("%sExecuteTransfert%i%i", moduleName, itemData.bagId, itemData.slotIndex)

            eventManager:RegisterForUpdate(identifier, 150, function()
                if GetItemId(targetBagId, firstEmptySlot) > 0 then
                    eventManager:UnregisterForUpdate(identifier)
                    local newStartIndex = startIndex + 1
                    if newStartIndex <= #cacheBank then
                        ExecuteTransfert(cacheBank, newStartIndex, stack, toKeep)
                    end
                end
            end)
        end
    else
        if Banking.SV.autoStackBag then
            StackBag(BAG_BANK)
            if IsESOPlusSubscriber() then
                StackBag(BAG_SUBSCRIBER_BANK)
            end
            StackBag(BAG_BACKPACK)
        end

        PrintMessage('No space left, stacking bag ...')
    end
end

---Return a table with all required wrist items at levfel 50
---@return table
local function CreateWristItemsTable()
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

---@param currencyType number
---@param toKeep number
---@param source number
---@param destination number
local function TransfertCurrency(currencyType, toKeep, source, destination)
    local current = GetCurrencyAmount(currencyType, source)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, source, destination)
    end
end

local function DepositWithdrawItems()
    local wristNotPresent = CreateWristItemsTable()
    local wristComparator = CreateWristComparator()

    local wristAlreadyPresent = {}
    for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(wristComparator, BAG_BACKPACK)) do
        wristNotPresent[slotData.name] = nil
        wristAlreadyPresent[slotData.name] = true
    end

    if next(wristNotPresent) ~= nil then
        local wristCacheBankCleaned, removeDuplicate = {}, {}
        for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(wristComparator, BAG_BANK, BAG_SUBSCRIBER_BANK)) do
            if not wristAlreadyPresent[slotData.name] and not removeDuplicate[slotData.name] then
                table_insert(wristCacheBankCleaned, slotData)
                removeDuplicate[slotData.name] = true
            end
        end

        ExecuteTransfert(wristCacheBankCleaned, 1, 1, nil)
    end

    local uselessCacheBank = SHARED_INVENTORY:GenerateFullSlotData(CreateUselessComparator(), BAG_BACKPACK)
    if next(uselessCacheBank) ~= nil then
        ExecuteTransfert(uselessCacheBank, 1, 1, nil)
    end

    local keepCacheBank = SHARED_INVENTORY:GenerateFullSlotData(CreateKeepComparator(), BAG_BACKPACK)
    if next(keepCacheBank) ~= nil then
        ExecuteTransfert(keepCacheBank, 1, nil, 50)
    end
end

local function LoadSavedVars()
    Banking.SV = ZO_SavedVars:NewAccountWide(UrilkUI.SVName, UrilkUI.SVVer, 'Banking', Banking.Defaults)
end

local function RegisterEvents()
    if Banking.SV.autoCurrencyTransfert then
        eventManager:RegisterForEvent(moduleName .. 'DepositWithdrawCurrency', EVENT_OPEN_BANK,
            function()
                TransfertCurrency(CURT_MONEY, Banking.SV.amountGoldInInventory, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
                TransfertCurrency(CURT_TELVAR_STONES, Banking.SV.amountTelvarInInventory, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
                TransfertCurrency(CURT_ALLIANCE_POINTS, Banking.SV.amountAlliancePointsInInventory, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
            end
        )
    end

    if Banking.SV.autoWithdrawWristItems then
        eventManager:RegisterForEvent(moduleName .. 'DepositWithdrawItems', EVENT_OPEN_BANK, DepositWithdrawItems)
    end
end

function Banking.Initialize(enabled)
    LoadSavedVars()

    if enabled then
        RegisterEvents()
    end
end