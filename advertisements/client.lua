local sx,sy = guiGetScreenSize()
local advertsBrowser = guiCreateBrowser(0,0,sx,sy, true, true, false)
guiSetVisible(advertsBrowser, false)
local advertsBrowserGUI = guiGetBrowser(advertsBrowser)

addEventHandler("onClientBrowserCreated",advertsBrowserGUI, function()
	loadBrowserURL(source, "http://mta/local/html/index.html")
	end)
	
addEvent("adverts.close",true)
addEventHandler("adverts.close",root,function()
    guiSetInputEnabled(not guiGetVisible(advertsBrowser))
	guiSetVisible(advertsBrowser, false)
end)

yasakliMesajlar = {
    "sik",
    "orospu",
    "babadolu",
    "roleplay",
    "inception",
    "ananı",
    "anneni",
    "bırak",
    "arıyorum",
    "aranır",
    "ibne",
    "Hanz",
    "Hanz",
    "yetkili",
    }
    
addEvent("adverts.send",true)
    addEventHandler("adverts.send",root,function(msg)
        for index, value in ipairs(yasakliMesajlar) do
            if string.find(msg, value) then 
                if value then 
                        outputChatBox("#f9f9f9 Conteúdo incorreto detectado em seu anúncio.", 255, 0, 0, true) 
                    return false 
                end
            return end
        end
        if msg == "" then outputChatBox("#ffffffNão deixe o conteúdo do anúncio em branco.", 230, 120, 66, true) return end
            outputChatBox("[-] #ffffffVerificando o status do seu anúncio..", 230, 120, 66, true)
				setTimer(function()
				triggerServerEvent("adverts:receive", localPlayer, localPlayer, msg)
				ses = playSound("sounds/music.mp3")
				setSoundVolume(ses, 0.2)
			end, 1500, 1)
    end)
    
    
	local state = true
	
    addEvent("reklam:HTML", true)
	addEventHandler("reklam:HTML", root, 
	function()
        guiSetVisible(advertsBrowser, not guiGetVisible(advertsBrowser))
		guiSetInputEnabled(guiGetVisible(advertsBrowser))
    end)
    