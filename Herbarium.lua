

-- SavedVariables
HerbariumlDB = HerbariumlDB or {}
Herbarium = {}

Herbarium.CurrentPage = 1

Herbarium.herbalism = {
		{1,   "Peacebloom", 133939},
		{1,   "Silverleaf", 134190},
		{15,  "Earthroot", 134187},
		{50,  "Mageroyal", 133436},
		{70,  "Briarthorn", 134412},
		{85,  "Stranglekelp", 134191},
		{100, "Bruiseweed", 134181},
		{115, "Wild Steelbloom", 133938},
		{120, "Grave Moss", 133849},
		{125, "Kingsblood", 134183},
		{150, "Liferoot", 134413},
		{160, "Fadeleaf", 134193},
		{170, "Goldthorn", 134196},
		{185, "Khadgar's Whisker", 134188},
		{195, "Wintersbite", 133940},
		{205, "Firebloom", 134200},
		{210, "Purple Lotus", 134198},
		{220, "Arthas' Tears", 134194},
		{230, "Sungrass", 134199},
		{235, "Blindweed", 134195},
		{245, "Ghost Mushroom", 134529},
		{250, "Gromsblood", 134197},
		{260, "Golden Sansam", 134221},
		{270, "Dreamfoil", 134204},
		{280, "Mountain Silversage", 134215},
		{285, "Plaguebloom", 134219},
		{290, "Icecap", 134212},
		{300, "Black Lotus", 134202},
	}

Herbarium.professionRanks =  {
		{75,  APPRENTICE},
		{150, JOURNEYMAN},
		{225, EXPERT},
		{300, ARTISAN}
	}

Herbarium.L = {
		["Peacebloom"]=   "Peacebloom",
		["Silverleaf"]=   "Silverleaf",
		["Earthroot"]=  "Earthroot",
		["Mageroyal"]=  "Mageroyal",
		["Briarthorn"]=  "Briarthorn",
		["Stranglekelp"]=  "Stranglekelp",
		["Bruiseweed"]= "Bruiseweed",
		["Wild Steelbloom"]= "Wild Steelbloom",
		["Grave Moss"]= "Grave Moss",
		["Kingsblood"]= "Kingsblood",
		["Liferoot"]= "Liferoot",
		["Fadeleaf"]= "Fadeleaf",
		["Goldthorn"]= "Goldthorn",
		["Khadgar's Whisker"]= "Khadgar's Whisker",
		["Wintersbite"]= "Wintersbite",
		["Firebloom"]= "Firebloom",
		["Purple Lotus"]= "Purple Lotus",
		["Arthas' Tears"]= "Arthas' Tears",
		["Sungrass"]= "Sungrass",
		["Blindweed"]= "Blindweed",
		["Ghost Mushroom"]= "Ghost Mushroom",
		["Gromsblood"]= "Gromsblood",
		["Golden Sansam"]= "Golden Sansam",
		["Dreamfoil"]= "Dreamfoil",
		["Mountain Silversage"]= "Mountain Silversage",
		["Plaguebloom"]= "Plaguebloom",
		["Icecap"]= "Icecap",
		["Black Lotus"]= "Black Lotus",
		["herbalism"]= "Herbalism"
	}

if GetLocale() == "deDE" then 

	local L = Herbarium.L

	L["Arthas' Tears"] = "Arthas' Tr\195\164nen"
	L["Black Lotus"] = "Schwarzer Lotus"
	L["Blindweed"] = "Blindkraut"
	L["Briarthorn"] = "Wilddornrose"
	L["Bruiseweed"] = "Beulengras"
	L["Dreamfoil"] = "Traumblatt"
	L["Earthroot"] = "Erdwurzel"
	L["Fadeleaf"] = "Blassblatt"
	L["Firebloom"] = "Feuerbl\195\188te"
	L["Ghost Mushroom"] = "Geisterpilz"
	L["Goldthorn"] = "Golddorn"
	L["Grave Moss"] = "Grabmoos"
	L["Golden Sansam"] = "Goldener Sansam"
	L["Gromsblood"] = "Gromsblut"
	L["Icecap"] = "Eiskappe"
	L["Khadgar's Whisker"] = "Khadgars Schnurrbart"
	L["Kingsblood"] = "K\195\182nigsblut"
	L["Liferoot"] = "Lebenswurz"
	L["Mageroyal"] = "Magusk\195\182nigskraut"
	L["Mountain Silversage"] = "Bergsilbersalbei"
	L["Peacebloom"] = "Friedensblume"
	L["Plaguebloom"] = "Pestbl\195\188te"
	L["Purple Lotus"] = "Lila Lotus"
	L["Silverleaf"] = "Silberblatt"
	L["Sungrass"] = "Sonnengras"
	L["Stranglekelp"] = "W\195\188rgetang"
	L["Swiftthistle"] = "Flitzdistel"
	L["Wild Steelbloom"] = "Wildstahlblume"
	L["Wildvine"] = "Wildranke"
	L["Wintersbite"] = "Winterbiss"

	L["Herbalism"] = "Kr\195\164uterkunde"
	L["herbalism"] = "Kr\195\164uterkunde"

end


function Herbarium:PrintChat(message)
    print("|cff00ff00[Herbarium]|r " .. message)
end


