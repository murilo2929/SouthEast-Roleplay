local wConfirmFriendRequest,bButtonYes,bButtonNo,bButtonPlayer = nil

function askAcceptFriend()
	if wConfirmFriendRequest then
		destroyElement(wConfirmFriendRequest)
		wConfirmFriendRequest = nil
	end

	local sx, sy = guiGetScreenSize()
	wConfirmFriendRequest = guiCreateWindow(sx/2 - 150,sy/2 - 50,300,100,"Friend request", false)
	local lQuestion = guiCreateLabel(0.05,0.25,0.9,0.3,getElementData(source, "account:username") .. " deseja adicioná-lo à lista de amigos dele. Você quer aceitar este pedido?",true,wConfirmFriendRequest)
	guiLabelSetHorizontalAlign (lQuestion,"center",true)
	bButtonYes = guiCreateButton(0.1,0.65,0.37,0.23,"Sim",true,wConfirmFriendRequest)
	bButtonNo = guiCreateButton(0.53,0.65,0.37,0.23,"Não",true,wConfirmFriendRequest)
	addEventHandler("onClientGUIClick", bButtonYes, askAcceptFriendClick, false)
	addEventHandler("onClientGUIClick", bButtonNo, askAcceptFriendClick, false)
	bButtonPlayer = source
end
addEvent("askAcceptFriend", true)
addEventHandler("askAcceptFriend", getRootElement(), askAcceptFriend)

function askAcceptFriendClick(button, state)
	if button == "left" and state == "up" then
		if source == bButtonYes then
			-- clicked yes
			triggerServerEvent("social:acceptFriend", getLocalPlayer())
			destroyElement(wConfirmFriendRequest)
			wConfirmFriendRequest = nil
		end
		if source == bButtonNo then
			-- clicked no
			triggerServerEvent("declineFriendSystemRequest", getLocalPlayer(), bButtonPlayer)
			destroyElement(wConfirmFriendRequest)
			wConfirmFriendRequest = nil
		end
	end
end

function toggleCursor()
	if (isCursorShowing()) then
		exports.rightclick:destroy()
		showCursor(false)
	else
		showCursor(true)
	end
end
addCommandHandler("togglecursor", toggleCursor)
bindKey("m", "down", "togglecursor")

function onPlayerSpawn()
	showCursor(false)
end
addEventHandler("onClientPlayerSpawn", getLocalPlayer(), onPlayerSpawn)

function cursorHide()
	showCursor(false)
end
addEvent("cursorHide", false)
addEventHandler("cursorHide", getRootElement(), cursorHide)

function cursorShow()
	showCursor(true)
end
addEvent("cursorShow", false)
addEventHandler("cursorShow", getRootElement(), cursorShow)
