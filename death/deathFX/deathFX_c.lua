--MAXIME
local deathSound = nil
local ckSound = nil
function playerWasted (thePlayer)
	deathSound = playSound("deathFX/wasted.mp3",false)
	setSoundVolume(deathSound, 0.2)
	setGameSpeed (0.1)
end
addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), playerWasted )

function playerSpawn()
	if deathSound and isElement(deathSound) then
		destroyElement(deathSound)
	end
	setGameSpeed (1)
end
addEventHandler ( "onClientPlayerSpawn", getLocalPlayer(), playerSpawn )

local gui = {}
function showCkWindow()
	triggerServerEvent("updateCharacters", localPlayer)
	setTimer(function()
		triggerEvent("accounts:logout", localPlayer)
		setGameSpeed (1)
		closeCkWindow()

		ckSound = playSound("deathFX/cked.mp3",false)
		setSoundVolume(ckSound, 0.4)

		triggerEvent("es-system:closeRespawnButton", localPlayer)

		gui.window = guiCreateStaticImage(0, 0, 350, 300, ":resources/window_body.png", false)
		exports.global:centerWindow(gui.window)

		gui.label = guiCreateLabel(0.05, 0.05, 0.9, 0.7, string.gsub(getPlayerName(localPlayer), "_", " ").." acabou de receber um CK!\n\nCK (Character Kill) é a forma mais incomum de um personagem ser morto no jogo e é usado apenas em situações onde é necessário. \n\nQuando você é morto por um CK, é permanente e a única maneira de obter os ativos pertencentes a este personagem de volta é através de um privilégio de transferência de estatísticas em Recursos Premium (F10).\n\nVocê agora é redirecionado para a tela de seleção de personagens, pois era a única opção que você tinha.", true, gui.window)
		guiLabelSetHorizontalAlign(gui.label, "left", true)
		guiLabelSetVerticalAlign(gui.label, "center", true)

		gui.bClose = guiCreateButton(0.05, 0.8, 0.9, 0.15, "OK", true, gui.window)
		addEventHandler("onClientGUIClick", gui.bClose,
		function ()
			if source == gui.bClose then
				closeCkWindow()
			end
		end, false)
	end, 2000, 1)
end
addEvent("showCkWindow", true)
addEventHandler ( "showCkWindow", localPlayer, showCkWindow )

function closeCkWindow()
	if gui.window and isElement(gui.window) then
		destroyElement(gui.window)
		--setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	end
end
