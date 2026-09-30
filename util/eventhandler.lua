local addonName, namespace = ...

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}

local FIND_HERBS_SPELL_ID = 2383

-- Loot is cached when it becomes available and only recorded when the slot is
-- actually cleared. This avoids counting herbs that were seen but not looted.
local pendingGatherLoot = {}
local gatheredThisLoot = {}

local function clearTable(tbl)
    for key in pairs(tbl) do
        tbl[key] = nil
    end
end

local function getGatherMapID()
    local mapID = C_Map.GetBestMapForUnit("player")

    -- Normalize sub-zones to the same map level Herbarium historically stored.
    while mapID do
        local mapInfo = C_Map.GetMapInfo(mapID)
        if not mapInfo or mapInfo.mapType <= 3 then
            break
        end

        mapID = mapInfo.parentMapID
    end

    if not mapID then
        local _, _, _, _, _, _, _, instanceID = GetInstanceInfo()
        mapID = instanceID
    end

    return mapID
end

local function getGameObjectSourceGUID(lootSlot)
    local sources = { GetLootSourceInfo(lootSlot) }

    -- GetLootSourceInfo returns GUID/quantity pairs. Resource nodes such as
    -- herbs are GameObjects; creature loot therefore does not get tracked.
    for i = 1, #sources, 2 do
        local sourceGUID = sources[i]
        if type(sourceGUID) == "string" and sourceGUID:sub(1, 11) == "GameObject-" then
            return sourceGUID
        end
    end
end

local function cacheGatherLoot()
    clearTable(pendingGatherLoot)
    clearTable(gatheredThisLoot)

    -- Do not track herb items unless this character actually knows Herbalism.
    if not Herbarium.getProfessionLevel() then
        return
    end

    for lootSlot = 1, GetNumLootItems() do
        if LootSlotHasItem(lootSlot) then
            local itemLink = GetLootSlotLink(lootSlot)
            local itemID = itemLink and C_Item.GetItemIDForItemInfo(itemLink)
            local herb = itemID and Herbarium.herbsByID[itemID]

            if herb then
                local sourceGUID = getGameObjectSourceGUID(lootSlot)

                if sourceGUID then
                    pendingGatherLoot[lootSlot] = {
                        itemID = itemID,
                        sourceGUID = sourceGUID,
                    }

                    Herbarium:debug("Tracking herb loot itemID: ", itemID, " source: ", sourceGUID)
                end
            end
        end
    end
end

local function recordGather(itemID)
    local herb = Herbarium.herbsByID[itemID]
    if not herb then
        return
    end

    local playerName = UnitName("player")
    local gathered = Herbarium.ensure(HerbariumDB, playerName, "GATHERED")
    local gatherLog = gathered[itemID]
    local firstGather = gatherLog == nil

    -- Keep old SavedVariables usable even if the player gathers before opening
    -- Herbarium and triggering the normal database migration.
    if type(gatherLog) == "number" then
        gatherLog = {
            total = gatherLog,
            zones = {},
        }
        gathered[itemID] = gatherLog
        firstGather = false
    elseif type(gatherLog) ~= "table" then
        gatherLog = {
            total = 0,
            zones = {},
        }
        gathered[itemID] = gatherLog
    end

    gatherLog.total = (gatherLog.total or 0) + 1
    gatherLog.zones = gatherLog.zones or {}

    local mapID = getGatherMapID()
    if mapID then
        gatherLog.zones[mapID] = gatherLog.zones[mapID] or { total = 0 }
        gatherLog.zones[mapID].total = (gatherLog.zones[mapID].total or 0) + 1
    end

    Herbarium:debug("Gathered herb itemID: ", itemID, " mapID: ", mapID)

    if firstGather then
        PlaySound(7355)
        PlaySound(3093)

        local itemName = C_Item.GetItemNameByID(itemID) or Herbarium.L[herb.name] or tostring(itemID)
        Herbarium.printChat(Herbarium.L["GatherFirst"] .. itemName)
    end

    Herbarium.checkAchievements()
end

function Herbarium.handleEvent(self, event, ...)
    if event == "LOOT_READY" then
        cacheGatherLoot()
        return
    end

    if event == "LOOT_SLOT_CLEARED" then
        local lootSlot = ...
        local pending = pendingGatherLoot[lootSlot]

        if pending then
            -- A single source can theoretically expose the same item in more
            -- than one loot slot. Count that herb only once per resource node.
            local gatherKey = pending.sourceGUID .. ":" .. pending.itemID

            if not gatheredThisLoot[gatherKey] then
                gatheredThisLoot[gatherKey] = true
                recordGather(pending.itemID)
            end

            pendingGatherLoot[lootSlot] = nil
        end

        return
    end

    if event == "LOOT_CLOSED" then
        clearTable(pendingGatherLoot)
        clearTable(gatheredThisLoot)
        return
    end

    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        local unitTarget, _, spellID = ...

        -- Keep the existing convenience behavior: using Find Herbs opens Herbarium.
        if unitTarget == "player" and spellID == FIND_HERBS_SPELL_ID then
            Herbarium:Open()
        end
    end
end

local f = CreateFrame("Frame")
f:RegisterEvent("LOOT_READY")
f:RegisterEvent("LOOT_SLOT_CLEARED")
f:RegisterEvent("LOOT_CLOSED")
f:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
f:SetScript("OnEvent", Herbarium.handleEvent)

Herbarium.eventFrame = f
