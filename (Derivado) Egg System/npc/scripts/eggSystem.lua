local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)
local talkState = {}
function onCreatureAppear(cid) npcHandler:onCreatureAppear(cid) end
function onCreatureDisappear(cid) npcHandler:onCreatureDisappear(cid) end
function onCreatureSay(cid, type, msg) npcHandler:onCreatureSay(cid, type, msg) end
function onThink() npcHandler:onThink() end

local npc = getNpcCid()
local npcName = npcs[getCreatureName(getNpcCid())]

function creatureSayCallback(cid, type, msg)

	if(not npcHandler:isFocused(cid)) then
		return false
	end

local storageDayCare = 21422
local talkUser = NPCHANDLER_CONVBEHAVIOR == CONVERSATION_DEFAULT and 0 or cid

	if(msgcontains(msg, 'help')) then
		if (eggGetExhaust(cid, "Male")) > 0 or (eggGetExhaust(cid, "Female")) > 0 then
			selfSay('We have your pokemon under our care. Do you want to see how much {time} is left before the end of care, {withdraw} or {cancel} your pokemon care?', cid)		
			talkState[talkUser] = 1		
		else
			selfSay('You can {deposit} your pokemon to be under our care.', cid)		
			talkState[talkUser] = 3
		end
	elseif(msgcontains(msg, 'time') and talkState[talkUser] == 1) then	
		selfSay('Oh, ok! Tell me now what pokemon you want to check, {male} or {female}?', cid)
		talkState[talkUser] = 2
	elseif(msgcontains(msg, 'deposit') and talkState[talkUser] == 3) then	
		local pokeball = getPlayerSlotItem(CONST_SLOT_FEET).uid
		selfSay('Oh, ok! But you really want to deposit a '..getItemAttribute(pokeball, "pokename")..'?', cid)
		talkState[talkUser] = 4
	elseif(msgcontains(msg, 'yes') and talkState[talkUser] == 4) then
		local pokeball = getPlayerSlotItem(CONST_SLOT_FEET).uid
		if (getItemAttribute(pokeball, "gender") == "Male") then
			if (os.time() > os.time+eggGetExhaust(cid, "Male")) then
				if (pokeball ~= 0) then
					depositPokemon(pokeball)
					doRemoveItem(pokeball, 1)
				end
			end
		end
		

	elseif(msgcontains(msg, 'no') and talkState[talkUser] == 4) then
		selfSay('Ok then... Bye!', cid)
		talkState[talkUser] = 0
	elseif(msgcontains(msg, 'male') and talkState[talkUser] == 2) then	
		if (os.time() < os.time-eggGetExhaust(cid, "Male")) then
			local pokename = getItemAttribute(getPlayerSlotItem(CONST_SLOT_HEAD).uid, "pokename")
			selfSay('Hmmm... Your '..pokename..' will be looked after '..eggGetExhaustString(cid, "Male"), cid)
		else
			selfSay('Hmmm... We are done with your pokemon!', cid)
		end
	elseif(msgcontains(msg, 'female') and talkState[talkUser] == 2) then	
		if (os.time() < os.time-eggGetExhaust(cid, "Female")) then
			local pokename = getItemAttribute(getPlayerSlotItem(CONST_SLOT_HEAD).uid, "pokename")
			selfSay('Hmmm... Your '..pokename..' will be looked after '..eggGetExhaustString(cid, "Female"), cid)
		else
			selfSay('Hmmm... We are done with your pokemon!', cid)
		end
	
	
	end
	
	
	end
return true
end


npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())