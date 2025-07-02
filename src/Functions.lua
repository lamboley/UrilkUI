local UUI = UUI

-- -----------------------------------------------------------------------------
-- https://esoapi.uesp.net/current/src/ingame/chatsystem/chathandlers.lua.html#422
do
    local function AddSystemMessage(messageText)
        CHAT_ROUTER:AddSystemMessage(messageText)
    end

    UUI.AddSystemMessage = AddSystemMessage
end

-- -----------------------------------------------------------------------------
--- currently supports one text and n arguments
do
    local function println(prefix, line, ...)
        local prefix = prefix or "General"

        CHAT_SYSTEM:AddMessage(table.concat({UUI.name, ' - ', prefix, ": ", text, ...}))
    end

    UUI.println = println
end