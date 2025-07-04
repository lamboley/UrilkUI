local UUI = UUI

local AddSystemMessage = UUI.AddSystemMessage
local println = UUI.println

-- ESO API Locals
local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()
local GetCurrencyAmount = GetCurrencyAmount
local TransferCurrency = TransferCurrency
local IsUnitInCombat = IsUnitInCombat
local GetBagSize = GetBagSize
local IsItemUsable = IsItemUsable
local FindFirstEmptySlotInBag = FindFirstEmptySlotInBag
local GetItemType = GetItemType

local Items = {}
UUI.Items = Items

Items.SV = {}
Items.Defaults = {
    name = 'Items',
    goldDepositEnabled = true,
    goldToKeep = 10000,
    itemDepositEnabled = true,
    itemWithdrawWristEnabled = true,
    foodBuffEnabled = true,
    foodToConsumme = "Orzorga's Tripe Trifle Pocket",
}

local wristItemsName = {
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

-- https://esoapi.uesp.net/100024/src/ingame/inventory/inventory.lua.html#2010
-- https://esoapi.uesp.net/current/src/ingame/inventory/inventoryslot.lua.html#625
-- https://www.esoui.com/forums/showthread.php?t=2446&highlight=FindFirstEmptySlotInBag
function Items.OpenBank(eventCode, bankBag)
    if Items.SV.goldDepositEnabled then
        local currentGold = GetCurrencyAmount(CURT_MONEY, CURRENCY_LOCATION_CHARACTER)
        if currentGold > Items.SV.goldToKeep then
            TransferCurrency(CURT_MONEY, currentGold-Items.SV.goldToKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
        end
    end

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
            if slotData and slotData.stackCount > 0 and slotData.name and wristItemsName[slotData.name] then
                itemToTransfert[slotData.name] = nil
            end
	    end

        if itemToTransfert then
            local bagSlots = GetBagSize(BAG_BANK)
            local destSlot = findEmptySlotInBagpack(nil, bagSlots - 1)

            for slotIndex = 0, bagSlots - 1 do
                local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BANK, slotIndex)

                if slotData and slotData.stackCount > 0 and slotData.name and itemToTransfert[slotData.name] and destSlot then

                    CallSecureProtected('RequestMoveItem', BAG_BANK, slotIndex, BAG_BACKPACK, destSlot, 1)
                    println('Transfert', slotData.name)
                    itemToTransfert[slotData.name] = nile

                    destSlot = findEmptySlotInBagpack(destSlot, bagSlots - 1)
                end
            end
        end
    end
end

local unitTag = 'player'

-- https://esoapi.uesp.net/100026/src/ingame/buffdebuff/buffdebuffstyles.lua.html#104
-- https://esoapi.uesp.net/100025/data/g/e/t/GetItemName.html
-- https://esoapi.uesp.net/100021/src/ingame/quickslot/quickslot.lua.html#474
function Items.FoodBuff()
	if IsUnitInCombat(unitTag) or Items.SV.foodToConsumme == nil or Items.SV.foodToConsumme == '' then
        return
    end

    local isBuffPresent = false
    
    for i = 1, GetNumBuffs(unitTag) do
        local buffName = GetUnitBuffInfo(unitTag, i) 
        if buffName == Items.SV.foodToConsumme then
            isBuffPresent = true
        end
    end
    
    if not isBuffPresent then
        local bagSlots = GetBagSize(BAG_BACKPACK)
        for slotIndex = 0, bagSlots - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
            if slotData and slotData.stackCount > 0 and slotData.name and slotData.name == Items.SV.foodToConsumme and IsItemUsable(BAG_BACKPACK, slotIndex) then
                local success = CallSecureProtected('UseItem', BAG_BACKPACK, slotIndex)
                if not success then
                    debugln('ITEMS', 'Failed to consumme food.')
                end
                return
            end
	    end
    end
end

function Items.Initialize(enabled)
    Items.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Items', Items.Defaults)
    if not enabled then
        return
    end

    eventManager:RegisterForEvent('Items.OpenBank', EVENT_OPEN_BANK, Items.OpenBank)
    eventManager:RegisterForUpdate('Items.FoodBuff', 60000, Items.FoodBuff)
end