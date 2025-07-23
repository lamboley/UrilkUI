local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local Items = UUI.Items

-----------------------------------------------------------------------------
-- Lua Locals
local table_remove = table.remove
local table_insert = table.insert

-----------------------------------------------------------------------------
-- ESO API Locals
local GetItemType, GetItemLink, GetItemName = GetItemType, GetItemLink, GetItemName
local GetBagSize, StackBag = GetBagSize, StackBag
local IsESOPlusSubscriber = IsESOPlusSubscriber
local CallSecureProtected, IsProtectedFunction = CallSecureProtected, IsProtectedFunction
local GetCurrencyAmount, TransferCurrency = GetCurrencyAmount, TransferCurrency
local CURT_MONEY, CURT_TELVAR_STONES, CURT_ALLIANCE_POINTS = CURT_MONEY, CURT_TELVAR_STONES, CURT_ALLIANCE_POINTS

local function TransfertCurrencyToBank(currencyType, toKeep)
    local current = GetCurrencyAmount(currencyType, CURRENCY_LOCATION_CHARACTER)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    end
end

local function BuildEmptySlotCache(bagId)
	local emptySlotCache = {}
    local slotIndex = FindFirstEmptySlotInBag(bagId)

    while slotIndex do
        if GetItemName(bagId, slotIndex) == '' then
            table_insert(emptySlotCache, slotIndex)
        end
        slotIndex = ZO_GetNextBagSlotIndex(bagId, slotIndex)
    end

    return emptySlotCache
end

local function RequestTransfertToBagpack(bagId, sourcedSlotIndex, destSlotIndex, stack)
    if destSlotIndex and GetItemName(BAG_BACKPACK, destSlotIndex) == '' then
        if IsProtectedFunction('RequestMoveItem') then
            CallSecureProtected('RequestMoveItem', bagId, sourcedSlotIndex, BAG_BACKPACK, destSlotIndex, stack)
        else
            RequestMoveItem(bagId, sourcedSlotIndex, BAG_BACKPACK, destSlotIndex, stack)
        end
    else
        return false
    end

    PrintMessage('Transfert 1x ' .. GetItemLink(bagId, sourcedSlotIndex) .. ' to inventory')
    return true
end

local function DoStackBags()
    StackBag(BAG_BANK)
    if IsESOPlusSubscriber() then
        StackBag(BAG_SUBSCRIBER_BANK)
    end
    StackBag(BAG_BACKPACK)
end

local function TransfertCraftedWristToCharacter()
    local itemToTransfert = LibUrilkUIData.wristItemsName

    local filteredDataTableBagpack = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in pairs(filteredDataTableBagpack) do
        if slotData and slotData.stackCount > 0 and slotData.name and LibUrilkUIData.wristItemsName[slotData.name] then
            itemToTransfert[slotData.name] = nil
        end
    end

    if itemToTransfert then
        local filteredDataTableBank = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
        local destIndex = BuildEmptySlotCache(BAG_BACKPACK)
        local nextIndex = 1

        for _, slotData in pairs(filteredDataTableBank) do
            if slotData and slotData.stackCount > 0 and slotData.name and itemToTransfert[slotData.name] then
                local wasMoved = RequestTransfertToBagpack(slotData.bagId, slotData.slotIndex, destIndex[nextIndex], 1)
                if wasMoved then
                    nextIndex = nextIndex + 1
                    itemToTransfert[slotData.name] = nil
                end
            end
        end
    end
end

local function OpenBank(eventCode, bankBag)
    if Items.SV.autoCurrencyTransfert then
        TransfertCurrencyToBank(CURT_MONEY, Items.SV.amountGoldInInventory)
        TransfertCurrencyToBank(CURT_TELVAR_STONES, Items.SV.amountTelvarInInventory)
        TransfertCurrencyToBank(CURT_ALLIANCE_POINTS, Items.SV.amountAlliancePointsInInventory)
    end

    if Items.SV.autoStackBag then
        DoStackBags()
    end

    if Items.SV.autoWithdrawWristItems then
        SHARED_INVENTORY:RefreshInventory(BAG_BACKPACK)
        SHARED_INVENTORY:RefreshInventory(BAG_BANK)
        if IsESOPlusSubscriber() then
            SHARED_INVENTORY:RefreshInventory(BAG_SUBSCRIBER_BANK)
        end

        zo_callLater(function()
            TransfertCraftedWristToCharacter()
        end, 100)
    end

    if Items.SV.autoStackBag then
        DoStackBags()
    end
end

Items.OpenBank = OpenBank