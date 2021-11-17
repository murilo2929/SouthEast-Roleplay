--MAXIME
local guiRules = {}
local state = 0
function showServerRules(state1)
	if state1 and tonumber(state1) then
		state = tonumber(state1)
	end
	
	local sWidth,sHeight = guiGetScreenSize() 
	local width = 750
	local x = (sWidth-width)/2
	local y = sHeight*0.3
	local height = sHeight*0.45
	triggerEvent("hideLoginPanel", localPlayer, true)
	local xmlRules = xmlLoadFile( ":help/commands/rules.xml" )
	
	guiRules.mBrowser = guiCreateBrowser(x + 25, y, width, height, false, false, false)
	guiRules.mBrowserElement = guiGetBrowser(guiRules.mBrowser)
	
	addEventHandler("onClientBrowserCreated", guiRules.mBrowserElement, function()
		if isBrowserDomainBlocked("http:///") or isBrowserDomainBlocked("http:///") then
			requestBrowserDomains({"http:///", "http:///"}, false, function(accepted, newDomains)
				loadBrowserURL(source, "http:///")
			end)
		else
			loadBrowserURL(source, "http:///")
		end
	end)
	
	guiRules.checkbox = guiCreateCheckBox ( x, sHeight*0.76, sWidth, 30, "Eu li as regras acima e concordo em obedecer às regras estabelecidas pelo Servidor de Roleplay Live Yours MTA.\nEu, por meio deste, reconheço que se eu violar qualquer uma das regras acima, me submeterei à punição a critério da equipe de administração.", false, false)
	
	guiRules.acceptRules = guiCreateButton ( sWidth*0.45, sHeight*0.81, 100, 40, "Aceitar", false)
	
	guiSetEnabled(guiRules.acceptRules, false)
	addEventHandler ( "onClientGUIClick", guiRules.acceptRules, clickRules, false )
	addEventHandler ( "onClientGUIClick", guiRules.checkbox, clickRules, false )
end
addEvent("account:showRules", true)
addEventHandler("account:showRules", root, showServerRules)

function hideServerRules()
	for i, gui in pairs (guiRules) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
end
addEvent("account:hideRules", true)
addEventHandler("account:hideRules", root, hideServerRules)

function clickRules ( button )
    if button == "left" then
		if source == guiRules.acceptRules then
			hideServerRules()
			if state == 0 then
				triggerServerEvent("apps:startStep11", localPlayer)
			elseif state == 1 then
				triggerServerEvent("apps:startStep2", localPlayer)
			elseif state == 2 then
				triggerServerEvent("apps:startStep3", localPlayer)
			end
			playSoundFrontEnd(12)
		end
		if guiRules.acceptRules and isElement(guiRules.acceptRules) and guiRules.checkbox and isElement(guiRules.checkbox) then
			guiSetEnabled(guiRules.acceptRules, guiCheckBoxGetSelected(guiRules.checkbox))
		end
    end
end