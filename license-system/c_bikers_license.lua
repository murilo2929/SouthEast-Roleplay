local localPlayer = getLocalPlayer()

guiIntroLabel1B = nil
guiIntroProceedButtonB = nil
guiIntroWindowB = nil
guiQuestionLabelB = nil
guiQuestionAnswer1RadioB = nil
guiQuestionAnswer2RadioB = nil
guiQuestionAnswer3RadioB = nil
guiQuestionWindowB = nil
guiFinalPassTextLabelB = nil
guiFinalFailTextLabelB = nil
guiFinalRegisterButtonB = nil
guiFinalCloseButtonB = nil
guiFinishWindowB = nil

-- variable for the max number of possible questions
local NoQuestions = 10
local NoQuestionToAnswer = 7
local correctAnswers = 0
local passPercent = 80
		
selection = {}

-- functon makes the intro window for the quiz
function createlicenseBikeTestIntroWindow()
	showCursor(true)
	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	guiIntroWindowB = guiCreateWindow ( X , Y , Width , Height , "Teste de Teoria de Moto" , false )
	
	guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "banner.png", true, guiIntroWindowB)
	
	guiIntroLabel1B = guiCreateLabel(0, 0.3,1, 0.5, [[Agora você vai prosseguir com o teste de teoria. Você irá
receber sete perguntas com base na teoria básica de condução. Você deve pontuar
um mínimo de 80% para passar.

Boa sorte.]], true, guiIntroWindowB)
	
	guiLabelSetHorizontalAlign ( guiIntroLabel1B, "center", true )
	guiSetFont ( guiIntroLabel1B,"default-bold-small")
	
	guiIntroProceedButtonB = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Iniciar Teste" , true ,guiIntroWindowB)
	
	addEventHandler ( "onClientGUIClick", guiIntroProceedButtonB,  function(button, state)
		if(button == "left" and state == "up") then
		
			-- start the quiz and hide the intro window
			startLicenceBikeTest()
			guiSetVisible(guiIntroWindowB, false)
		
		end
	end, false)
	
end

-- done bike up to here

-- function create the question window
function createBikeLicenseQuestionWindow(number)

	local screenwidth, screenheight = guiGetScreenSize ()
	
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	
	-- create the window
	guiQuestionWindowB = guiCreateWindow ( X , Y , Width , Height , "Pergunta "..number.." de "..NoQuestionToAnswer , false )
	
	guiQuestionLabelB = guiCreateLabel(0.1, 0.2, 0.9, 0.2, selection[number][1], true, guiQuestionWindowB)
	guiSetFont ( guiQuestionLabelB,"default-bold-small")
	guiLabelSetHorizontalAlign ( guiQuestionLabelB, "left", true)
	
	
	if not(selection[number][2]== "nil") then
		guiQuestionAnswer1RadioB = guiCreateRadioButton(0.1, 0.4, 0.9,0.1, selection[number][2], true,guiQuestionWindowB)
	end
	
	if not(selection[number][3] == "nil") then
		guiQuestionAnswer2RadioB = guiCreateRadioButton(0.1, 0.5, 0.9,0.1, selection[number][3], true,guiQuestionWindowB)
	end
	
	if not(selection[number][4]== "nil") then
		guiQuestionAnswer3RadioB = guiCreateRadioButton(0.1, 0.6, 0.9,0.1, selection[number][4], true,guiQuestionWindowB)
	end
	
	-- if there are more questions to go, then create a "next question" button
	if(number < NoQuestionToAnswer) then
		guiQuestionNextButtonB = guiCreateButton ( 0.4 , 0.75 , 0.2, 0.1 , "Proxima Pergunta" , true ,guiQuestionWindowB)
		
		addEventHandler ( "onClientGUIClick", guiQuestionNextButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1RadioB)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2RadioB)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3RadioB)) then
					selectedAnswer = 3
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create a new window for the next question
					guiSetVisible(guiQuestionWindowB, false)
					createBikeLicenseQuestionWindow(number+1)
				end
			end
		end, false)
		
	else
		guiQuestionSumbitButtonB = guiCreateButton ( 0.4 , 0.75 , 0.3, 0.1 , "Enviar Respostas" , true ,guiQuestionWindowB)
		
		-- handler for when the player clicks submit
		addEventHandler ( "onClientGUIClick", guiQuestionSumbitButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				
				local selectedAnswer = 0
			
				-- check all the radio buttons and seleted the selectedAnswer variabe to the answer that has been selected
				if(guiRadioButtonGetSelected(guiQuestionAnswer1RadioB)) then
					selectedAnswer = 1
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer2RadioB)) then
					selectedAnswer = 2
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer3RadioB)) then
					selectedAnswer = 3
				elseif(guiRadioButtonGetSelected(guiQuestionAnswer4RadioB)) then
					selectedAnswer = 4
				else
					selectedAnswer = 0
				end
				
				-- don't let the player continue if they havn't selected an answer
				if(selectedAnswer ~= 0) then
					
					-- if the selection is the same as the correct answer, increase correct answers by 1
					if(selectedAnswer == selection[number][5]) then
						correctAnswers = correctAnswers + 1
					end
				
					-- hide the current window, then create the finish window
					guiSetVisible(guiQuestionWindowB, false)
					createBikeTestFinishWindow()


				end
			end
		end, false)
	end
