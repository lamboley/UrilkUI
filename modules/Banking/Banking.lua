---@class (partial) UrilkUI
local UrilkUI = UrilkUI

-- ESO APIs
local eventManager = GetEventManager()

local moduleName = UrilkUI.name .. 'Banking'

---@class (partial) UrilkUI.Banking
local Banking = {}
Banking.__index = Banking
UrilkUI.Banking = Banking

Banking.Defaults = {
    --- _Bank
    autoCurrencyTransfert = true,
    amountGoldInInventory = 250,
    amountAlliancePointsInInventory = 0,
    amountTelvarInInventory = 0,
    amountWritInInventory = 0,
    autoWithdrawWristItems = true,
    autoStackBag = true,
}

Banking.SV = {}
Banking.moduleName = moduleName

local function LoadSavedVars()
    Banking.SV = ZO_SavedVars:NewAccountWide(UrilkUI.SVName, UrilkUI.SVVer, 'Banking', Banking.Defaults)
end

local function RegisterEvents()
    if Banking.SV.autoCurrencyTransfert then
        eventManager:RegisterForEvent(moduleName .. 'ExecuteTransfertCurrency', EVENT_OPEN_BANK, Banking.ExecuteTransfertCurrency)
    end

    if Banking.SV.autoWithdrawWristItems then
        eventManager:RegisterForEvent(moduleName .. 'TransfertItem', EVENT_OPEN_BANK, Banking.TransfertItem)
    end
end

function Banking.Initialize(enabled)
    LoadSavedVars()

    if enabled then
        RegisterEvents()
    end
end