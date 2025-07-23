local UUI = UUI

-----------------------------------------------------------------------------
-- Addons Locals
local PrintMessage = UUI.PrintMessage
local Banking = UUI.Banking

-----------------------------------------------------------------------------
-- Lua Locals
local table_remove = table.remove
local table_insert = table.insert

-----------------------------------------------------------------------------
-- ESO API Locals
local eventManager = GetEventManager()
local GetItemType, GetItemLink, GetItemName = GetItemType, GetItemLink, GetItemName
local GetBagSize, StackBag = GetBagSize, StackBag
local IsESOPlusSubscriber = IsESOPlusSubscriber
local CallSecureProtected, IsProtectedFunction = CallSecureProtected, IsProtectedFunction

local Banking = {}
Banking.moduleName = UUI.name .. 'Banking'
Banking.SV = {}
Banking.Defaults = {
    --- _Bank
    autoCurrencyTransfert = true,
    amountGoldInInventory = 10000,
    amountAlliancePointsInInventory = 0,
    amountTelvarInInventory = 0,
    amountWritInInventory = 0,
    autoWithdrawWristItems = true,
    autoStackBag = true,
}

local function LoadSavedVars()
    Banking.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Banking', Banking.Defaults)
end

local function RegisterEvents()
    eventManager:RegisterForEvent(Banking.moduleName .. 'ExecuteTransfertCurrency', EVENT_OPEN_BANK, Banking.ExecuteTransfertCurrency)
    eventManager:RegisterForEvent(Banking.moduleName .. 'ExecuteTransfertItems', EVENT_OPEN_BANK, Banking.ExecuteTransfertItems)
end

local function Initialize()
    LoadSavedVars()
    RegisterEvents()
end

Banking.Initialize = Initialize
UUI.Banking = Banking