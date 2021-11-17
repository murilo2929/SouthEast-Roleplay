--[[
 * ***********************************************************************************************************************
 * Copyright (c) 2015 OwlGaming Community - All Rights Reserved
 * All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ***********************************************************************************************************************
 ]]

local convos = {
	['greet'] = {
		"Oi! Como posso ajudá-lo?",
		"Olá! Como eu poderia te ajudar?",
		"Bem-vindo ao Star Fashion!",
	},
	['cant'] = {
		"Desculpe, eu não posso fazer isso no momento.",
		"Talvez outra hora? Esse departamento está indisponível no momento.",
	},
}

local function getConvoText(convoId)
	if convos[convoId] then
		return convos[convoId][math.random(1, #convos[convoId])]
	else
		return convoId
	end
end

local say_cooldown = {}
function pedSay(pedName, convoId)
	-- 500 miliseconds is more than enough to prevent lagging server when using key macro to spam mouse 1 and also less spams.
	if not say_cooldown[convoId] or getTickCount() - say_cooldown[convoId] > 500 then
		say_cooldown[convoId] = getTickCount()
		return exports.global:sendLocalText( source, ""..pedName.." diz: "..(getConvoText(convoId)), 255, 255, 255, 10 )
	end
end
addEvent("clothes:pedSay", true)
addEventHandler("clothes:pedSay", root, pedSay)

local function translateErrorCode(code)
	code = tonumber(code) or 1
	if code == 0 then
		return 'ok'
	elseif code > 0 and code < 90 then
		return 'Não foi possível recuperar o arquivo do URL.'
	elseif code >=400 and code < 600 then
		return 'Não foi possível recuperar o arquivo do URL.'
	elseif code == 1002 then
		return 'Download abortado'
	elseif code == 1003 then
		return 'Falha ao inicializar'
	elseif code == 1004 then
		return 'Incapaz de analisar url'
	elseif code == 1005 then
		return 'Incapaz de resolver o nome do host'
	elseif code == 1006 then
		return 'IP de destino não permitido'
	elseif code == 1007 then
		return 'Erro de arquivo'
	end
	return 'Não foi possível recuperar o arquivo do URL.'
end

local function getPath2(url)
	return 'uploads/' .. md5(url) .. '.tex'
end

function wizard2Result(url, desc, skin_, for_faction)
	local player = client
	local skin = skin_
	local url_ = url
	local desc_ = desc
	local collection_size = 0

	for cid, cl in pairs(savedClothing) do
		if for_faction then
			-- will do
		else
			if cl.creator_char == getElementData(player, 'dbid') then
				collection_size = collection_size + 1
			end
		end
	end

	if collection_size >= max_collection_items then
		triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, "Sua coleção não pode ter mais de "..max_collection_items.." itens.")
		return
	end

	local apiURL = string.match(url:match("^.*%/(.*)"), "(%w+)%.") --> I'm not too great with regex
	local apiURL = "https://api.imgur.com/3/image/" .. apiURL
	local options = {
		queueName = "clothes",
		connectionAttempts = 5,
		headers = {Authorization = "Client-ID " .. tostring(get("imgurClient"))}
	}

	fetchRemote(apiURL, options, function(data, errno)
		if not errno.success then
			triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, translateErrorCode(errno.statusCode))
		else
			local table = fromJSON(data)
			if table and table.success and table.data then
				local width, height, size = table.data.width, table.data.height, table.data.size

				if size > 200000 then
					triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, 'O arquivo excede o tamanho máximo de 200KB')
				elseif height > 500 or width > 1200 then
					triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, 'O arquivo excede as dimensões máximas de 500x1200')
				else
					-- Initial Checks done
					local options = {
						queueName = "clothes",
						connectionAttempts = 5,
						postIsBinary = true
					}

					fetchRemote(url, options, function(str, errno)
						if not errno.success then
							triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, translateErrorCode(errno.statusCode))
						else
							if exports.global:takeMoney(player, 200) then
								-- make the skin
								local add = {
												url=url_,
												description=desc_,
												skin=skin, price=50,
												creator_charname=exports.global:getPlayerName(player),
												creator_char=getElementData(player, 'dbid'),
												for_sale_until=0,
												date=exports.datetime:now(),
												distribution=1,
												sold=0,
											}
								if for_faction then
									local fid = canUploadForFaction(player)
									if fid then
										add.creator_charname = exports.factions:getFactionName(fid)
										add.creator_char = -fid
										add.distribution = 5
									end
								end

								local clothing_id = saveClothes(add, player)
								if clothing_id and tonumber(clothing_id) then
									exports.logs:dbLog(player, 25, player, "Made dupont skin #" .. tostring(clothing_id) .. " for $200 of size " .. tostring(size / 100) .. "kB")
									if add.distribution == 5 then
										savedClothing[clothing_id].mdate = exports.datetime:now()
										dbExec(exports.mysql:getConn('mta'), "UPDATE clothing SET manufactured_date=NOW() WHERE `id`=?", clothing_id)
									end

									local file_path = getPath(clothing_id)
									local file = fileCreate(file_path)
									fileWrite(file, str)
									if fileClose(file) then
										triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, 'ok', add.distribution == 5 and -add.creator_char or nil)
										return true
									end
								end
								triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, 'Erro interno! O servidor não conseguiu processar o seu arquivo de imagem.')
							else
								triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, "Você precisa de $ 25 para enviar uma nova proposta de design.")
							end
						end
					end)
				end
			else
				triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, "Parece haver um problema com a API do imgur")
			end
		end
	end)

	local options = {
		queueName = "clothes",
		connectionAttempts = 5,
		postIsBinary = true
	}

	fetchRemote(url, options, function(str, errno)
		if not errno.success then
			triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, translateErrorCode(errno.statusCode))
		else
			local file_path = getPath2(url)
			if fileExists(file_path) then
				fileDelete(file_path)
			end

			local file = fileCreate(file_path)
			fileWrite(file, str)
			local size = fileGetSize ( file )
			fileClose(file)

			if size > 200000 then
				triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, 'O arquivo excede o tamanho máximo de 200KB')
				fileDelete(file_path)
			else
				-- make sure the tmp file always gets cleaned up.
				setTimer(function ()
					if fileExists(file_path) then
						fileDelete(file_path)
					end
				end, 60000, 1)

				if exports.global:takeMoney(player, 25) then
					-- make the skin
					local add = {
									url=url_,
									description=desc_,
									skin=skin, price=50,
									creator_charname=exports.global:getPlayerName(player),
									creator_char=getElementData(player, 'dbid'),
									for_sale_until=0,
									date=exports.datetime:now(),
									distribution=1,
									sold=0,
								}
					if for_faction then
						local fid = canUploadForFaction(player)
						if fid then
							add.creator_charname = exports.factions:getFactionName(fid)
							add.creator_char = -fid
							add.distribution = 5
						end
					end

					local clothing_id = saveClothes(add, player)
					if clothing_id and tonumber(clothing_id) then
						if add.distribution == 5 then
							savedClothing[clothing_id].mdate = exports.datetime:now()
							dbExec(exports.mysql:getConn('mta'), "UPDATE clothing SET manufactured_date=NOW() WHERE `id`=?", clothing_id)
						end

						local new_path = getPath(clothing_id)
						if fileExists(new_path) then
							fileDelete(new_path)
						end
						if fileRename ( file_path, new_path ) then
							triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, 'ok', add.distribution == 5 and -add.creator_char or nil)
							return true
						end
					end
					triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, 'Erro interno! O servidor não conseguiu processar o seu arquivo de imagem.')
				else
					triggerClientEvent(player, 'clothes:wizard2Result', resourceRoot, "Você precisa de $ 25 para enviar uma nova proposta de design.")
				end
			end
		end
	end)
