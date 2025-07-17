
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

    -- Currency Header
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Currency Management',
        width = 'full',
    }

    -- Enable deposit of currency
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly deposit currency in Bank',
        -- tooltip = 'Automaticaly deposit currency in Bank',
        getFunc = function()
            return Settings.currencyDepositEnabled
        end,
        setFunc = function(value)
            Settings.currencyDepositEnabled = value
        end,
        width = 'full',
        default = Defaults.currencyDepositEnabled,
    }

    -- How much Gold to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Gold to keep',
        tooltip = 'How much Gold to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.goldToKeep
        end,
        setFunc = function(value)
            Settings.goldToKeep = value
        end,
        width = 'full',
        default = Defaults.goldToKeep,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.currencyDepositEnabled
        end,
    }

    -- How much Alliance Point to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Alliance Points to keep',
        tooltip = 'How much Alliance Points to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.alliancePointsToKeep
        end,
        setFunc = function(value)
            Settings.alliancePointsToKeep = value
        end,
        width = 'full',
        default = Defaults.alliancePointsToKeep,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.currencyDepositEnabled
        end,
    }

    -- How much Tel Var stones to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Tel Var stones to keep',
        tooltip = 'How much Tel Var stones to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.telvarToKeep
        end,
        setFunc = function(value)
            Settings.telvarToKeep = value
        end,
        width = 'full',
        default = Defaults.telvarToKeep,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.currencyDepositEnabled
        end,
    }

    -- How much Tel Var stones to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Wrist Vouchers to keep',
        tooltip = 'How much wrist Vouchers to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.writToKeep
        end,
        setFunc = function(value)
            Settings.writToKeep = value
        end,
        width = 'full',
        default = Defaults.writToKeep,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.currencyDepositEnabled
        end,
    }

    -- Food&Drink Header
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
        name = 'Automaticaly deposit/withdraw items from the Bank',
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
        name = 'Withdraw items for wrist',
        tooltip = 'Automaticaly withdraw items for wrist',
        getFunc = function()
            return Settings.itemWithdrawWristEnabled
        end,
        setFunc = function(value)
            Settings.itemWithdrawWristEnabled = value
        end,
        width = 'full',
        default = Defaults.itemWithdrawWristEnabled,
    }

    -- Junk management
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Junk Management',
        width = 'full',
    }

    -- Automaticaly mark items as Junk
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly mark items as Junk',
        getFunc = function()
            return Settings.itemDepositEnabled
        end,
        setFunc = function(value)
            Settings.itemDepositEnabled = value
        end,
        width = 'full',
        default = Defaults.itemDepositEnabled,
    }
    
    LAM:RegisterAddonPanel(UUI.name .. 'ItemsOptions', panelDataItems)
    LAM:RegisterOptionControls(UUI.name .. 'ItemsOptions', optionsDataItems)
end
