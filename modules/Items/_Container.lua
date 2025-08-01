---@class (partial) UrilkUI
local UrilkUI = UrilkUI

---@class (partial) UrilkUI.Items
local Items = UrilkUI.Items

local CallUseItem = UrilkUI.CallUseItem
local IsSpaceLeftInBag = UrilkUI.IsSpaceLeftInBag

-- ESO APIs
local eventManager = GetEventManager()
local GetItemName, GetBagSize = GetItemName, GetBagSize
local LootAll = LootAll

local moduleName = Items.moduleName

local IsThereContainerInInventory

function Items.InventorySingleSlotUpdate(_, bagId, slotIndex, isNew)
	if isNew and IsSpaceLeftInBag(BAG_BACKPACK) then
        local itemName = GetItemName(BAG_BACKPACK, slotIndex)
        if itemName and LibUrilkUIData.autoOpenContainersName[itemName] then
            CallUseItem(bagId, slotIndex)
            eventManager:RegisterForUpdate(moduleName .. 'IsThereContainerInInventory', 1000, IsThereContainerInInventory)
        end
    end
end

function IsThereContainerInInventory()
    if IsSpaceLeftInBag(BAG_BACKPACK) then
        for slotIndex = 0, GetBagSize(BAG_BACKPACK) do
            Items.InventorySingleSlotUpdate(1, BAG_BACKPACK, slotIndex, true)
        end

        eventManager:UnregisterForUpdate(moduleName .. 'IsThereContainerInInventory')
    end
end

function Items.LootAllUpdated()
    LootAll()
    return true
end