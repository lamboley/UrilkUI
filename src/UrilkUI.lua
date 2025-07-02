UUI = {}
-- UUI.__index = UUI

local UUI = UUI

UUI.tag = 'UUI'
UUI.name = 'UrilkUI'
UUI.version = "0.0.1"
UUI.author = 'Urilk'

UUI.LAM = LibAddonMenu2 or error('LibAddonMenu2 is not initialized', 2)

UUI.SV = {}
UUI.SVVer = 2
UUI.SVName = 'UUISV'

UUI.Defaults = {
    debug = false,
    AurasEnabled = true,
    ItemsEnabled = true,
}