local UUI = UUI

local PrintMessage = UUI.PrintMessage
local SlashCommands = UUI.SlashCommands

local function SlashShowSlashCommands(option)
    PrintMessage(option)
end

SlashCommands.SlashShowSlashCommands = SlashShowSlashCommands
