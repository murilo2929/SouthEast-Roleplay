--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

local guiStep11 = {}
local q = {{},{},{},{},{},{}}
local result = {}
local quests = {}
local timer = nil
function startStep11(quests1, retest, remainHours, remainMinutes, remainSeconds)
	triggerEvent("account:hideRules", localPlayer)
	
	if guiStep11.back and isElement(guiStep11.back) then
		showGUIPart(guiStep11)
		return false
	else
		quests = quests1
	end

	local sWidth,sHeight = guiGetScreenSize() 
	
	local line = 15
	local startY = sHeight*0.45
	local width = 800
	local startX = (sWidth-width)/2
	local panelH = 80
	local panelW = width/2
	local margin = 30
	guiStep11.intro2 = guiCreateLabel(startX-1, startY-1, width+1, line*2+1, "Antes de se tornar elegível para jogar neste servidor, você primeiro terá que terminar uma pequena aplicação que irá testar seu portugues, conhecimento geral de roleplay e compreensão geral das regras de servidores que você acabou de ver. (Seção 1/2)", false )
	guiLabelSetHorizontalAlign(guiStep11.intro2, "center", true)
	guiLabelSetColor( guiStep11.intro2, 0, 0, 0 )
	guiStep11.intro = guiCreateLabel(startX, startY, width, line*2, "Antes de se tornar elegível para jogar neste servidor, você primeiro terá que terminar uma pequena aplicação que irá testar seu portugues, conhecimento geral de roleplay e compreensão geral das regras de servidores que você acabou de ver. (Seção 1/2)", false )
	guiLabelSetHorizontalAlign(guiStep11.intro, "center", true)
	startX = startX +20
	startY = startY +20
	--col 1 row 1
	guiStep11.q1 = guiCreateScrollPane(startX, startY+line*3, panelW, panelH, false )
	guiStep11.q11 = guiCreateLabel(0, 0, panelW, line, (quests[1].question or "-"), false, guiStep11.q1 )
	guiSetFont(guiStep11.q11, "default-bold-small")
	q[1][1] = guiCreateRadioButton(0, line, panelW, line, (quests[1].answer1 or "-"), false, guiStep11.q1 )
	q[1][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[1].answer2 or "-"), false, guiStep11.q1 )
	q[1][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[1].answer3 or "-"), false, guiStep11.q1 )
	--col 1 row 2
	guiStep11.q2 = guiCreateScrollPane(startX, startY+line*3+panelH, panelW, panelH, false )
	guiStep11.q22 = guiCreateLabel(0, 0, panelW, line, (quests[2].question or "-"), false, guiStep11.q2 )
	guiSetFont(guiStep11.q22, "default-bold-small")
	q[2][1] = guiCreateRadioButton(0, line, panelW, line, (quests[2].answer1 or "-"), false, guiStep11.q2 )
	q[2][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[2].answer2 or "-"), false, guiStep11.q2 )
	q[2][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[2].answer3 or "-"), false, guiStep11.q2 )
	--col 1 row 3
	guiStep11.q3 = guiCreateScrollPane(startX, startY+line*3+panelH*2, panelW, panelH, false )
	guiStep11.q33 = guiCreateLabel(0, 0, panelW, line, (quests[3].question or "-"), false, guiStep11.q3 )
	guiSetFont(guiStep11.q33, "default-bold-small")
	q[3][1] = guiCreateRadioButton(0, line, panelW, line, (quests[3].answer1 or "-"), false, guiStep11.q3 )
	q[3][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[3].answer2 or "-"), false, guiStep11.q3 )
	q[3][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[3].answer3 or "-"), false, guiStep11.q3 )
	--col 2 row 1
	guiStep11.q4 = guiCreateScrollPane(startX+panelW+margin, startY+line*3, panelW, panelH, false )
	guiStep11.q44 = guiCreateLabel(0, 0, panelW, line, (quests[4].question or "-"), false, guiStep11.q4 )
	guiSetFont(guiStep11.q44, "default-bold-small")
	q[4][1] = guiCreateRadioButton(0, line, panelW, line, (quests[4].answer1 or "-"), false, guiStep11.q4 )
	q[4][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[4].answer2 or "-"), false, guiStep11.q4 )
	q[4][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[4].answer3 or "-"), false, guiStep11.q4 )
	--col 2 row 2
	guiStep11.q5 = guiCreateScrollPane(startX+panelW+margin, startY+line*3+panelH, panelW, panelH, false )
	guiStep11.q55 = guiCreateLabel(0, 0, panelW, line, (quests[5].question or "-"), false, guiStep11.q5 )
	guiSetFont(guiStep11.q55, "default-bold-small")
	q[5][1] = guiCreateRadioButton(0, line, panelW, line, (quests[5].answer1 or "-"), false, guiStep11.q5 )
	q[5][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[5].answer2 or "-"), false, guiStep11.q5 )
	q[5][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[5].answer3 or "-"), false, guiStep11.q5 )
	--col 2 row 3
	guiStep11.q6 = guiCreateScrollPane(startX+panelW+margin, startY+line*3+panelH*2, panelW, panelH, false )
	guiStep11.q66 = guiCreateLabel(0, 0, panelW, line, (quests[6].question or "-"), false, guiStep11.q6 )
	guiSetFont(guiStep11.q66, "default-bold-small")
	q[6][1] = guiCreateRadioButton(0, line, panelW, line, (quests[6].answer1 or "-"), false, guiStep11.q6 )
	q[6][2] = guiCreateRadioButton(0, line*2, panelW, line, (quests[6].answer2 or "-"), false, guiStep11.q6 )
	q[6][3] = guiCreateRadioButton(0, line*3, panelW, line, (quests[6].answer3 or "-"), false, guiStep11.q6 )
	
	local bW, bH = 120, 30
	local bX = (sWidth-bW*2)/2
	local bY = startY+line*3+panelH*3
	guiStep11.back = guiCreateButton ( bX, bY, bW, bH, "< Regras do servidor", false)
	guiStep11.next = guiCreateButton ( bX+bW, bY, bW, bH, "Proximo >", false)
	guiStep11.retest = guiCreateButton ( bX+bW, bY, bW, bH, "Reiniciar seção", false)
	guiSetVisible(guiStep11.retest, false)
	guiSetEnabled(guiStep11.next, false)
	addEventHandler ( "onClientGUIClick", root, clickOnApplication)
	
	text1 = nil
	if remainSeconds then
		text1 = remainSeconds.." segundo(s)"
	elseif remainMinutes then
		text1 = remainMinutes.." minuto(s)"
	elseif remainHours then
		text1 = remainHours.." hora(s)"
	end
	if text1 then 
		guiSetEnabled(guiStep11.next, false)
		guiSetText(guiStep11.intro2, "Porque uma equipe o forçou a voltar ao estágio de aplicação ou porque você falhou constantemente muitas vezes. Agora você terá "..text1.." para revisar nossas regras de servidor e tentar novamente com outra aplicação.")
		guiSetText(guiStep11.intro, "Porque uma equipe o forçou a voltar ao estágio de aplicação ou porque você falhou constantemente muitas vezes. Agora você terá "..text1.." para revisar nossas regras de servidor e tentar novamente com outra aplicação.")
		guiLabelSetColor ( guiStep11.intro, 255,0,0 )
	end

	for i = 1, 6 do
		addEventHandler( "onClientMouseEnter",guiStep11['q'..i..i], function ()
			guiLabelSetColor( source, 0, 0, 0 )
		end, false )
		addEventHandler("onClientMouseLeave",guiStep11['q'..i..i], function ()
			guiLabelSetColor( source, 255, 255, 255 )
		end, false )
		for k = 1, 3 do
			guiSetProperty( q[i][k]  , "HoverTextColour", "FF000000") 
		end
	end
