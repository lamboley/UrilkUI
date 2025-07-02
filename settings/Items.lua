
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

    LAM:RegisterAddonPanel(UUI.name .. 'ItemsOptions', panelDataItems)
    LAM:RegisterOptionControls(UUI.name .. 'ItemsOptions', optionsDataItems)
end
