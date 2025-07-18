local UUI = UUI

-- Lua Locals
local table_concat = table.concat

-- ESO API Locals
local eventManager = GetEventManager()
local HasLFGReadyCheckNotification = HasLFGReadyCheckNotification
local AcceptLFGReadyCheckNotification = AcceptLFGReadyCheckNotification

do
    -- local function print_message(prefix, line, ...)
    --     CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ' - ', prefix or 'General', ': ', line, ...}))
    -- end

    local function print_message(line)
        if not line then return end

        CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ': ', line}))
    end

    UUI.print_message = print_message
end

local function on_activity_finder_status_update(_, status)
    if status == ACTIVITY_FINDER_STATUS_READY_CHECK and HasLFGReadyCheckNotification() then
        AcceptLFGReadyCheckNotification()
    end
end

function UUI.AutoAcceptLFG(enabled)
    if not enabled then return end

    eventManager:RegisterForEvent(UUI.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, on_activity_finder_status_update)
end

