local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local PrintDebug = UUI.PrintDebug
local Items = UUI.Items

-----------------------------------------------------------------------------
-- ESO API Locals
local eventManager = GetEventManager()
local GetBagSize = GetBagSize
local CallSecureProtected, IsProtectedFunction = CallSecureProtected, IsProtectedFunction
local GetItemLink, GetItemName = GetItemLink, GetItemName
local FindFirstEmptySlotInBag = FindFirstEmptySlotInBag
local LootAll, UseItem = LootAll, UseItem

local function LootUpdated()
    LootAll()
    return true
end

local IsThereContainerInInventory

local function IsThereSpaceLeftInInventory()
    if FindFirstEmptySlotInBag(BAG_BACKPACK) then
        return true
    else
        PrintDebug("Can't open container, no space left in inventory")
        return false
    end
end

local function InventorySingleSlotUpdate(_, bagId, slotIndex, isNew)
	if isNew and IsThereSpaceLeftInInventory() then
        local itemName = GetItemName(BAG_BACKPACK, slotIndex)
        if itemName and LibUrilkUIData.autoOpenContainersName[itemName] then
            if IsProtectedFunction('UseItem') then
                CallSecureProtected('UseItem', bagId, slotIndex)
            else
                UseItem(bagId, slotIndex)
            end
            PrintMessage('Opening ' .. GetItemLink(BAG_BACKPACK, slotIndex))
            eventManager:RegisterForUpdate(Items.moduleName .. 'IsThereContainerInInventory', 1000, IsThereContainerInInventory)
        end
    end
end

function IsThereContainerInInventory()
    if IsThereSpaceLeftInInventory() then
        for slotIndex = 0, GetBagSize(BAG_BACKPACK) do
            InventorySingleSlotUpdate(1, BAG_BACKPACK, slotIndex, true)
        end

        eventManager:UnregisterForUpdate(Items.moduleName .. 'IsThereContainerInInventory')
    end
end

Items.LootUpdated = LootUpdated
Items.InventorySingleSlotUpdate = InventorySingleSlotUpdate