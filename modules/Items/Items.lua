local UUI = UUI

local PrintMessage = UUI.PrintMessage

-----------------------------------------------------------------------------
-- ESO API Locals
local eventManager = GetEventManager()

local Items = {}
Items.moduleName = UUI.name .. 'Items'
Items.SV = {}
Items.Defaults = {
    --- _Bank
    autoCurrencyTransfert = true,
    amountGoldInInventory = 10000,
    amountAlliancePointsInInventory = 0,
    amountTelvarInInventory = 0,
    amountWritInInventory = 0,
    autoWithdrawWristItems = true,
    autoStackBag = true,

    --- _JunkHandler
    autoSetJunk = true,
    autoSetTreasureAsJunk = true,
    autoSetTrashAsJunk = true,
    autoSellJunk = true,

    --- _OpenContainers
    autoOpenContainer = true,

    --- _RepairAndRecharge
    autoRepair = true,
    autoRecharge = true,
}

local function LoadSavedVars()
    Items.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Items', Items.Defaults)
end

local function RegisterEvents()
    eventManager:RegisterForEvent(Items.moduleName, EVENT_OPEN_BANK, Items.OpenBank)

    if Items.SV.autoSetJunk then
        eventManager:RegisterForUpdate(Items.moduleName .. 'JunkHandler', 40000, Items.JunkHandler)
        eventManager:RegisterForEvent(Items.moduleName, EVENT_OPEN_STORE, Items.OpenStore)
    end

    if Items.SV.autoRepair then
        eventManager:RegisterForEvent(Items.moduleName .. 'RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, Items.RepairSingleSlot)
        eventManager:AddFilterForEvent(Items.moduleName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
        eventManager:AddFilterForEvent(Items.moduleName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DURABILITY_CHANGE)
    end

    if Items.SV.autoRecharge then
        eventManager:RegisterForEvent(Items.moduleName .. 'ChargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, Items.ChargeWeapon)
        eventManager:AddFilterForEvent(Items.moduleName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
        eventManager:AddFilterForEvent(Items.moduleName, EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_ITEM_CHARGE)
    end

    if Items.SV.autoOpenContainer then
        eventManager:RegisterForEvent(Items.moduleName .. 'InventorySingleSlotUpdate', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, Items.InventorySingleSlotUpdate)
        ZO_PreHook(SYSTEMS:GetObject('loot'), 'UpdateLootWindow', Items.LootUpdated)
    end
end

local function Initialize()
    LoadSavedVars()
    RegisterEvents()
end

Items.Initialize = Initialize
UUI.Items = Items