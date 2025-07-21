local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local GetSlotIndexFromNameInBackpack = UUI.GetSlotIndexFromNameInBackpack
local Items = UUI.Items
local PrintMessage = UUI.PrintMessage

-----------------------------------------------------------------------------
-- ESO API Locals
local DoesItemHaveDurability, GetItemCondition = DoesItemHaveDurability, GetItemCondition
local RepairItemWithRepairKit = RepairItemWithRepairKit
local IsItemChargeable, GetChargeInfoForItem = IsItemChargeable, GetChargeInfoForItem
local ChargeItemWithSoulGem = ChargeItemWithSoulGem

local function RepairSingleSlot(_, bagId, slotIndex)
    if DoesItemHaveDurability(bagId, slotIndex) then
        local condition = GetItemCondition(bagId, slotIndex)
        if condition < 20 then
            local kitIndex = GetSlotIndexFromNameInBackpack('Equipment Repair Kit')
            if kitIndex then
                RepairItemWithRepairKit(bagId, slotIndex, BAG_BACKPACK, kitIndex)
            else
                PrintMessage("No 'Equipment Repair Kit' found in inventory.")
            end
        end
    end
end

local function ChargeWeapon(_, bagId, slotIndex)
    if IsItemChargeable(bagId, slotIndex) then
        local charges = GetChargeInfoForItem(bagId, slotIndex)
        if charges < 20 then
            local soulGemIndex = GetSlotIndexFromNameInBackpack('Soul Gem')
            if soulGemIndex then
                ChargeItemWithSoulGem(bagId, slotIndex, BAG_BACKPACK, soulGemIndex)
            else
                PrintMessage("No 'Soul Gem' found in inventory.")
            end
        end
    end
end

Items.RepairSingleSlot = RepairSingleSlot
Items.ChargeWeapon = ChargeWeapon