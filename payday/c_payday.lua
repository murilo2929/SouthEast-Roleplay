function cPayDay(faction, pay, profit, interest, donatormoney, tax, incomeTax, vtax, ptax, rent, totalInsFee, grossincome, Perc)
	--local cPayDaySound = playSound("mission_accomplished.mp3")
	local bankmoney = getElementData(getLocalPlayer(), "bankmoney")
	local moneyonhand = getElementData(getLocalPlayer(), "money")
	local wealthCheck = moneyonhand + bankmoney
	--setSoundVolume(cPayDaySound, 0)
	local info = {}
	-- output payslip
	--outputChatBox("-------------------------- PAY SLIP --------------------------", 255, 194, 14)
	table.insert(info, {"Payday"})	
	table.insert(info, {""})
	--table.insert(info, {""})
	-- state earnings/money from faction
	if not (faction) then
		if (pay + tax > 0) then
			--outputChatBox(, 255, 194, 14, true)
			table.insert(info, {"  Benefícios Estatais: $" .. exports.global:formatMoney(pay+tax)})	
		end
	else
		if (pay + tax > 0) then
			--outputChatBox(, 255, 194, 14, true)
			table.insert(info, {"  Salário Pago: $" .. exports.global:formatMoney(pay+tax)})
		end
	end
	
	-- business profit
	if (profit > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Lucro Empresarial: $" .. exports.global:formatMoney(profit)})
	end
	
	-- bank interest
	if (interest > 0) then
		--outputChatBox(,255, 194, 14, true)
		table.insert(info, {"  Juros Bancários: $" .. exports.global:formatMoney(interest) .. " (≈" ..("%.2f"):format(Perc) .. "%)"})
	end
	
	-- donator money (nonRP)
	if (donatormoney > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Dinheiro Doador: $" .. exports.global:formatMoney(donatormoney)})
	end
	
	-- Above all the + stuff
	-- Now the - stuff below
	
	-- income tax
	if (tax > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Imposto de Renda de " .. (math.ceil(incomeTax*100)) .. "%: $" .. exports.global:formatMoney(tax)})
	end
	
	if (vtax > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Imposto sobre Veículos: $" .. exports.global:formatMoney(vtax)})
	end

	if (totalInsFee > 0) then
		table.insert(info, {"  Seguro Veículo: $" .. exports.global:formatMoney(totalInsFee)})
	end
	
	if (ptax > 0) then
		--outputChatBox(, 255, 194, 14, true )
		table.insert(info, {"  Despesas Propriedade: $" .. exports.global:formatMoney(ptax)})
	end
	
	if (rent > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Aluguel Apartamento: $" .. exports.global:formatMoney(rent)})
	end
	
	--outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	
	if grossincome == 0 then
		--outputChatBox(,255, 194, 14, true)
		table.insert(info, {"  Renda Bruta: $0"})
	elseif (grossincome > 0) then
		--outputChatBox(,255, 194, 14, true)
		--outputChatBox(, 255, 194, 14)
		table.insert(info, {"  Renda Bruta: $" .. exports.global:formatMoney(grossincome)})
		table.insert(info, {"  Comentário(s): Transferido para sua conta bancária."})
	else
		--outputChatBox(, 255, 194, 14, true)
		--outputChatBox(, 255, 194, 14)
		table.insert(info, {"  Renda Bruta: $" .. exports.global:formatMoney(grossincome)})
		table.insert(info, {"  Observação: Retirado de sua conta bancária."})
	end
	
	
	if (pay + tax == 0) then
		if not (faction) then
			--outputChatBox(, 255, 0, 0)
			table.insert(info, {"  O governo não pode pagar os benefícios do estado para você."})
		else
			--outputChatBox(, 255, 0, 0)
			table.insert(info, {"  Seu chefe não pode pagar seu salário."})
		end
	end
	
	if (rent == -1) then
		--outputChatBox(, 255, 0, 0)
		table.insert(info, {"  Você foi despejado do seu apartamento, pois não pode mais pagar o aluguel."})
	end

	if (totalInsFee == -1) then
		table.insert(info, {"  Seu seguro foi removido porque você não pagou por ele."})
	end
	
	--outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	-- end of output payslip
	if exports.hud:isActive() then
		triggerEvent("hudOverlay:drawOverlayTopRight", localPlayer, info ) 
	end
	triggerEvent("updateWaves", getLocalPlayer())

	-- trigger one event to run whatever functions anywhere that needs to be executed hourly
	triggerEvent('payday:run', resourceRoot)
end
addEvent("cPayDay", true)
addEventHandler("cPayDay", getRootElement(), cPayDay)

function startResource()
	addEvent('payday:run', true)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startResource)