end
addEvent("apps:step11", true)
addEventHandler("apps:step11", root, startStep11)

function clickOnApplication()
	if source == guiStep11.next then
		if text1 then
			guiSetEnabled(guiStep11.next, false)
			return false
		end
		local corrects, incorrects = 0, 0
		for i = 1, 6 do 
			if quests[i].key == getAnswerFromRadio(q[i]) then
				corrects = corrects + 1
			else
				incorrects = incorrects + 1
			end
		end
		if incorrects > 0 then
			guiSetText(guiStep11.intro2, "Oops, Desculpa! "..(incorrects < 6 and incorrects or "todas").." de suas respostas "..(incorrects <= 1 and "esta" or "estão").." errado e "..(corrects < 1 and "nenhuma" or ("apenas "..corrects)).." "..(corrects <= 1 and "esta" or "estão").." correta. Você tem que corrigir todos eles para continuar.")
			guiSetText(guiStep11.intro, "Oops, Desculpa! "..(incorrects < 6 and incorrects or "todas").." de suas respostas "..(incorrects <= 1 and "esta" or "estão").." errado e "..(corrects < 1 and "nenhuma" or ("apenas "..corrects)).." "..(corrects <= 1 and "esta" or "estão").." correta. Você tem que corrigir todos eles para continuar.")
			guiLabelSetColor ( guiStep11.intro, 255,0,0 )
			guiSetVisible(guiStep11.retest, true)
			guiSetVisible(guiStep11.next, false)
			guiSetEnabled(guiStep11.back, false)
			killTimer1()
			timer = setTimer(function()
				destroyGUIPart(guiStep11)
				triggerEvent("account:showRules",localPlayer, 0)
			end, 3000, 1)
		else
			guiSetText(guiStep11.intro2, "Parabéns! Você foi aprovado nesta seção da aplicação. Movendo para a próxima seção..")
			guiSetText(guiStep11.intro, "Parabéns! Você foi aprovado nesta seção da aplicação. Movendo para a próxima seção..")
			guiLabelSetColor ( guiStep11.intro, 0,255,0 )
			killTimer1()
			guiSetEnabled(guiStep11.retest, false)
			guiSetEnabled(guiStep11.back, false)
			guiSetEnabled(guiStep11.next, false)
			guiSetEnabled(guiStep11.q1, false)
			guiSetEnabled(guiStep11.q2, false)
			guiSetEnabled(guiStep11.q3, false)
			guiSetEnabled(guiStep11.q4, false)
			guiSetEnabled(guiStep11.q5, false)
			guiSetEnabled(guiStep11.q6, false)
			
			timer = setTimer(function()
				destroyGUIPart(guiStep11)
				triggerServerEvent("apps:finishStep1",localPlayer)
			end, 3000, 1)
		end
	elseif source == guiStep11.retest then
		killTimer1()
		destroyGUIPart(guiStep11)
		triggerEvent("account:showRules",localPlayer, 0)
	elseif source == guiStep11.back then
		killTimer1()
		hideGUIPart(guiStep11)
		triggerEvent("account:showRules",localPlayer, 0)
	else
		if guiStep11.intro and isElement(guiStep11.intro) and guiGetVisible(guiStep11.intro) then
			--outputDebugString("checking")
			local count = 0
			for i = 1, 6 do
				for j = 1, 3 do
					if q[i][j] and isElement(q[i][j]) and guiRadioButtonGetSelected(q[i][j]) then
						count = count + 1
						result[i] = j
					end
				end
			end
			if count == 6 then
				guiSetEnabled(guiStep11.next, true)
			else
				guiSetEnabled(guiStep11.next, false)
			end
		end
	end