end
addEvent('clothes:wizard2Result', true)
addEventHandler('clothes:wizard2Result', resourceRoot, wizard2Result)

local function countPublishedClothes(pid)
	local count = 0
	for id, cloth in pairs(savedClothing) do
		if cloth.creator_char == pid and cloth.distribution ~= 1 then
			count = count + 1
		end
	end
	return count
end

function manufacture(cid, instant)
	local done, why = false, 'Ocorreram erros durante a fabricação do design de suas roupas.'
	local clothing = savedClothing[cid]
	if clothing then
		local pid = getElementData(client, 'dbid')
		if clothing.creator_char == pid then
			if clothing.distribution == 1 then
				-- everything is good, now check if exceeds upload quota.
				local current = countPublishedClothes(pid)
				dbQuery( function(qh, client, clothing, current)
					local result = dbPoll( qh, 0 )
					if current < tonumber(result[1].max_clothes) then--or isModerator(client) then
						-- quota is ok. now check if the file is still existed on server.
						local path = getPath(clothing.id)
						if fileExists(path) then
							local file = fileOpen(path, true)
							if file then
								extra_minutes = 0
								if not instant then
									-- now determine how long the manufactoring process, based on the file size.
									local max_minutes = 360 -- 3 hours
									local max_file_size = 300000
									local size = math.min(fileGetSize(file), max_file_size) -- max file size would be 300kb
									local one_minute_size = max_file_size/max_minutes
									extra_minutes = math.ceil(size/one_minute_size)
								else
									local pre = exports.donators:getPerks(43)
									if exports.donators:takeGC(client, pre[2]) then
										exports.donators:addPurchaseHistory(client, "Fabricação Instantanea Star", -pre[2])
									else
										fileClose(file)
										exports.hud:sendBottomNotification(client, "GameCoins", "Você não tem GCs para comprar este item. Pressione F10 -> Recursos Premium para aprender como obter mais GCs!")
										why = "((Você não tem os GCs para processar isso instantaneamente.))"
										triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
										return
									end
								end
								clothing.distribution = 2 -- Personal (Private)
								clothing.mdate = exports.datetime:now()+(extra_minutes*60)
								saveClothes(clothing, client, true)

								-- now set the arrival time.
								dbExec(exports.mysql:getConn('mta'), "UPDATE clothing SET manufactured_date=NOW() + INTERVAL ? MINUTE WHERE `id`=?", extra_minutes, clothing.id)
								done, why = true, "Sua solicitação de fabricação foi confirmada. Você pode voltar aqui em alguns dias para recolher os produtos. ((em "..extra_minutes.." minutos. Se você fez upload instantaneamente, reabra sua lista.))"
								triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
								fileClose(file)
								-- send notification when it's arrived
								local content = "Pedido de confecção de roupas #"..clothing.id.." Atualizar"
								setTimer( sendBatchNotis, math.max(50,extra_minutes)*60*1000, 1, getElementData(client, 'account:id'), content )
							else
								why = "((Seu arquivo de skin carregado no servidor está corrompido.))"
								triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
								return
							end
						else
							why = "((Seu arquivo de skin enviado não foi encontrado no servidor.))"
							triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
							return
						end
					else
						why = "Você já fabricou "..current.."/"..result[1].max_clothes.." designs."
						triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
						return
					end
				end
				,{client, clothing, current}, exports.mysql:getConn('mta'), "SELECT max_clothes FROM characters WHERE id=? LIMIT 1", pid)

			else
				why = "Este design de roupa já foi fabricado."
				triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
				return
			end
		else
			why = "Você não é ou não é mais o proprietário deste rascunho de design de roupas."
			triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
			return
		end
	else
		why = 'Não foi possível alocar o design de sua roupa no servidor. Pode ser excluído prematuramente pelo moderador ou a textura pode ser inválida.'
		triggerClientEvent(client, 'clothes:callback_Manu', resourceRoot, done, why)
		return
	end
