
local UUI = UUI
local CruxTracker = UUI.CruxTracker

local zo_strformat = zo_strformat

local LAM = UUI.LAM

function CruxTracker.CreateSettings()
    if not UUI.SV.CruxTrackerEnabled then
        return
    end

    local Defaults = CruxTracker.Defaults
    local Settings = CruxTracker.SV

    local panelDataCruxTracker = {
        type = 'panel',
        name = zo_strformat("<<1>> - <<2>>", UUI.name, 'CruxTracker'),
        displayName = zo_strformat("<<1>> <<2>>", UUI.name, 'CruxTracker'),
        author = UUI.author .. "\n",
        version = UUI.version,
        -- slashCommand = "/luiip",
        registerForRefresh = true,
        registerForDefaults = true,
    }

    local optionsDataCruxTracker = {}

    optionsDataCruxTracker[#optionsDataCruxTracker + 1] = {
        type = 'description',
        text = 'Show 3 triangle which represent crux.',
    }

    optionsDataCruxTracker[#optionsDataCruxTracker + 1] = {
        type = 'button',
        name = 'ReloadUI',
        tooltip = 'ReloadUI',
        func = function ()
            ReloadUI('ingame')
        end,
        width = 'full',
    }

    LAM:RegisterAddonPanel(UUI.name .. 'CruxTrackerOptions', panelDataCruxTracker)
    LAM:RegisterOptionControls(UUI.name .. 'CruxTrackerOptions', optionsDataCruxTracker)
end
