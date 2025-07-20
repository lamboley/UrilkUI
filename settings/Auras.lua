local UUI = UUI
local Auras = UUI.Auras
local LAM = UUI.LAM

-- ESO API Locals
local zo_strformat = zo_strformat

local function CreateSettings()
    if not UUI.SV.AurasEnabled then return end

    local Defaults = Auras.Defaults
    local Settings = Auras.SV

    local panelDataAuras = {
        type = 'panel',
        name = zo_strformat("<<1>> - <<2>>", UUI.name, 'Auras'),
        displayName = zo_strformat("<<1>> <<2>>", UUI.name, 'Auras'),
        author = UUI.author.."\n",
        version = UUI.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsDataAuras = {}

    ------------------------------------------------------------------------
    -- Description: Do things related to auras.
    optionsDataAuras[#optionsDataAuras + 1] = {
        type = 'description',
        text = 'Do things related to auras.',
    }

    ------------------------------------------------------------------------
    -- Button: ReloadUI
    optionsDataAuras[#optionsDataAuras + 1] = {
        type = 'button',
        name = 'ReloadUI',
        tooltip = 'ReloadUI',
        func = function()
            ReloadUI('ingame')
        end,
        width = 'full',
    }

    ------------------------------------------------------------------------
    -- Header: Crux
    optionsDataAuras[#optionsDataAuras + 1] = {
        type = 'header',
        name = 'Crux',
        width = 'full',
    }

    ------------------------------------------------------------------------
    -- Checkbox: Hide when not in combat
    optionsDataAuras[#optionsDataAuras + 1] = {
        type = 'checkbox',
        name = 'Hide when not in combat',
        getFunc = function()
            return Settings.hideNotInCombat
        end,
        setFunc = function(value)
            Settings.hideNotInCombat = value
        end,
        width = 'full',
        default = Defaults.hideNotInCombat,
    }

    LAM:RegisterAddonPanel(UUI.name..'AurasOptions', panelDataAuras)
    LAM:RegisterOptionControls(UUI.name..'AurasOptions', optionsDataAuras)
end

Auras.CreateSettings = CreateSettings