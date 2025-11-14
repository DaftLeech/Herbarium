local addonName, Herbarium = ...

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}

-- ==========================================================================================
-- handle events
-- ==========================================================================================

Herbarium.CurrentPlantGUID = nil
Herbarium.CurrentPlantItemId = nil
Herbarium.CurrentPlantName = nil

function Herbarium.handleEvent(self, event, arg1, arg2, arg3, arg4, arg5)

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
				plantNameEn = nameEn:lower()
			end
		end

		-- get the itemId
		Herbarium.CurrentPlantItemId = Herbarium.herbsByName[plantNameEn].itemId
		
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
			local itemId = Herbarium.CurrentPlantItemId
			

			-- create entry in DB if not exists..
			if not HerbariumDB[playerName] or not HerbariumDB[playerName]["GATHERED"] or not HerbariumDB[playerName]["GATHERED"][itemId] then
				Herbarium.ensureSet(HerbariumDB, 1, playerName, "GATHERED", itemId)

				PlaySound(7355)
				PlaySound(3093)--3093 (writing sound) / 7355 (tutorial pling)
				if Herbarium.CurrentPlantName then
					Herbarium.printChat(Herbarium.L["GatherFirst"] .. Herbarium.CurrentPlantName)
				end
				
			else 
				-- .. else count up
				local currentGatherCount = Herbarium.ensureGet(HerbariumDB, playerName, "GATHERED", itemId)
				Herbarium.ensureSet(HerbariumDB, currentGatherCount + 1, playerName, "GATHERED", itemId)
			end

			Herbarium.checkAchievements()
			
		end
	end

end

local f = CreateFrame("Frame")
--f:RegisterEvent("CHAT_MSG_SYSTEM")
f:RegisterEvent("UNIT_SPELLCAST_SENT")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:SetScript("OnEvent", Herbarium.handleEvent)