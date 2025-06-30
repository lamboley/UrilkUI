local UUI = UUI

local LAM = UUI.LAM

-- Create Settings Menu
function UUI.CreateSettings()
    local Defaults = UUI.Defaults
    local Settings = UUI.SV

    local optionsData = {}

    local panelData = {
        type = "panel",
        name = UUI.name,
        displayName = UUI.name,
        author = UUI.author .. "\n",
        version = UUI.version,
        slashCommand = "/luiset",
        registerForRefresh = true,
        registerForDefaults = false,
    }

    optionsData[#optionsData + 1] = {
        type = 'button',
        name = 'Reload UI',
        tooltip = 'This will reload the UI.',
        func = function ()
            ReloadUI('ingame')
        end,
        width = 'full',
    }

    -- Modules Header
    optionsData[#optionsData + 1] = {
        type = 'header',
        name = 'Module Settings',
        width = 'full',
    }

    -- Show CruxTracker
    optionsData[#optionsData + 1] = {
        type = "checkbox",
        name = 'Crux Tracker Module',
        getFunc = function ()
            return Settings.CruxTrackerEnabled
        end,
        setFunc = function (value)
            Settings.CruxTrackerEnabled = value
        end,
        width = 'half',
        warning = 'This will need a reaload to take effect.',
        default = Defaults.CruxTrackerEnabled,
    }

    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Display crux available.',
    }

    LAM:RegisterAddonPanel(UUI.name .. 'AddonOptions', panelData)
    LAM:RegisterOptionControls(UUI.name .. 'AddonOptions', optionsData)
end
