--MAXIME / 2015.1.10
local mysql = exports.mysql
function sendOpm(username, msg, cost)
	if not isElement( client ) then
		client = source
	end
	
	local userid = exports.cache:getIdFromUsername(username)
	if userid then
		local read = mysql:query_fetch_assoc("SELECT DATE_FORMAT(date,'%b %d, %Y %h:%i %p') AS fdate FROM notifications WHERE userid="..userid.." AND type="..getElementData(client, "account:id").." AND `read`=0 LIMIT 1")
		if read and read.fdate then
			outputChatBox("Oops, "..username.." já recebeu outro PM não lido de você em "..read.fdate..". Eles devem ler antes que você possa enviar outro.", client, 255,0,0)
			return false
		else
			--outputChatBox(tostring(cost))
			if cost and tonumber(cost) and tonumber(cost) > 0 then
				local perk = exports.donators:getPerks(37)
				local suc, err = exports.donators:takeGC(client, perk[2])
				if suc then
					exports.donators:addPurchaseHistory(client, perk[1].." (To "..username..")", -perk[2])
				else
					outputChatBox("Opps, "..err, client, 255,0,0)
					return false
				end
			end
			if makePlayerNotification(userid, "Nova mensagem privada de "..getElementData(client, "account:username"), msg, getElementData(client, "account:id")) then
				outputChatBox("Mensagem privada entregue a "..username, client, 0,255,0)
				return true
			else
				return false
			end
		end
	else
		outputChatBox("Oops, não conseguimos encontrar destinatário '"..username.."'. A entrega da mensagem falhou!", client, 255, 0, 0)
		return false
	end
end
addEvent( "opm:send", true )
addEventHandler( "opm:send", resourceRoot, sendOpm )

function sendOpmFromCmd(player, cmd, username, ...)
	local cost = exports.donators:getPerks(37)[2]
	if exports.integration:isPlayerStaff(player) then
		cost = 0
	end
	if username and (...) then
		msg = table.concat({...}," ")
		triggerEvent("opm:send", player, username, msg, cost)
	end
end
addCommandHandler("opm", sendOpmFromCmd)