end
addEvent('clothes:manufacture', true)
addEventHandler('clothes:manufacture', resourceRoot, manufacture)

function getProduct(cid)
	local done, why = false, "Ocorreram erros ao recuperar o item do servidor."
	local cl = savedClothing[cid]
	local pid = getElementData(client, 'dbid')
	local sold, id = nil
	if cl then
		if cl.creator_char == pid then
			-- if manufacture, is private and arrived.
			if cl.distribution == 2 and not (cl.mdate and cl.mdate > 0 and cl.mdate > exports.datetime:now()) then
				local price = 2^cl.sold
				if exports.global:takeMoney(client, price) then
					done = exports.global:giveItem(client, 16, cl.skin..':'..cl.id)
					why = "Você recebeu um novo conjunto de roupas em seu inventário."
					dbExec( exports.mysql:getConn('mta'), "UPDATE clothing SET sold=sold+1 WHERE id=?", cl.id )
					savedClothing[cid].sold = savedClothing[cid].sold + 1
					sold = savedClothing[cid].sold
					id = cl.id
				end
			end
		end
	end
	triggerClientEvent( client, 'clothes:callback_Dis', resourceRoot, {action='getProduct', done=done, why=why, id=id, sold=sold } )
end
addEvent('clothes:getProduct', true)
addEventHandler('clothes:getProduct', resourceRoot, getProduct)

