local UUI = UUI

-- Lua Locals
local table_concat = table.concat

-- -----------------------------------------------------------------------------
-- https://esoapi.uesp.net/100013/data/a/d/d/AddMessage.html
do
    local function println(prefix, line, ...)
        local prefix = prefix or "General"

        CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ' - ', prefix, ": ", line, ...}))
    end

    UUI.println = println
end