---@class (partial) UrilkUI
local UrilkUI = UrilkUI

local GetSlotIndexFromNameInBackpack = UrilkUI.GetSlotIndexFromNameInBackpack
local CallUseItem = UrilkUI.CallUseItem
local IsSpaceLeftInBag = UrilkUI.IsSpaceLeftInBag

-- ESO APIs
local eventManager = GetEventManager()

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

local IsThereContainerInInventory

local function InventorySingleSlotUpdate(_, bagId, slotIndex, isNew)
	if isNew and IsSpaceLeftInBag(BAG_BACKPACK) then
        local itemName = GetItemName(BAG_BACKPACK, slotIndex)
        if itemName and LibUrilkUIData.autoOpenContainersName[itemName] then
            CallUseItem(bagId, slotIndex)
            eventManager:RegisterForUpdate(moduleName .. 'IsThereContainerInInventory', 2000, IsThereContainerInInventory)
        end
    end
end

function IsThereContainerInInventory()
    if IsSpaceLeftInBag(BAG_BACKPACK) then
        for slotIndex = 0, GetBagSize(BAG_BACKPACK) do
            InventorySingleSlotUpdate(1, BAG_BACKPACK, slotIndex, true)
        end

        eventManager:UnregisterForUpdate(moduleName .. 'IsThereContainerInInventory')
    end
end

local function JunkHandler(_, bagId, slotIndex)
    if not bagId == BAG_BACKPACK or IsItemJunk(bagId, slotIndex) or not CanItemBeMarkedAsJunk(bagId, slotIndex) then return end

    local itemName = GetItemName(bagId, slotIndex)
    if itemName and LibUrilkUIData.customJunk[itemName] then
        SetItemIsJunk(bagId, slotIndex, true)
    end
end


local function ChargeWeapon(_, bagId, slotIndex)
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

local function LoadSavedVars()
    Items.SV = ZO_SavedVars:NewAccountWide(UrilkUI.SVName, UrilkUI.SVVer, 'Items', Items.Defaults)
end

local function RegisterEvents()
    if Items.SV.autoSetJunk then
        eventManager:RegisterForEvent(moduleName .. 'JunkHandler', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, JunkHandler)
        eventManager:AddFilterForEvent(moduleName .. 'JunkHandler', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
        eventManager:RegisterForEvent(moduleName .. 'SellAllJunk', EVENT_OPEN_STORE,
            function()
                if HasAnyJunk(BAG_BACKPACK, true) then
                    SellAllJunk()
                end
            end
        )
    end

    if Items.SV.autoRepair then
        eventManager:RegisterForEvent(moduleName .. 'RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, RepairSingleSlot)
        eventManager:AddFilterForEvent(moduleName .. 'RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
        eventManager:AddFilterForEvent(moduleName .. 'RepairSingleSlot', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_DURABILITY_CHANGE)
    end

    if Items.SV.autoRecharge then
        eventManager:RegisterForEvent(moduleName .. 'RechargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, ChargeWeapon)
        eventManager:AddFilterForEvent(moduleName .. 'RechargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_WORN)
        eventManager:AddFilterForEvent(moduleName .. 'RechargeWeapon', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_INVENTORY_UPDATE_REASON, INVENTORY_UPDATE_REASON_ITEM_CHARGE)
    end

    if Items.SV.autoOpenContainer then
        eventManager:RegisterForEvent(moduleName .. 'InventorySingleSlotUpdate', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, InventorySingleSlotUpdate)
        eventManager:AddFilterForEvent(moduleName .. 'InventorySingleSlotUpdate', EVENT_INVENTORY_SINGLE_SLOT_UPDATE, REGISTER_FILTER_BAG_ID, BAG_BACKPACK)
        ZO_PreHook(SYSTEMS:GetObject('loot'), 'UpdateLootWindow',
            function()
                LootAll()
                return true
            end
        )
    end
end

function Items.Initialize(enabled)
    LoadSavedVars()

    if enabled then
        RegisterEvents()
    end
end