end


-- funciton create the window that tells the
function createBikeTestFinishWindow()

	local score = math.floor((correctAnswers/NoQuestionToAnswer)*100)

	local screenwidth, screenheight = guiGetScreenSize ()
		
	local Width = 450
	local Height = 200
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
		
	-- create the window
	guiFinishWindowB = guiCreateWindow ( X , Y , Width , Height , "Fim do Teste.", false )
	
	if(score >= passPercent) then
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "pass.png", true, guiFinishWindowB)
	
		guiFinalPassLabelB = guiCreateLabel(0, 0.3, 1, 0.1, "Parabéns! Você passou nesta seção do teste.", true, guiFinishWindowB)
		guiSetFont ( guiFinalPassLabelB,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalPassLabelB, "center")
		guiLabelSetColor ( guiFinalPassLabelB ,0, 255, 0 )
		
		guiFinalPassTextLabelB = guiCreateLabel(0, 0.4, 1, 0.4, "Você pontuou "..score.."%, e a marca de aprovação é "..passPercent.."%. Muito bem!" ,true, guiFinishWindowB)
		guiLabelSetHorizontalAlign ( guiFinalPassTextLabelB, "center", true)
		
		guiFinalRegisterButtonB = guiCreateButton ( 0.35 , 0.8 , 0.3, 0.1 , "Continuar" , true ,guiFinishWindowB)
		
		-- if the player has passed the quiz and clicks on register
		addEventHandler ( "onClientGUIClick", guiFinalRegisterButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				-- set player date to say they have passed the theory.
				

				initiateBikeTest()
				-- reset their correct answers
				correctAnswers = 0
				toggleAllControls ( true )
				--cleanup
				destroyElement(guiIntroLabel1B)
				destroyElement(guiIntroProceedButtonB)
				destroyElement(guiIntroWindowB)
				destroyElement(guiQuestionLabelB)
				destroyElement(guiQuestionAnswer1RadioB)
				destroyElement(guiQuestionAnswer2RadioB)
				destroyElement(guiQuestionAnswer3RadioB)
				destroyElement(guiQuestionWindowB)
				destroyElement(guiFinalPassTextLabelB)
				destroyElement(guiFinalRegisterButtonB)
				destroyElement(guiFinishWindowB)
				guiIntroLabel1B = nil
				guiIntroProceedButtonB = nil
				guiIntroWindowB = nil
				guiQuestionLabelB = nil
				guiQuestionAnswer1RadioB = nil
				guiQuestionAnswer2RadioB = nil
				guiQuestionAnswer3RadioB = nil
				guiQuestionWindowB = nil
				guiFinalPassTextLabelB = nil
				guiFinalRegisterButtonB = nil
				guiFinishWindowB = nil
				
				correctAnswers = 0
				selection = {}
				
				showCursor(false)
			end
		end, false)
		
	else -- player has failed, 
	
		guiCreateStaticImage (0.35, 0.1, 0.3, 0.2, "fail.png", true, guiFinishWindowB)
	
		guiFinalFailLabelB = guiCreateLabel(0, 0.3, 1, 0.1, "Desculpe, você não passou desta vez.", true, guiFinishWindowB)
		guiSetFont ( guiFinalFailLabelB,"default-bold-small")
		guiLabelSetHorizontalAlign ( guiFinalFailLabelB, "center")
		guiLabelSetColor ( guiFinalFailLabelB ,255, 0, 0 )
		
		guiFinalFailTextLabelB = guiCreateLabel(0, 0.4, 1, 0.4, "Você pontuou "..math.ceil(score).."%, e a marca de aprovação é "..passPercent.."%." ,true, guiFinishWindowB)
		guiLabelSetHorizontalAlign ( guiFinalFailTextLabelB, "center", true)
		
		guiFinalCloseButtonB = guiCreateButton ( 0.2 , 0.8 , 0.25, 0.1 , "Fechar" , true ,guiFinishWindowB)
		
		-- if player click the close button
		addEventHandler ( "onClientGUIClick", guiFinalCloseButtonB,  function(button, state)
			if(button == "left" and state == "up") then
				destroyElement(guiIntroLabel1B)
				destroyElement(guiIntroProceedButtonB)
				destroyElement(guiIntroWindowB)
				destroyElement(guiQuestionLabelB)
				destroyElement(guiQuestionAnswer1RadioB)
				destroyElement(guiQuestionAnswer2RadioB)
				destroyElement(guiQuestionAnswer3RadioB)
				destroyElement(guiQuestionWindowB)
				destroyElement(guiFinalPassTextLabelB)
				destroyElement(guiFinalRegisterButtonB)
				destroyElement(guiFinishWindowB)
				guiIntroLabel1B = nil
				guiIntroProceedButtonB = nil
				guiIntroWindowB = nil
				guiQuestionLabelB = nil
				guiQuestionAnswer1RadioB = nil
				guiQuestionAnswer2RadioB = nil
				guiQuestionAnswer3RadioB = nil
				guiQuestionWindowB = nil
				guiFinalPassTextLabelB = nil
				guiFinalRegisterButtonB = nil
				guiFinishWindowB = nil
				
				selection = {}
				correctAnswers = 0
				
				showCursor(false)
			end
		end, false)
	end
	
