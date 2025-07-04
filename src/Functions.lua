local UUI = UUI

-- Lua Locals
local table_concat = table.concat

-- https://esoapi.uesp.net/100013/data/a/d/d/AddMessage.html
do
    local function println(prefix, line, ...)
        CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ' - ', prefix or 'General', ": ", line, ...}))
    end

    UUI.println = println
end

do
    local function debugln(prefix, line, ...)
         if UUI.SV.debug then
            CHAT_SYSTEM:AddMessage(table_concat({UUI.name, ' - ', prefix or 'General', ": ", line, ...}))
        end
    end

    UUI.debugln = debugln
end