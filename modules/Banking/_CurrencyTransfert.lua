---@class (partial) UrilkUI
local UrilkUI = UrilkUI

---@class (partial) UrilkUI.Banking
local Banking = UrilkUI.Banking

-- ESO APIs
local TransferCurrency, GetCurrencyAmount = TransferCurrency, GetCurrencyAmount

---@param currencyType number
---@param toKeep number
---@param source number
---@param destination number
local function DoTransfertCurrency(currencyType, toKeep, source, destination)
    local current = GetCurrencyAmount(currencyType, source)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, source, destination)
    end
end

function Banking.ExecuteTransfertCurrency()
    DoTransfertCurrency(CURT_MONEY, Banking.SV.amountGoldInInventory, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    DoTransfertCurrency(CURT_TELVAR_STONES, Banking.SV.amountTelvarInInventory, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    DoTransfertCurrency(CURT_ALLIANCE_POINTS, Banking.SV.amountAlliancePointsInInventory, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
end
