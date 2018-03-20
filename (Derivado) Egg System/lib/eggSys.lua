eggSystem = {
name = "Egg System";
author = "Smowking";
version = "1.0.0.0";
mysqlquery1="ALTER TABLE accounts ADD eggTimeMale int(15) NOT NULL DEFAULT 0";
mysqlquery1="ALTER TABLE accounts ADD eggTimeFemale int(15) NOT NULL DEFAULT 0";
mysqlquery2="ALTER TABLE accounts ADD eggGroup VARCHAR(15)";
mysqlquery3="ALTER TABLE accounts ADD eggTries int(4) NOT NULL DEFAULT 0";

sqlquery1="ALTER TABLE accounts ADD eggTimeMale INTEGER";
sqlquery1="ALTER TABLE accounts ADD eggTimeFemale INTEGER";
sqlquery2="ALTER TABLE accounts ADD eggTime char(15)";
sqlquery3="ALTER TABLE accounts ADD eggTries INTEGER";
}

eggGroups = {
["Monster"] = {desc = "Monster", chance = 80, pokemons = {"Ditto", "Bulbasaur", "Ivysaur", "Venusaur", "Charmander", "Charmeleon", "Charizard", "Squirtle", "Wartortle", "Blastoise", "NidoranM", "NidoranF", "Nidorino", "Nidoking", "Slowpoke", "Slowbro", "Rhyhorn", "Rhydon", "Lapras", "Cubone", "Marowak", "Lickitung", "Kangaskhan", "Snorlax", "Chikorita", "Bayleef", "Meganium", "Totodile", "Croconaw", "Feraligatr", "Mareep", "Flaaffy", "Ampharos", "Slowking", "Larvitar", "Pupitar", "Tyranitar"}},
["Water 1"] = {desc = "Water 1", chance = 80, pokemons = {"Ditto","Squirtle", "Wartortle", "Blastoise", "Psyduck", "Golduck", "Slowpoke", "Slowbro", "Seel", "Dewgong", "Horsea", "Seadra", "Lapras", "Omanyte", "Omastar", "Kabuto", "Kabutops", "Dratini", "Dragonair", "Dragonite", "Poliwag", "Poliwhirl", "Poliwrath"}},
["Water 2"] = {desc = "Water 2", chance = 80, pokemons = {"Ditto"}},
["Water 3"] = {desc = "Water 3", chance = 80, pokemons = {"Ditto"}},
["Bug"] = {desc = "Bug", chance = 80, pokemons = {"Ditto", "Caterpie", "Metapod", "Butterfree"}},
["Human-Like"] = {desc = "Homan-Like", chance = 80, pokemons = {"Ditto", "Geodude"}},
["Mineral"] = {desc = "Mineral", chance = 80, pokemons = {"Ditto"}},
["Flying"] = {desc = "Flying", chance = 80, pokemons = {"Ditto"}},
["Amorphous"] = {desc = "Amorphous", chance = 80, pokemons = {"Ditto"}},
["Field"] = {desc = "Field", chance = 80, pokemons = {"Ditto"}},
["Fairy"] = {desc = "Fairy", chance = 80, pokemons = {"Ditto"}},
["Grass"] = {desc = "Grass", chance = 80, pokemons = {"Ditto"}},
["Dragon"] = {desc = "Dragon", chance = 80, pokemons = {"Dratini", "Dragonair", "Dragonite"}},
["Undiscovered"] = {desc = "Undiscovered", chance = 80, pokemons = {"Ditto"}},
["Gender Unknown"] = {desc = "Gender Unknown", chance = 80, pokemons = {"Ditto", "Magnemite"}}
}

function depositPokemon(pokeball)
local slotDeposit = CONST_SLOT_ARMOR

if (getItemAttribute(pokeball, "gender") == "Male") then
	slotDeposit = CONST_SLOT_HEAD
end

local attributes = {"poke", "hp", "offense", "defense", "speed", "vitality", "specialattack", "happy", "gender", "hands", "description", "fakedesc", "boost", "ball", "defeated", "shiny", "level", "wildlevel", "levell", "lp"}
for i=1, #attributes do
doItemSetAttribute(getPlayerSlotItem(slotDeposit).uid, attributes[i], getItemAttribute(pokeball))
end

eggAddExhaust(cid, 1000*60*60*24, getItemAttribute(pokeball, "gender"))
end

function eggAddExhaust(cid,time, sexo)
if (sexo ~= "Male" or sexo ~= "Female") then error('Unknown parameter "sexo" in eggAddExhaust()') end;
dofile("config.lua")
assert(tonumber(cid),'Parameter must be a number')
assert(tonumber(time),'Parameter must be a number')
if isPlayer(cid) == FALSE then error('Player don\'t find') end;
db.executeQuery("UPDATE `"..sqlDatabase.."`.`accounts` SET `eggTime"..sexo.."` = '"..(os.time()+time).."' WHERE `accounts`.`name` ='".. getPlayerAccount(cid).."';")
end

function eggGetExhaustString(cid, sexo)
if (sexo ~= "Male" or sexo ~= "Female") then error('Unknown parameter "sexo" in eggGetExhaustString()') end;
assert(tonumber(cid),'Parameter must be a number')
if isPlayer(cid) == TRUE then
return os.date("%d %B %Y %X ", eggGetExhaust(cid, sexo))
end
end

function eggGetExhaust(cid, sexo)
if (sexo ~= "Male" or sexo ~= "Female") then error('Unknown parameter "sexo" in eggGetExhaust()') end;
assert(tonumber(cid),'Parameter must be a number')
if isPlayer(cid) == FALSE then error('Player don\'t find') end;
ae = db.getResult("SELECT `eggTime"..sexo.."` FROM `accounts` WHERE `name` = '"..getPlayerAccount(cid).."';")
if ae:getID() == -1 then
return 0
end
end

function retornaCompatibility(pokemon1, pokemon2)
local groups1 = returnEggGroups(pokemon1)
local groups2 = returnEggGroups(pokemon2)

	for _,group in pairs(groups1) do
		for i=1,#groups2 do
		  if group == groups2[i] then
				return true
		  end
		end
	end
return false
end

function returnEggGroups(pokemon)
local groups = {}

for _,group in pairs(eggGroups) do
	if (isInArray(group.pokemons, pokemon)) then
		table.insert(groups, group.desc)
	end
end

return groups
end

function eggsCreateTables()
dofile('config.lua')
if sqlType == "sqlite" then
db.executeQuery(eggSystem.sqlquery1)
db.executeQuery(eggSystem.sqlquery2)
db.executeQuery(eggSystem.sqlquery3)
else
db.executeQuery(eggSystem.mysqlquery1)
db.executeQuery(eggSystem.mysqlquery2)
db.executeQuery(eggSystem.mysqlquery3)
end