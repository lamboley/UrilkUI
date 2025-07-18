local UUI = UUI
local Alerts = UUI.Alerts
local LAM = UUI.LAM

-- ESO API Locals
local zo_strformat = zo_strformat

function Alerts.CreateSettings()
    if not UUI.SV.AlertsEnabled then
        return
    end

    local Defaults = Alerts.Defaults
    local Settings = Alerts.SV

    local panelDataAlerts = {
        type = 'panel',
        name = zo_strformat("<<1>> - <<2>>", UUI.name, 'Alerts'),
        displayName = zo_strformat("<<1>> <<2>>", UUI.name, 'Alerts'),
        author = UUI.author.."\n",
        version = UUI.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsDataAlerts = {}

    ------------------------------------------------------------------------
    -- Description: Do things related to alerts.
    optionsDataAlerts[#optionsDataAlerts + 1] = {
        type = 'description',
        text = 'Do things related to alerts.',
    }

    ------------------------------------------------------------------------
    -- Button: ReloadUI
    optionsDataAlerts[#optionsDataAlerts + 1] = {
        type = 'button',
        name = 'ReloadUI',
        tooltip = 'ReloadUI',
        func = function ()
            ReloadUI('ingame')
        end,
        width = 'full',
    }

    ------------------------------------------------------------------------
    -- Header: Currency
    optionsDataAlerts[#optionsDataAlerts + 1] = {
        type = 'header',
        name = 'Antiquities',
        width = 'full',
    }

    ------------------------------------------------------------------------
    -- Checkbox: Print alert when antiquities expires in 2 days
    optionsDataAlerts[#optionsDataAlerts + 1] = {
        type = 'checkbox',
        name = 'Print alert when antiquities expires in 2 days',
        getFunc = function()
            return Settings.antiquitiesExpiresEnabled
        end,
        setFunc = function(value)
            Settings.antiquitiesExpiresEnabled = value
        end,
        width = 'full',
        default = Defaults.antiquitiesExpiresEnabled,
    }

    LAM:RegisterAddonPanel(UUI.name..'AlertsOptions', panelDataAlerts)
    LAM:RegisterOptionControls(UUI.name..'AlertsOptions', optionsDataAlerts)
end