end
 
 -- function starts the quiz
 function startLicenceBikeTest()
 
	-- choose a random set of questions
	chooseBikeTestQuestions()
	-- create the question window with question number 1
	createBikeLicenseQuestionWindow(1)
 
 end
 
 
 -- functions chooses the questions to be used for the quiz
 function chooseBikeTestQuestions()
 
	-- loop through selections and make each one a random question
	for i=1, 10 do
		-- pick a random number between 1 and the max number of questions
		local number = math.random(1, NoQuestions)
		
		-- check to see if the question has already been selected
		if(testBikeQuestionAlreadyUsed(number)) then
			repeat -- if it has, keep changing the number until it hasn't
				number = math.random(1, NoQuestions)
			until (testBikeQuestionAlreadyUsed(number) == false)
		end
		
		-- set the question to the random one
		selection[i] = questionsBike[number]
	end
 end
 
 
 -- function returns true if the queston is already used
 function testBikeQuestionAlreadyUsed(number)
 
	local same = 0
 
	-- loop through all the current selected questions
	for i, j in pairs(selection) do
		-- if a selected question is the same as the new question
		if(j[1] == questionsBike[number][1]) then
			same = 1 -- set same to 1
		end
		
	end
	
	-- if same is 1, question already selected to return true
	if(same == 1) then
		return true
	else
		return false
	end
 end

---------------------------------------
------ Practical Driving Test ---------
---------------------------------------
 
testBikeRoute = {
	{ -2046.58984375, -79.71484375, 35.171875 },
	{ -2078.720703125, -67.6689453125, 35.171875 },
	{ -2154.4755859375, -68.3466796875, 35.171875 },
	{ -2240.470703125, -68.310546875, 35.171875 },
	{ -2250.103515625, 40.0361328125, 35.171875 },
	{ -2249.130859375, 182.44140625, 35.171875 },
	{ -2249.134765625, 307.1572265625, 35.1640625 },
	{ -2159.1474609375, 317.833984375, 35.171875 },
	{ -2139.9658203125, 490.2666015625, 35.015625 },
	{ -2025.41015625, 502.0205078125, 35.015625 },
	{ -2007.7333984375, 420.0263671875, 35.015625 },	
	{ -2133.365234375, 322.7939453125, 35.141960144043 },
	{ -2149.228515625, 221.2001953125, 35.171875 },
	{ -2120.607421875, 107.927734375, 35.171875 },
	{ -2110.1904296875, 43.8984375, 35.1640625 },
	{ -2089.7138671875, -56.765625, 35.199607849121 },
	{ -2046.9482421875, -96.54296875, 35.171798706055 },
}

testBike = { [468]=true } -- Mananas need to be spawned at the start point.
local vehicleIdUsedToStartTest = nil

local blip = nil
local marker = nil

function initiateBikeTest()
	triggerServerEvent("theoryBikeComplete", getLocalPlayer())
	local x, y, z = testBikeRoute[1][1], testBikeRoute[1][2], testBikeRoute[1][3]
	blip = createBlip(x, y, z, 0, 2, 0, 255, 0, 255)
	marker = createMarker(x, y, z, "checkpoint", 4, 0, 255, 0, 150) -- start marker.
	addEventHandler("onClientMarkerHit", marker, startBikeTest)
	
	outputChatBox("#FF9933Agora você está pronto para fazer seu exame prático de direção. Pegue uma moto de teste e comece a rota.", 255, 194, 14, true)
	
end

