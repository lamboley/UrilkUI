local UUI = UUI

local eventManager = GetEventManager()

eventManager:RegisterForEvent(UUI.name, EVENT_ADD_ON_LOADED, function (eventId, addonName)
    if UUI.name ~= addonName then
        return
    end

    eventManager:UnregisterForEvent(addonName, eventId)

    UUI.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, nil, UUI.Defaults)

    UUI.CruxTracker.Initialize(UUI.SV.CruxTrackerEnabled)

    UUI.CreateSettings()
    UUI.CruxTracker.CreateSettings()
end)
