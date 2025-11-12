

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}

Herbarium.CurrentPage = 1

local ensure, ensureSet, ensureGet
local hasCompletedAchievement, hasFinishedAchievement, updateAchievementFrame, checkAchievements, createAchievementFrame

-- print function with color
function Herbarium:PrintChat(message)
    print("|cff00ff00[Herbarium]|r " .. message)
end
-- ==========================================================================================
-- create ui with all frames
-- ==========================================================================================
function Herbarium:CreateUI()
	if( self.frame ) then return end
	
	-- base frame
	local frame = CreateFrame("Frame", "HerbariumFrame", UIParent)
	frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self, button)
			if button == "LeftButton" then self:StartMoving() end
		end)
	frame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
		end)
	frame:SetClampedToScreen(false)
	frame:SetFrameStrata("DIALOG")
	frame:SetWidth(384)
	frame:SetHeight(512)
	frame:SetPoint("TOPLEFT", 0, -104)
	
	frame:SetScript("OnHide", function()
			PlaySound(830);
			HideUIPanel(self.frame)
		end)
	
	-- Frame type info for default ui 
	frame:SetAttribute("UIPanelLayout-defined", true)
	frame:SetAttribute("UIPanelLayout-enabled", true)
	frame:SetAttribute("UIPanelLayout-pushable", 5)
 	frame:SetAttribute("UIPanelLayout-area", "left")
	frame:SetAttribute("UIPanelLayout-whileDead", true)
	table.insert(UISpecialFrames, frame:GetName())
	HideUIPanel(self.frame)
	
	-- frame title
	local title = frame:CreateFontString(nil, "ARTWORK")
	title:SetFontObject(GameFontNormal)
	title:SetPoint("CENTER", 6, 230)
	title:SetText("Herbarium")
	
	-- frame icon topleft
	local texture = frame:CreateTexture(nil, "BACKGROUND")
	texture:SetWidth(58)
	texture:SetHeight(58)
	texture:SetPoint("TOPLEFT", 10, -8)
	texture:SetTexture(133939)
	
	
	-- Container border
	frame.topLeft = frame:CreateTexture(nil, "ARTWORK")
	frame.topLeft:SetWidth(256)
	frame.topLeft:SetHeight(256)
	frame.topLeft:SetPoint("TOPLEFT", 0, 0)
	frame.topLeft:SetTexture("Interface\\Spellbook\\UI-SpellbookPanel-TopLeft")

	frame.topRight = frame:CreateTexture(nil, "ARTWORK")
	frame.topRight:SetWidth(128)
	frame.topRight:SetHeight(256)
	frame.topRight:SetPoint("TOPRIGHT", 0, 0)
	frame.topRight:SetTexture("Interface\\Spellbook\\UI-SpellbookPanel-TopRight")

	frame.bottomLeft = frame:CreateTexture(nil, "ARTWORK")
	frame.bottomLeft:SetWidth(256)
	frame.bottomLeft:SetHeight(256)
	frame.bottomLeft:SetPoint("BOTTOMLEFT", 0, 0)
	frame.bottomLeft:SetTexture("Interface\\Spellbook\\UI-SpellbookPanel-BotLeft")

	frame.bottomRight = frame:CreateTexture(nil, "ARTWORK")
	frame.bottomRight:SetWidth(128)
	frame.bottomRight:SetHeight(256)
	frame.bottomRight:SetPoint("BOTTOMRIGHT", 0, 0)
	frame.bottomRight:SetTexture("Interface\\Spellbook\\UI-SpellbookPanel-BotRight")
	
	-- Next / prev Buttons
	-- navigation frame
	local naviFrame = CreateFrame("Frame", "HerbariumPageNavigationFrame", frame)
	naviFrame.pageNumber = naviFrame:CreateFontString("HerbariumPageText", "OVERLAY")
	naviFrame.pageNumber:SetFontObject("GameFontBlack")
	naviFrame.pageNumber:SetWidth(102)
	naviFrame.pageNumber:SetHeight(32)
	naviFrame.pageNumber:SetJustifyH("RIGHT")
	naviFrame.pageNumber:SetPoint("BOTTOMRIGHT", -110, 38)
	naviFrame.pageNumber:SetTextColor(0.25, 0.12, 0)

	naviFrame.prevButton = CreateFrame("Button", "HerbariumPrevPageButton", naviFrame)
	naviFrame.prevButton:SetWidth(32)
	naviFrame.prevButton:SetHeight(32)
	naviFrame.prevButton:SetPoint("CENTER", frame, "BOTTOMLEFT", 50, 105)
	naviFrame.prevButton:SetScript("OnClick", HerbariumPrevPageButton_OnClick)
	naviFrame.prevButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	naviFrame.prevButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	naviFrame.prevButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
	naviFrame.prevButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

	naviFrame.nextButton = CreateFrame("Button", "HerbariumNextPageButton", naviFrame)
	naviFrame.nextButton:SetWidth(32)
	naviFrame.nextButton:SetHeight(32)
	naviFrame.nextButton:SetPoint("CENTER", frame, "BOTTOMLEFT", 314, 105)
	naviFrame.nextButton:SetScript("OnClick", HerbariumNextPageButton_OnClick)
	naviFrame.nextButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Up")
	naviFrame.nextButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Down")
	naviFrame.nextButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-NextPage-Disabled")
	naviFrame.nextButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

	frame.naviFrame = naviFrame


	-- Close button
	local button = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	button:SetPoint("CENTER", frame, "TOPRIGHT", -44, -25)
	button:SetScript("OnClick", function()
		PlaySound(830)
		HideUIPanel(self.frame)
	end)

	-- ==========================================================================================
	-- plant-Grid / Buttonframe
	-- all 12 slots for plants
	-- created by "virtual" Template
	-- ==========================================================================================
	local plantButtonFrame = CreateFrame("Frame", "HerbariumPlantButtonFrame", frame)
	plantButtonFrame:SetPoint("TOPLEFT", frame, "TOPLEFT")
	plantButtonFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")	

	plantButtonFrame.plantButton1 = Herbarium:plantButtonTemplate("plantButton1", plantButtonFrame)
	plantButtonFrame.plantButton1:SetPoint("TOPLEFT", 34, -85)
	plantButtonFrame.plantButton1.id = 1

	plantButtonFrame.plantButton2 = Herbarium:plantButtonTemplate("plantButton2", plantButtonFrame)
	plantButtonFrame.plantButton2:SetPoint("TOPLEFT", plantButtonFrame.plantButton1, "BOTTOMLEFT", 0, -14)
	plantButtonFrame.plantButton1.id = 2

	plantButtonFrame.plantButton3 = Herbarium:plantButtonTemplate("plantButton3", plantButtonFrame)
	plantButtonFrame.plantButton3:SetPoint("TOPLEFT", plantButtonFrame.plantButton2, "BOTTOMLEFT", 0, -14)
	plantButtonFrame.plantButton3.id = 3

	plantButtonFrame.plantButton4 = Herbarium:plantButtonTemplate("plantButton4", plantButtonFrame)
	plantButtonFrame.plantButton4:SetPoint("TOPLEFT", plantButtonFrame.plantButton3, "BOTTOMLEFT", 0, -14)
	plantButtonFrame.plantButton4.id = 4

	plantButtonFrame.plantButton5 = Herbarium:plantButtonTemplate("plantButton5", plantButtonFrame)
	plantButtonFrame.plantButton5:SetPoint("TOPLEFT", plantButtonFrame.plantButton4, "BOTTOMLEFT", 0, -14)
	plantButtonFrame.plantButton5.id = 5
	
	plantButtonFrame.plantButton6 = Herbarium:plantButtonTemplate("plantButton6", plantButtonFrame)
	plantButtonFrame.plantButton6:SetPoint("TOPLEFT", plantButtonFrame.plantButton5, "BOTTOMLEFT", 0, -14)
	plantButtonFrame.plantButton6.id = 6

	plantButtonFrame.plantButton7 = Herbarium:plantButtonTemplate("plantButton7", plantButtonFrame)
	plantButtonFrame.plantButton7:SetPoint("TOPLEFT", plantButtonFrame.plantButton1, 157, 0)
	plantButtonFrame.plantButton7.id = 7

	plantButtonFrame.plantButton8 = Herbarium:plantButtonTemplate("plantButton8", plantButtonFrame)
	plantButtonFrame.plantButton8:SetPoint("TOPLEFT", plantButtonFrame.plantButton2, 157, 0)
	plantButtonFrame.plantButton8.id = 8

	plantButtonFrame.plantButton9 = Herbarium:plantButtonTemplate("plantButton9", plantButtonFrame)
	plantButtonFrame.plantButton9:SetPoint("TOPLEFT", plantButtonFrame.plantButton3, 157, 0)
	plantButtonFrame.plantButton9.id = 9

	plantButtonFrame.plantButton10 = Herbarium:plantButtonTemplate("plantButton10", plantButtonFrame)
	plantButtonFrame.plantButton10:SetPoint("TOPLEFT", plantButtonFrame.plantButton4, 157, 0)
	plantButtonFrame.plantButton10.id = 10

	plantButtonFrame.plantButton11 = Herbarium:plantButtonTemplate("plantButton11", plantButtonFrame)
	plantButtonFrame.plantButton11:SetPoint("TOPLEFT", plantButtonFrame.plantButton5, 157, 0)
	plantButtonFrame.plantButton11.id = 11

	plantButtonFrame.plantButton12 = Herbarium:plantButtonTemplate("plantButton12", plantButtonFrame)
	plantButtonFrame.plantButton12:SetPoint("TOPLEFT", plantButtonFrame.plantButton6, 157, 0)
	plantButtonFrame.plantButton12.id = 12
	
	-- connect to main frame
	frame.plantButtonFrame = plantButtonFrame
	frame.plantButtonList = {}
	frame.plantButtonList[1] = plantButtonFrame.plantButton1
	frame.plantButtonList[2] = plantButtonFrame.plantButton2
	frame.plantButtonList[3] = plantButtonFrame.plantButton3
	frame.plantButtonList[4] = plantButtonFrame.plantButton4
	frame.plantButtonList[5] = plantButtonFrame.plantButton5
	frame.plantButtonList[6] = plantButtonFrame.plantButton6
	frame.plantButtonList[7] = plantButtonFrame.plantButton7
	frame.plantButtonList[8] = plantButtonFrame.plantButton8
	frame.plantButtonList[9] = plantButtonFrame.plantButton9
	frame.plantButtonList[10] = plantButtonFrame.plantButton10
	frame.plantButtonList[11] = plantButtonFrame.plantButton11
	frame.plantButtonList[12] = plantButtonFrame.plantButton12


	-- ==========================================================================================
	-- detail window
	-- ==========================================================================================
	local plantDetailFrame = CreateFrame("Frame", "HerbariumplantDetailFrame", frame)
	plantDetailFrame:SetPoint("TOPLEFT", frame, "TOPLEFT")
	plantDetailFrame:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT")	

	plantDetailFrame.plantButton1 = Herbarium:plantButtonTemplate("plantButton1", plantDetailFrame)
	plantDetailFrame.plantButton1:SetPoint("TOPLEFT", 34, -85)
	plantDetailFrame.plantButton1.id = 0
	plantDetailFrame.plantButton1:SetScript("OnClick", function ()
		Herbarium.frame.plantDetailFrame:Hide()
		Herbarium:Open()
	end)
	plantDetailFrame.plantButton1.plantName:SetFontObject("GameFontNormalLarge")
	plantDetailFrame.plantButton1.plantName:SetSize(250, 0)

	plantDetailFrame.zonesTitle = plantDetailFrame:CreateFontString(nil, "BORDER")
	plantDetailFrame.zonesTitle:SetFontObject("QuestTitleFont")
	plantDetailFrame.zonesTitle:SetMaxLines(2)
	plantDetailFrame.zonesTitle:SetJustifyH("LEFT")
	plantDetailFrame.zonesTitle:SetSize(300, 0)
	plantDetailFrame.zonesTitle:SetPoint("TOPLEFT", plantDetailFrame.plantButton1, "BOTTOMLEFT", 0, -14)
	plantDetailFrame.zonesTitle:SetText("Zones")

	plantDetailFrame.zones = plantDetailFrame:CreateFontString(nil, "BORDER")
	plantDetailFrame.zones:SetFontObject("QuestFont")
	plantDetailFrame.zones:SetMaxLines(10)
	plantDetailFrame.zones:SetJustifyH("LEFT")
	plantDetailFrame.zones:SetSize(300, 0)
	plantDetailFrame.zones:SetPoint("TOPLEFT", plantDetailFrame.zonesTitle, "BOTTOMLEFT", 0, -14)
	plantDetailFrame.zones:SetText("")
	plantDetailFrame.zones:Hide()

	plantDetailFrame:Hide()

	frame.plantDetailFrame = plantDetailFrame

	self.frame = frame