function startBikeTest(element)
	if element == getLocalPlayer() then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if not vehicle or not testBike[getElementModel(vehicle)] then
			outputChatBox("#FF9933Você deve estar andando de moto de teste ao passar pelos pontos de verificação.", 255, 0, 0, true ) -- Wrong  type.
		else
			destroyElement(blip)
			destroyElement(marker)
			
			setElementData(getLocalPlayer(), "drivingTest.marker", 2, false)
			vehicleIdUsedToStartTest = getElementData(vehicle, "dbid")

			local x1,y1,z1 = nil -- Setup the first checkpoint
			x1 = testBikeRoute[2][1]
			y1 = testBikeRoute[2][2]
			z1 = testBikeRoute[2][3]
			setElementData(getLocalPlayer(), "drivingTest.checkmarkers", #testBikeRoute, false)

			blip = createBlip(x1, y1 , z1, 0, 2, 255, 0, 255, 255)
			marker = createMarker( x1, y1,z1 , "checkpoint", 4, 255, 0, 255, 150)
				
			addEventHandler("onClientMarkerHit", marker, UpdateBikeCheckpoints)
				
			outputChatBox("#FF9933Você precisará completar o percurso sem danificar a moto. Boa sorte e dirija com cuidado.", 255, 194, 14, true)
		end
	end
end

function UpdateBikeCheckpoints(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if not vehicle or not testBike[getElementModel(vehicle)] then
			outputChatBox("Você deve estar em uma moto de teste ao passar pelos pontos de verificação.", 255, 0, 0) -- Wrong car type.
		elseif getElementData(vehicle, "dbid") ~= vehicleIdUsedToStartTest then
			outputChatBox("Você não está usando a moto com a qual iniciou este teste.", 255, 194, 14)
			outputChatBox("Você falhou no teste prático de direção.", 255, 0, 0)

			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
		else
			destroyElement(blip)
			destroyElement(marker)
			blip = nil
			marker = nil
				
			local m_number = getElementData(getLocalPlayer(), "drivingTest.marker")
			local max_number = getElementData(getLocalPlayer(), "drivingTest.checkmarkers")
			
			if (tonumber(max_number-1) == tonumber(m_number)) then -- if the next checkpoint is the final checkpoint.
				outputChatBox("#FF9933Estacione sua moto #FF66CCno estacionamento #FF9933para completar o teste.", 255, 194, 14, true)
				
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
					
				local x2, y2, z2 = nil
				x2 = testBikeRoute[newnumber][1]
				y2 = testBikeRoute[newnumber][2]
				z2 = testBikeRoute[newnumber][3]
				
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				
				addEventHandler("onClientMarkerHit", marker, EndBikeTest)
			else
				local newnumber = m_number+1
				setElementData(getLocalPlayer(), "drivingTest.marker", newnumber, false)
						
				local x2, y2, z2 = nil
				x2 = testBikeRoute[newnumber][1]
				y2 = testBikeRoute[newnumber][2]
				z2 = testBikeRoute[newnumber][3]
						
				marker = createMarker( x2, y2, z2, "checkpoint", 4, 255, 0, 255, 150)
				blip = createBlip( x2, y2, z2, 0, 2, 255, 0, 255, 255)
				
				addEventHandler("onClientMarkerHit", marker, UpdateBikeCheckpoints)
			end
		end
	end
end

function EndBikeTest(element)
	if (element == localPlayer) then
		local vehicle = getPedOccupiedVehicle(getLocalPlayer())
		if not vehicle or not testBike[getElementModel(vehicle)] then
			outputChatBox("Você deve estar em uma moto de teste ao passar pelos pontos de verificação.", 255, 0, 0)
		else
			local vehicleHealth = getElementHealth ( vehicle )
			if getElementData(vehicle, "dbid") ~= vehicleIdUsedToStartTest then
				outputChatBox("Você não está usando a moto com a qual iniciou este teste.", 255, 194, 14)
				outputChatBox("Você falhou no teste prático de direção.", 255, 0, 0)
			elseif (vehicleHealth >= 800) then
				----------
				-- PASS --
				----------
				outputChatBox("Depois de inspecionar o veículo, não encontramos nenhum dano.", 255, 194, 14)
				triggerServerEvent("acceptBikeLicense", getLocalPlayer())
			
			else
				----------
				-- Fail --
				----------
				outputChatBox("Depois de inspecionar o veículo, podemos ver que ela está danificado.", 255, 194, 14)
				outputChatBox("Você falhou no teste prático de direção.", 255, 0, 0)
			end
			
			destroyElement(blip)
			destroyElement(marker)
			triggerServerEvent('takeBackHelmet', localPlayer)
			blip = nil
			marker = nil
		end
	end
end
