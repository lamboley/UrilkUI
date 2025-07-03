local UUI = UUI

local AddSystemMessage = UUI.AddSystemMessage
local println = UUI.println

-- ESO API Locals
local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()
local IsUnitInCombat = IsUnitInCombat
local GetBagSize = GetBagSize
local IsItemUsable= IsItemUsable

local Items = {}
UUI.Items = Items

Items.SV = {}
Items.Defaults = {
    name = 'Items',
    goldDepositEnabled = true,
    goldToKeep = 10000,
    itemDepositEnabled = true,
    itemWithdrawEnabled = true,
    foodBuffEnabled = true,
    foodToConsumme = "Orzorga's Tripe Trifle Pocket",
}

-- https://esoapi.uesp.net/100024/src/ingame/inventory/inventory.lua.html#2010
function Items.OpenBank(eventCode, bankBag)
    if Items.SV.goldDepositEnabled then
        local currentGold = GetCurrencyAmount(CURT_MONEY, CURRENCY_LOCATION_CHARACTER)
        if currentGold > Items.SV.goldToKeep then
            TransferCurrency(CURT_MONEY, currentGold-Items.SV.goldToKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
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
        local buffName, timeStarted, timeEnding, buffSlot, stackCount, iconFilename, buffType, effectType, abilityType, statusEffectType, abilityId, _, castByPlayer = GetUnitBuffInfo(unitTag, i) 
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
                if success then
                    println('ITEMS', 'Consummed a buff.')
                else
                    debugln('ITEMS', 'Failed to consumme a buff.')
                end

                return success
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