local addonName, namespace = ...

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

		arg2 = arg2:gsub("’","'") 

		-- capture localizated name for SUCCEEDED event 
		Herbarium.CurrentPlantName = arg2
		Herbarium:debug(Herbarium.CurrentPlantName)

		-- target is localizated name of plant
		-- get the english name so we can figure out the itemId
		local plantNameEn = nil
		for nameEn, nameLoc in pairs(Herbarium.L) do
			if nameLoc:lower() == arg2:lower() then
				plantNameEn = nameEn:lower()
			end
		end

		-- get the itemId
		Herbarium:debug(plantNameEn)
		
		Herbarium.CurrentPlantItemId = Herbarium.herbsByName[plantNameEn].itemId
		
	end

	-- spell=2366/herb-gathering
	-- arg1 = unit / "player"
	-- arg2 = castGUID 
	-- arg3 = spellId / 2366
	if event == "UNIT_SPELLCAST_SUCCEEDED" then


		-- search for herbs -> open ui
		if arg3 == 2383 then 
			Herbarium:Open()
			return
		end

		-- different spells for different "ranks" ..
			--local spellName = GetSpellInfo(arg3)
			--if Herbarium.L["Herb Gathering"] ~= spellName then return end 

		-- .. or always 2366?
		if arg3 ~= 2366 then return end

		-- same GUID as in before? we continue 
		if arg2 == Herbarium.CurrentPlantGUID and arg1 == "player" then

			local playerName = UnitName(arg1)
			local itemId = Herbarium.CurrentPlantItemId

			local mapId = C_Map.GetBestMapForUnit("player")
			
			while mapId and C_Map.GetMapInfo(mapId).mapType > 3 do
				mapId = C_Map.GetMapInfo(mapId).parentMapID
			end
			Herbarium:debug(C_Map.GetMapInfo(mapId or 1).name)

			-- TOTAL GATHERED
			-- create entry in DB if not exists..
			if not HerbariumDB[playerName] or not HerbariumDB[playerName]["GATHERED"] or not HerbariumDB[playerName]["GATHERED"][itemId] then
				local gatherLog = Herbarium.ensure(HerbariumDB, playerName, "GATHERED", itemId)
				gatherLog.total = 1
				gatherLog.zones = {}

				if mapId then
					gatherLog.zones[mapId] = {total = 1}
				end

				Herbarium.ensureSet(HerbariumDB, gatherLog, playerName, "GATHERED", itemId)

				PlaySound(7355)
				PlaySound(3093)--3093 (writing sound) / 7355 (tutorial pling)
				if Herbarium.CurrentPlantName then
					Herbarium.printChat(Herbarium.L["GatherFirst"] .. Herbarium.CurrentPlantName)
				end
				
			else 
				-- .. else count up
				local currentGatherLog = Herbarium.ensure(HerbariumDB, playerName, "GATHERED", itemId)
				currentGatherLog.total = currentGatherLog.total + 1

				if mapId then
					currentGatherLog.zones[mapId] = currentGatherLog.zones[mapId] or {total = 0}
					currentGatherLog.zones[mapId].total = (currentGatherLog.zones[mapId].total or 0) + 1
				end

				Herbarium.ensureSet(HerbariumDB, currentGatherLog, playerName, "GATHERED", itemId)
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

Herbarium.eventFrame = f