end

-- ==========================================================================================
-- Plant Icon template
-- ==========================================================================================
function Herbarium:plantButtonTemplate(name, parent)
	local f = CreateFrame("CheckButton", name, parent)
	f:SetWidth(37)
	f:SetHeight(37)
	f:SetHighlightTexture("Interface\\Buttons\\CheckButtonHilight", "ADD")

	f.background = f:CreateTexture(nil, "BACKGROUND")
	f.background:SetTexture("Interface\\Spellbook\\UI-Spellbook-SpellBackground")
	f.background:SetWidth(64)
	f.background:SetHeight(64)
	f.background:SetPoint("TOPLEFT", -3, 3)

	f.iconTexture = f:CreateTexture(nil, "BORDER")
	f.iconTexture:SetTexture(133939)
	f.iconTexture:SetAllPoints()

	f.plantName = f:CreateFontString(nil, "BORDER")
	f.plantName:SetFontObject("GameFontNormal")
	f.plantName:SetMaxLines(3)
	f.plantName:Hide()
	f.plantName:SetJustifyH("LEFT")
	f.plantName:SetSize(103, 0)
	f.plantName:SetPoint("LEFT", f, "RIGHT", 5, 3)

	f.plantSubName = f:CreateFontString(nil, "BORDER")
	f.plantSubName:SetFontObject("SubSpellFont")
	f.plantSubName:SetMaxLines(3)
	f.plantSubName:Hide()
	f.plantSubName:SetJustifyH("LEFT")
	f.plantSubName:SetSize(79, 0)
	f.plantSubName:SetPoint("TOPLEFT", f.plantName, "BOTTOMLEFT", 0, -2)
	

	f.id = 0

	f:SetScript("OnClick", HerbariumOpenDetails_OnClick)

	-- set Tooltip
	f:SetScript("OnEnter", function (self, motion)
		
		if self.id == 0 then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")	
		GameTooltip:SetItemByID(Herbarium.herbalism[self.id][4])--		
		CursorUpdate(self)
		
	end)
	f:SetScript("OnLeave", function (frameButton, motion)
		GameTooltip:Hide()
		ResetCursor()
	end)


	return f
