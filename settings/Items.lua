
local UUI = UUI
local Items = UUI.Items
local LAM = UUI.LAM

-- ESO API Locals
local zo_strformat = zo_strformat

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

    -- Gold Header
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Food&Drink Management',
        width = 'full',
    }

    -- Which food&drink to consumme
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'editbox',
        name = 'Which food&drink to consumme',
        getFunc = function ()
            return Settings.foodToConsumme
        end,
        setFunc = function (value)
            Settings.foodToConsumme = value
        end,
        width = 'full',
        default = Defaults.foodToConsumme,
        disabled = function()
            return not UUI.SV.ItemsEnabled
        end,
    }

    -- Bank management
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Bank Management',
        width = 'full',
    }

    -- Enable deposit of items in bank
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly deposit items in the bank',
        getFunc = function()
            return Settings.itemDepositEnabled
        end,
        setFunc = function(value)
            Settings.itemDepositEnabled = value
        end,
        width = 'full',
        default = Defaults.itemDepositEnabled,
    }

    -- Automaticaly withdraw items for wrist
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly withdraw items for wrist',
        getFunc = function()
            return Settings.itemWithdrawWristEnabled
        end,
        setFunc = function(value)
            Settings.itemWithdrawWristEnabled = value
        end,
        width = 'full',
        default = Defaults.itemWithdrawWristEnabled,
    }

    LAM:RegisterAddonPanel(UUI.name .. 'ItemsOptions', panelDataItems)
    LAM:RegisterOptionControls(UUI.name .. 'ItemsOptions', optionsDataItems)
end