end

function hideGUIPart(GUIs)
	for i, gui in pairs (GUIs) do
		if gui and isElement(gui) then
			guiSetVisible(gui, false)
		end
	end
end

function showGUIPart(GUIs)
	for i, gui in pairs (GUIs) do
		if gui and isElement(gui) and (gui ~= guiStep11.retest) then
			guiSetVisible(gui, true)
		end
	end
end

function destroyGUIPart(GUIs)
	for i, gui in pairs (GUIs) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	removeEventHandler ( "onClientGUIClick", root, clickOnApplication)
end

function getAnswerFromRadio(radios)
	for i = 1, 3 do
		if guiRadioButtonGetSelected(radios[i]) then
			return tostring(i)
		end
	end
end

local guiRules = {}
function showServerRules()
	local xmlRules = xmlLoadFile( ":admin-system/help/rules.xml" )
	guiRules.mRule = guiCreateMemo(0.25, 0.45, 0.5, 0.3, xmlNodeGetValue( xmlRules  ), true )
	guiMemoSetReadOnly(guiRules.mRule, true)
	guiRules.acceptRules = guiCreateButton ( 0.45, 0.81, 0.1, 0.04, "Proxima", true)
	addEventHandler ( "onClientGUIClick", guiRules.acceptRules, function()
		--triggerEvent("app:step1", localPlayer)
		playSoundFrontEnd(12)
	end)
end

function killTimer1()
	if timer and isTimer(timer) then
		killTimer(timer)
	end
end