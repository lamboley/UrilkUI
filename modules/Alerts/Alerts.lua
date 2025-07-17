local UUI = UUI

local AddSystemMessage = UUI.AddSystemMessage
local println = UUI.println

-- ESO API Locals
local eventManager = GetEventManager()
local GetNextAntiquityId = GetNextAntiquityId
local GetAntiquityLeadTimeRemainingSeconds = GetAntiquityLeadTimeRemainingSeconds
local GetAntiquityName = GetAntiquityName
local GetNextAntiquityId = GetNextAntiquityId

local Alerts = {}
UUI.Alerts = Alerts

Alerts.SV = {}
Alerts.Defaults = {
    name = 'Alerts',
    antiquitiesExpiresEnabled = true, 
}

function Alerts.Initialize(enabled)
    Alerts.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Alerts', Alerts.Defaults)
    if not enabled then
        return
    end

    eventManager:RegisterForEvent('Alerts.CheckAntiquities', EVENT_PLAYER_ACTIVATED, function()
        local antiquityId = GetNextAntiquityId()
        while antiquityId do
            local leadExpirationTimeS = GetAntiquityLeadTimeRemainingSeconds(antiquityId) 
            if leadExpirationTimeS > 0 and leadExpirationTimeS < 172800 then
                local name = GetAntiquityName(antiquityId) 
                println('AntiquitiesExpire', name)
            end
            antiquityId = GetNextAntiquityId(antiquityId)
        end
    end)
end