end

-- ==========================================================================================
-- OnClick functions
-- ==========================================================================================
function HerbariumOpenDetails_OnClick(plantButton, button, down)

	if plantButton.id > 0 then 

		
		local plantIndex = plantButton.id -- index in the UI-Grid
		local plantItem = Herbarium.herbalism[plantIndex] -- plant Object(level,name,icon,id)
		local plantItemId = Herbarium.herbalism[plantIndex][4] -- plant ItemId / object.id

		local plantDetailButton = Herbarium.frame.plantDetailFrame.plantButton1 --button in detail frame
		local zones = Herbarium.frame.plantDetailFrame.zones 
		
		plantDetailButton.id = plantIndex
		plantDetailButton.iconTexture:SetTexture(plantItem[3])
		plantDetailButton.iconTexture:Show()
		
		plantDetailButton.plantName:SetText(C_Item.GetItemNameByID(plantItemId))
		plantDetailButton.plantName:Show()

		zones:SetText("")
		local countPrint = 1
		for i, zone in pairs(Herbarium.zoneLinks[plantItemId]) do
			if countPrint <= 20 then
				if C_MapExplorationInfo.GetExploredMapTextures(zone[1]) then
					countPrint = countPrint + 1
					
					if not zones:GetText() then
						zones:SetText(C_Map.GetMapInfo(zone[1]).name)
					else
						zones:SetText(zones:GetText().. "\n" .. C_Map.GetMapInfo(zone[1]).name)
					end
				end
				
			end
		end
		zones:Show()

		PlaySound(829)
		Herbarium.frame.plantButtonFrame:Hide()
		Herbarium.frame.naviFrame:Hide()
		Herbarium.frame.plantDetailFrame:Show()
	end
