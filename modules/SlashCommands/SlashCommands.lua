local UUI = UUI

local SlashCommands = {}
UUI.SlashCommands = SlashCommands

SlashCommands.SV = {}
SlashCommands.Defaults = {
    name = 'SlashCommands',
}

function SlashCommands.Initialize(enabled)
    if not enabled then return end

    SlashCommands.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'SlashCommands', SlashCommands.Defaults)

    if SlashCommands.SlashShowSlashCommands then
        SLASH_COMMANDS["/ucmd"] = SlashCommands.SlashShowSlashCommands
    end
end