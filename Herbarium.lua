local _, Herbarium = ...

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}


-- print function with color
function Herbarium.printChat(message)
    print("|cff00ff00[Herbarium]|r " .. message)
end


-- ==========================================================================================
-- profession level by name..
-- ==========================================================================================
function Herbarium.getProfessionLevel()				
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
function Herbarium.updatePlants()

	local currentRank, currentMaxRank, skillmodifier  = Herbarium.getProfessionLevel()
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


function Herbarium:Open()
	Herbarium:createUI()
	Herbarium.updatePlants()
	PlaySound(829) --603/605
	ShowUIPanel(self.frame)
	
	
end



-- =========================================================
-- show AchievementFrame
-- =========================================================

function Herbarium.updateAchievementFrame(iconID, professionRank)
    local f = Herbarium.createAchievementFrame()
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



-- This stub is overridden when loading Herbarium_Debug
function Herbarium:debug(...) end


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

	
	
end



