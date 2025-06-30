local UUI = UUI
local CruxTracker = {}
UUI.CruxTracker = CruxTracker

local eventManager = GetEventManager()
local sceneManager = SCENE_MANAGER
local windowManager = GetWindowManager()

local LAM = UUI.LAM

CruxTracker.SV = {}

CruxTracker.Defaults = {
    name = 'CruxTracker',
    stacks = 0,
}

function CruxTracker.Update()
    for i=1, 3 do
        local cruxFill = CruxTrackerContainer:GetNamedChild('cruxFill' .. i)
        if CruxTracker.SV.stacks >= i then
            cruxFill:SetHidden(false)
        else
            cruxFill:SetHidden(true)
        end
    end
end

local function onSceneChange(_, scene)
    if scene == SCENE_SHOWN then
        CruxTrackerContainer:SetHidden(false)
    else
        CruxTrackerContainer:SetHidden(true)
    end
end

function CruxTracker.Initialize(enabled)
    CruxTracker.SV = ZO_SavedVars:NewAccountWide(UUI.SVName, UUI.SVVer, 'CruxTracker', CruxTracker.Defaults)
    if not enabled or GetUnitClassId('player') ~= 117 then
        return
    end

    local CruxTrackerContainer = windowManager:CreateTopLevelWindow('CruxTrackerContainer')

    CruxTrackerContainer:SetMovable(false)
    CruxTrackerContainer:SetMouseEnabled(true)
    CruxTrackerContainer:SetHidden(false)
    CruxTrackerContainer:SetDimensions(140, 180)

    local width, height = GuiRoot:GetDimensions()

    local rotations = {
        -90, 90, -90
    }

    local additionalMovement = {
        0, -4, 0
    }

    for i=1, 3 do
        local cruxFill = windowManager:CreateControl("$(parent)cruxFill" .. i, CruxTrackerContainer, CT_TEXTURE, 4)
        cruxFill:SetDimensions(150, 150)
        cruxFill:SetAnchor(BOTTOMLEFT, CruxTrackerContainer, BOTTOMLEFT, 0 + additionalMovement[i], -60 * i)
        cruxFill:SetTexture("UrilkUI/media/textures/cruxFill.dds")
        cruxFill:SetHidden(true)
        cruxFill:SetDrawLayer(1)
        cruxFill:SetTransformRotationZ(math.rad(rotations[i]))
    end

    CruxTrackerContainer:ClearAnchors()
    CruxTrackerContainer:SetAnchor(BOTTOMLEFT, GuiRoot, CENTER, width/11, height/6)

    sceneManager:GetScene('hud'):RegisterCallback('StateChange', onSceneChange)
    sceneManager:GetScene('hudui'):RegisterCallback('StateChange', onSceneChange)

    eventManager:RegisterForEvent("CruxTracker.registerEventCruxUpdated", EVENT_EFFECT_CHANGED, function(_, result, _, _, _, _, _, stacks)
        if result == EFFECT_RESULT_FADED then
            CruxTracker.SV.stacks = 0
            return
        end
        CruxTracker.SV.stacks = stacks
    end)
    eventManager:AddFilterForEvent("CruxTracker.registerEventCruxUpdated", EVENT_EFFECT_CHANGED, REGISTER_FILTER_ABILITY_ID, 184220)
    eventManager:AddFilterForEvent("CruxTracker.registerEventCruxUpdated", EVENT_EFFECT_CHANGED, REGISTER_FILTER_SOURCE_COMBAT_UNIT_TYPE, COMBAT_UNIT_TYPE_PLAYER)

    eventManager:RegisterForUpdate('CruxTracker.Update', 100, CruxTracker.Update)
end
