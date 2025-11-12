local _, herbariumData = ...

Herbarium = Herbarium or {}

Herbarium.zoneLinks = {
    [765] = { -- Silverleaf
        {1413, 98}, -- The Barrens
        {1432, 81}, -- Loch Modan
        {1420, 70}, -- Tirisfal Glades
        {1412, 69}, -- Mulgore
        {1439, 64}, -- Darkshore
        {1429, 60}, -- Elwynn Forest
        {1426, 54}, -- Dun Morogh
        {1421, 54}, -- Silverpine Forest
        {1438, 49}, -- Teldrassil
        {1436, 27}, -- Westfall
        {1443, 5}, -- Desolace
    },
    [785] = { -- Mageroyal
        {1440, 63}, -- Ashenvale
        {1439, 61}, -- Darkshore
        {1436, 49}, -- Westfall
        {1421, 31}, -- Silverpine Forest
        {1433, 24}, -- Redridge Mountains
        {1432, 20}, -- Loch Modan
        {1437, 16}, -- Wetlands
        {1431, 15}, -- Duskwood
        {1411, 14}, -- Durotar
        {1424, 12}, -- Hillsbrad Foothills
        {1438, 12}, -- Teldrassil
        {1442, 6}, -- Stonetalon Mountains
        {1441, 2}, -- Thousand Needles
    },
    [2447] = { -- Peacebloom
        {1420, 54}, -- Tirisfal Glades
        {1412, 53}, -- Mulgore
        {1411, 53}, -- Durotar
        {1438, 44}, -- Teldrassil
        {1426, 41}, -- Dun Morogh
        {1429, 34}, -- Elwynn Forest
        {1421, 31}, -- Silverpine Forest
        {1432, 19}, -- Loch Modan
        {1436, 18}, -- Westfall
        {1439, 18}, -- Darkshore
        {1433, 8}, -- Redridge Mountains
        {1443, 4}, -- Desolace
        {1424, 3}, -- Hillsbrad Foothills
        {1458, 2}, -- Undercity
    },
    [2449] = { -- Earthroot
        {1420, 37}, -- Tirisfal Glades
        {1411, 33}, -- Durotar
        {1426, 31}, -- Dun Morogh
        {1438, 29}, -- Teldrassil
        {1436, 27}, -- Westfall
        {1433, 24}, -- Redridge Mountains
        {1412, 23}, -- Mulgore
        {1439, 20}, -- Darkshore
        {1429, 17}, -- Elwynn Forest
        {1421, 12}, -- Silverpine Forest
        {1432, 9}, -- Loch Modan
        {1443, 4}, -- Desolace
    },
    [2450] = { -- Briarthorn
        {1413, 84}, -- The Barrens
        {1440, 57}, -- Ashenvale
        {1439, 52}, -- Darkshore
        {1436, 50}, -- Westfall
        {1424, 32}, -- Hillsbrad Foothills
        {1433, 28}, -- Redridge Mountains
        {1437, 27}, -- Wetlands
        {1421, 25}, -- Silverpine Forest
        {1432, 17}, -- Loch Modan
        {1442, 14}, -- Stonetalon Mountains
        {1412, 2}, -- Mulgore
    },
    [2453] = { -- Bruiseweed
        {1424, 111}, -- Hillsbrad Foothills
        {1413, 104}, -- The Barrens
        {1440, 104}, -- Ashenvale
        {1437, 95}, -- Wetlands
        {1433, 92}, -- Redridge Mountains
        {1436, 86}, -- Westfall
        {1431, 82}, -- Duskwood
        {1432, 61}, -- Loch Modan
        {1441, 59}, -- Thousand Needles
        {1443, 50}, -- Desolace
        {1421, 39}, -- Silverpine Forest
        {1439, 39}, -- Darkshore
        {1417, 26}, -- Arathi Highlands
        {1416, 18}, -- Alterac Mountains
        {1428, 6}, -- Burning Steppes
    },
    [3355] = { -- Wild Steelbloom
        {1442, 90}, -- Stonetalon Mountains
        {1437, 47}, -- Wetlands
        {1434, 41}, -- Stranglethorn Vale
        {1441, 37}, -- Thousand Needles
        {1413, 34}, -- The Barrens
        {1418, 17}, -- Badlands
        {1440, 17}, -- Ashenvale
        {1424, 16}, -- Hillsbrad Foothills
        {1416, 16}, -- Alterac Mountains
        {1431, 11}, -- Duskwood
        {1443, 11}, -- Desolace
        {1427, 3}, -- Searing Gorge
        {1448, 3}, -- Felwood
        {1428, 2}, -- Burning Steppes
        {1425, 2}, -- The Hinterlands
    },
    [3356] = { -- Kingsblood
        {1424, 37}, -- Hillsbrad Foothills
        {1413, 29}, -- The Barrens
        {1437, 26}, -- Wetlands
        {1417, 21}, -- Arathi Highlands
        {1440, 21}, -- Ashenvale
        {1418, 20}, -- Badlands
        {1442, 20}, -- Stonetalon Mountains
        {1431, 19}, -- Duskwood
        {1441, 15}, -- Thousand Needles
        {1443, 13}, -- Desolace
        {1435, 6}, -- Swamp of Sorrows
        {1445, 5}, -- Dustwallow Marsh
        {1416, 3}, -- Alterac Mountains
    },
    [3357] = { -- Liferoot
        {1437, 51}, -- Wetlands
        {1417, 47}, -- Arathi Highlands
        {1416, 39}, -- Alterac Mountains
        {1424, 25}, -- Hillsbrad Foothills
        {1444, 19}, -- Feralas
        {1443, 11}, -- Desolace
        {1425, 11}, -- The Hinterlands
        {1440, 11}, -- Ashenvale
        {1435, 10}, -- Swamp of Sorrows
        {1445, 10}, -- Dustwallow Marsh
        {1433, 6}, -- Redridge Mountains
        {1421, 4}, -- Silverpine Forest
    },
    [3358] = { -- Khadgar's Whisker
        {1417, 71}, -- Arathi Highlands
        {1435, 51}, -- Swamp of Sorrows
        {1425, 27}, -- The Hinterlands
        {1416, 27}, -- Alterac Mountains
        {1418, 26}, -- Badlands
        {1444, 16}, -- Feralas
        {1424, 11}, -- Hillsbrad Foothills
        {1445, 9}, -- Dustwallow Marsh
        {1447, 4}, -- Azshara
    },
    [3369] = { -- Grave Moss
        {1443, 18}, -- Desolace
        {1437, 15}, -- Wetlands
        {1417, 7}, -- Arathi Highlands
        {1416, 7}, -- Alterac Mountains
        {1413, 5}, -- The Barrens
    },
    [3818] = { -- Fadeleaf
        {1435, 50}, -- Swamp of Sorrows
        {1416, 36}, -- Alterac Mountains
        {1434, 34}, -- Stranglethorn Vale
        {1418, 28}, -- Badlands
        {1425, 25}, -- The Hinterlands
        {1424, 9}, -- Hillsbrad Foothills
        {1445, 7}, -- Dustwallow Marsh
    },
    [3819] = { -- Wintersbite
        {1416, 17}, -- Alterac Mountains
    },
    [3820] = { -- Stranglekelp
        {1439, 92}, -- Darkshore
        {1413, 68}, -- The Barrens
        {1434, 57}, -- Stranglethorn Vale
        {1437, 41}, -- Wetlands
        {1424, 35}, -- Hillsbrad Foothills
        {1444, 31}, -- Feralas
        {1436, 27}, -- Westfall
        {1443, 24}, -- Desolace
        {1425, 18}, -- The Hinterlands
        {1421, 15}, -- Silverpine Forest
        {1447, 12}, -- Azshara
        {1435, 6}, -- Swamp of Sorrows
        {1446, 5}, -- Tanaris
        {1417, 4}, -- Arathi Highlands
        {1445, 3}, -- Dustwallow Marsh
        {1458, 2}, -- Undercity
    },
    [3821] = { -- Goldthorn
        {1417, 117}, -- Arathi Highlands
        {1435, 91}, -- Swamp of Sorrows
        {1416, 76}, -- Alterac Mountains
        {1425, 53}, -- The Hinterlands
        {1418, 41}, -- Badlands
        {1444, 28}, -- Feralas
        {1445, 9}, -- Dustwallow Marsh
        {1424, 5}, -- Hillsbrad Foothills
        {1447, 2}, -- Azshara
    },
    [4625] = { -- Firebloom
        {1427, 54}, -- Searing Gorge
        {1419, 43}, -- Blasted Lands
        {1418, 21}, -- Badlands
    },
    [8831] = { -- Purple Lotus
        {1425, 34}, -- The Hinterlands
        {1446, 32}, -- Tanaris
        {1434, 15}, -- Stranglethorn Vale
        {1444, 15}, -- Feralas
        {1440, 15}, -- Ashenvale
        {1418, 5}, -- Badlands
        {1432, 2}, -- Loch Modan
    },
    [8836] = { -- Arthas' Tears
        {1423, 24}, -- Eastern Plaguelands
        {1448, 23}, -- Felwood
        {1420, 2}, -- Tirisfal Glades
    },
    [8838] = { -- Sungrass
        {1425, 77}, -- The Hinterlands
        {1419, 37}, -- Blasted Lands
        {1423, 35}, -- Eastern Plaguelands
        {1444, 23}, -- Feralas
        {1449, 21}, -- Un'Goro Crater
        {1428, 20}, -- Burning Steppes
        {1448, 18}, -- Felwood
        {1422, 9}, -- Western Plaguelands
        {1451, 4}, -- Silithus
    },
    [8839] = { -- Blindweed
        {1449, 16}, -- Un'Goro Crater
        {1447, 2}, -- Azshara
    },
    [8845] = { -- Ghost Mushroom
        {1443, 12}, -- Desolace
    },
    [8846] = { -- Gromsblood
        {1419, 26}, -- Blasted Lands
        {1443, 12}, -- Desolace
        {1440, 8}, -- Ashenvale
        {1452, 2}, -- Winterspring
    },
    [13463] = { -- Dreamfoil
        {1449, 83}, -- Un'Goro Crater
        {1423, 71}, -- Eastern Plaguelands
        {1428, 57}, -- Burning Steppes
        {1448, 54}, -- Felwood
        {1422, 33}, -- Western Plaguelands
        {1451, 22}, -- Silithus
        {1435, 2}, -- Swamp of Sorrows
    },
    [13464] = { -- Golden Sansam
        {1447, 87}, -- Azshara
        {1423, 45}, -- Eastern Plaguelands
        {1428, 32}, -- Burning Steppes
        {1451, 30}, -- Silithus
        {1448, 30}, -- Felwood
        {1425, 26}, -- The Hinterlands
        {1444, 17}, -- Feralas
    },
    [13465] = { -- Mountain Silversage
        {1449, 64}, -- Un'Goro Crater
        {1447, 52}, -- Azshara
        {1428, 28}, -- Burning Steppes
        {1451, 12}, -- Silithus
        {1423, 11}, -- Eastern Plaguelands
        {1422, 3}, -- Western Plaguelands
    },
    [13466] = { -- Plaguebloom
        {1422, 77}, -- Western Plaguelands
        {1448, 63}, -- Felwood
    },
    [13468] = { -- Black Lotus
        {1452, 15}, -- Winterspring
        {1423, 10}, -- Eastern Plaguelands
        {1451, 6}, -- Silithus
    },
}

