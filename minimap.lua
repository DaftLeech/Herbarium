-- Herbarium - LibDataBroker / LibDBIcon launcher

Herbarium = Herbarium or {}
Herbarium_Minimap = Herbarium_Minimap or {}

local OBJECT_NAME = "Herbarium"
local DEFAULT_POSITION = 220

local LDB = LibStub("LibDataBroker-1.1")
local DBIcon = LibStub("LibDBIcon-1.0")

local function GetMinimapDB()
  HerbariumDB.minimap = HerbariumDB.minimap or {}

  if HerbariumDB.minimap.minimapPos == nil then
    HerbariumDB.minimap.minimapPos = DEFAULT_POSITION
  end

  if HerbariumDB.minimap.hide == nil then
    HerbariumDB.minimap.hide = false
  end

  return HerbariumDB.minimap
end

local launcher = LDB:NewDataObject(OBJECT_NAME, {
  type = "launcher",
  label = "Herbarium",
  text = "Herbarium",
  icon = "Interface\\MINIMAP\\Dungeon",

  OnClick = function(_, button)
    if button == "LeftButton" and Herbarium then
      if Herbarium.frame and Herbarium.frame:IsShown() then
          HideUIPanel(Herbarium.frame)
      else
          Herbarium:Open()
      end
    end
  end,

  OnTooltipShow = function(tooltip)
    tooltip:AddLine("Herbarium")
    tooltip:AddLine("Left-click to open or close Herbarium.", 1, 1, 1)
    tooltip:AddLine("Drag the minimap icon to move it.", 0.7, 0.7, 0.7)
  end,
})

function Herbarium_Minimap.Show()
  local db = GetMinimapDB()
  db.hide = false

  if DBIcon:IsRegistered(OBJECT_NAME) then
    DBIcon:Show(OBJECT_NAME)
  end
end

function Herbarium_Minimap.Hide()
  local db = GetMinimapDB()
  db.hide = true

  if DBIcon:IsRegistered(OBJECT_NAME) then
    DBIcon:Hide(OBJECT_NAME)
  end
end

function Herbarium_Minimap.Toggle()
  local db = GetMinimapDB()

  if db.hide then
    Herbarium_Minimap.Show()
  else
    Herbarium_Minimap.Hide()
  end
end

function Herbarium_Minimap.ResetPosition()
  local db = GetMinimapDB()
  db.minimapPos = DEFAULT_POSITION

  if DBIcon:IsRegistered(OBJECT_NAME) then
    DBIcon:Refresh(OBJECT_NAME, db)
  end
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("PLAYER_LOGIN")
eventFrame:SetScript("OnEvent", function()
  local db = GetMinimapDB()

  if not DBIcon:IsRegistered(OBJECT_NAME) then
    DBIcon:Register(OBJECT_NAME, launcher, db)
  end
end)
