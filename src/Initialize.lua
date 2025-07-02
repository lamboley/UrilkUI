local UUI = UUI

-- ESO API Locals
local eventManager = GetEventManager()

eventManager:RegisterForEvent(UUI.name, EVENT_ADD_ON_LOADED, function (eventId, addonName)
    if UUI.name ~= addonName then
        return
    end

    eventManager:UnregisterForEvent(addonName, eventId)

    UUI.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, nil, UUI.Defaults)

    UUI.Auras.Initialize(UUI.SV.AurasEnabled)
    UUI.Items.Initialize(UUI.SV.ItemsEnabled)

    UUI.CreateSettings()
    UUI.Auras.CreateSettings()
    UUI.Items.CreateSettings()
end)
