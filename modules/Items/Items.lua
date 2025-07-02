local UUI = UUI

local AddSystemMessage = UUI.AddSystemMessage
local println = UUI.println

-- ESO API Locals
local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()

local Items = {}
UUI.Items = Items

Items.SV = {}
Items.Defaults = {
    name = 'Items',
    goldDepositEnabled = true,
    goldToKeep = 10000,
    itemDepositEnabled = true,
    itemWithdrawEnabled = true,
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

function Items.Initialize(enabled)
    Items.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Items', Items.Defaults)
    if not enabled then
        return
    end

    eventManager:RegisterForEvent('Items.OpenBank', EVENT_OPEN_BANK, Items.OpenBank)
end