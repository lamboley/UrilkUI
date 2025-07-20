local UUI = UUI

local AddSystemMessage = UUI.AddSystemMessage
local PrintMessage = UUI.PrintMessage

-- ESO API Locals
local eventManager = GetEventManager()
local GetNextAntiquityId = GetNextAntiquityId
local GetAntiquityLeadTimeRemainingSeconds = GetAntiquityLeadTimeRemainingSeconds
local GetAntiquityName = GetAntiquityName

local Alerts = {}
UUI.Alerts = Alerts

Alerts.SV = {}
Alerts.Defaults = {
    name = 'Alerts',
    antiquitiesExpiresEnabled = true,
}

local function CheckLeadTime()
    local antiquityId = GetNextAntiquityId()
    while antiquityId do
        local leadExpirationTimeS = GetAntiquityLeadTimeRemainingSeconds(antiquityId)
        if leadExpirationTimeS > 0 and leadExpirationTimeS < 86400 then
            local name = GetAntiquityName(antiquityId)
            PrintMessage('Antiquities will expire: '..name)
        end
        antiquityId = GetNextAntiquityId(antiquityId)
    end
end

local function Initialize(enabled)
    if not enabled then return end

    Alerts.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Alerts', Alerts.Defaults)
    eventManager:RegisterForEvent('Alerts.CheckLeadTime', EVENT_PLAYER_ACTIVATED, CheckLeadTime)
end

Alerts.Initialize = Initialize