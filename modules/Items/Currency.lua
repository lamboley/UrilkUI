local UUI = UUI

local Items = UUI.Items

-- ESO API Locals
local GetCurrencyAmount = GetCurrencyAmount
local TransferCurrency = TransferCurrency

local CURT_MONEY = CURT_MONEY
local CURT_TELVAR_STONES = CURT_TELVAR_STONES
local CURT_ALLIANCE_POINTS = CURT_ALLIANCE_POINTS

local function TransfertCurrencyToCharacter(currencyType, toKeep)
    local current = GetCurrencyAmount(currencyType, CURRENCY_LOCATION_CHARACTER)
    if current > toKeep then
        TransferCurrency(currencyType, current-toKeep, CURRENCY_LOCATION_CHARACTER, CURRENCY_LOCATION_BANK)
    end
end

local function DepositGold()
    if not Items.SV.currencyDepositEnabled then return end

    TransfertCurrencyToCharacter(CURT_MONEY, Items.SV.goldToKeep)
    TransfertCurrencyToCharacter(CURT_TELVAR_STONES, Items.SV.telvarToKeep)
    TransfertCurrencyToCharacter(CURT_ALLIANCE_POINTS, Items.SV.alliancePointsToKeep)
end

Items.DepositGold = DepositGold