end

function HerbariumPrevPageButton_OnClick()

	if Herbarium.CurrentPage > 1 then 
		Herbarium.CurrentPage = Herbarium.CurrentPage - 1
		Herbarium:updatePlants()
	end

end

function HerbariumNextPageButton_OnClick()

	if Herbarium.CurrentPage < 5 then 
		Herbarium.CurrentPage = Herbarium.CurrentPage + 1
		Herbarium:updatePlants()
	end

end

-- ==========================================================================================
-- profession level by name..
-- ==========================================================================================
function Herbarium:GetProfessionLevel()				
	local numSkills = GetNumSkillLines();
	for i=1, numSkills do
		local skillname,_,_,skillrank,_,skillmodifier, skillMaxRank = GetSkillLineInfo(i)		

		if (skillname == Herbarium.L["herbalism"]) then
			return skillrank, skillMaxRank, skillmodifier
		end
	end
end

-- ==========================================================================================
-- update UI-Grid-View depending on page
-- ==========================================================================================
function Herbarium:updatePlants()

	local currentRank, currentMaxRank, skillmodifier  = Herbarium:GetProfessionLevel()
	local countItemsReachable = 0

	--fake maxrank for sceenshots
	--currentMaxRank = 300
	--currentMaxRank = currentRank
	--currentRank = 125

	if skillmodifier then
		currentRank = currentRank + skillmodifier
	end

	--clear current plantButtons
	for _, plantButton in pairs(Herbarium.frame.plantButtonList) do
		plantButton.iconTexture:Hide()
		plantButton.plantName:Hide()
		plantButton.plantSubName:Hide()
	end

	--set Items
	local minIndex, maxIndex = 1 + (12 * (Herbarium.CurrentPage - 1)), 12 + (12 * (Herbarium.CurrentPage - 1))
	
	for indexPlant, plantItem in pairs(Herbarium.herbalism) do
		if plantItem[1] <= currentMaxRank and plantItem[2] then			

			countItemsReachable = countItemsReachable + 1

			if minIndex <= indexPlant and indexPlant <= maxIndex then
				
				local index = indexPlant - (12 * (Herbarium.CurrentPage - 1))

				-- get the Item-Box at the same Index
				local plantButtonAtIndex = Herbarium.frame.plantButtonList[index]

				-- save plant Index
				plantButtonAtIndex.id = indexPlant
				
				-- gray-scale higher plants
				plantButtonAtIndex.iconTexture:SetDesaturated(nil)
				plantButtonAtIndex.plantName:SetFontObject("GameFontNormal")

				if plantItem[1] > currentRank then
					plantButtonAtIndex.iconTexture:SetDesaturated(1)
					plantButtonAtIndex.plantName:SetFontObject("GameFontBlack")
				end
				
				-- fill the plant boxes and show them				
				plantButtonAtIndex.iconTexture:SetTexture(plantItem[3])
				plantButtonAtIndex.iconTexture:Show()
				
				plantButtonAtIndex.plantName:SetText(Herbarium.L[plantItem[2]])
				plantButtonAtIndex.plantName:Show()

				-- check if gathered before
				local playerName = UnitName("player")
				local itemSlot = ensureGet(HerbariumDB, playerName, "GATHERED")
				if itemSlot and itemSlot[plantItem[4]] then
					plantButtonAtIndex.plantSubName:SetText(Herbarium.L["Gathered"])
					plantButtonAtIndex.plantSubName:Show()
				end

				

			end
			
		end
	end

	--set Page
	Herbarium.frame.naviFrame.pageNumber:SetText(tostring(Herbarium.CurrentPage))

	if Herbarium.CurrentPage == 1 then
		Herbarium.frame.naviFrame.prevButton:Disable()
	else 
		Herbarium.frame.naviFrame.prevButton:Enable()
	end

	if countItemsReachable - ( 12 * Herbarium.CurrentPage) > 0 then
		Herbarium.frame.naviFrame.nextButton:Enable()
	else
		Herbarium.frame.naviFrame.nextButton:Disable()
	end


	Herbarium.frame.plantDetailFrame:Hide()
	Herbarium.frame.plantButtonFrame:Show()
	Herbarium.frame.naviFrame:Show()

