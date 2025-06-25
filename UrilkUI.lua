UrilkUI = {}

local ADDON_NAME = 'UrilkUI'

local function OnLoad(eventCode, name)
    if name == ADDON_NAME then

        EVENT_MANAGER:UnregisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED)
    end
end

EVENT_MANAGER:RegisterForEvent(ADDON_NAME, EVENT_ADD_ON_LOADED, OnLoad)