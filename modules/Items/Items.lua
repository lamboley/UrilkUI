local UUI = UUI
local Items = {}
UUI.Items = Items

local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()

local LAM = UUI.LAM

local AddSystemMessage = UUI.AddSystemMessage
local println = UUI.println

Items.SV = {}

Items.Defaults = {
    name = 'Items',
}

local function OnBankOpen(eventCode, bankBag)
    println('ITEMS', 'EVENT_OPEN_BANK')
    -- PAB.depositOrWithdrawCurrencies()
    -- executeBankingItemTransfers()
end

function Items.Initialize(enabled)
    Items.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Items', Items.Defaults)
    if not enabled then
        return
    end

    eventManager:RegisterForEvent("Items.OpenBank", EVENT_OPEN_BANK, OnBankOpen)
end