local UUI = UUI

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
    treasureJunkEnabled = true,
    junkEnabled = true,
    trashJunkEnabled = true,
    autoRepairEnabled = true,
    autoRechargeEnabled = true,
}

--- TODO: Maybe check if module is enabled before loading the event. I also
-- unregister the event if it is disabled.
local function Initialize(enabled)
    if not enabled then return end

    Items.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Items', Items.Defaults)

    eventManager:RegisterForEvent('Items.HandleWithdrawAndDeposit', EVENT_OPEN_BANK, Items.HandleWithdrawAndDeposit)
    eventManager:RegisterForEvent('Items.DepositGold', EVENT_OPEN_BANK, Items.DepositGold)
    eventManager:RegisterForUpdate('Items.FoodBuff', 60000, Items.FoodBuff)
    eventManager:RegisterForUpdate('Items.CustomJunk', 10000, Items.CustomJunk)

    eventManager:RegisterForEvent('Items.RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, Items.RepairSingleSlot )
    eventManager:AddFilterForEvent('Items.RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
    eventManager:AddFilterForEvent('Items.RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DURABILITY_CHANGE)

    eventManager:RegisterForEvent('Items.ChargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, Items.ChargeWeapon )
    eventManager:AddFilterForEvent('Items.ChargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
    eventManager:AddFilterForEvent('Items.ChargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_ITEM_CHARGE)
end

Items.Initialize = Initialize