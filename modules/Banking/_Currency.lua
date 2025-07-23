local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local Banking = UUI.Banking

-----------------------------------------------------------------------------
-- ESO API Locals
local GetCurrencyAmount, TransferCurrency = GetCurrencyAmount, TransferCurrency

local function TransfertCurrencyToBank(currencyType, toKeep)
    local current = GetCurrencyAmount(currencyType, CURRENCY_LOCATION_CHARACTER)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    end
end

local function ExecuteTransfertCurrency()
    if Banking.SV.autoCurrencyTransfert then
        TransfertCurrencyToBank(CURT_MONEY, Banking.SV.amountGoldInInventory)
        TransfertCurrencyToBank(CURT_TELVAR_STONES, Banking.SV.amountTelvarInInventory)
        TransfertCurrencyToBank(CURT_ALLIANCE_POINTS, Banking.SV.amountAlliancePointsInInventory)
    end
end

Banking.ExecuteTransfertCurrency = ExecuteTransfertCurrency