local UUI = UUI

-----------------------------------------------------------------------------
-- Addons Locals
local PrintMessage = UUI.PrintMessage
local PrintDebug = UUI.PrintDebug
local Banking = UUI.Banking

-----------------------------------------------------------------------------
-- Lua Locals
local table_remove = table.remove
local table_insert = table.insert
local string_format = string.format
local next = next
local pairs = pairs

-----------------------------------------------------------------------------
-- ESO API Locals
local eventManager = GetEventManager()
local GetItemLink, GetItemId = GetItemLink, GetItemId
local StackBag = StackBag
local CallSecureProtected, IsProtectedFunction = CallSecureProtected, IsProtectedFunction
local FindFirstEmptySlotInBag, IsESOPlusSubscriber = FindFirstEmptySlotInBag, IsESOPlusSubscriber

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

local function RequestTransfertItem(sourceBag, sourceSlot, destBag, destSlot, stackCount)
    local itemLink = GetItemLink(sourceBag, sourceSlot)
    if itemLink ~= '' then
        PrintMessage('Transfert ' .. stackCount .. 'x ' .. itemLink)
        if IsProtectedFunction('RequestMoveItem') then
            CallSecureProtected('RequestMoveItem', sourceBag, sourceSlot, destBag, destSlot, stackCount)
        else
            RequestMoveItem(sourceBag, sourceSlot, destBag, destSlot, stackCount)
        end
        return true
    else
        PrintDebug('Failed to transfert 1x item')
    end
    return false
end

local function GetFirstEmptySlot(sourceBagId)
    local targetBagId, targetSlotIndex

    if sourceBagId == BAG_BACKPACK then
        targetBagId = BAG_BANK
        targetSlotIndex = FindFirstEmptySlotInBag(targetBagId)
        if targetSlotIndex == nil and IsESOPlusSubscriber() then
            targetBagId = BAG_SUBSCRIBER_BANK
            targetSlotIndex = FindFirstEmptySlotInBag(targetBagId)
        end
    elseif sourceBagId == BAG_BANK or (sourceBagId == BAG_SUBSCRIBER_BANK and IsESOPlusSubscriber()) then
        targetBagId = BAG_BACKPACK
        targetSlotIndex = FindFirstEmptySlotInBag(targetBagId)
    end

    if targetBagId ~= nil and targetSlotIndex ~= nil then
        return targetBagId, targetSlotIndex
    end

    return targetBagId, nil
end

local function ExecuteTransfert(cacheBank, startIndex)
    local itemData = cacheBank[startIndex]
    if not itemData.bagId then return end

    local targetBagId, firstEmptySlot = GetFirstEmptySlot(itemData.bagId)
    if targetBagId ~= nil and firstEmptySlot ~= nil then
        if RequestTransfertItem(itemData.bagId, itemData.slotIndex, targetBagId, firstEmptySlot, 1) then
            local identifier = string_format("%sExecuteTransfert%i%i", Banking.moduleName, itemData.bagId, itemData.slotIndex)
            
            eventManager:RegisterForUpdate(identifier, 150, function()
                if GetItemId(targetBagId, firstEmptySlot) > 0 then
                    eventManager:UnregisterForUpdate(identifier)
                    local newStartIndex = startIndex + 1
                    if newStartIndex <= #cacheBank then
                        ExecuteTransfert(cacheBank, newStartIndex)
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
        PrintDebug('No space left, stacking bag ...')
    end
end

local function TransfertCraftedWristToCharacter()
    local wristNotPresent = { -- FIX: No choice to make a new array
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

    local wristAlreadyPresent = {}
    local wristComparator = CreateWristComparator()
    for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(wristComparator, BAG_BACKPACK)) do
        wristNotPresent[slotData.name] = nil
        wristAlreadyPresent[slotData.name] = true
    end

    if next(wristNotPresent) == nil then return end

    local wristCacheBankCleaned = {}
    local removeDuplicate = {}
    for _, slotData in pairs(SHARED_INVENTORY:GenerateFullSlotData(wristComparator, BAG_BANK, BAG_SUBSCRIBER_BANK)) do
        if not wristAlreadyPresent[slotData.name] and not removeDuplicate[slotData.name] then
            table_insert(wristCacheBankCleaned, slotData)
            removeDuplicate[slotData.name] = true
        end
    end

    ExecuteTransfert(wristCacheBankCleaned, 1)
end

local function TransfertUselessItemToBank()
    local uselessCacheBank = SHARED_INVENTORY:GenerateFullSlotData(CreateUselessComparator(), BAG_BACKPACK)

    if next(uselessCacheBank) == nil then return end

    ExecuteTransfert(uselessCacheBank, 1)
end

local function ExecuteTransfertItems(_, bankBag)
    if Banking.SV.autoWithdrawWristItems then
        TransfertCraftedWristToCharacter()
        TransfertUselessItemToBank()
    end
end

Banking.ExecuteTransfertItems = ExecuteTransfertItems