end


function Herbarium:Open()
	Herbarium:CreateUI()
	Herbarium:updatePlants()
	Herbarium:updatePlants()
	PlaySound(829) --603/605
	ShowUIPanel(self.frame)
	
	
end

-- ==========================================================================================
-- handle events
-- ==========================================================================================

Herbarium.CurrentPlantGUID = nil
Herbarium.CurrentPlantItemId = nil
Herbarium.CurrentPlantName = nil

local function HandleEvent(self, event, arg1, arg2, arg3, arg4, arg5)

	-- spell=2366/herb-gathering
	-- arg1 = unit / "player"
	-- arg2 = target / "Peacebloom"
	-- arg3 = castGUID 
	-- arg4 = spellId / 2366
	if event == "UNIT_SPELLCAST_SENT" and arg1 == "player" then
		
		-- different spells for different "diffeculties"
			--local spellName = GetSpellInfo(arg4)
			--if Herbarium.L["Herb Gathering"] ~= spellName then return end 

		-- .. or always 2366?
		if arg4 ~= 2366 then return end

		-- capture the GUID so we can detect it in SUCCEEDED event
		Herbarium.CurrentPlantGUID = arg3

		-- capture localizated name for SUCCEEDED event 
		Herbarium.CurrentPlantName = arg2

		-- target is localizated name of plant
		-- get the english name so we can figure out the itemId
		local plantNameEn = nil
		for nameEn, nameLoc in pairs(Herbarium.L) do
			if nameLoc == arg2 then
				plantNameEn = nameEn
			end
		end
		
		-- get the itemId
		for i,v in ipairs(Herbarium.herbalism) do
			if v[2] == plantNameEn then
				Herbarium.CurrentPlantItemId = v[4]
			end

		end
		
	end

	-- spell=2366/herb-gathering
	-- arg1 = unit / "player"
	-- arg2 = castGUID 
	-- arg3 = spellId / 2366
	if event == "UNIT_SPELLCAST_SUCCEEDED" then

		-- different spells for different "ranks" ..
			--local spellName = GetSpellInfo(arg3)
			--if Herbarium.L["Herb Gathering"] ~= spellName then return end 

		-- .. or always 2366?
		if arg3 ~= 2366 then return end

		-- same GUID as in before? we continue 
		if arg2 == Herbarium.CurrentPlantGUID and arg1 == "player" then

			local playerName = UnitName(arg1)
			local itemID = Herbarium.CurrentPlantItemId

			-- create entry in DB if not exists..
			if not HerbariumDB[playerName] or not HerbariumDB[playerName]["GATHERED"] or not HerbariumDB[playerName]["GATHERED"][itemID] then
				ensureSet(HerbariumDB, 1, playerName, "GATHERED", itemID)

				PlaySound(7355)
				PlaySound(3093)--3093 (writing sound) / 7355 (tutorial pling)
				if Herbarium.CurrentPlantName then
					Herbarium:PrintChat("First time gathered: " .. Herbarium.CurrentPlantName)
				end
				
			else 
				-- .. else count up
				local currentGatherCount = Herbarium:ensureGet(HerbariumDB, playerName, "GATHERED", itemID)
				ensureSet(HerbariumDB, currentGatherCount + 1, playerName, "GATHERED", itemID)
			end

			checkAchievements()
			
		end
	end

