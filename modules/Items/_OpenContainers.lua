local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local Items = UUI.Items

-----------------------------------------------------------------------------
-- ESO API Locals
local GetBagSize = GetBagSize
local IsUnitInCombat = IsUnitInCombat
local IsLooting = IsLooting
local CallSecureProtected = CallSecureProtected

local function LootUpdated()
    if IsLooting() then
        LOOT_SHARED:LootAllItems()
    end
end

local function OpenContainers()
    if IsUnitInCombat('player') then return end

    for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
        local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
        if slotData and slotData.stackCount > 0 and slotData.name and LibUrilkUIData.autoOpenContainersName[slotData.name] then -- and not IsLooting()
            if IsProtectedFunction('UseItem') then
                CallSecureProtected('UseItem', BAG_BACKPACK, slotIndex)
            else
                UseItem(BAG_BACKPACK, slotIndex)
            end
            local itemLink = GetItemLink(BAG_BACKPACK, slotIndex)
            PrintMessage('Opening ' .. itemLink)
            return true
        end
    end
end

Items.OpenContainers = OpenContainers
Items.LootUpdated = LootUpdated