---@class (partial) UrilkUI
local UrilkUI = UrilkUI

--- ESO APIs
local eventManager = GetEventManager()

local function LoadSavedVars()
    UrilkUI.SV = ZO_SavedVars:NewAccountWide(UrilkUI.SVName, UrilkUI.SVVer, nil, UrilkUI.Defaults)
end

local function RegisterEvents()
    if UrilkUI.SV.LFGEnabled then
        eventManager:RegisterForEvent(UrilkUI.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, UrilkUI.OnActivityFinderStatusUpdate)
    end

    if UrilkUI.SV.antiquitiesExpiresEnabled then
        eventManager:RegisterForEvent(UrilkUI.name, EVENT_PLAYER_ACTIVATED, UrilkUI.CheckLeadTime)
    end
end

---@param eventId integer
---@param addonName string
eventManager:RegisterForEvent(UrilkUI.name, EVENT_ADD_ON_LOADED, function(eventId, addonName)
    if UrilkUI.name ~= addonName then
        return
    end

    eventManager:UnregisterForEvent(addonName, eventId)

    LoadSavedVars()

    UrilkUI.Auras.Initialize(UrilkUI.SV.AurasEnabled)
    UrilkUI.Banking.Initialize(UrilkUI.SV.BankingEnabled)
    UrilkUI.Items.Initialize(UrilkUI.SV.ItemsEnabled)

    UrilkUI.CreateSettings()

    RegisterEvents()
end)
