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
        author = UUI.author .. "\n",
        version = UUI.version,
        registerForRefresh = true,
        registerForDefaults = false,
    }

    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Debug',
        getFunc = function ()
            return Settings.debug
        end,
        setFunc = function (value)
            Settings.debug = value
        end,
        width = 'half',
        default = Defaults.debug,
    }

    optionsData[#optionsData + 1] = {
        type = 'button',
        name = 'Reload UI',
        tooltip = 'This will reload the UI.',
        func = function ()
            ReloadUI('ingame')
        end,
        width = 'half',
    }

    -- Modules Header
    optionsData[#optionsData + 1] = {
        type = 'header',
        name = 'Module Settings',
        width = 'full',
    }

    -- Auras Module
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

    -- Items Module
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

    -- Miscellaneous Header
    optionsData[#optionsData + 1] = {
        type = 'header',
        name = 'Miscellaneous Settings',
        width = 'full',
    }

    -- Auto Accept LFG
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

    LAM:RegisterAddonPanel(UUI.name .. 'AddonOptions', panelData)
    LAM:RegisterOptionControls(UUI.name .. 'AddonOptions', optionsData)
end
