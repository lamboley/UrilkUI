local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local Alerts = UUI.Alerts
local Auras = UUI.Auras
local Items = UUI.Items
local Banking = UUI.Banking
local LAM = UUI.LAM

local function CreateSettings()
    local Defaults = UUI.Defaults
    local Settings = UUI.SV

    local optionsData = {}
    local optionsDataAuras = {}
    local optionsDataItems = {}
    local optionsDataBanking = {}

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

    -------------------------------------------------------------------------
    --  Description: Do things related to auras.
    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Do things related to auras.',
    }

    -------------------------------------------------------------------------
    --  Module: Banking
    optionsData[#optionsData + 1] = {
        type = 'checkbox',
        name = 'Banking Module',
        getFunc = function ()
            return Settings.BankingEnabled
        end,
        setFunc = function (value)
            Settings.BankingEnabled = value
        end,
        width = 'half',
        warning = 'This will need a reaload to take effect.',
        default = Defaults.BankingEnabled,
    }

    -------------------------------------------------------------------------
    --  Description: Do things related to banking.
    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Do things related to banking.',
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

    -------------------------------------------------------------------------
    --  Description: Do things related to items.
    optionsData[#optionsData + 1] = {
        type = 'description',
        width = 'half',
        text = 'Do things related to items.',
    }

    if UUI.SV.AurasEnabled then
        -------------------------------------------------------------------------
        -- Submenu: Auras
        optionsData[#optionsData + 1] = {
            type = 'submenu',
            name = 'Auras Module',
            controls = optionsDataAuras
        }

        -------------------------------------------------------------------------
        -- Submenu: Auras - Header: Food&Drink Management
        optionsDataAuras[#optionsDataAuras + 1] = {
            type = 'header',
            name = 'Food&Drink Management',
            width = 'full',
        }

        -------------------------------------------------------------------------
        -- Submenu: Auras - Editbox: Which food&drink to consumme
        optionsDataAuras[#optionsDataAuras + 1] = {
            type = 'editbox',
            name = 'Which food&drink to consumme',
            getFunc = function ()
                return Auras.SV.autoFoodName
            end,
            setFunc = function (value)
                Auras.SV.autoFoodName = value
            end,
            width = 'full',
            default = Auras.Defaults.autoFoodName,
        }

        -------------------------------------------------------------------------
        -- Submenu: Auras - Header: Crux
        optionsDataAuras[#optionsDataAuras + 1] = {
            type = 'header',
            name = 'Crux',
            width = 'full',
        }

        -------------------------------------------------------------------------
        -- Submenu: Auras - Checkbox: Hide when not in combat
        optionsDataAuras[#optionsDataAuras + 1] = {
            type = 'checkbox',
            name = 'Hide when not in combat',
            getFunc = function()
                return Auras.SV.hideNotInCombat
            end,
            setFunc = function(value)
                Auras.SV.hideNotInCombat = value
            end,
            width = 'full',
            default = Auras.Defaults.hideNotInCombat,
        }
    end

    if UUI.SV.BankingEnabled then
        -------------------------------------------------------------------------
        -- Submenu: Banking
        optionsData[#optionsData + 1] = {
            type = 'submenu',
            name = 'Banking Module',
            controls = optionsDataBanking
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Header: Currency Management
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'header',
            name = 'Currency Management',
            width = 'full',
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Checkbox: Automaticaly deposit currency in Bank
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'checkbox',
            name = 'Automaticaly deposit currency in Bank',
            getFunc = function()
                return Banking.SV.autoCurrencyTransfert
            end,
            setFunc = function(value)
                Banking.SV.autoCurrencyTransfert = value
            end,
            width = 'full',
            default = Banking.Defaults.autoCurrencyTransfert,
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Slider: Gold to keep
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'slider',
            name = 'Gold to keep',
            tooltip = 'How much Gold to keep in inventory',
            min = 0,
            max = 100000,
            step = 100,
            getFunc = function()
                return Banking.SV.amountGoldInInventory
            end,
            setFunc = function(value)
                Banking.SV.amountGoldInInventory = value
            end,
            width = 'full',
            default = Banking.Defaults.amountGoldInInventory,
            disabled = function()
                return not UUI.SV.ItemsEnabled or not Banking.SV.autoCurrencyTransfert
            end,
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Slider: Alliance Points to keep
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'slider',
            name = 'Alliance Points to keep',
            tooltip = 'How much Alliance Points to keep in inventory',
            min = 0,
            max = 100000,
            step = 100,
            getFunc = function()
                return Banking.SV.amountAlliancePointsInInventory
            end,
            setFunc = function(value)
                Banking.SV.amountAlliancePointsInInventory = value
            end,
            width = 'full',
            default = Banking.Defaults.amountAlliancePointsInInventory,
            disabled = function()
                return not UUI.SV.ItemsEnabled or not Banking.SV.autoCurrencyTransfert
            end,
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Slider: Tel Var stones to keep
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'slider',
            name = 'Tel Var stones to keep',
            tooltip = 'How much Tel Var stones to keep in inventory',
            min = 0,
            max = 100000,
            step = 100,
            getFunc = function()
                return Banking.SV.amountTelvarInInventory
            end,
            setFunc = function(value)
                Banking.SV.amountTelvarInInventory = value
            end,
            width = 'full',
            default = Banking.Defaults.amountTelvarInInventory,
            disabled = function()
                return not UUI.SV.ItemsEnabled or not Banking.SV.autoCurrencyTransfert
            end,
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Slider: Wrist Vouchers to keep
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'slider',
            name = 'Wrist Vouchers to keep',
            tooltip = 'How much wrist Vouchers to keep in inventory',
            min = 0,
            max = 100000,
            step = 100,
            getFunc = function()
                return Banking.SV.amountWritInInventory
            end,
            setFunc = function(value)
                Banking.SV.amountWritInInventory = value
            end,
            width = 'full',
            default = Banking.Defaults.amountWritInInventory,
            disabled = function()
                return not UUI.SV.ItemsEnabled or not Banking.SV.autoCurrencyTransfert
            end,
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Header: Bank Management
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'header',
            name = 'Bank Management',
            width = 'full',
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Checkbox: Automaticaly stack all bags
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'checkbox',
            name = 'Automaticaly stack all bags',
            getFunc = function()
                return Banking.SV.autoStackBag
            end,
            setFunc = function(value)
                Banking.SV.autoStackBag = value
            end,
            width = 'full',
            default = Banking.Defaults.autoStackBag,
        }

        -------------------------------------------------------------------------
        -- Submenu: Banking - Checkbox: Automaticaly withdraw items for wrist
        optionsDataBanking[#optionsDataBanking + 1] = {
            type = 'checkbox',
            name = 'Withdraw items for wrist',
            tooltip = 'Automaticaly withdraw items for wrist',
            getFunc = function()
                return Banking.SV.autoWithdrawWristItems
            end,
            setFunc = function(value)
                Banking.SV.autoWithdrawWristItems = value
            end,
            width = 'full',
            default = Banking.Defaults.autoWithdrawWristItems,
        }
    end

    if UUI.SV.ItemsEnabled then
        -------------------------------------------------------------------------
        -- Submenu: Items
        optionsData[#optionsData + 1] = {
            type = 'submenu',
            name = 'Items Module',
            controls = optionsDataItems
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Header: Junk management
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'header',
            name = 'Junk Management',
            width = 'full',
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Checkbox: Automaticaly mark items as Junk
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'checkbox',
            name = 'Automaticaly mark items as Junk',
            getFunc = function()
                return Items.SV.autoSetJunk
            end,
            setFunc = function(value)
                Items.SV.autoSetJunk = value
            end,
            width = 'full',
            default = Items.Defaults.autoSetJunk,
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Checkbox: Automaticaly mark all Treasure as Junk
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'checkbox',
            name = 'Automaticaly mark all Treasure as Junk',
            getFunc = function()
                return Items.SV.autoSetTreasureAsJunk
            end,
            setFunc = function(value)
                Items.SV.autoSetTreasureAsJunk = value
            end,
            width = 'full',
            default = Items.Defaults.autoSetTreasureAsJunk,
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Checkbox: Automaticaly mark all Trash as Junk
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'checkbox',
            name = 'Automaticaly mark all Trash as Junk',
            getFunc = function()
                return Items.SV.autoSetTrashAsJunk
            end,
            setFunc = function(value)
                Items.SV.autoSetTrashAsJunk = value
            end,
            width = 'full',
            default = Items.Defaults.autoSetTrashAsJunk,
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Header: Repair and Recharge Management
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'header',
            name = 'Repair and Recharge Management',
            width = 'full',
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Checkbox: Automaticaly repair
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'checkbox',
            name = 'Automaticaly repair',
            getFunc = function()
                return Items.SV.autoRepair
            end,
            setFunc = function(value)
                Items.SV.autoRepair = value
            end,
            width = 'full',
            default = Items.Defaults.autoRepair,
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Checkbox: Automaticaly recharge
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'checkbox',
            name = 'Automaticaly recharge',
            getFunc = function()
                return Items.SV.autoRecharge
            end,
            setFunc = function(value)
                Items.SV.autoRecharge = value
            end,
            width = 'full',
            default = Items.Defaults.autoRecharge,
        }

        -------------------------------------------------------------------------
        --  Submenu: Items - Miscellaneous Settings
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'header',
            name = 'Miscellaneous Settings',
            width = 'full',
        }

        -------------------------------------------------------------------------
        -- Submenu: Items - Checkbox: Automaticaly open container
        optionsDataItems[#optionsDataItems + 1] = {
            type = 'checkbox',
            name = 'Automaticaly open container',
            getFunc = function()
                return Items.SV.autoOpenContainer
            end,
            setFunc = function(value)
                Items.SV.autoOpenContainer = value
            end,
            width = 'full',
            default = Items.Defaults.autoOpenContainer,
        }
    end

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