localPlayer = getLocalPlayer()
function carshop_showInfo(carPrice, taxPrice)
	
	local actualmodel = getElementModel(source)
	local customid = getElementData(source, exports.newmodels:getDataNameFromType("vehicle"))
	local name = ""
	if customid then
		local isCustom, mod = exports.newmodels:isCustomModID(customid)
		if mod then
			local base_id = tonumber(mod.base_id)
			if base_id then
				name = getVehicleNameFromModel(base_Id) or "?"
			end
		end
	else
		name = getVehicleNameFromModel(actualmodel) or "?"
	end

	local isOverlayDisabled = getElementData(localPlayer, "hud:isOverlayDisabled")
	if isOverlayDisabled then
		outputChatBox("")
		outputChatBox("Concessionária de carros")
		outputChatBox("   - Marca: "..(getElementData(source, "brand") or name) )
		outputChatBox("   - Modelo: "..(getElementData(source, "maximemodel") or name) )
		outputChatBox("   - Ano: "..(getElementData(source, "year") or "2015") )

		if getVehicleType(source) ~= 'BMX' then
			outputChatBox("   - Odômetro: "..exports.global:formatMoney(getElementData(source, 'odometer') or 0) .. " miles"  )
		end
		outputChatBox("   - Preço: $"..exports.global:formatMoney(carPrice)  )
		outputChatBox("   - Imposto: $"..exports.global:formatMoney(taxPrice)  )
		outputChatBox("   (( MTA Modelo: "..name.."))"  )
		outputChatBox("Pressione F ou Enter para comprar este veículo")
	else
		local content = {}
		table.insert(content, { getCarShopNicename(getElementData(source, "carshop")) , false, false, false, false, false, false, "title"} )
		table.insert(content, {" " } )
		table.insert(content, {"   - Marca: "..(getElementData(source, "brand") or name) } )
		table.insert(content, {"   - Modelo: "..(getElementData(source, "maximemodel") or name) } )
		table.insert(content, {"   - Ano: "..(getElementData(source, "year") or "2015")} )
		if getVehicleType(source) ~= 'BMX' then
			table.insert(content, {"   - Odometro: "..exports.global:formatMoney(getElementData(source, 'odometer') or 0) .. " miles"})
		end
		table.insert(content, {"   - Preço: $"..exports.global:formatMoney(carPrice)  } )
		table.insert(content, {"   - Imposto: $"..exports.global:formatMoney(taxPrice) } )
		table.insert(content, {"   (( MTA Modelo: "..name.."))" } )
		table.insert(content, {"Pressione 'F' ou 'Enter' para comprar!" } )
		exports.hud:sendTopRightNotification( content, localPlayer, 240)
	end
end
addEvent("carshop:showInfo", true)
addEventHandler("carshop:showInfo", getRootElement(), carshop_showInfo)

local gui, theVehicle = {}
function carshop_buyCar(carPrice, cashEnabled, bankEnabled)
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return false
	end

	if gui["_root"] then
		return
	end

	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)

	theVehicle = source

	guiSetInputEnabled(true)
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateStaticImage(left, top, windowWidth, windowHeight, ":resources/window_body.png", false)
	--guiWindowSetSizable(gui["_root"], false)

	gui["lblText1"] = guiCreateLabel(20, 25, windowWidth-40, 16, "Você está prestes a comprar o seguinte veículo:", false, gui["_root"])
	gui["lblVehicleName"] = guiCreateLabel(20, 45+5, windowWidth-40, 13, exports.global:getVehicleName(source) , false, gui["_root"])
	guiSetFont(gui["lblVehicleName"], "default-bold-small")
	gui["lblVehicleCost"] = guiCreateLabel(20, 45+15+5, windowWidth-40, 13, "Preço: $"..exports.global:formatMoney(carPrice), false, gui["_root"])
	guiSetFont(gui["lblVehicleCost"], "default-bold-small")
	gui["lblText2"] = guiCreateLabel(20, 45+15*2, windowWidth-40, 70, "Ao clicar em um botão de pagamento, você concorda que um reembolso não é possível. Obrigado por nos escolher!", false, gui["_root"])
	guiLabelSetHorizontalAlign(gui["lblText2"], "left", true)
	guiLabelSetVerticalAlign(gui["lblText2"], "center", true)

	gui["btnCash"] = guiCreateButton(10, 140, 105, 41, "Pagar com dinheiro", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCash"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnCash"], cashEnabled)
	if exports.global:hasItem(localPlayer, 263) and carPrice <= 35000 then
		guiSetText(gui["btnCash"], "Redeem Token")
		guiSetEnabled(gui["btnCash"], true)
	end

	gui["btnBank"] = guiCreateButton(120, 140, 105, 41, "Pagar com banco", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnBank"], carshop_buyCar_click, false)
	guiSetEnabled(gui["btnBank"], bankEnabled)

	gui["btnCancel"] = guiCreateButton(232, 140, 105, 41, "Cancelar", false, gui["_root"])
	addEventHandler("onClientGUIClick", gui["btnCancel"], carshop_buyCar_close, false)
end
addEvent("carshop:buyCar", true)
addEventHandler("carshop:buyCar", getRootElement(), carshop_buyCar)

function carshop_buyCar_click()
	if exports.global:hasSpaceForItem(getLocalPlayer(), 3, 1) then
		local sourcestr = "cash"
		if (source == gui["btnBank"]) then
			sourcestr = "bank"
		elseif guiGetText(gui["btnCash"]) == "Resgatar token" then
			sourcestr = "token"
		end
		triggerServerEvent("carshop:buyCar", theVehicle, sourcestr)
	else
		outputChatBox("Você não tem espaço no inventario para a chave", 0, 255, 0)
	end
	carshop_buyCar_close()
end


function carshop_buyCar_close()
	if gui["_root"] then
		destroyElement(gui["_root"])
		gui = { }
	end
	guiSetInputEnabled(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end
--PREVENT ABUSER TO CHANGE CHAR
addEventHandler ( "account:changingchar", getRootElement(), carshop_buyCar_close )
addEventHandler("onClientChangeChar", getRootElement(), carshop_buyCar_close)

function cleanUp()
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end
addEventHandler("onClientResourceStart", resourceRoot, cleanUp)
