local rosie = createPed(141, -1347.033203125, -188.302734375, 14.151561737061)
local lsesOptionMenu = nil
setPedRotation(rosie, 296.709533)
setElementFrozen(rosie, true)
setElementDimension(rosie, 9)
setElementInterior(rosie, 6)
--setPedAnimation(rosie, "INT_OFFICE", "OFF_Sit_Idle_Loop", -1, true, false, false)
setElementData(rosie, "talk", 1, false)
setElementData(rosie, "name", "Rosie Jenkins", false)
--[[
local jacob = createPed(277, -1794.3291015625, 647.0517578125, 960.38513183594)
local lsesOptionMenu = nil
setPedRotation(jacob, 57)
setElementFrozen(jacob, true)
setElementDimension(jacob, 8)
setElementInterior(jacob, 1)
setElementData(jacob, "talk", 1, false)
setElementData(jacob, "name", "Jacob Greenaway", false)]]

function popupSFESPedMenu()
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	if not lsesOptionMenu then
		local width, height = 150, 100
		local scrWidth, scrHeight = guiGetScreenSize()
		local x = scrWidth/2 - (width/2)
		local y = scrHeight/2 - (height/2)

		lsesOptionMenu = guiCreateWindow(x, y, width, height, "Como podemos te ajudar?", false)

		bPhotos = guiCreateButton(0.05, 0.2, 0.87, 0.2, "Eu preciso de ajuda", true, lsesOptionMenu)
		addEventHandler("onClientGUIClick", bPhotos, helpButtonFunction, false)

		bAdvert = guiCreateButton(0.05, 0.5, 0.87, 0.2, "Consulta", true, lsesOptionMenu)
		addEventHandler("onClientGUIClick", bAdvert, appointmentButtonFunction, false)
		
		bSomethingElse = guiCreateButton(0.05, 0.8, 0.87, 0.2, "Eu estou bem, obrigado.", true, lsesOptionMenu)
		addEventHandler("onClientGUIClick", bSomethingElse, otherButtonFunction, false)
		triggerServerEvent("lses:ped:start", getLocalPlayer(), getElementData(rosie, "name"))
		showCursor(true)
	end
end
addEvent("lses:popupPedMenu", true)
addEventHandler("lses:popupPedMenu", getRootElement(), popupSFESPedMenu)

function closeSFESPedMenu()
	destroyElement(lsesOptionMenu)
	lsesOptionMenu = nil
	showCursor(false)
end

function helpButtonFunction()
	closeSFESPedMenu()
	triggerServerEvent("lses:ped:help", getLocalPlayer(), getElementData(rosie, "name"))
end

function appointmentButtonFunction()
	closeSFESPedMenu()
	triggerServerEvent("lses:ped:appointment", getLocalPlayer(), getElementData(rosie, "name"))
end

function otherButtonFunction()
	closeSFESPedMenu()
end


local pedDialogWindow
local thePed
function pedDialog_hospital(ped)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	thePed = ped
	local width, height = 500, 345
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)
	if pedDialogWindow and isElement(pedDialogWindow) then
		destroyElement(pedDialogWindow)
	end
	pedDialogWindow = guiCreateWindow(x, y, width, height, "Recepção do hospital", false)

	b1 = guiCreateButton(10, 30, width-20, 40, "Eu preciso de um médico agora, alguém está morrendo!", false, pedDialogWindow)
	addEventHandler("onClientGUIClick", b1,
		function()
			endDialog()
			if thePed then
				triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "local", "Estamos enviando uma equipe aqui o mais rápido possível, por favor, mantenha a calma.")
				setTimer(function()
						triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "hospitalpa", "Código crítico na recepção, Código crítico na recepção, equipe de resposta à recepção o mais rápido possível.")
					end, 3000, 1)
			end
		end, false)

	b2 = guiCreateButton(10, 75, width-20, 40, "Preciso de alguém para me ajudar ou um amigo para o Pronto Socorro.", false, pedDialogWindow)
	addEventHandler("onClientGUIClick", b2,
		function()
			endDialog()
			if thePed then
				triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "local", "Estamos enviando alguém aqui para ajudá-lo, por favor, fique calmo.")
				setTimer(function()
						triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "hospitalpa", "Membro da equipe na recepção, por favor, para ajudar um paciente a E.R.")
					end, 4000, 1)
			end
		end, false)

	b3 = guiCreateButton(10, 120, width-20, 40, "Estou aqui para agendar uma consulta ou check-up.", false, pedDialogWindow)
	addEventHandler("onClientGUIClick", b3,
		function()
			endDialog()
			if thePed then
				triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "local", "Ok, estou enviando alguém para baixo.")
				setTimer(function()
						triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "hospitalpa", "Membro da equipe na recepção, por favor, para ajudar um paciente para check-up ou consulta.")
					end, 5000, 1)
			end
		end, false)

	b4 = guiCreateButton(10, 165, width-20, 40, "Estou aqui para ver um amigo que está internado por um período prolongado.", false, pedDialogWindow)
	addEventHandler("onClientGUIClick", b4,
		function()
			endDialog()
			if thePed then
				triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "local", "Por favor, dirija-se à sala de serviços de internamento, no final do corredor e primeiro elevador à esquerda. Uma enfermeira estará lá para ajudá-lo.")
			end
		end, false)

	b5 = guiCreateButton(10, 210, width-20, 40, "Estou aqui para ver um amigo que está no pronto-socorro ou no ambulatório.", false, pedDialogWindow)
	addEventHandler("onClientGUIClick", b5,
		function()
			endDialog()
			if thePed then
				triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "local", "Estou enviando um membro da equipe para ajudá-lo, esteja ciente de que temos uma política de 1 visitante no E.R.")
				setTimer(function()
						triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "hospitalpa", "Membro da equipe na recepção, por favor, para ajudar um visitante do E.R ou Serviços Ambulatoriais.")
					end, 5000, 1)
			end
		end, false)

	b6 = guiCreateButton(10, 255, width-20, 40, "I just need to talk to a staff member.", false, pedDialogWindow)
	addEventHandler("onClientGUIClick", b6,
		function()
			endDialog()
			if thePed then
				triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "local", "Ok, vou mandar um para baixo.")
				setTimer(function()
						triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "hospitalpa", "Membro da equipe na recepção, por favor, para ajudar um visitante solicitando um membro da equipe.")
					end, 5000, 1)
			end
		end, false)

	b7 = guiCreateButton(10, 300, width-20, 40, "Uhm. Esquece.", false, pedDialogWindow)
	addEventHandler("onClientGUIClick", b7, pedDialog_hospital_noHelp, false)

	--showCursor(true)

	triggerServerEvent("airport:ped:outputchat", getResourceRootElement(), thePed, "local", "Bem-vindo à recepção da LSIA. Posso ajudar?")
end
addEvent("lses:ped:hospitalfrontdesk", true)
addEventHandler("lses:ped:hospitalfrontdesk", getRootElement(), pedDialog_hospital)

function endDialog()
	if pedDialogWindow and isElement(pedDialogWindow) then
		destroyElement(pedDialogWindow)
		pedDialogWindow = nil
	end
end

function pedDialog_hospital_noHelp()
	endDialog()
	if thePed then
		triggerServerEvent("lses:ped:outputchat", getResourceRootElement(), thePed, "local", "Okay.")
	end
end