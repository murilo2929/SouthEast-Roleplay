--Furkan Parlak

SERITLER = {}

function findEmptyID(plr)
	local i = 1
	if not SERITLER[plr] then
		SERITLER[plr] = {}
	end
	while (SERITLER[plr][i]) do
		i = i + 1
	end
	return i
end

SERIT_MODE = {}

function reloadPlayers()
	triggerClientEvent(root,"serit.loadSerits",root,SERITLER)
end

function sendToServer(id,data)
	if not SERITLER[source] then
		SERITLER[source] = {}
	end
	SERITLER[source][id] = data
	reloadPlayers()
end
addEvent("serit.sendToServer",true)
addEventHandler("serit.sendToServer",root,sendToServer)

function seritMode(plr)
	local fact = exports.factions:isPlayerInFaction(plr, 1)
	if not(fact) then return end
	if SERIT_MODE[plr] then
		local eid = SERIT_MODE[plr]
		triggerClientEvent( plr, "serit.openSeritModeClient", plr, false, eid )
		outputChatBox("[!] #ffffffFaixa colocada. ID: "..eid,plr,255,0,0,true)
		outputChatBox("[!] #ffffffPara remover /rfita [id].",plr,255,0,0,true)
		SERIT_MODE[plr] = false
		return
	end
	outputChatBox("[!] #ffffffVocê está colocando faixas. Para parar /fita.",plr,255,0,0,true)
	local eid = findEmptyID(plr)
	SERIT_MODE[plr] = eid
	triggerClientEvent( plr, "serit.openSeritModeClient", plr, true, eid )
end
addCommandHandler("fita",seritMode,false,false)

function seritsil(plr,cmd,id)
	if SERITLER[plr] and tonumber(id) and SERITLER[plr][tonumber(id)] then
		SERITLER[plr][tonumber(id)] = nil
		reloadPlayers()
		outputChatBox("[!] #ffffffFita removida.",plr,255,0,0,true)
	end
end
addCommandHandler("rfita",seritsil,false,false)

function quitPlayer ( quitType )
	if SERITLER[source] then
		SERITLER[source] = nil
	end
	reloadPlayers()
end
addEventHandler ( "onPlayerQuit", getRootElement(), quitPlayer )
