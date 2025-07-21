local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local Alerts = UUI.Alerts
local LAM = UUI.LAM

local function CreateSettings()
    local Defaults = UUI.Defaults
    local Settings = UUI.SV

    local optionsData = {}

    local panelData = {
        type = 'panel',
        name = UUI.name,
        displayName = UUI.name,
        author = UUI.author.."\n",
        version = UUI.version,
        registerForRefresh = true,
        registerForDefaults = false,
    }

    -------------------------------------------------------------------------
    --  Debug Settings
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Debug',
        getFunc = function ()
            return Settings.debug
        end,
        setFunc = function (value)
            Settings.debug = value
        end,
        width = 'full',
        default = Defaults.debug,
    }

    -------------------------------------------------------------------------
    --  Header Module
    optionsData[#optionsData + 1] = {
        type = 'header',
        name = 'Module Settings',
        width = 'full',
    }

    -------------------------------------------------------------------------
    --  Module: Auras
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Auras Module',
        getFunc = function ()
            return Settings.AurasEnabled
        end,
        setFunc = function (value)
            Settings.AurasEnabled = value
        end,
        width = 'half',
        warning = 'This will need a reaload to take effect.',
        default = Defaults.AurasEnabled,
    }

    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Do things related to auras.',
    }

    -------------------------------------------------------------------------
    --  Module: Items
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Items Module',
        getFunc = function ()
            return Settings.ItemsEnabled
        end,
        setFunc = function (value)
            Settings.ItemsEnabled = value
        end,
        width = 'half',
        warning = 'This will need a reaload to take effect.',
        default = Defaults.ItemsEnabled,
    }

    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Do things related to items.',
    }

    -------------------------------------------------------------------------
    --  Miscellaneous Settings
    optionsData[#optionsData + 1] = {
        type = 'header',
        name = 'Miscellaneous Settings',
        width = 'full',
    }

    -------------------------------------------------------------------------
    -- Checkbox: Accept LFG automatically
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Accept LFG automatically',
        getFunc = function ()
            return Settings.LFGEnabled
        end,
        setFunc = function (value)
            Settings.LFGEnabled = value
        end,
        width = 'full',
        default = Defaults.LFGEnabled,
    }

    --------------------------------------------------------------------------
    -- Checkbox: Print in chart when antiquities expires in less than 1 day
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Print in chart when antiquities expires in less than 1 day',
        getFunc = function ()
            return Settings.antiquitiesExpiresEnabled
        end,
        setFunc = function (value)
            Settings.antiquitiesExpiresEnabled = value
        end,
        width = 'full',
        default = Defaults.antiquitiesExpiresEnabled,
    }

    LAM:RegisterAddonPanel(UUI.name..'AddonOptions', panelData)
    LAM:RegisterOptionControls(UUI.name..'AddonOptions', optionsData)
end

UUI.CreateSettings = CreateSettings