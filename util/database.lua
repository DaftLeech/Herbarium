local addonName, namespace = ...

-- SavedVariables
HerbariumDB = HerbariumDB or {}
Herbarium = Herbarium or {}

-- ==========================================================================================
-- database functions
-- ==========================================================================================

-- Erstellt alle Zwischen-Tabellen und gibt den letzten Teil zurück
function Herbarium.ensure(tbl, ...)
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

function Herbarium.ensureSet(tbl, value, ...)
    local keys = {...}
    local lastKey = table.remove(keys)
    local target = Herbarium.ensure(tbl, unpack(keys))
    target[lastKey] = value
end

-- ensureGet(tbl, key1, key2, key3, ...)
-- Gibt den Wert zurück, falls der gesamte Pfad existiert, sonst nil
function Herbarium.ensureGet(tbl, ...)
    local keys = {...}
    local current = tbl
    for i = 1, #keys do
        if type(current) ~= "table" then
            return current
        end
        current = current[keys[i]]
        if current == nil then
            return nil
        end
    end
    return current
end

function Herbarium.removeItem(playerName, section, itemId)
    local playerData = HerbariumDB[playerName]
    if not playerData then return end	
	if not playerData[section] then return end

    playerData[section][itemId] = nil

	-- Falls keine Items mehr da sind, lösche den Spieler
	if next(playerData[section]) == nil then
        HerbariumDB[playerName][section] = nil
    end
    
    if next(playerData) == nil then
        HerbariumDB[playerName] = nil
    end
end