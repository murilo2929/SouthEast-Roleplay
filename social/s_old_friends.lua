function declineFriendRequest(targetPlayer)
	--outputChatBox(getPlayerName(source):gsub("_", " ") .. " declined your friend request.", targetPlayer, 255, 0, 0)
	outputChatBox(" Você recusou ".. getPlayerName(targetPlayer):gsub("_", " ") .."'s pedido de amizade.", source, 255, 0, 0)
end
addEvent("declineFriendSystemRequest", true)
addEventHandler("declineFriendSystemRequest", getRootElement(), declineFriendRequest)
