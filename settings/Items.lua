
local UUI = UUI
local Items = UUI.Items

local zo_strformat = zo_strformat

local LAM = UUI.LAM

function Items.CreateSettings()
    if not UUI.SV.ItemsEnabled then
        return
    end

    local Defaults = Items.Defaults
    local Settings = Items.SV

    local panelDataItems = {
        type = 'panel',
        name = zo_strformat("<<1>> - <<2>>", UUI.name, 'Items'),
        displayName = zo_strformat("<<1>> <<2>>", UUI.name, 'Items'),
        author = UUI.author .. "\n",
        version = UUI.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsDataItems = {}

    optionsDataItems[#optionsDataItems + 1] = {
        type = 'description',
        text = 'Do things related to items.',
    }

    optionsDataItems[#optionsDataItems + 1] = {
        type = 'button',
        name = 'ReloadUI',
        tooltip = 'ReloadUI',
        func = function ()
            ReloadUI('ingame')
        end,
        width = 'full',
    }

    -- Gold Header
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Gold Management',
        width = 'full',
    }

    -- Enable deposit of gold
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly deposit gold in bank',
        getFunc = function()
            return Settings.goldDepositEnabled
        end,
        setFunc = function(value)
            Settings.goldDepositEnabled = value
        end,
        width = 'full',
        default = Defaults.goldDepositEnabled,
    }

    -- How much golds to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'How much gold to keep',
        min = 0,
        max = 100000,
        step = 1000,
        getFunc = function()
            return Settings.goldToKeep
        end,
        setFunc = function(value)
            Settings.goldToKeep = value
        end,
        width = 'full',
        default = Defaults.goldToKeep,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.goldDepositEnabled
        end,
    }

    -- Bank management
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Bank Management',
        width = 'full',
    }

    LAM:RegisterAddonPanel(UUI.name .. 'ItemsOptions', panelDataItems)
    LAM:RegisterOptionControls(UUI.name .. 'ItemsOptions', optionsDataItems)
end