function Herbarium:CreateUI()
	if( self.frame ) then return end
	
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
	
	-- Frame type info
	frame:SetAttribute("UIPanelLayout-defined", true)
	frame:SetAttribute("UIPanelLayout-enabled", true)
	frame:SetAttribute("UIPanelLayout-pushable", 5)
 	frame:SetAttribute("UIPanelLayout-area", "left")
	frame:SetAttribute("UIPanelLayout-whileDead", true)
	table.insert(UISpecialFrames, frame:GetName())
	HideUIPanel(self.frame)
	
	local title = frame:CreateFontString(nil, "ARTWORK")
	title:SetFontObject(GameFontNormal)
	title:SetPoint("CENTER", 6, 230)
	title:SetText("Herbarium")
	

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

	--plant Buttonframe

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

	
	self.frame = frame

end

-- Plant Icon template
function Herbarium:plantButtonTemplate(name, parent)
	local f = CreateFrame("CheckButton", name, parent)
	f:SetWidth(37)
	f:SetHeight(37)

	f.background = f:CreateTexture(nil, "BACKGROUND")
	f.background:SetTexture("Interface\\Spellbook\\UI-Spellbook-SpellBackground")
	f.background:SetWidth(64)
	f.background:SetHeight(64)
	f.background:SetPoint("TOPLEFT", -3, 3)

	f.iconTexture = f:CreateTexture(nil, "BORDER")
	f.iconTexture:SetTexture(133939)
	f.iconTexture:SetAllPoints()
	f.iconTexture:Hide()

	f.plantName = f:CreateFontString(nil, "BORDER")
	f.plantName:SetFontObject("GameFontNormal")
	f.plantName:SetMaxLines(3)
	f.plantName:Hide()
	f.plantName:SetJustifyH("LEFT")
	f.plantName:SetSize(103, 0)
	f.plantName:SetPoint("LEFT", f, "RIGHT", 5, 3)

	f.plantSubName = f:CreateFontString(nil, "BORDER")
	f.plantSubName:SetFontObject("GameFontNormal")
	f.plantSubName:SetMaxLines(3)
	f.plantSubName:Hide()
	f.plantSubName:SetJustifyH("LEFT")
	f.plantSubName:SetSize(79, 18)
	f.plantSubName:SetPoint("TOPLEFT", f, "BOTTOMLEFT", 0, -2)


	return f
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

function Herbarium:GetProfessionLevel()				
	local numSkills = GetNumSkillLines();
	for i=1, numSkills do
		local skillname,_,_,skillrank,_,skillmodifier, skillMaxRank = GetSkillLineInfo(i)		

		if (skillname == Herbarium.L["herbalism"]) then
			return skillrank, skillMaxRank, skillmodifier
		end
	end
end


function Herbarium:updatePlants()

	local currentRank, currentMaxRank, skillmodifier  = Herbarium:GetProfessionLevel()
	local countItemsReachable = 0

	--fake maxrank
	--currentMaxRank = 300
	--currentMaxRank = currentRank

	if skillmodifier then
		currentRank = currentRank + skillmodifier
	end

	--clear current Items
	for _, plantItem in pairs(Herbarium.frame.plantButtonList) do
		plantItem.iconTexture:Hide()
		plantItem.plantName:Hide()
		plantItem.plantSubName:Hide()
	end

	--set Items
	local minIndex, maxIndex = 1 + (12 * (Herbarium.CurrentPage - 1)), 12 + (12 * (Herbarium.CurrentPage - 1))
	
	for indexPlant, plantItem in pairs(Herbarium.herbalism) do
		if plantItem[1] <= currentMaxRank and plantItem[2] then			

			countItemsReachable = countItemsReachable + 1

			if minIndex <= indexPlant and indexPlant <= maxIndex then
				
				local index = indexPlant - (12 * (Herbarium.CurrentPage - 1))

				-- get the Item-Box at the same Index
				local plantItemAtIndex = Herbarium.frame.plantButtonList[index]

				-- gray-scale higher plants
				plantItemAtIndex.iconTexture:SetDesaturated(nil)
				plantItemAtIndex.plantName:SetFontObject("GameFontNormal")

				if plantItem[1] > currentRank then
					plantItemAtIndex.iconTexture:SetDesaturated(1)
					plantItemAtIndex.plantName:SetFontObject("GameFontBlack")
				end
				
				-- fill the plant boxes and show them				
				plantItemAtIndex.iconTexture:SetTexture(plantItem[3])
				plantItemAtIndex.iconTexture:Show()
				plantItemAtIndex.plantName:SetText(Herbarium.L[plantItem[2]])
				plantItemAtIndex.plantName:Show()

				

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

end


function Herbarium:Open()
	Herbarium:CreateUI()
	Herbarium:updatePlants()
	PlaySound(829)
	ShowUIPanel(self.frame)
end

local f = CreateFrame("Frame")
f:RegisterEvent("CHAT_MSG_SYSTEM")
f:SetScript("OnEvent", HandleChatEvent)

SLASH_Herbarium1 = "/Herbarium"
SLASH_Herbarium1 = "/herb"
SlashCmdList["Herbarium"] = function()
    
       
    if Herbarium.frame and Herbarium.frame:IsShown() then
        HideUIPanel(Herbarium.frame)
    else
        Herbarium:Open()
    end
end

Herbarium:PrintChat("v" .. C_AddOns.GetAddOnMetadata("Herbarium","Version") .. " loaded.")

