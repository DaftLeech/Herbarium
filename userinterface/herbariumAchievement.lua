local addonName, Herbarium = ...

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}

local hasCompletedAchievement, hasFinishedAchievement, updateAchievementFrame, createAchievementFrame

-- ==========================================================================================
-- achievement functions
-- ==========================================================================================

-- has finished the achievement in the past (saved in database)
function hasCompletedAchievement(professionRank)
	local playerName = UnitName("player")
	local rankSlot = Herbarium.ensure(HerbariumDB, playerName, "ACHIEVEMENT")
	local hasCompletedAchiement = rankSlot[professionRank] or false
	return hasCompletedAchiement
end

-- has finished the achievement and is not saved in database (first time)
function hasFinishedAchievement(professionRank)
	local playerName = UnitName("player")
	local finished = true

	--set the Skillmax for this rank
	local professionRankSkillmax = 999
	for _, ranks in ipairs(Herbarium.professionRanks) do
		if ranks[2] == professionRank then professionRankSkillmax = ranks[1] end
	end

	-- for each herb with required skill lower or equal to Skillmax check DB for gathered
	for _, herb in ipairs(Herbarium.herbs) do
		if herb.skill <= professionRankSkillmax then
			local itemSlot = Herbarium.ensure(HerbariumDB, playerName, "GATHERED")
			if not itemSlot[herb.itemId] then
				finished = false
				break
			end
		end
	end
	return finished
end

-- check all profession ranks for finished achievements and then play achievement frame and save to database
function Herbarium.checkAchievements()
	for _, professionRank in ipairs(Herbarium.professionRanks) do
		local professionRankName = professionRank[2]
		if not hasCompletedAchievement(professionRankName) and hasFinishedAchievement(professionRankName) then
			local playerName = UnitName("player")
			Herbarium.ensureSet(HerbariumDB, true, playerName, "ACHIEVEMENT", professionRankName)
			Herbarium.updateAchievementFrame(133939, professionRankName)
		end
	end
end

-- =========================================================
-- Achievement UI
-- =========================================================
function createAchievementFrame()
    if Herbarium.achievementFrame then
        return Herbarium.achievementFrame
    end

    local f = CreateFrame("Frame", "achievementFrame", UIParent)
    f:SetSize(320, 92)
    f:SetPoint("CENTER", 0, -280)
    f:Hide()
    f:SetFrameStrata("TOOLTIP")

    -- Background
    local background = f:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()

    -- Try atlas first; fallback to file + coords
    local ok = background.SetAtlas and background:SetAtlas("UI-Achievement-Alert-Background", true)
    if not ok then
        background:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Background")
        background:SetTexCoord(0, 0.605, 0, 0.703)
    else
        background:SetTexCoord(0, 1, 0, 1)
    end
    f.background = background

    -- Icon group
    local iconFrame = CreateFrame("Frame", nil, f)
    iconFrame:SetSize(40, 40)
    iconFrame:SetPoint("LEFT", f, "LEFT", 6, 0)

    local iconTexture = iconFrame:CreateTexture(nil, "ARTWORK")
    iconTexture:ClearAllPoints()
    iconTexture:SetPoint("CENTER", iconFrame, "CENTER", 0, 0)
    iconTexture:SetSize(40, 43)
    iconTexture:SetTexCoord(0.05, 1, 0.05, 1)
    iconFrame.tex = iconTexture

    f.iconTexture = iconTexture
    f.iconFrame = iconFrame

    local iconOverlay = iconFrame:CreateTexture(nil, "OVERLAY")
    iconOverlay:SetTexture("Interface\\AchievementFrame\\UI-Achievement-IconFrame")
    iconOverlay:SetTexCoord(0, 0.5625, 0, 0.5625)
    iconOverlay:SetSize(72, 72)
    iconOverlay:SetPoint("CENTER", iconFrame, "CENTER", -1, 2)

    -- Title (Achievement name)
    local name = f:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    name:SetPoint("CENTER", f, "CENTER", 10, 0)
    name:SetJustifyH("CENTER")
    name:SetText("")
    f.name = name

    -- "Achievement Unlocked" label
    local unlocked = f:CreateFontString(nil, "OVERLAY", "GameFontBlackTiny")
    unlocked:SetPoint("TOP", f, "TOP", 7, -26)
    unlocked:SetText(ACHIEVEMENT_UNLOCKED)
    f.unlocked = unlocked

    -- Shield & points
    local shield = CreateFrame("Frame", nil, f)
    shield:SetSize(64, 64)
    shield:SetPoint("RIGHT", f, "RIGHT", -10, -4)

    local shieldIcon = shield:CreateTexture(nil, "BACKGROUND")
    shieldIcon:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Shields")
    shieldIcon:SetSize(56, 52)
    shieldIcon:SetPoint("TOPRIGHT", 1, 0)
    shieldIcon:SetTexCoord(0, 0.5, 0, 0.45)

    local points = shield:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    points:SetPoint("CENTER", 4, 5)
    points:SetText("")
    f.points = points

    -- fade out function
    function f:FadeOut(duration)
        local timeInSec = 0
        self:SetScript("OnUpdate", function(frame, elapsed)
            timeInSec = timeInSec + elapsed
            local alphaPerc = 1 - math.min(timeInSec / duration, 1)
            frame:SetAlpha(alphaPerc)
            if timeInSec >= duration then
                frame:SetScript("OnUpdate", nil)
                frame:Hide()
                frame:SetAlpha(1)
            end
        end)
    end

    Herbarium.achievementFrame = f
	return f
end