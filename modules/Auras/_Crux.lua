local UUI = UUI

-----------------------------------------------------------------------------
-- Addon Locals
local PrintMessage = UUI.PrintMessage
local Auras = UUI.Auras

-----------------------------------------------------------------------------
-- Lua Locals
local math_rad = math.rad

-----------------------------------------------------------------------------
-- ESO API Locals
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()

local cruxStacks = 0

local function OnSceneChange(_, scene)
    if scene == SCENE_SHOWN then
        AurasContainer:SetHidden(false)
    else
        AurasContainer:SetHidden(true)
    end
end

local function OnUpdate()
    for i=1, 3 do
        local cruxFill = AurasContainer:GetNamedChild('cruxFill'..i)
        if cruxStacks >= i then
            cruxFill:SetColor(0,1,0,1)
        else
            cruxFill:SetColor(1,1,1,0.5)
        end
        if not IsUnitInCombat('player') and Auras.SV.hideNotInCombat then
            cruxFill:SetHidden(true)
        else
            cruxFill:SetHidden(false)
        end
    end
end

local function OnEffectChangedCruxStack(_, result, _, _, _, _, _, stacks)
    if result == EFFECT_RESULT_FADED then
        cruxStacks = 0
        return
    end
    cruxStacks = stacks
end

local function CreateCruxTexture()
    local AurasContainer = windowManager:CreateTopLevelWindow('AurasContainer')

    AurasContainer:SetMovable(false)
    AurasContainer:SetMouseEnabled(true)
    AurasContainer:SetHidden(false)
    AurasContainer:SetDimensions(140, 180)

    local rotations = { 180, 180, 180 }
    local additionalMovement = { 0, 0, 0 }

    for i=1, 3 do
        local cruxFill = windowManager:CreateControl("$(parent)cruxFill"..i, AurasContainer, CT_TEXTURE, 4)
        cruxFill:SetDimensions(80, 80)
        cruxFill:SetAnchor(BOTTOMLEFT, AurasContainer, BOTTOMLEFT, 0 + additionalMovement[i], -65 * i)
        cruxFill:SetTexture("esoui/art/icons/class/gamepad/gp_class_arcanist.dds")
        cruxFill:SetDrawLayer(1)
        cruxFill:SetTransformRotationZ(math_rad(rotations[i]))
    end

    local width, height = GuiRoot:GetDimensions()

    AurasContainer:ClearAnchors()
    AurasContainer:SetAnchor(BOTTOMLEFT, GuiRoot, CENTER, width/11, height/6)

    sceneManager:GetScene('hud'):RegisterCallback('StateChange', OnSceneChange)
    sceneManager:GetScene('hudui'):RegisterCallback('StateChange', OnSceneChange)
end

Auras.CreateCruxTexture = CreateCruxTexture
Auras.OnEffectChangedCruxStack = OnEffectChangedCruxStack
Auras.OnUpdate = OnUpdate