end

local f = CreateFrame("Frame")
--f:RegisterEvent("CHAT_MSG_SYSTEM")
f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:SetScript("OnEvent", HandleEvent)

-- ==========================================================================================
-- database functions
-- ==========================================================================================

-- Erstellt alle Zwischen-Tabellen und gibt den letzten Teil zurück
function ensure(tbl, ...)
    local keys = {...}
    local current = tbl
    for i = 1, #keys do
        local key = keys[i]
        if not current[key] then
            current[key] = {}
        end
        current = current[key]
    end
    return current
end

function ensureSet(tbl, value, ...)
    local keys = {...}
    local lastKey = table.remove(keys)
    local target = ensure(tbl, unpack(keys))
    target[lastKey] = value
end

-- ensureGet(tbl, key1, key2, key3, ...)
-- Gibt den Wert zurück, falls der gesamte Pfad existiert, sonst nil
function ensureGet(tbl, ...)
    local keys = {...}
    local current = tbl
    for i = 1, #keys do
        if type(current) ~= "table" then
            return nil
        end
        current = current[keys[i]]
        if current == nil then
            return nil
        end
    end
    return current
end

local function removeItem(playerName, section, itemID)
    local playerData = HerbariumDB[playerName]
    if not playerData then return end	
	if not playerData[section] then return end

    playerData[section][itemID] = nil

	-- Falls keine Items mehr da sind, lösche den Spieler
	if next(playerData[section]) == nil then
        HerbariumDB[playerName][section] = nil
    end
    
    if next(playerData) == nil then
        HerbariumDB[playerName] = nil
    end
