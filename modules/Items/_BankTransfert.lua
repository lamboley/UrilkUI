local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local Items = UUI.Items

-----------------------------------------------------------------------------
-- Lua Locals
local table_remove = table.remove

-----------------------------------------------------------------------------
-- ESO API Locals
local GetItemType, GetItemLink, GetItemName = GetItemType, GetItemLink, GetItemName
local GetBagSize, StackBag = GetBagSize, StackBag
local CallSecureProtected = CallSecureProtected
local IsProtectedFunction = IsProtectedFunction
local GetCurrencyAmount, TransferCurrency = GetCurrencyAmount, TransferCurrency
local CURT_MONEY, CURT_TELVAR_STONES, CURT_ALLIANCE_POINTS = CURT_MONEY, CURT_TELVAR_STONES, CURT_ALLIANCE_POINTS

local emptySlotCacheBackpack = {}

local function TransfertCurrencyToBank(currencyType, toKeep)
    local current = GetCurrencyAmount(currencyType, CURRENCY_LOCATION_CHARACTER)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    end
end

local function FindEmptySlotInBagpack(prevIndex, lastIndex)
    local slotIndex = prevIndex or -1
    while slotIndex < lastIndex do
        slotIndex = slotIndex + 1
        if GetItemType(BAG_BACKPACK, slotIndex) == ITEMTYPE_NONE then
            return slotIndex
        end
    end
    return nil
end

local function BuildEmptySlotCacheBackpack()
	emptySlotCacheBackpack = {}
	for index = FindFirstEmptySlotInBag(BAG_BACKPACK) or 250, GetBagSize(BAG_BACKPACK) - 1 do
		if GetItemName(BAG_BACKPACK, index) == '' then
			emptySlotCacheBackpack[#emptySlotCacheBackpack + 1] = index
		end
	end
	return nil
end

local function RequestTransfertToBagpack(bagId, slotIndex, stack)
    local firstEmptySlotInCache = emptySlotCacheBackpack[1]

    if firstEmptySlotInCache and GetItemName(BAG_BACKPACK, firstEmptySlotInCache) == '' then
        table_remove(emptySlotCacheBackpack, 1)

        if IsProtectedFunction('RequestMoveItem') then
            CallSecureProtected('RequestMoveItem', bagId, slotIndex, BAG_BACKPACK, firstEmptySlotInCache, stack)
        else
            RequestMoveItem(bagId, slotIndex, BAG_BACKPACK, firstEmptySlot, stack)
        end
    else
        return false
    end

    PrintMessage('Transfert 1x' .. GetItemLink(bagId, slotIndex) .. ' to inventory')
    return true
end

local function DoRefreshBag()
    SHARED_INVENTORY:RefreshInventory(BAG_BACKPACK)
    SHARED_INVENTORY:RefreshInventory(BAG_BANK)
    if IsESOPlusSubscriber() then
        SHARED_INVENTORY:RefreshInventory(BAG_SUBSCRIBER_BANK)
    end
end

local function DoStackBags()
    StackBag(BAG_BANK)
    if IsESOPlusSubscriber() then
        StackBag(BAG_SUBSCRIBER_BANK)
    end
    StackBag(BAG_BACKPACK)
end

local function TransfertCraftedWristToCharacter()
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

    local filteredDataTableBagpack = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BACKPACK)
    for _, slotData in pairs(filteredDataTableBagpack) do -- Destination
        if slotData and slotData.stackCount > 0 and slotData.name and LibUrilkUIData.wristItemsName[slotData.name] then
            itemToTransfert[slotData.name] = nil
        end
    end

    if itemToTransfert then
        local filteredDataTableBank = SHARED_INVENTORY:GenerateFullSlotData(nil, BAG_BANK, BAG_SUBSCRIBER_BANK)
        for _, slotData in pairs(filteredDataTableBank) do -- Source
            if slotData and slotData.stackCount > 0 and slotData.name and itemToTransfert[slotData.name] then
                local wasMoved = RequestTransfertToBagpack(slotData.bagId, slotData.slotIndex, 1)
                if wasMoved then
                    itemToTransfert[slotData.name] = nil
                end
            end
        end
    end

    -- for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
    --     local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
    --     if slotData and slotData.stackCount > 0 and slotData.name and LibUrilkUIData.wristItemsName[slotData.name] then
    --         itemToTransfert[slotData.name] = nil
    --     end
    -- end

    -- if itemToTransfert then
        -- local bagSlots = GetBagSize(BAG_BANK)
        -- local destSlot = FindEmptySlotInBagpack(nil, bagSlots - 1)
        -- for slotIndex = 0, bagSlots - 1 do
        --     local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BANK, slotIndex)

        --     if slotData and slotData.stackCount > 0 and slotData.name then
        --         if itemToTransfert[slotData.name] and destSlot then
        --             if IsProtectedFunction('RequestMoveItem') then
        --                 CallSecureProtected('RequestMoveItem', BAG_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
        --             else
        --                 RequestMoveItem(BAG_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
        --             end

        --             itemToTransfert[slotData.name] = nil
        --             local itemLink = GetItemLink(BAG_BANK, slotIndex)
        --             PrintMessage('Withdrawing ' .. itemLink)
        --             destSlot = FindEmptySlotInBagpack(destSlot, bagSlots - 1)
        --         end
        --     end
        -- end

        -- bagSlots = GetBagSize(BAG_SUBSCRIBER_BANK)
        -- destSlot = FindEmptySlotInBagpack(nil, bagSlots - 1)
        -- for slotIndex = 0, bagSlots - 1 do
        --     local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_SUBSCRIBER_BANK, slotIndex)

        --     if slotData and slotData.stackCount > 0 and slotData.name then
        --         if itemToTransfert[slotData.name] and destSlot then
        --             if IsProtectedFunction('RequestMoveItem') then
        --                 CallSecureProtected('RequestMoveItem', BAG_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
        --             else
        --                 RequestMoveItem(BAG_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
        --             end
        --             itemToTransfert[slotData.name] = nil
        --             local itemLink = GetItemLink(BAG_SUBSCRIBER_BANK, slotIndex)
        --             PrintMessage('Withdrawing ' .. itemLink)
        --             destSlot = FindEmptySlotInBagpack(destSlot, bagSlots - 1)
        --         end
        --     end
        -- end
    -- end
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
        BuildEmptySlotCacheBackpack()
        DoRefreshBag()
        TransfertCraftedWristToCharacter()
    end

    if Items.SV.autoStackBag then
        DoStackBags()
    end
end

Items.OpenBank = OpenBank