---@class (partial) UrilkUI
local UrilkUI = UrilkUI

local PrintMessage = UrilkUI.PrintMessage

-- ESO APIs
local GetNextAntiquityId, GetAntiquityLeadTimeRemainingSeconds = GetNextAntiquityId, GetAntiquityLeadTimeRemainingSeconds
local GetZoneNameById = GetZoneNameById
local AcceptLFGReadyCheckNotification = AcceptLFGReadyCheckNotification
local IsProtectedFunction, CallSecureProtected = IsProtectedFunction, CallSecureProtected
local FindFirstEmptySlotInBag = FindFirstEmptySlotInBag
local GetItemName = GetItemName

do
    ---Return the slot index of an item in the bagpack using his name.
    ---@param name string
    ---@return number|boolean
    local function GetSlotIndexFromNameInBackpack(name)
        if not name then
            return false
        end

        for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
            local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
            if slotData and slotData.stackCount > 0 and slotData.name == name then
                return slotIndex
            end
        end
        return false
    end

    UrilkUI.GetSlotIndexFromNameInBackpack = GetSlotIndexFromNameInBackpack
end

do
    local function CheckLeadTime()
        local antiquityId = GetNextAntiquityId()
        while antiquityId do
            local leadExpirationTimeS = GetAntiquityLeadTimeRemainingSeconds(antiquityId)
            if leadExpirationTimeS > 0 and leadExpirationTimeS < 86400 then
                PrintMessage('1x Lead will expire in |c00FF00' .. GetZoneNameById(GetAntiquityZoneId(antiquityId)) .. '|r')
            end
            antiquityId = GetNextAntiquityId(antiquityId)
        end
    end

    UrilkUI.CheckLeadTime = CheckLeadTime
end

do
    local function OnActivityFinderStatusUpdate(_, status)
        if status == ACTIVITY_FINDER_STATUS_READY_CHECK and HasLFGReadyCheckNotification() then
            AcceptLFGReadyCheckNotification()
        end
    end

    UrilkUI.OnActivityFinderStatusUpdate = OnActivityFinderStatusUpdate
end

do
    ---@param bagId number
    ---@return boolean
    local function IsSpaceLeftInBag(bagId)
        if FindFirstEmptySlotInBag(bagId) then
            return true
        else
            return false
        end
    end

    UrilkUI.IsSpaceLeftInBag = IsSpaceLeftInBag
end

do
    ---@param bagId number
    ---@param slotIndex number
    ---@return boolean
    local function IsSlotEmpty(bagId, slotIndex)
        if GetItemName(bagId, slotIndex) == '' then
            return true
        end
        return false
    end

    UrilkUI.IsSlotEmpty = IsSlotEmpty
end

do
    local function CallUseItem(bagId, slotIndex)
        if IsProtectedFunction('UseItem') then
            CallSecureProtected('UseItem', bagId, slotIndex)
        else
            UseItem(bagId, slotIndex)
        end
    end

    UrilkUI.CallUseItem = CallUseItem
end

do
    local function CallRequestMoveItem(sourceBagId, sourceSlotIndex, targetBagId, targetSlotIndex, stack)
        if IsProtectedFunction('RequestMoveItem') then
            CallSecureProtected('RequestMoveItem', sourceBagId, sourceSlotIndex, targetBagId, targetSlotIndex, stack)
        else
            RequestMoveItem(sourceBagId, sourceSlotIndex, targetBagId, targetSlotIndex, stack)
        end
    end

    UrilkUI.CallRequestMoveItem = CallRequestMoveItem
end

