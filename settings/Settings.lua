local UUI = UUI
local LAM = UUI.LAM

function UUI.CreateSettings()
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

    ------------------------------------------------------------------------
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

    ------------------------------------------------------------------------
    --  Header Module
    optionsData[#optionsData + 1] = {
        type = 'header',
        name = 'Module Settings',
        width = 'full',
    }

    ------------------------------------------------------------------------
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

    ------------------------------------------------------------------------
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

    ------------------------------------------------------------------------
    --  Module: Alerts
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Alerts Module',
        getFunc = function ()
            return Settings.AlertsEnabled
        end,
        setFunc = function (value)
            Settings.AlertsEnabled = value
        end,
        width = 'half',
        warning = 'This will need a reload to take effect.',
        default = Defaults.AlertsEnabled,
    }

    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Show different alerts.',
    }

    ------------------------------------------------------------------------
    --  Module: Slash Commands
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Slash Commands Module',
        getFunc = function ()
            return Settings.SlashCommandsEnabled
        end,
        setFunc = function (value)
            Settings.SlashCommandsEnabled = value
        end,
        width = 'half',
        warning = 'This will need a reload to take effect.',
        default = Defaults.SlashCommandsEnabled,
    }

    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Add some usefull slash commands.',
    }

    ------------------------------------------------------------------------
    --  Miscellaneous Settings
    optionsData[#optionsData + 1] = {
        type = 'header',
        name = 'Miscellaneous Settings',
        width = 'full',
    }

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

    LAM:RegisterAddonPanel(UUI.name..'AddonOptions', panelData)
    LAM:RegisterOptionControls(UUI.name..'AddonOptions', optionsData)
end