function sendBatchNotis(acc_id, content)
	return exports.announcement:makePlayerNotification(acc_id, content, 'Sua solicitação foi atendida, por favor, dirija-se ao nosso HQ para retirar os produtos!', 'star')
end

function sellProduct(cid)
	local done, why = false, "Ocorreram erros ao recuperar o item do servidor."
	local cl = savedClothing[cid]
	local pid = getElementData(client, 'dbid')
	local dist, id = nil
	if cl then
		if cl.creator_char == pid then
			-- if manufacture, is private and arrived.
			if cl.distribution == 2 and not (cl.mdate and cl.mdate > 0 and cl.mdate > exports.datetime:now()) then
				local price = 200
				savedClothing[cid].distribution = 3
				cl.distribution = 3
				dbExec( exports.mysql:getConn('mta'), "UPDATE clothing SET distribution=3 WHERE id=?", cl.id )
				exports.global:giveMoney(client, price)
				exports.logs:dbLog(client, 25, client, "Sold dupont skin #" .. tostring(cl.id) .. " for $" .. tostring(price))
				saveClothes(savedClothing[cid], client, true)
				done = true
				why = "You received $"..exports.global:formatMoney(price).."."
				id = cl.id
				dist = 3
			end
		end
	end
	triggerClientEvent( client, 'clothes:callback_Dis', resourceRoot, {action='sellProduct', done=done, why=why, id=id, dist=dist } )
end
addEvent('clothes:sellProduct', true)
addEventHandler('clothes:sellProduct', resourceRoot, sellProduct)

addEvent( 'clothes:deleteMyClothes', true )
addEventHandler( 'clothes:deleteMyClothes', resourceRoot, function( index )
	local clothes = savedClothing[ index ]
	if clothes then
		local search_for = clothes.skin..":"..index

		local qh = dbQuery( exports.mysql:getConn('mta'), "SELECT `index` FROM items WHERE itemID=16 and itemValue=? LIMIT 1", search_for )
		local result, num_affected_rows, last_insert_id = dbPoll ( qh, 10000 )
		if num_affected_rows > 0 then
			triggerClientEvent( client, 'clothes:deleteMyClothes', resourceRoot, index, false, "Porque há um ou mais itens de roupa em algum lugar do jogo que usam esse design. Encontre e destrua-os primeiro." )
		else
			local qh = dbQuery( exports.mysql:getConn('mta'), "SELECT `id` FROM worlditems WHERE itemid=16 and itemvalue=? LIMIT 1", search_for )
			local result, num_affected_rows, last_insert_id = dbPoll ( qh, 10000 )
			if num_affected_rows > 0 then
				triggerClientEvent( client, 'clothes:deleteMyClothes', resourceRoot, index, false, "Porque há um ou mais itens de roupa em algum lugar do jogo que usam esse design. Encontre e destrua-os primeiro." )
			else
				local qh = dbQuery( exports.mysql:getConn('mta'), "SELECT `pID` FROM shop_products WHERE pItemID=16 and pItemValue=? LIMIT 1", search_for )
				local result, num_affected_rows, last_insert_id = dbPoll ( qh, 10000 )
				if num_affected_rows > 0 then
					triggerClientEvent( client, 'clothes:deleteMyClothes', resourceRoot, index, false, "Porque há um ou mais itens de roupa em algum lugar do jogo que usam esse design. Encontre e destrua-os primeiro." )
				else
					triggerClientEvent( client, 'clothes:deleteMyClothes', resourceRoot, index, true )
				end
			end
		end
	else
		triggerClientEvent( client, 'clothes:deleteMyClothes', resourceRoot, index, false, "Internal error - code 312" )
	end
end)
