---@class (partial) UrilkUI
---@field __index UrilkUI
---@field Auras UrilkUI.Auras
---@field Banking UrilkUI.Banking
---@field Items UrilkUI.Items
---@field name string The addon name
---@field author string The addon author
---@field version string The addon version
---@field SVName string SavedVariables name
---@field SVVer number SavedVariables version
---@field Defaults UrilkUI_Defaults_SV Default settings
---@field SV UrilkUI_Defaults_SV Current saved variables
UrilkUI = {}
UrilkUI.__index = UrilkUI

---@class (partial) UrilkUI
local UrilkUI = UrilkUI

UrilkUI.name = 'UrilkUI'
UrilkUI.author = 'Urilk'
UrilkUI.version = '0.0.1'

UrilkUI.LAM = LibAddonMenu2 or error("LibAddonMenu2 is not initialized", 2)

UrilkUI.SV = {}
UrilkUI.SVVer = 2
UrilkUI.SVName = 'UrilkUISV'

local LibUrilkUIData = LibUrilkUIData
if not LibUrilkUIData then
    error('LibUrilkUIData is not enabled', 2)
end

---@class UrilkUI_Defaults_SV
UrilkUI.Defaults = {
    -- Modules
    AurasEnabled = true,
    ItemsEnabled = true,
    BankingEnabled = true,
    antiquitiesExpiresEnabled = true,
    LFGEnabled = true,
}

---@param line string
UrilkUI.PrintMessage = function(line)
    CHAT_SYSTEM:AddMessage(string.format("|c9900ff%s|r: %s", UrilkUI.name, line))
end