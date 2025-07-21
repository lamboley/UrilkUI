local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local Items = UUI.Items
local LAM = UUI.LAM

-----------------------------------------------------------------------------
-- ESO API Locals
local zo_strformat = zo_strformat

local function CreateSettings()
    if not UUI.SV.ItemsEnabled then return end

    local Defaults = Items.Defaults
    local Settings = Items.SV

    local panelDataItems = {
        type = 'panel',
        name = zo_strformat("<<1>> - <<2>>", UUI.name, 'Items'),
        displayName = zo_strformat("<<1>> <<2>>", UUI.name, 'Items'),
        author = UUI.author.."\n",
        version = UUI.version,
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsDataItems = {}

    -------------------------------------------------------------------------
    -- Description: Do things related to items.
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'description',
        text = 'Do things related to items.',
    }

    -------------------------------------------------------------------------
    -- Button: ReloadUI
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'button',
        name = 'ReloadUI',
        tooltip = 'ReloadUI',
        func = function ()
            ReloadUI('ingame')
        end,
        width = 'full',
    }

    -------------------------------------------------------------------------
    -- Header: Currency Management
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Currency Management',
        width = 'full',
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly deposit currency in Bank
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly deposit currency in Bank',
        getFunc = function()
            return Settings.autoCurrencyTransfert
        end,
        setFunc = function(value)
            Settings.autoCurrencyTransfert = value
        end,
        width = 'full',
        default = Defaults.autoCurrencyTransfert,
    }

    -------------------------------------------------------------------------
    -- Slider: Gold to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Gold to keep',
        tooltip = 'How much Gold to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.amountGoldInInventory
        end,
        setFunc = function(value)
            Settings.amountGoldInInventory = value
        end,
        width = 'full',
        default = Defaults.amountGoldInInventory,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.autoCurrencyTransfert
        end,
    }

    -------------------------------------------------------------------------
    -- Slider: Alliance Points to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Alliance Points to keep',
        tooltip = 'How much Alliance Points to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.amountAlliancePointsInInventory
        end,
        setFunc = function(value)
            Settings.amountAlliancePointsInInventory = value
        end,
        width = 'full',
        default = Defaults.amountAlliancePointsInInventory,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.autoCurrencyTransfert
        end,
    }

    -------------------------------------------------------------------------
    -- Slider: Tel Var stones to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Tel Var stones to keep',
        tooltip = 'How much Tel Var stones to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.amountTelvarInInventory
        end,
        setFunc = function(value)
            Settings.amountTelvarInInventory = value
        end,
        width = 'full',
        default = Defaults.amountTelvarInInventory,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.autoCurrencyTransfert
        end,
    }

    -------------------------------------------------------------------------
    -- Slider: Wrist Vouchers to keep
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'slider',
        name = 'Wrist Vouchers to keep',
        tooltip = 'How much wrist Vouchers to keep in inventory',
        min = 0,
        max = 100000,
        step = 100,
        getFunc = function()
            return Settings.amountWritInInventory
        end,
        setFunc = function(value)
            Settings.amountWritInInventory = value
        end,
        width = 'full',
        default = Defaults.amountWritInInventory,
        disabled = function()
            return not UUI.SV.ItemsEnabled or not Settings.autoCurrencyTransfert
        end,
    }

    -------------------------------------------------------------------------
    -- Header: Bank Management
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Bank Management',
        width = 'full',
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly stack all bags
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly stack all bags',
        getFunc = function()
            return Settings.autoStackBag
        end,
        setFunc = function(value)
            Settings.autoStackBag = value
        end,
        width = 'full',
        default = Defaults.autoStackBag,
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly withdraw items for wrist
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Withdraw items for wrist',
        tooltip = 'Automaticaly withdraw items for wrist',
        getFunc = function()
            return Settings.autoWithdrawWristItems
        end,
        setFunc = function(value)
            Settings.autoWithdrawWristItems = value
        end,
        width = 'full',
        default = Defaults.autoWithdrawWristItems,
    }

    -------------------------------------------------------------------------
    -- Header: Junk management
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Junk Management',
        width = 'full',
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly mark items as Junk
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly mark items as Junk',
        getFunc = function()
            return Settings.autoSetJunk
        end,
        setFunc = function(value)
            Settings.autoSetJunk = value
        end,
        width = 'full',
        default = Defaults.autoSetJunk,
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly mark all Treasure as Junk
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly mark all Treasure as Junk',
        getFunc = function()
            return Settings.autoSetTreasureAsJunk
        end,
        setFunc = function(value)
            Settings.autoSetTreasureAsJunk = value
        end,
        width = 'full',
        default = Defaults.autoSetTreasureAsJunk,
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly mark all Trash as Junk
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly mark all Trash as Junk',
        getFunc = function()
            return Settings.autoSetTrashAsJunk
        end,
        setFunc = function(value)
            Settings.autoSetTrashAsJunk = value
        end,
        width = 'full',
        default = Defaults.autoSetTrashAsJunk,
    }

    -------------------------------------------------------------------------
    -- Header: Repair and Recharge Management
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Repair and Recharge Management',
        width = 'full',
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly repair
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly repair',
        getFunc = function()
            return Settings.autoRepair
        end,
        setFunc = function(value)
            Settings.autoRepair = value
        end,
        width = 'full',
        default = Defaults.autoRepair,
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly recharge
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly recharge',
        getFunc = function()
            return Settings.autoRecharge
        end,
        setFunc = function(value)
            Settings.autoRecharge = value
        end,
        width = 'full',
        default = Defaults.autoRecharge,
    }

    -------------------------------------------------------------------------
    --  Miscellaneous Settings
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'header',
        name = 'Miscellaneous Settings',
        width = 'full',
    }

    -------------------------------------------------------------------------
    -- Checkbox: Automaticaly open container
    optionsDataItems[#optionsDataItems + 1] = {
        type = 'checkbox',
        name = 'Automaticaly open container',
        getFunc = function()
            return Settings.autoOpenContainer
        end,
        setFunc = function(value)
            Settings.autoOpenContainer = value
        end,
        width = 'full',
        default = Defaults.autoOpenContainer,
    }

    LAM:RegisterAddonPanel(UUI.name..'ItemsOptions', panelDataItems)
    LAM:RegisterOptionControls(UUI.name..'ItemsOptions', optionsDataItems)
end

Items.CreateSettings = CreateSettings