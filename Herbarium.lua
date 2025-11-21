local _, namespace = ...

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




function Herbarium:Open()
	local playerName = UnitName("player")
	if HerbariumDB[playerName] and not HerbariumDB[playerName].migrateDatabase then
		Herbarium.migrateDatabase()
	end
	

	Herbarium:createUI()
	Herbarium.updatePlants()
	PlaySound(829) --603/605
	ShowUIPanel(self.frame)
	
	
end

function Herbarium.migrateDatabase()
	local playerName = UnitName("player")
	local itemSlot = Herbarium.ensureGet(HerbariumDB, playerName, "GATHERED")
	if itemSlot then
		local newItemSlot = {}
		local changed = false
		for i, itemEntry in pairs(itemSlot) do
			
			Herbarium:debug("key: ", i, " value: ", itemEntry)
			if type(itemEntry) == "number" then
				newItemSlot[i] = {total = itemEntry, zones = {}}
				if Herbarium.dump then
					Herbarium:dump(newItemSlot)
				end
				changed = true
			end
		end
		if changed then
			HerbariumDB[playerName]["GATHERED"] = newItemSlot
		end		
	end
	HerbariumDB[playerName].migrateDatabase = true
end





Herbarium.debugEnabled = Herbarium.debugEnabled or false
Herbarium.debugReceiver = Herbarium.debugReceiver or ""

-- This stub is overridden when loading Herbarium_Debug
function Herbarium:debug(...)

	if not Herbarium.debugEnabled then return end

	local msg = ""
    for i = 1, select("#", ...) do
        local v = select(i, ...)
        msg = msg .. tostring(v) .. " "
    end

    msg = msg:gsub("\n", "")

	if Herbarium.generatePayload and Herbarium.sendNetworkMessage then
			
		local payload = Herbarium.generatePayload("DEBUG_MSG")
		payload.text = msg

		Herbarium:sendNetworkMessage(Herbarium.debugReceiver, payload, true)
	end
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
	
end

SLASH_HERBDEBUG1 = "/herbdebug"
SlashCmdList["HERBDEBUG"] = function()
    if not IsAddOnLoaded("Herbarium_Debug") then
        LoadAddOn("Herbarium_Debug")
    else
        print("|cffff0000Herbarium Debug already loaded.|r")
    end
end

