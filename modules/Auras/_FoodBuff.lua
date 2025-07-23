local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local PrintDebug = UUI.PrintDebug
local Auras = UUI.Auras
local GetSlotIndexFromNameInBackpack = UUI.GetSlotIndexFromNameInBackpack
local CheckIfBuffIsPresentById = UUI.CheckIfBuffIsPresentById

-----------------------------------------------------------------------------
-- ESO API Locals
local IsUnitInCombat = IsUnitInCombat
local IsItemUsable = IsItemUsable
local CallSecureProtected = CallSecureProtected

local unitTag = 'player'

local function FoodBuff()
	if IsUnitInCombat(unitTag) then return end

    local desiredBuffId = LibUrilkUIData.buffInfo[Auras.SV.autoFoodName]
    if desiredBuffId then
        if not CheckIfBuffIsPresentById(desiredBuffId) then
            local slotIndex = GetSlotIndexFromNameInBackpack(Auras.SV.autoFoodName)
            if slotIndex and IsItemUsable(BAG_BACKPACK, slotIndex) then
                if IsProtectedFunction('UseItem') then
                    CallSecureProtected('UseItem', BAG_BACKPACK, slotIndex)
                else
                    UseItem(BAG_BACKPACK, slotIndex)
                end
                local itemLink = GetItemLink(BAG_BACKPACK, slotIndex)
                -- PrintMessage('Consummming ' .. itemLink)
            end
        end
    else
        PrintDebug('Missing buffId: ' .. Auras.SV.autoFoodName)
    end
end

Auras.FoodBuff = FoodBuff