local UUI = UUI

local Items = UUI.Items

-- ESO API Locals
local GetCurrencyAmount = GetCurrencyAmount
local TransferCurrency = TransferCurrency

local function transfert_currency_to_character(currencyType, toKeep)
    local current = GetCurrencyAmount(currencyType, CURRENCY_LOCATION_CHARACTER)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    end
end

function Items.DepositGold()
    if not Items.SV.currencyDepositEnabled then return end

    transfert_currency_to_character(CURT_MONEY, Items.SV.goldToKeep)
    transfert_currency_to_character(CURT_TELVAR_STONES, Items.SV.telvarToKeep)
    transfert_currency_to_character(CURT_ALLIANCE_POINTS, Items.SV.alliancePointsToKeep)
end