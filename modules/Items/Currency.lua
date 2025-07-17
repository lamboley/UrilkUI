local UUI = UUI

local println = UUI.println
local Items = UUI.Items

-- ESO API Locals
local GetCurrencyAmount = GetCurrencyAmount
local TransferCurrency = TransferCurrency

local function transfertCurrencyToCharacter(currencyType, toKeep)
    local current = GetCurrencyAmount(currencyType, CURRENCY_LOCATION_CHARACTER)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    end
end

function Items.DepositGold()
    if not Items.SV.currencyDepositEnabled then return end

    transfertCurrencyToCharacter(CURT_MONEY, Items.SV.goldToKeep)
    transfertCurrencyToCharacter(CURT_TELVAR_STONES, Items.SV.telvarToKeep)
    transfertCurrencyToCharacter(CURT_ALLIANCE_POINTS, Items.SV.alliancePointsToKeep)
end