Herbarium.herbalism = {
    {1,   "Peacebloom",             133939,  2447},
    {1,   "Silverleaf",             134190,   765},
    {15,  "Earthroot",              134187,  2449},
    {50,  "Mageroyal",              133436,   785},
    {70,  "Briarthorn",             134412,  2450},
    {85,  "Stranglekelp",           134191,  3820},
    {100, "Bruiseweed",             134181,  2453},
    {115, "Wild Steelbloom",        133938,  3355},
    {120, "Grave Moss",             133849,  3369},
    {125, "Kingsblood",             134183,  3356},
    {150, "Liferoot",               134413,  3357},
    {160, "Fadeleaf",               134193,  3818},
    {170, "Goldthorn",              134196,  3821},
    {185, "Khadgar's Whisker",      134188,  3358},
    {195, "Wintersbite",            133940,  3819},
    {205, "Firebloom",              134200,  4625},
    {210, "Purple Lotus",           134198,  8831},
    {220, "Arthas' Tears",          134194,  8836},
    {230, "Sungrass",               134199,  8838},
    {235, "Blindweed",              134195,  8839},
    {245, "Ghost Mushroom",         134529,  8845},
    {250, "Gromsblood",             134197,  8846},
    {260, "Golden Sansam",          134221,  13464},
    {270, "Dreamfoil",              134204,  13463},
    {280, "Mountain Silversage",    134215,  13465},
    {285, "Plaguebloom",            134219,  13466},
    {290, "Icecap",                 134212,  13467},
    {300, "Black Lotus",            134202,  13468},
}

