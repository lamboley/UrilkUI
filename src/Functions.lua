local UUI = UUI

-- Lua Locals
local table_concat = table.concat

-- ESO API Locals
local eventManager = GetEventManager()
local HasLFGReadyCheckNotification = HasLFGReadyCheckNotification
local AcceptLFGReadyCheckNotification = AcceptLFGReadyCheckNotification

-- https://esoapi.uesp.net/100013/data/a/d/d/AddMessage.html
do
    local function println(prefix, line, ...)
        CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ' - ', prefix or 'General', ": ", line, ...}))
    end

    UUI.println = println
end

do
    local function debugln(prefix, line, ...)
         if UUI.SV.debug then
            CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ' - ', prefix or 'General', ": ", line, ...}))
        end
    end

    UUI.debugln = debugln
end

local function OnActivityFinderStatusUpdate(eventCode, status)
    if status == ACTIVITY_FINDER_STATUS_READY_CHECK and HasLFGReadyCheckNotification() then
        AcceptLFGReadyCheckNotification()
    end
end

function UUI.AutoAcceptLFG(enabled)
    if not enabled then
        return
    end

    eventManager:RegisterForEvent(UUI.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, OnActivityFinderStatusUpdate)
end

