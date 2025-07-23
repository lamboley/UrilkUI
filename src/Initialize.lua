local UUI = UUI

-----------------------------------------------------------------------------
-- ESO API Locals
local eventManager = GetEventManager()

local function LoadSavedVars()
    UUI.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, nil, UUI.Defaults)
end

local function RegisterEvents()
    if UUI.SV.LFGEnabled then
        eventManager:RegisterForEvent(UUI.name, EVENT_ACTIVITY_FINDER_STATUS_UPDATE, UUI.OnActivityFinderStatusUpdate)
    end

    if UUI.SV.antiquitiesExpiresEnabled then
        eventManager:RegisterForEvent(UUI.name, EVENT_PLAYER_ACTIVATED, UUI.CheckLeadTime)
    end
end

eventManager:RegisterForEvent(UUI.name, EVENT_ADD_ON_LOADED, function (eventId, addonName)
    if UUI.name ~= addonName then return end

    eventManager:UnregisterForEvent(addonName, eventId)

    LoadSavedVars()

    UUI.CreateSettings()

    if UUI.SV.AurasEnabled then
        UUI.Auras.Initialize()
    end

    if UUI.SV.BankingEnabled then
        UUI.Banking.Initialize()
    end

    if UUI.SV.ItemsEnabled then
        UUI.Items.Initialize()
    end

    RegisterEvents()
end)
