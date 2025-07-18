local UUI = UUI

local AddSystemMessage = UUI.AddSystemMessage
local print_message = UUI.print_message

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

local function check_lead_time()
    local antiquityId = GetNextAntiquityId()
    while antiquityId do
        local leadExpirationTimeS = GetAntiquityLeadTimeRemainingSeconds(antiquityId)
        if leadExpirationTimeS > 0 and leadExpirationTimeS < 172800 then
            local name = GetAntiquityName(antiquityId)
            print_message('Antiquities will expire: '..name)
        end
        antiquityId = GetNextAntiquityId(antiquityId)
    end
end

function Alerts.Initialize(enabled)
    if not enabled then return end

    Alerts.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Alerts', Alerts.Defaults)

    eventManager:RegisterForEvent('Alerts.check_lead_time', EVENT_PLAYER_ACTIVATED, check_lead_time)
end