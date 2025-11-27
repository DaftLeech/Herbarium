local addonName, namespace = ...

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}

Herbarium.CurrentPage = 1

local onPlantDetailsClick, onPrevPageClick, onNextPageClick

-- ==========================================================================================
-- create ui with all frames
-- ==========================================================================================
function Herbarium:createUI()
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
	naviFrame.prevButton:SetScript("OnClick", onPrevPageClick)
	naviFrame.prevButton:SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	naviFrame.prevButton:SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	naviFrame.prevButton:SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
	naviFrame.prevButton:SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight", "ADD")

	naviFrame.nextButton = CreateFrame("Button", "HerbariumNextPageButton", naviFrame)
	naviFrame.nextButton:SetWidth(32)
	naviFrame.nextButton:SetHeight(32)
	naviFrame.nextButton:SetPoint("CENTER", frame, "BOTTOMLEFT", 314, 105)
	naviFrame.nextButton:SetScript("OnClick", onNextPageClick)
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
	plantButtonFrame.plantButton2.id = 2

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
	plantDetailFrame.plantButton1.plantSubName:SetFontObject("GameFontNormal")
	plantDetailFrame.plantButton1.plantSubName:SetSize(250, 0)

	plantDetailFrame.foundRegion = plantDetailFrame:CreateFontString(nil, "BORDER")
	plantDetailFrame.foundRegion:SetFontObject("QuestFont")
	plantDetailFrame.foundRegion:SetMaxLines(3)
	plantDetailFrame.foundRegion:SetJustifyH("LEFT")
	plantDetailFrame.foundRegion:SetSize(300, 0)
	plantDetailFrame.foundRegion:SetPoint("TOPLEFT", plantDetailFrame.plantButton1, "BOTTOMLEFT", 0, -14)
	plantDetailFrame.foundRegion:SetText("")
	plantDetailFrame.foundRegion:Hide()

	plantDetailFrame.zonesTitle = plantDetailFrame:CreateFontString(nil, "BORDER")
	plantDetailFrame.zonesTitle:SetFontObject("QuestTitleFont")
	plantDetailFrame.zonesTitle:SetMaxLines(2)
	plantDetailFrame.zonesTitle:SetJustifyH("LEFT")
	plantDetailFrame.zonesTitle:SetSize(300, 0)
	plantDetailFrame.zonesTitle:SetPoint("TOPLEFT", plantDetailFrame.foundRegion, "BOTTOMLEFT", 0, -14)
	plantDetailFrame.zonesTitle:SetText(Herbarium.L["knownZones"])

	plantDetailFrame.zones = plantDetailFrame:CreateFontString(nil, "BORDER")
	plantDetailFrame.zones:SetFontObject("QuestFont")
	plantDetailFrame.zones:SetMaxLines(10)
	plantDetailFrame.zones:SetJustifyH("LEFT")
	plantDetailFrame.zones:SetSize(255, 0)
	plantDetailFrame.zones:SetPoint("TOPLEFT", plantDetailFrame.zonesTitle, "BOTTOMLEFT", 0, -14)
	plantDetailFrame.zones:SetText("")
	plantDetailFrame.zones:Hide()

	plantDetailFrame.zonesCount = plantDetailFrame:CreateFontString(nil, "BORDER")
	plantDetailFrame.zonesCount:SetFontObject("QuestFont")
	plantDetailFrame.zonesCount:SetMaxLines(10)
	plantDetailFrame.zonesCount:SetJustifyH("RIGHT")
	--plantDetailFrame.zonesCount:SetSize(40, 0)
	plantDetailFrame.zonesCount:SetPoint("TOPLEFT", plantDetailFrame.zones, "TOPRIGHT", 0, 0)
	plantDetailFrame.zonesCount:SetText("")
	plantDetailFrame.zonesCount:Hide()

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
	f.itemId = 0

	f:SetScript("OnClick", onPlantDetailsClick)

	-- set Tooltip
	f:SetScript("OnEnter", function (self, motion)
		
		if self.itemId == 0 then return end
		GameTooltip:SetOwner(self, "ANCHOR_RIGHT")	
		GameTooltip:SetItemByID(self.itemId)--		
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
function onPlantDetailsClick(plantButton, button, down)
    if plantButton.id <= 0 then
        return
    end

    local plantIndex      = plantButton.id -- index in the UI-Grid
    local plantItem       = Herbarium.herbs[plantIndex] -- plant Object(level,name,icon,id)
    local plantItemId     = plantItem.itemId -- plant ItemId / object.id
    local plantDetailBtn  = Herbarium.frame.plantDetailFrame.plantButton1 --button in detail frame
    local zones           = Herbarium.frame.plantDetailFrame.zones
	local zonesCount      = Herbarium.frame.plantDetailFrame.zonesCount
	local foundRegion     = Herbarium.frame.plantDetailFrame.foundRegion

	local playerName = UnitName("player")

    plantDetailBtn.id         = plantIndex
    plantDetailBtn.itemId     = plantItemId
    plantDetailBtn.iconTexture:SetTexture(plantItem.icon)
    plantDetailBtn.iconTexture:Show()
    plantDetailBtn.plantName:SetText(Herbarium.L[plantItem.name])
    plantDetailBtn.plantName:Show()
	plantDetailBtn.plantSubName:SetText("|cFFFFA500"..tostring(plantItem.skillups.orange)..
	"|r".." | ".."|cFFFFFF00"..tostring(plantItem.skillups.yellow).."|r".." | ".."|cFF008000"..tostring(plantItem.skillups.green).."|r"
	.." | ".."|cFF808080"..tostring(plantItem.skillups.grey).."|r")
	plantDetailBtn.plantSubName:Show()


	foundRegion:SetText("")
	for _, region in pairs(plantItem.spawn) do
		Herbarium:debug("Region: ", region)
		local regionText = Herbarium.L["spawn_"..region]
		Herbarium:debug("Region: ", regionText)
		if not foundRegion:GetText() then
			foundRegion:SetText(regionText)
		else
			foundRegion:SetText(foundRegion:GetText().." "..Herbarium.L["spawn_connect"]..regionText:gsub(Herbarium.L["spawn_found"],""))
		end
	end
	foundRegion:Show()

	local textWidthFont = Herbarium.frame.plantDetailFrame:CreateFontString(nil, "BORDER")
	textWidthFont:SetFontObject("QuestFont")

	textWidthFont:SetText(".")
	local dotWidth = textWidthFont:GetStringWidth()

    zones:SetText("")
	zonesCount:SetText("")
    local countPrint = 1

    for _, zoneLink in pairs(Herbarium.zoneLinks[plantItemId]) do
		local zoneId = zoneLink[1]
		local zoneObj = Herbarium.zones[zoneId]
		local zoneParent = nil
		if #zoneObj == 2 then
			zoneParent = zoneObj[2]
		end
        if countPrint <= 10 then
            if C_MapExplorationInfo.GetExploredMapTextures(zoneId) or (zoneParent and C_MapExplorationInfo.GetExploredMapTextures(zoneParent)) then
                countPrint = countPrint + 1
                local mapInfo = C_Map.GetMapInfo(zoneId)
				if not mapInfo then
					local name, instanceID = Herbarium.L[zoneObj[1]], zoneId
					mapInfo = {}
					mapInfo.name = name
					mapInfo.mapID = instanceID
				end
				local totalGatheredInZone = Herbarium.ensureGet(HerbariumDB, playerName, "GATHERED", plantItemId, "zones", zoneId, "total")
				Herbarium:debug("mapName: ", mapInfo.name, " mapId: ", mapInfo.mapID)
				Herbarium:debug("totalGatheredInZone: ",totalGatheredInZone)

				local totalWidth = 250
				textWidthFont:SetText(mapInfo.name)
				local currentWidth = textWidthFont:GetStringWidth()
				textWidthFont:SetText(tostring(totalGatheredInZone or 0))
				local countWidth = textWidthFont:GetStringWidth()
				

				local totalDots = (totalWidth - currentWidth ) / dotWidth
				local dotString = "."

				Herbarium:debug("totalWidth: ",totalWidth, " currentWidth: ", currentWidth, " countWidth: ", countWidth, " dotWidth: ", dotWidth, " totalDots: ", totalDots)

				for i = 1, totalDots do
					dotString = dotString .. "."
				end

                if mapInfo then
                    if not zones:GetText() then
                        zones:SetText(mapInfo.name .. dotString)
						zonesCount:SetText(tostring(totalGatheredInZone or 0))
                    else
                        zones:SetText(zones:GetText() .. "\n" .. mapInfo.name .. dotString)
						zonesCount:SetText(zonesCount:GetText() .. "\n" .. tostring(totalGatheredInZone or 0))
                    end
                end
            end
        end
    end

    zones:Show()
	zonesCount:Show()
    PlaySound(829)
    Herbarium.frame.plantButtonFrame:Hide()
    Herbarium.frame.naviFrame:Hide()
    Herbarium.frame.plantDetailFrame:Show()
end


 function onPrevPageClick()
    if Herbarium.CurrentPage > 1 then
        Herbarium.CurrentPage = Herbarium.CurrentPage - 1
        Herbarium:updatePlants()
    end
end

function onNextPageClick()
    if Herbarium.CurrentPage < 5 then
        Herbarium.CurrentPage = Herbarium.CurrentPage + 1
        Herbarium:updatePlants()
    end
end

-- ==========================================================================================
-- update UI-Grid-View depending on page
-- ==========================================================================================
function Herbarium.updatePlants()

	local currentRank, currentMaxRank, skillmodifier  = Herbarium.getProfessionLevel()
	local countItemsReachable = 0

	if not currentMaxRank then 
		HideUIPanel(Herbarium.frame)
		return
	 end

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
		plantButton.itemId = 0
	end

	--set Items
	local minIndex, maxIndex = 1 + (12 * (Herbarium.CurrentPage - 1)), 12 + (12 * (Herbarium.CurrentPage - 1))
	
	for indexPlant, plantItem in ipairs(Herbarium.herbs) do
		if plantItem.skill <= currentMaxRank then			

			countItemsReachable = countItemsReachable + 1

			if minIndex <= indexPlant and indexPlant <= maxIndex then
				
				local index = indexPlant - (12 * (Herbarium.CurrentPage - 1))

				-- get the Item-Box at the same Index
				local plantButtonAtIndex = Herbarium.frame.plantButtonList[index]

				-- save plant ItemId
				plantButtonAtIndex.itemId = plantItem.itemId
				plantButtonAtIndex.id = indexPlant
				
				-- gray-scale higher plants
				plantButtonAtIndex.iconTexture:SetDesaturated(nil)
				plantButtonAtIndex.plantName:SetFontObject("GameFontNormal")

				if plantItem.skill > currentRank then
					plantButtonAtIndex.iconTexture:SetDesaturated(1)
					plantButtonAtIndex.plantName:SetFontObject("GameFontBlack")
				end
				
				-- fill the plant boxes and show them				
				plantButtonAtIndex.iconTexture:SetTexture(plantItem.icon)
				plantButtonAtIndex.iconTexture:Show()
				
				plantButtonAtIndex.plantName:SetText(Herbarium.L[plantItem.name])
				plantButtonAtIndex.plantName:Show()

				-- check if gathered before
				local playerName = UnitName("player")
				local itemSlot = Herbarium.ensureGet(HerbariumDB, playerName, "GATHERED")
				if itemSlot and itemSlot[plantItem.itemId] then
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