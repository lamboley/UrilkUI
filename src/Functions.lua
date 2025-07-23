local UUI = UUI

-----------------------------------------------------------------------------
-- Lua Locals
local table_concat = table.concat
local string_format = string.format
local select = select

-----------------------------------------------------------------------------
-- ESO API Locals
local eventManager = GetEventManager()
local HasLFGReadyCheckNotification, AcceptLFGReadyCheckNotification = HasLFGReadyCheckNotification, AcceptLFGReadyCheckNotification
local GetBagSize = GetBagSize
local GetNumBuffs = GetNumBuffs
local GetAntiquityLeadTimeRemainingSeconds, GetZoneNameById, GetAntiquityZoneId = GetAntiquityLeadTimeRemainingSeconds, GetZoneNameById, GetAntiquityZoneId

do
    local function PrintMessage(line)
        if line then
            -- CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ': ', line}))
            CHAT_SYSTEM:AddMessage(string_format("|cFFFFFF%s|r: %s", UUI.name, line))
        end
    end

    UUI.PrintMessage = PrintMessage
end

do
    local function PrintDebug(text)
        if text then
            d(string_format(">|cffffff%s|r", text))
        end
    end

    UUI.PrintDebug = PrintDebug
end

do
    --- Return the slot index of an item in the bagpack using his name.
    -- return nil if no index found.
    -- @string name item's name
    -- @treturn number index slot
    local function GetSlotIndexFromNameInBackpack(name)
        if not name then return end

        for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
            if slotData and slotData.stackCount > 0 and slotData.name == name then
                return slotIndex
            end
        end
        return
    end

    UUI.GetSlotIndexFromNameInBackpack = GetSlotIndexFromNameInBackpack
end

do
    --- Check if a buff is already present on the player based on the id
    -- @int id id of a buff
    -- @treturn bool
    local function CheckIfBuffIsPresentById(id)
        if not id then return end

        for i = 1, GetNumBuffs('player') do
            local buffId = select(11, GetUnitBuffInfo('player', i))
            if buffId and buffId == id then
                return true
            end
        end
        return
    end

    UUI.CheckIfBuffIsPresentById = CheckIfBuffIsPresentById
end

do
    local function CheckLeadTime()
        local antiquityId = GetNextAntiquityId()
        while antiquityId do
            local leadExpirationTimeS = GetAntiquityLeadTimeRemainingSeconds(antiquityId)
            if leadExpirationTimeS > 0 and leadExpirationTimeS < 86400 then
                UUI.PrintMessage('Leads will expire in |c00FF00' .. GetZoneNameById(GetAntiquityZoneId(antiquityId)) .. '|r')
            end
            antiquityId = GetNextAntiquityId(antiquityId)
        end
    end

    UUI.CheckLeadTime = CheckLeadTime
end

do
    local function OnActivityFinderStatusUpdate(_, status)
        if status == ACTIVITY_FINDER_STATUS_READY_CHECK and HasLFGReadyCheckNotification() then
            AcceptLFGReadyCheckNotification()
        end
    end

    UUI.OnActivityFinderStatusUpdate = OnActivityFinderStatusUpdate
end