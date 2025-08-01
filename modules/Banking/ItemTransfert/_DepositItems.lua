---@class (partial) UrilkUI
local UrilkUI = UrilkUI

---@class (partial) UrilkUI.Banking
local Banking = UrilkUI.Banking

-- Lua APIs
local next = next

local function GetComparator()
    return function(itemData)
        if itemData then
            if itemData.itemType == ITEMTYPE_GLYPH_ARMOR or itemData.itemType == ITEMTYPE_GLYPH_JEWELRY or itemData.itemType == ITEMTYPE_GLYPH_WEAPON or itemData.itemType == ITEMTYPE_WEAPON or itemData.itemType == ITEMTYPE_ARMOR or itemData.itemType == ITEMTYPE_JEWELRY then
                return true
            end
        end
        return false
    end
end

function Banking.DepositItems()
    local inventoryFullSlotData = SHARED_INVENTORY:GenerateFullSlotData(GetComparator(), BAG_BACKPACK)
    if next(inventoryFullSlotData) ~= nil then
        Banking.MoveItemOneWay(inventoryFullSlotData, 1, 1, nil)
    end
end