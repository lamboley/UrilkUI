---@class (partial) UrilkUI
local UrilkUI = UrilkUI

local CallRequestMoveItem = UrilkUI.CallRequestMoveItem
local PrintMessage = UrilkUI.PrintMessage

---@class (partial) UrilkUI.Banking
local Banking = UrilkUI.Banking

-- Lua APIs
local string_format = string.format

-- ESO APIs
local eventManager = GetEventManager()
local FindFirstEmptySlotInBag, IsESOPlusSubscriber = FindFirstEmptySlotInBag, IsESOPlusSubscriber
local GetItemLink, GetItemId = GetItemLink, GetItemId
local StackBag = StackBag

local moduleName = Banking.moduleName

Banking.soulGemStack = 100
Banking.LockpickStack = 100
Banking.equipmentRepairKitStack = 100

local function DoBagStacking()
    StackBag(BAG_BANK)
    if IsESOPlusSubscriber() then
        StackBag(BAG_SUBSCRIBER_BANK)
    end
    StackBag(BAG_BACKPACK)
end

local function GetEmptySlotAndBag(bagId)
    local targetBagId, firstEmptySlot

    if bagId == BAG_BACKPACK then
        targetBagId = BAG_BANK
        firstEmptySlot = FindFirstEmptySlotInBag(targetBagId)
        if firstEmptySlot == nil and IsESOPlusSubscriber() then
            targetBagId = BAG_SUBSCRIBER_BANK
            firstEmptySlot = FindFirstEmptySlotInBag(targetBagId)
        end
    elseif bagId == BAG_BANK or (bagId == BAG_SUBSCRIBER_BANK and IsESOPlusSubscriber()) then
        targetBagId = BAG_BACKPACK
        firstEmptySlot = FindFirstEmptySlotInBag(targetBagId)
    end

    return targetBagId, firstEmptySlot
end

local function GetStackCount(itemData, stack, toKeep)
    if stack == nil and toKeep ~= nil then
        return itemData.stackCount-toKeep
    elseif stack ~= nil and toKeep == nil then
        return stack
    else
        return itemData.stackCount
    end
end

function Banking.MoveItemOneWay(cacheBank, startIndex, stack, toKeep)
    local itemData = cacheBank[startIndex]

    local targetBagId, firstEmptySlot = GetEmptySlotAndBag(itemData.bagId)

    if targetBagId ~= nil and firstEmptySlot ~= nil then
        local itemLink = GetItemLink(itemData.bagId, itemData.slotIndex)
        if itemLink ~= '' then
            local amount = GetStackCount(itemData, stack, toKeep)
            CallRequestMoveItem(itemData.bagId, itemData.slotIndex, targetBagId, firstEmptySlot, amount, itemLink)

            local identifier = string_format("%sExecuteTransfert%i%i", moduleName, itemData.bagId, itemData.slotIndex)
            eventManager:RegisterForUpdate(identifier, 50,
                function()
                    if GetItemId(targetBagId, firstEmptySlot) > 0 then
                        eventManager:UnregisterForUpdate(identifier)

                        local newStartIndex = startIndex + 1
                        if newStartIndex <= #cacheBank then
                            Banking.MoveItemOneWay(cacheBank, newStartIndex, stack, toKeep)
                        end
                    end
                end
            )
        else
            -- PrintMessage('Failed to transfert 1x item')
        end
    else
        if Banking.SV.autoStackBag then DoBagStacking() end
        -- PrintMessage('No space left')
    end
end

function Banking.TransfertItem()
    Banking.WithdrawWrist()
    Banking.DepositItems()
    Banking.KeepAmount()
end