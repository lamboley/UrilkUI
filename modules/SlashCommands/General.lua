local UUI = UUI

local println = UUI.println
local debugln = UUI.debugln

local SlashCommands = UUI.SlashCommands

function SlashCommands.SlashShowSlashCommands(option)
    println('SLASH', option)
end
