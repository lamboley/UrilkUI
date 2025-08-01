---@class (partial) UrilkUI
local UrilkUI = UrilkUI

---@class (partial) UrilkUI.Items
local Items = UrilkUI.Items

-- Lua APIs
local next = next
local pairs = pairs

-- ESO APIs
local HasAnyJunk, SellAllJunk, IsItemJunk, CanItemBeMarkedAsJunk, SetItemIsJunk = HasAnyJunk, SellAllJunk, IsItemJunk, CanItemBeMarkedAsJunk, SetItemIsJunk

function Items.SellJunk()
    if HasAnyJunk(BAG_BACKPACK, true) then
        SellAllJunk()
    end
end

local function CreateJunkComparator()
    return function(itemData)
        if itemData and not IsItemJunk(itemData.bagId, itemData.slotIndex) and CanItemBeMarkedAsJunk(itemData.bagId, itemData.slotIndex) and (LibUrilkUIData.customJunk[itemData.name] or LibUrilkUIData.customJunkId[GetItemId(itemData.bagId, itemData.slotIndex)] or itemData.itemType == ITEMTYPE_TREASURE or itemData.itemType == ITEMTYPE_TRASH) then
            return true
        end
        return false
    end
end

function Items.SetAsJunk()
    local junkCacheBank = SHARED_INVENTORY:GenerateFullSlotData(CreateJunkComparator(), BAG_BACKPACK)
    if next(junkCacheBank) ~= nil then
        for _, slotData in pairs(junkCacheBank) do
            SetItemIsJunk(slotData.bagId, slotData.slotIndex, true)
        end
    end
end