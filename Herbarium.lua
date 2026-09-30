local _, namespace = ...

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}

Herbarium.HERBALISM_SKILL_LINE_ID = C_TradeSkillUI.GetProfessionSkillLineID(Enum.Profession.Herbalism)


-- print function with color
function Herbarium.printChat(message)
    print("|cff00ff00[Herbarium]|r " .. message)
end


-- ==========================================================================================
-- Herbalism profession level by TradeSkillLineID
-- ==========================================================================================
function Herbarium.getProfessionLevel()
	local profession1, profession2 = GetProfessions()
	local professions = { profession1, profession2 }

	for _, professionIndex in pairs(professions) do
		if professionIndex then
			local _, _, skillLevel, maxSkillLevel, _, _, skillLineID, skillModifier = GetProfessionInfo(professionIndex)

			if skillLineID == Herbarium.HERBALISM_SKILL_LINE_ID then
				return skillLevel, maxSkillLevel, skillModifier or 0
			end
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
SLASH_Herbarium1 = "/herbarium"
SLASH_Herbarium2 = "/herb"
SlashCmdList["Herbarium"] = function()
       
    if Herbarium.frame and Herbarium.frame:IsShown() then
        HideUIPanel(Herbarium.frame)
    else
        Herbarium:Open()
    end
	
end

SLASH_HERBDEBUG1 = "/herbdebug"
SlashCmdList["HERBDEBUG"] = function()
    if not C_AddOns.IsAddOnLoaded("Herbarium_Debug") then
        C_AddOns.LoadAddOn("Herbarium_Debug")
    else
        print("|cffff0000Herbarium Debug already loaded.|r")
    end
end