end



-- ==========================================================================================
-- achievement functions
-- ==========================================================================================

-- has finished the achievement in the past (saved in database)
function hasCompletedAchievement(professionRank)
	local playerName = UnitName("player")
	local rankSlot = ensure(HerbariumDB, playerName, "ACHIEVEMENT")
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
	for _, herb in ipairs(Herbarium.herbalism) do
		if herb[1] <= professionRankSkillmax then
			local itemSlot = ensure(HerbariumDB, playerName, "GATHERED")
			if not itemSlot[herb[4]] then
				finished = false
				break
			end
		end
	end
	return finished
end

-- check all profession ranks for finished achievements and then play achievement frame and save to database
function checkAchievements()
	for _, professionRank in ipairs(Herbarium.professionRanks) do
		local professionRankName = professionRank[2]
		if not hasCompletedAchievement(professionRankName) and hasFinishedAchievement(professionRankName) then
			local playerName = UnitName("player")
			ensureSet(HerbariumDB, true, playerName, "ACHIEVEMENT", professionRankName)
			updateAchievementFrame(133939, professionRankName)
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

-- =========================================================
-- show AchievementFrame
-- =========================================================

function updateAchievementFrame(iconID, professionRank)
    local f = createAchievementFrame()
    f:Hide()
    f:SetAlpha(1)

    --set the Skillmax for this rank
	local professionRankSkillmax = 999
	for _, ranks in ipairs(Herbarium.professionRanks) do
		if ranks[2] == professionRank then professionRankSkillmax = ranks[1] end
	end

	local title = professionRank .. " " .. Herbarium.L["Completed"]

    f.iconTexture:SetTexture(iconID)
    f.name:SetText(title or "")
    f.points:SetText(tostring(professionRankSkillmax) or "")

    f:Show()

    PlaySoundFile("Interface\\AddOns\\Herbarium\\AchievementSound1.ogg", "Effects")

    C_Timer.After(3, function()
        if f:IsShown() then f:FadeOut(0.6) end
    end)
end

-- ==========================================================================================
-- debug functions
-- ==========================================================================================
local function debugEvent()
	HandleEvent(Herbarium, "UNIT_SPELLCAST_SENT", "player", "Grabmoos", "GUID", 2366, nil)
	HandleEvent(Herbarium, "UNIT_SPELLCAST_SUCCEEDED", "player", "GUID", 2366, nil, nil)
end


local function resetDB(playerName)
	HerbariumDB[playerName] = nil
end

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end

local function debug()
	---[[
	--debug event
	--resetDB("GATHERED")
	ensureSet(HerbariumDB, 3, "Franzfrozt", "GATHERED", 2447) -- Peacebloom 3
	ensureSet(HerbariumDB, 1, "Franzfrozt", "GATHERED", 765) -- Silverleaf 1
	ensureSet(HerbariumDB, 2, "Franzfrozt", "GATHERED", 2449) -- Earthroot 2
	ensureSet(HerbariumDB, 4, "Franzfrozt", "GATHERED", 785) -- Mageroyal 4
	ensureSet(HerbariumDB, 4, "Franzfrozt", "GATHERED", 2450) -- Briarthorn 4
	ensureSet(HerbariumDB, false, "Franzfrozt", "ACHIEVEMENT", APPRENTICE) -- APPRENTICE false
	
	
	removeItem("Franzfrozt", "GATHERED", 3369)
	--removeItem("Franzfrozt", "GATHERED", 2450)
	debugEvent()

	print(hasCompletedAchievement(APPRENTICE))
	print(hasFinishedAchievement(APPRENTICE))
	--updateAchievementFrame(Herbarium.herbalism[1][3],APPRENTICE)
	-- dump database
	print(dump(HerbariumDB))
	--print(dump(Herbarium.L))
	--]]
	
	Herbarium:PrintChat("v" .. C_AddOns.GetAddOnMetadata("Herbarium","Version") .. " loaded.")
end


-- ==========================================================================================
-- commands
-- ==========================================================================================
SLASH_Herbarium1 = "/Herbarium"
SLASH_Herbarium1 = "/herb"
SlashCmdList["Herbarium"] = function()
    
       
    if Herbarium.frame and Herbarium.frame:IsShown() then
        HideUIPanel(Herbarium.frame)
    else
        Herbarium:Open()
    end

	--debug()
	
end