Herbarium.zones = {
    {1411, "Durotar"},
    {1412, "Mulgore"},
    {1413, "The Barrens"},
    {1416, "Alterac Mountains"},
    {1417, "Arathi Highlands"},
    {1418, "Badlands"},
    {1419, "Blasted Lands"},
    {1420, "Tirisfal Glades"},
    {1421, "Silverpine Forest"},
    {1422, "Western Plaguelands"},
    {1423, "Eastern Plaguelands"},
    {1424, "Hillsbrad Foothills"},
    {1425, "The Hinterlands"},
    {1426, "Dun Morogh"},
    {1427, "Searing Gorge"},
    {1428, "Burning Steppes"},
    {1429, "Elwynn Forest"},
    {1430, "Deadwind Pass"},
    {1431, "Duskwood"},
    {1432, "Loch Modan"},
    {1433, "Redridge Mountains"},
    {1434, "Stranglethorn Vale"},
    {1435, "Swamp of Sorrows"},
    {1436, "Westfall"},
    {1437, "Wetlands"},
    {1438, "Teldrassil"},
    {1439, "Darkshore"},
    {1440, "Ashenvale"},
    {1441, "Thousand Needles"},
    {1442, "Stonetalon Mountains"},
    {1443, "Desolace"},
    {1444, "Feralas"},
    {1445, "Dustwallow Marsh"},
    {1446, "Tanaris"},
    {1447, "Azshara"},
    {1448, "Felwood"},
    {1449, "Un'Goro Crater"},
    {1450, "Moonglade"},
    {1451, "Silithus"},
    {1452, "Winterspring"},
    {1453, "Stormwind City"},
    {1454, "Orgrimmar"},
    {1455, "Ironforge"},
    {1456, "Thunder Bluff"},
    {1457, "Darnassus"},
    {1458, "Undercity"},
    {1459, "Alterac Valley"},
    {1460, "Warsong Gulch"},
    {1461, "Arathi Basin"},
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
		["herbalism"]= "Herbalism",
        ["Gathered"] = "Gathered",
        ["Herb Gathering"] = "Herb Gathering",
        ["Completed"] = "completed",
        ["GatherFirst"] = "First time gathered: "
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
    L["Gathered"] = "Gesammelt"
    L["Herb Gathering"] = "Kr\195\164utersammeln"
    L["Completed"] = "abgeschlossen"
    L["GatherFirst"] = "Zum ersten mal gesammelt: "

end

--autotranslate
local countNil = 1
local maxtrys = 3
while countNil > 0 and maxtrys > 0 do
    
    countNil = 0
    maxtrys = maxtrys - 1
    for _, herb in pairs(Herbarium.herbalism) do
        for name, translation in pairs(Herbarium.L) do
            if herb[2] == name then
                local translatedName = C_Item.GetItemNameByID(herb[4])
                if translatedName then 
                    Herbarium.L[name] = translatedName
                else
                    countNil = countNil + 1
                end
            end
            
        end
    end
end