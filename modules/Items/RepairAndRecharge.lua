local UUI = UUI

local PrintMessage = UUI.PrintMessage
local GetSlotIndexFromNameInBackpack = UUI.GetSlotIndexFromNameInBackpack
local Items = UUI.Items

-- ESO API Locals
local DoesItemHaveDurability = DoesItemHaveDurability
local GetItemCondition = GetItemCondition
local RepairItemWithRepairKit = RepairItemWithRepairKit
local GetBagSize = GetBagSize

-- local function GetRepairKitSlotIndex()
--     for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
--         local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
--         if slotData and slotData.stackCount > 0 and slotData.name == 'Equipment Repair Kit' then
--             return slotIndex
--         end
--     end
--     return
-- end

-- local function GetSoulGemSlotIndex()
--     for slotIndex = 0, GetBagSize(BAG_BACKPACK) - 1 do
--         local slotData = SHARED_INVENTORY:GenerateSingleSlotData(BAG_BACKPACK, slotIndex)
--         if slotData and slotData.stackCount > 0 and slotData.name == 'Soul Gem' then
--             return slotIndex
--         end
--     end
--     return
-- end

local function RepairSingleSlot(toto, bagId, slotIndex)
    if not Items.SV.autoRepairEnabled then return end

    if DoesItemHaveDurability(bagId, slotIndex) then
        local condition = GetItemCondition(bagId, slotIndex)
        if condition < 20 then
            local kitIndex = GetSlotIndexFromNameInBackpack('Equipment Repair Kit')
            if kitIndex then
                RepairItemWithRepairKit(bagId, slotIndex, BAG_BACKPACK, kitIndex)
            else
                PrintMessage("Tried to repair but you don't have any 'Equipment Repair Kit'")
            end
        end
    end
end

local function ChargeWeapon(_, bagId, slotIndex)
    if not Items.SV.autoRechargeEnabled then return end

    if IsItemChargeable(bagId, slotIndex) then
        local charges = GetChargeInfoForItem(bagId, slotIndex)
        if charges < 20 then
            local soulGemIndex = GetSlotIndexFromNameInBackpack('Soul Gem')
            if soulGemIndex then
                ChargeItemWithSoulGem(bagId, slotIndex, BAG_BACKPACK, soulGemIndex)
            else
                PrintMessage("Tried to recharge but you don't have any 'Soul Gem'")
            end
        end
    end
end

Items.RepairSingleSlot = RepairSingleSlot
Items.ChargeWeapon = ChargeWeapon