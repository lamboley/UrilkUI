---@class (partial) UrilkUI
local UrilkUI = UrilkUI

local GetSlotIndexFromNameInBackpack = UrilkUI.GetSlotIndexFromNameInBackpack

-- Lua APIs
local string_format = string.format

-- ESO APIs
local eventManager = GetEventManager()
local IsItemChargeable, DoesItemHaveDurability = IsItemChargeable, DoesItemHaveDurability
local GetChargeInfoForItem, GetItemCondition = GetChargeInfoForItem, GetItemCondition
local ChargeItemWithSoulGem, RepairItemWithRepairKit = ChargeItemWithSoulGem, RepairItemWithRepairKit
local GetBagSize = GetBagSize
local IsUnitDeadOrReincarnating = IsUnitDeadOrReincarnating

local moduleName = UrilkUI.name .. 'Items'

---@class (partial) UrilkUI.Items
local Items = {}
Items.__index = Items
UrilkUI.Items = Items

Items.Defaults = {
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

Items.SV = {}
Items.moduleName = moduleName

local function RechargeWeapon(_, bagId, slotIndex)
    if IsItemChargeable(bagId, slotIndex) then
        if GetChargeInfoForItem(bagId, slotIndex) < 20 then
            local soulGemIndex = GetSlotIndexFromNameInBackpack('Soul Gem')
            if soulGemIndex then
                ChargeItemWithSoulGem(bagId, slotIndex, BAG_BACKPACK, soulGemIndex)
            end
        end
    end
end


local function RepairSingleSlot(_, bagId, slotIndex)
    if DoesItemHaveDurability(bagId, slotIndex) then
        if GetItemCondition(bagId, slotIndex) < 20 then
            local kitIndex = GetSlotIndexFromNameInBackpack('Equipment Repair Kit')
            if kitIndex then
                RepairItemWithRepairKit(bagId, slotIndex, BAG_BACKPACK, kitIndex)
            end
        end
    end
end

local slotAlreadyRepaired = {}
local function RepairFullSlot()
	if IsUnitDeadOrReincarnating('player') then return end

    local kitIndex = GetSlotIndexFromNameInBackpack('Equipment Repair Kit')
    if not kitIndex then return end

    for slotIndex = 0, GetBagSize(BAG_WORN) do
        if DoesItemHaveDurability(BAG_WORN, slotIndex) then
            local repairKey = string_format("%d%d", BAG_WORN, slotIndex)
            if slotAlreadyRepaired[repairKey] then return end

            if GetItemCondition(BAG_WORN, slotIndex) < 20 then
                RepairItemWithRepairKit(BAG_WORN, slotIndex, BAG_BACKPACK, kitIndex)
                slotAlreadyRepaired[repairKey] = true
                zo_callLater(
                    function()
                        slotAlreadyRepaired[repairKey] = nil
                    end, 2000
                )
            end
        end
    end
end

local function LoadSavedVars()
    Items.SV = ZO_SavedVars:NewAccountWide(UrilkUI.SVName, UrilkUI.SVVer, 'Items', Items.Defaults)
end

local function RegisterEvents()
    if Items.SV.autoSetJunk then
        eventManager:RegisterForUpdate(moduleName .. 'SetAsJunk', 30000, Items.SetAsJunk)
        eventManager:RegisterForEvent(moduleName .. 'SellJunk', EVENT_OPEN_STORE, Items.SellJunk)
    end

    if Items.SV.autoRepair then
        eventManager:RegisterForEvent(moduleName .. 'RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RepairSingleSlot)
        eventManager:AddFilterForEvent(moduleName .. 'RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
        eventManager:AddFilterForEvent(moduleName .. 'RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DURABILITY_CHANGE)
		eventManager:RegisterForEvent(moduleName .. 'RepairFullSlot', EVENT_PLAYER_REINCARNATED, RepairFullSlot)
		eventManager:RegisterForEvent(moduleName .. 'RepairFullSlot', EVENT_PLAYER_ALIVE, RepairFullSlot)
    end

    if Items.SV.autoRecharge then
        eventManager:RegisterForEvent(moduleName .. 'RechargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RechargeWeapon)
        eventManager:AddFilterForEvent(moduleName .. 'RechargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
        eventManager:AddFilterForEvent(moduleName .. 'RechargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_ITEM_CHARGE)
    end

    if Items.SV.autoOpenContainer then
        eventManager:RegisterForEvent(moduleName .. 'InventorySingleSlotUpdate', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, Items.InventorySingleSlotUpdate)
        eventManager:AddFilterForEvent(moduleName .. 'InventorySingleSlotUpdate', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)

        ZO_PreHook(SYSTEMS:GetObject('loot'), 'UpdateLootWindow', Items.LootAllUpdated)
    end
end

function Items.Initialize(enabled)
    LoadSavedVars()

    if enabled then
        RegisterEvents()
    end
end