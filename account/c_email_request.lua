function requestEmail(id)
	if wEmail then
		closeEmailRequest()
	end
	guiSetInputEnabled ( true)
	showCursor(true)
	GUIEditor_Label = {}
	local width, height = 307, 160
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	
	wEmail = guiCreateWindow(x,y,width,height,"Atualizar Email de Segurança",false)
		guiWindowSetSizable(wEmail,false)
	GUIEditor_Label[1] = guiCreateLabel(13,26,207,19,"Por favor, indique o seu endereço de e-mail:",false,wEmail)

	GUIEditor_Label[2] = guiCreateLabel(17,53,52,21,"Email:",false,wEmail)
		guiLabelSetVerticalAlign(GUIEditor_Label[2],"center")
		guiSetFont(GUIEditor_Label[2],"default-bold-small")
	eEmail1 = guiCreateEdit(79,52,209,22,"",false,wEmail)
	
	GUIEditor_Label[3] = guiCreateLabel(17,78,52,21,"Digite novamente:",false,wEmail)
		guiLabelSetVerticalAlign(GUIEditor_Label[3],"center")
		guiSetFont(GUIEditor_Label[3],"default-bold-small")
	eEmail2 = guiCreateEdit(79,78,209,22,"",false,wEmail)
	
	lMsg = guiCreateLabel(17,105,271,16,"Isso será usado para recuperar sua senha.",false,wEmail)
		guiLabelSetColor(lMsg,255,255,0)
		guiLabelSetHorizontalAlign(lMsg,"center",false)
		guiSetFont(lMsg,"default-small")
	
	bOK = guiCreateButton(17,126,138,25,"OK",false,wEmail)
	addEventHandler("onClientGUIClick", bOK, function ()
		if source == bOK then
			if guiGetText(eEmail1) == guiGetText(eEmail2) then
				if (guiGetText(eEmail1):match("[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?")) then
					triggerServerEvent("requestEmail:saveEmail", getLocalPlayer(), id, guiGetText(eEmail1))
					guiSetText(lMsg, "Salvo com sucesso!")
					guiLabelSetColor(lMsg,0,255,0)
					setTimer(function () closeEmailRequest() end, 1000, 1)
				else
					guiSetText(lMsg, "Endereço de email invalido!")
					guiLabelSetColor(lMsg,255,255,0)
				end
			else
				guiSetText(lMsg, "O e-mail redigitado não corresponde!")
				guiLabelSetColor(lMsg,255,255,0)
			end
		end
	end)
	
	bCancel = guiCreateButton(155,126,138,25,"CANCELAR",false,wEmail)
	addEventHandler("onClientGUIClick", bCancel, function ()
		if source == bCancel then
			closeEmailRequest()
		end
	end)
	
	addEventHandler("onClientGUIChanged", getRootElement(), function ()
		guiSetText(lMsg, "")
	end)
end
addEvent("requestEmail:onPlayerLogin", true)
addEventHandler("requestEmail:onPlayerLogin", getRootElement(), requestEmail)

function closeEmailRequest()
	if wEmail then
		destroyElement(wEmail)
		wEmail = nil
	end
end