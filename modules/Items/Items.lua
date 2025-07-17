local UUI = UUI

local AddSystemMessage = UUI.AddSystemMessage
local println = UUI.println
local debugln = UUI.debugln

-- ESO API Locals
local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()
local TransferCurrency = TransferCurrency
local IsUnitInCombat = IsUnitInCombat
local GetBagSize = GetBagSize
local IsItemUsable = IsItemUsable
local FindFirstEmptySlotInBag = FindFirstEmptySlotInBag
local GetItemType = GetItemType
local CanItemBeMarkedAsJunk = CanItemBeMarkedAsJunk
local IsItemJunk = IsItemJunk
local SetItemIsJunk= SetItemIsJunk

local Items = {}
UUI.Items = Items

Items.SV = {}
Items.Defaults = {
    name = 'Items',
    currencyDepositEnabled = true,
    goldToKeep = 10000,
    alliancePointsToKeep = 0,
    telvarToKeep = 0,
    writToKeep = 0,
    itemDepositEnabled = true,
    itemWithdrawWristEnabled = true,
    foodBuffEnabled = true,
    foodToConsumme = 61255,
}

function Items.Initialize(enabled)
    Items.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Items', Items.Defaults)
    if not enabled then
        return
    end

    eventManager:RegisterForEvent('Items.OpenBank', EVENT_OPEN_BANK, Items.OpenBank)
    eventManager:RegisterForEvent('Items.DepositGold', EVENT_OPEN_BANK, Items.DepositGold)
    eventManager:RegisterForUpdate('Items.FoodBuff', 60000, Items.FoodBuff)
    eventManager:RegisterForUpdate('Items.CustomJunk', 10000, Items.CustomJunk)
end