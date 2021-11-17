local count = 0
local state = 0
local mgTimer = nil
local escapeTimer = nil
local pFish = nil

local fishermanJohn = createPed( 209, 24.6337890625, -2648.5556640625, 40.473812103271 )
setPedRotation(fishermanJohn, 100)
setElementDimension(fishermanJohn, 0)
setElementInterior(fishermanJohn , 0)
setElementData(fishermanJohn, "nametag", true)
setElementData(fishermanJohn, "name", "Fisherman John")
setElementFrozen(fishermanJohn, true)

function startFishingSession()
    if exports['item-system']:hasItem(localPlayer, 49, 1) then
        if getElementData(localPlayer, "isfishing") then
            outputChatBox("Voce ja esta pescando...", 255, 0, 0)
        else 
            if isPedInVehicle(localPlayer) then
                return outputChatBox("Você não pode pescar enquanto navega.", 255, 0, 0) 
            end
            if onBoat() then
                triggerServerEvent("sendAmeClient", localPlayer, "lança sua linha para o mar.")
                triggerServerEvent("artifacts:add", localPlayer, localPlayer, "rod")
                setElementData(localPlayer, "isfishing", true)
                
                mgTimer = setTimer(
                    function()
                        if not onBoat() then
                            endFishingSession()
                            return outputChatBox("Você falhou em ficar na água.", 255, 0, 0)
                        end
                        pFish = guiCreateProgressBar(0.425, 0.75, 0.2, 0.035, true)
                        exports.hud:sendBottomNotification(localPlayer, "Pescando", "Você tem uma mordida! Use '´' para enrolar.")
                        bindKey("[", "down", beginFishingGame)
                        -- Start the timer which determins if the fish would get away.
                        escapeTimer = setTimer(
                            function() 
                                endFishingSession()
                                outputChatBox("Ao enrolar sua linha, você nota que ela se quebra.", 255, 0, 0)
                                triggerServerEvent("fishing:takeRod", localPlayer, localPlayer)
                            end, 
                        math.random(8000, 10000), 1)
                    end
                , math.random(60000, 300000), 1)  
                outputChatBox("Você pode parar de pescar a qualquer momento digitando /pararpesca.", 0, 255, 0)
                outputChatBox("O tempo para fisgar um peixe pode variar entre 1 a 5 minutos.", 0, 255, 0)
            else 
                outputChatBox("Você não pode pescar aqui.", 255, 0, 0)
            end
        end
    else
        outputChatBox("Você não tem uma vara de pescar.", 255, 0, 0)
    end
end

function endFishingSession()
    if (getElementData(localPlayer, "isfishing")) then

        if isTimer(mgTimer) then
            killTimer(mgTimer)
        end

        if isTimer(escapeTimer) then
            killTimer(escapeTimer)
        end

        if isElement(pFish) then
            destroyElement(pFish)
            pFish = nil
            count = 0
            unbindKey("[", "down", reelItIn)
            unbindKey("]", "down", reelItIn)
        end

        triggerServerEvent("artifacts:remove", localPlayer, localPlayer, "rod")
        triggerServerEvent("sendAmeClient", localPlayer, "bobina sua linha.")
        setElementData(localPlayer, "isfishing", false)
    end
end

-- Old minigame made by Maxime
function beginFishingGame()
    if (state==0) then
		bindKey("[", "down", beginFishingGame)
		unbindKey("]", "down", beginFishingGame)
		state = 1
	elseif (state==1) then
		bindKey("[", "down", beginFishingGame)
		unbindKey("]", "down", beginFishingGame)
		state = 0
	end
	
    count = count + 1
    guiProgressBarSetProgress(pFish, count)
	
    if (count>=100) then
        killTimer(escapeTimer)
		destroyElement(pFish)
        pFish = nil
        count = 0
		unbindKey("[", "down", reelItIn)
        unbindKey("]", "down", reelItIn)
        endFishingSession()
        triggerServerEvent("fishing:giveCatch", localPlayer, localPlayer)
    end
end

function onBoat()
    local element = getPedContactElement(localPlayer)
    local px, py, pz = getElementPosition(localPlayer)

    if (isElement(element)) and (getVehicleType(element) == "Boat") and testLineAgainstWater(px, py, pz, px, py, pz - 25) then
        return true
    else 
        return false
    end
end

function fishermanJohnRightClick(button, state, absX, absY, wx, wy, wz, element)
    if (element) and (getElementType(element)=="ped") and (button=="right") and (state=="down") then
		local pedName = getElementData(element, "name") or "The Storekeeper"
		pedName = tostring(pedName):gsub("_", " ")

        local rcMenu
        if(pedName == "Fisherman John") then 
            rcMenu = exports.rightclick:create(pedName)
            local row = exports.rightclick:addRow("Talk")
            addEventHandler("onClientGUIClick", row,  function (button, state)
                triggerServerEvent("fishing:GeneratePayment", localPlayer, localPlayer)
            end, false)

            local row2 = exports.rightclick:addRow("Fechar")
            addEventHandler("onClientGUIClick", row2,  function (button, state)
                exports.rightclick:destroy(rcMenu)
            end, false)
        end
    end
end

function sellFish(fish, price)
    DestroySellingGUI()

    sellfishGUI = guiCreateWindow(744, 301, 303, 117, "Vender Peixe", false)
    exports.global:centerWindow(sellfishGUI)
    showCursor(true)
    guiWindowSetSizable(sellfishGUI, false)

    sellfishLabel = guiCreateLabel(4, 18, 295, 44, "Você tem atualmente " .. fish .. " peixe(s) e você fará $" .. price .. ".", false, sellfishGUI)
    guiLabelSetHorizontalAlign(sellfishLabel, "center", true)
    guiLabelSetVerticalAlign(sellfishLabel, "center")
    sellfishbutton = guiCreateButton(10, 68, 140, 34, "Vender Peixe", false, sellfishGUI)
    cancelfishbutton = guiCreateButton(153, 68, 140, 34, "Cancelar", false, sellfishGUI) 
    
    addEventHandler("onClientGUIClick", sellfishbutton, function(button) 
        if button == "left" then
            triggerServerEvent("fishing:sellFish", localPlayer, localPlayer, price)
            DestroySellingGUI()
        end
    end)

    addEventHandler("onClientGUIClick", cancelfishbutton, function(button)
        if button == "left" then
            DestroySellingGUI()
        end
    end)

end

function DestroySellingGUI()
    if isElement(sellfishGUI) then
        destroyElement(sellfishGUI)
        showCursor(false)
    end
end

-- Commands
addCommandHandler("fish", startFishingSession)
addCommandHandler("pescar", startFishingSession)
addCommandHandler("stopfishing", endFishingSession)
addCommandHandler("pararpesca", endFishingSession)
addEvent("fishing:SellFishGUI", true)
addEventHandler("fishing:SellFishGUI", root, sellFish)
addEventHandler("onClientChangeChar", root, endFishingSession)
addEventHandler("onClientClick", root, fishermanJohnRightClick)