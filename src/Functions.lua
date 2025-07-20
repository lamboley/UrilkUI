local UUI = UUI

-- Lua Locals
local table_concat = table.concat

-- ESO API Locals
local eventManager = GetEventManager()
local HasLFGReadyCheckNotification = HasLFGReadyCheckNotification
local AcceptLFGReadyCheckNotification = AcceptLFGReadyCheckNotification
local GetBagSize = GetBagSize

do
    local function PrintMessage(line)
        if not line then return end
        CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ': ', line}))
    end

    UUI.PrintMessage = PrintMessage
end

do
    local function GetSlotIndexFromNameInBackpack(name)
        if not name then return end
        for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
            if slotData and slotData.stackCount > 0 and slotData.name == name then
                return slotIndex
            end
        end
        return
    end

    UUI.GetSlotIndexFromNameInBackpack = GetSlotIndexFromNameInBackpack
end

local function OnActivityFinderStatusUpdate(_, status)
    if status == ACTIVITY_FINDER_STATUS_READY_CHECK and HasLFGReadyCheckNotification() then
        AcceptLFGReadyCheckNotification()
    end
end

local function AutoAcceptLFG(enabled)
    if not enabled then return end

    eventManager:RegisterForEvent(UUI.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
end

UUI.AutoAcceptLFG = AutoAcceptLFG