local UUI = UUI
local Auras = {}
UUI.Auras = Auras

local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()

local LAM = UUI.LAM

Auras.SV = {}

Auras.Defaults = {
    name = 'Auras',
    stacks = 0,
}

local function onSceneChange(_, scene)
    if scene == SCENE_SHOWN then
        AurasContainer:SetHidden(false)
    else
        AurasContainer:SetHidden(true)
    end
end

function Auras.Initialize(enabled)
    Auras.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'Auras', Auras.Defaults)
    if not enabled or GetUnitClassId('player') ~= 117 then
        return
    end

    local AurasContainer = windowManager:CreateTopLevelWindow('AurasContainer')

    AurasContainer:SetMovable(false)
    AurasContainer:SetMouseEnabled(true)
    AurasContainer:SetHidden(false)
    AurasContainer:SetDimensions(140, 180)

    local width, height = GuiRoot:GetDimensions()

    local rotations = {
        180, 180, 180
    }

    local additionalMovement = {
        0, 0, 0
    }

    for i=1, 3 do
        local cruxFill = windowManager:CreateControl("$(parent)cruxFill" .. i, AurasContainer, CT_TEXTURE, 4)
        cruxFill:SetDimensions(80, 80)
        cruxFill:SetAnchor(BOTTOMLEFT, AurasContainer, BOTTOMLEFT, 0 + additionalMovement[i], -65 * i)
        cruxFill:SetTexture("esoui/art/icons/class/gamepad/gp_class_arcanist.dds")
        cruxFill:SetDrawLayer(1)
        cruxFill:SetTransformRotationZ(math.rad(rotations[i]))
    end

    AurasContainer:ClearAnchors()
    AurasContainer:SetAnchor(BOTTOMLEFT, GuiRoot, CENTER, width/11, height/6)

    sceneManager:GetScene('hud'):RegisterCallback('StateChange', onSceneChange)
    sceneManager:GetScene('hudui'):RegisterCallback('StateChange', onSceneChange)

    eventManager:RegisterForEvent("Auras.registerEventCruxUpdated", EVENT_EFFECT_CHANGED, function(_, result, _, _, _, _, _, stacks)
        if result == EFFECT_RESULT_FADED then
            Auras.SV.stacks = 0
            return
        end
        Auras.SV.stacks = stacks
    end)

    eventManager:AddFilterForEvent("Auras.registerEventCruxUpdated", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, 184220)
    eventManager:AddFilterForEvent("Auras.registerEventCruxUpdated", EVENT_EFFECT_CHANGED, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)

    eventManager:RegisterForUpdate('Auras.Update', 100, function()
        for i=1, 3 do
            local cruxFill = AurasContainer:GetNamedChild('cruxFill' .. i)
            if Auras.SV.stacks >= i then
                -- cruxFill:SetHidden(false)
                cruxFill:SetColor(0,1,0,1)
            else
                -- cruxFill:SetHidden(true)
                cruxFill:SetColor(1,1,1,0.5)
            end
        end
    end)
end
