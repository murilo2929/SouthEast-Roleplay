local easyHotlines = {
	[911] = {
		name = "Emergency Hotline",
		order = 5,
		factions = { 1, 2, 164 },
		require_radio = true,
		operator = "911 Dispatcher",
		dialogue = {
			{
				q = "Emergência 911, qual serviço de emergência você precisa? LSPD ou LSFD",
				as = "service",
				check = function(service)
					-- return which factions should receive the call
					local found, factions = checkService(service)
					return factions, found, "Desculpe, não tenho certeza do que você quer dizer."
				end
			},
			{ q = "Você pode me dizer seu nome, por favor??", as = "name" },
			{ q = "Por favor, indique a sua emergência.", as = "emergency" },
			done = "Obrigado pela sua ligação, enviamos uma unidade para a sua localização."
		},
		done = function(caller, callstate, players)
			-- pick players depending on which service was dialled
			local players = collectReceivingPlayersForHotline { factions = callstate.service, require_radio = true }

			local zonelocation = string.gsub(exports.global:getElementZoneName(caller.element), "'", "''")
			local streetlocation = exports.gps:getPlayerStreetLocation(caller.element)

			local query = exports.mysql:query_insert_free("INSERT INTO `mdc_calls` (`caller`,`number`,`description`) VALUES ('" .. getElementData(caller.element, "dbid") .. "','" .. caller.phone .. "','" .. exports.mysql:escape_string(tostring(zonelocation) .. " - " .. callstate.emergency) .. "')")
			if query then

				log911("[911 Call] Player: " .. getPlayerName(caller.element) .. " || Situação: " .. callstate.emergency .. ", over.")
				players:send({
					"[RADIO] Aqui é a central, temos um relatório de emergência de " .. callstate.name .. " (#" .. caller.phone .. "), over.",
					"[RADIO] Situação: '" .. callstate.emergency .. "', over.",
					streetlocation and ("[RADIO] Localização: '" .. streetlocation .. " em " .. zonelocation .. "', out.") or ("[RADIO] Localização: '" .. zonelocation .. "', out.")
				}, 0, 183, 239)
				players:beep()
			else
				caller:respond("Houve um erro ao processar seu pedido. Tente mais tarde.")
			end
		end
	},
	[311] = {
		name = "LSPD Não Emergencial", -- name of the hotline shown on the client-side
		order = 10, -- sort order; smaller numbers are displayed first in the hotlines app on the client-side phone
		factions = { 1, 142, 50 }, -- which factions are going to receive notifications? this will later be used by .done; as players:send() will notify all players in those factions
		require_radio = true, -- to receive messages, players must have a turned-on radio
		operator = "LSPD Dispatcher", -- name of the person responding to your calls
		dialogue = {
			{ q = "LSPD Hotline. Por favor, indique a sua localização.", as = "location" },
			{ q = "Você pode descrever o motivo da sua ligação?", as = "reason" },
			done = "Obrigado pela sua ligação, entraremos em contato em breve."
		},
		-- with the dialogue options above, callstate.location is the location and callstate.reason the reason.
		-- caller.element is the player who called, caller.phone is the player's phone number from which he called.
		-- players is simply a table of all players that should be notified, players:send a shortcut for outputChatBox'ing
		done = function(caller, callstate, players)
			players:send({
				"[RADIO] Este é a central, temos um relatório de #" .. caller.phone .. " através da linha não emergencial # 311.",
				"[RADIO] Razão: '" .. callstate.reason .. "'.",
				"[RADIO] Localização: '" .. callstate.location .. "'."
			}, 245, 40, 135)
		end
	},
	[411] = {
		name = "LSFD Não Emergencial",
		order = 20,
		factions = { 2 },
		require_radio = true,
		operator = "LSFD Dispatcher",
		dialogue = {
			{ q = "LSFD Hotline. Por favor, indique a sua localização.", as = "location" },
			{ q = "Você pode nos dizer o motivo da sua ligação?", as = "reason" },
			done = "Obrigado pela sua ligação, entraremos em contato em breve."
		},
		done = function(caller, callstate, players)
			players:send({
				"[RADIO] Aqui é a central, temos um relatório de #" .. caller.phone .. " através da linha não emergencial # 411, over.",
				"[RADIO] Razão: '" .. callstate.reason .. "', over.",
				"[RADIO] Localização: '" .. callstate.location .. "', out."
			}, 245, 40, 135)
		end
	},
	[511] = {
		name = "Governo Los Santos",
		order = 30,
		factions = { 3 },
		require_radio = true,
		operator = "Gov Employee",
		dialogue = {
			{ q = "Governo de Los Santos. Como podemos te ajudar?", as = "reason" },
			done = "Obrigado pela sua ligação."
		},
		done = function(caller, callstate, players)
			players:send({
				"[RADIO] Aqui é a central LS Gov, recebemos uma mensagem de #" .. caller.phone .. ".",
				"[RADIO] Razão: '" .. callstate.reason .. "', over."
			}, 245, 40, 135)
		end
	},
	[711] = {
		name = "Relatório de veículo roubado",
		order = 2000,
		factions = { 1 },
		require_radio = true,
		operator = "911 Empregado",
		dialogue = {
			{ q = "Qual é o VIN do veículo que você gostaria de denunciar como roubado?", as = "vin", check = function(vin) return tonumber(vin), type(tonumber(vin)) == "number", "The VIN must be numeric." end }
		},
		done = function(caller, callstate, players)
			local query = exports.mysql:query("SELECT `stolen`, `owner`, `plate` FROM `vehicles` WHERE `id` = '" .. exports.mysql:escape_string(callstate.vin) .. "'")
			local row = exports.mysql:fetch_assoc(query)

			if row then
				if tonumber(row.owner) == getElementData(caller.element, "dbid") then
					if tonumber(row.stolen) == 0 then
						exports.mysql:update('vehicles', { stolen = 1 }, { id = callstate.vin })

						caller:respond("Obrigado, marcamos aquele veículo como roubado.")
						players:send({
							"[RADIO] Temos um veículo relatado como roubado de #" .. caller.phone .. ".",
							"[RADIO] Veículo VIN: '" .. callstate.vin .. "', Plate: '" .. row.plate .. "'"
						}, 245, 40, 135)
					else
						outputChatBox("Funcionário da Polícia [Celular]: Esse veículo já foi relatado como roubado, entre em contato com 311 se o veículo foi encontrado.", caller.element)
					end
				else
					caller:respond("Você não possui o veículo correspondente a esse VIN.")
				end
			else
				caller:respond("Não foi possível encontrar nenhum veículo que corresponda a esse VIN.")
			end
		end
	},
	[7332] = {
		name = "San Andreas Network",
		order = 35,
		factions = { 20 },
		require_phone = true,
		operator = "SAN Worker",
		dialogue = {
			{ q = "Obrigado por ligar para o SAN. Que mensagem posso passar aos nossos repórteres?", as = "reason" },
			done = "Obrigado pela mensagem, entraremos em contato com você se necessário."
		},
		done = function(caller, callstate, players)
			players:send("SMS de SAN: Mensagem de " .. caller.phone .. ": " .. callstate.reason .. ".", 120, 255, 80)
		end
	},
	[9021] = {
		name = "Bureau of Traffic Services",
		order = 50,
		factions = { 4 },
		require_radio = true,
		operator = "Operador",
		dialogue = {
			{ q = "Você ligou para o Bureau of Traffic Services. Por favor, diga o seu nome.", as = "name" },
			{ q = "Você pode descrever a situação, por favor?", as = "reason" },
			done = "Obrigado pela sua ligação, we've dispatched a unit to your location.",
		},
		done = function(caller, callstate, players)
			local zonelocation = exports.global:getElementZoneName(caller.element)
			local streetlocation = exports.gps:getPlayerStreetLocation(caller.element)

			players:send({
				"[RADIO] Aqui é a central, temos um relatório de incidente de " .. callstate.name .. " (#" .. caller.phone .. "), via #9021 over.",
				"[RADIO] Situação: '" .. callstate.reason .. "', over.",
				streetlocation and ("[RADIO] Localização: '" .. streetlocation .. " em " .. zonelocation .. "', out.") or ("[RADIO] Localização: '" .. zonelocation .. "', out.")
			}, 0, 183, 239)
			players:beep()
		end,
		no_players = "Desculpe, não há unidades disponíveis. Ligue de volta mais tarde."
	},
	[8294] = {
		name = "Yellow Cab Co.",
		order = 40,
		operator = "Taxi Operator",
		job = { id = 2, vehicle_models = { 438, 420 } },
		dialogue = {
			{ q = "Yellow Cab Company aqui, de onde você precisa de um táxi??", as = "location" },
			done = "Tudo bem então. Nós enviaremos um táxi."
		},
		done = function(caller, callstate, players)
			players:send("[RADIO] Operador de táxi diz: unidades, temos uma tarifa de #" .. caller.phone .. ". Eles precisam de um táxi em " .. callstate.location .. ".", 0, 183, 239)
			players:beep()
		end,
		no_players = "Er', parece que não temos nenhum táxi disponível nessa área. Por favor, tente novamente mais tarde."
	},
	[2552] = {
		name = "RS Haul",
		operator = "RS Haul Operator",
		job = { id = 1 },
		require_phone = true,
		dialogue = {
			{ q = "RS Haul aqui. Por favor, indique a sua localização.", as = "location" },
			done = "Obrigado pela sua ligação, a truck of goods will be coming shortly."
		},
		done = function(caller, callstate, players)
			players:send("SMS de RS Haul: Um cliente solicitou uma entrega em '" .. callstate.location .. "'. Por favor entre em contato #" .. caller.phone .. " para detalhes.", 120, 255, 80)
		end,
		no_players = "Não há nenhum caminhoneiro disponível no momento, tente novamente mais tarde."
	},
	[211] = {
		name = "Superior Court",
		operator = "Operador",
		factions = { 50 },
		require_radio = true,
		dialogue = {
			{ q = "Tribunal Superior de San Andreas, diga seu nome.", as = "name" },
			{ q = "O que você precisa?", as = "reason" },
			done = "Obrigado por nos ligar, entraremos em contato com você o mais rápido possível."
		},
		done = function(caller, callstate, players)
			players:send({
				"[RADIO] Aqui é a central, temos um relatório de #" .. caller.phone .. " via a linha direta # 211, over.",
				"[RADIO] Solicitar: '" .. callstate.reason .. "', over.",
				"[RADIO] De: '" .. callstate.name .. "', out."
			}, 245, 40, 135)
		end
	},
	[5555] = {
		name = "Los Santos International Airport",
		order = 100,
		operator = "Operador",
		factions = { 47 },
		require_phone = true,
		dialogue = {
			{ q = "Você chegou ao Aeroporto Internacional de Los Santos. Como podemos ajudá-lo?", as = "reason" },
			done = "Obrigado pela mensagem, entraremos em contato com você se necessário."
		},
		done = function(caller, callstate, players)
			players:send("SMS de LSIA: Inquérito de #" .. caller.phone .. ": " .. callstate.reason .. ".", 120, 255, 80)
		end
	},
	[2200] = {
		name = "JGC",
		operator = "Receptionist",
		factions = { 74 },
		require_phone = true,
		dialogue = {
			{ q = "Bem-vindo ao JGC. Qual empresa você está tentando alcançar?", as = "company" },
			{ q = "Tudo bem. Posso pegar seu nome por favor?", as = "name" },
			{ q = "Obrigado. Como podemos te ajudar?", as = "reason" },
			done = "Obrigado pela sua chamada. Vou passar a mensagem e pedir a alguém para ligar de volta. Tenha um bom dia!"
		},
		done = function(caller, callstate, players)
			players:send({
				"SMS de JGC: " .. callstate.name .. " está tentando alcançar " .. callstate.company .. ": " .. callstate.reason .. ".",
				"Ligue de volta para o cliente no telefone #" .. caller.phone .. "."
			}, 120, 255, 80)
		end
	},
	[5500] = {
		name = "Dinoco",
		operator = "Operador",
		factions = { 147 },
		require_phone = true,
		dialogue = {
			{ q = "Olá, Dinoco aqui, como podemos ajudá-lo?", as = "reason" },
			{ q = "Qual é o seu nome?", as = "name" },
			done = "Obrigado pela ligação, um funcionário deve ligar de volta em breve!"
		},
		done = function(caller, callstate, players)
			players:send({
				"SMS de Dinoco.: " .. callstate.name .. "está solicitando ajuda: " .. callstate.reason .. ".",
				"Ligue de volta para o cliente no telefone #" .. caller.phone .. "."
			}, 120, 255, 80)
		end
	},
	[2500] = {
		name = "Banco de Los Santos",
		order = 1900,
		operator = "Secretaria",
		factions = { 17 },
		require_phone = true,
		dialogue = {
			{ q = "Bem-vindo ao Banco de Los Santos. Posso saber seu nome, por favor?", as = "name" },
			{ q = "Tudo bem, como podemos ajudá-lo?", as = "message" },
			done = "Ok, vou notificar alguém. Tenha um bom dia."
		},
		done = function(caller, callstate, players)
			players:send({
				"SMS do banco de LS: Inquérito de " .. callstate.name .. ": " .. callstate.message .. ".",
				"Ligue de volta para o cliente no telefone #" .. caller.phone .. "."
			}, 120, 255, 80)
		end
	},
	[2600] = {
		name = "All Saints Hospital",
		operator = "Recepcionista",
		factions = { 164 },
		require_radio = true,
		dialogue = {
			{ q = "Você ligou para o Hospital All Saints. Posso pegar seu nome por favor?", as = "name" },
			{ q = "Como podemos te ajudar?", as = "reason" },
			done = "Obrigado por nos ligar, entraremos em contato com você o mais breve possível."
		},
		done = function(caller, callstate, players)
			players:send({
				"[RADIO] Aqui é a central, temos um relatório de #" .. caller.phone .. " através da linha direta # 2600, over.",
				"[RADIO] Nome: '" .. callstate.name .. "', over.",
				"[RADIO] Solicita: '" .. callstate.reason .. "', out."
			}, 245, 40, 135)
			players:beep()
		end
	},
	[4200] = {
		name = "Western Solutions LLC",
		operator = "Fritz Speer",
		factions = { 159 },
		require_phone = true,
		dialogue = {
			{ q = "Bem-vindo à Western Solutions, como podemos ajudá-lo?", as = "reason" },
			{ q = "Qual é o seu nome?", as = "name" },
			done = "Obrigado pela ligação, um funcionário deve ligar de volta em breve!"
		},
		done = function(caller, callstate, players)
			players:send({
				"SMS de Western Solutions: " .. callstate.name .. " está ligando sobre: " .. callstate.reason .. ".",
				"Ligue de volta para o cliente em #" .. caller.phone .. "."
			}, 120, 255, 80)
		end
	},
	[2504] = {
		name = "Sparta Inc",
		operator = "Operador",
		factions = { 212 },
		require_phone = true,
		dialogue = {
			{ q = "Hello, Sparta Inc. here, how can we help you?", as = "reason" },
			{ q = "Qual é o seu nome?", as = "name" },
			done = "Obrigado pela ligação, um funcionário deve ligar de volta em breve!"
		},
		done = function(caller, callstate, players)
			players:send({
				"SMS from Sparta Inc.: " .. callstate.name .. " is requesting assistance: " .. callstate.reason .. ".",
				"Ligue de volta para o cliente no telefone #" .. caller.phone .. "."
			}, 120, 255, 80)
		end
	},
}

------------------------------------------------------------------------------------------------------------------------
local function count(t)
	local c = 0
	for k, v in pairs(t) do
		c = c + 1
	end
	return c
end

function hasTurnedOnRadio(player)
	for _, item in ipairs(exports['item-system']:getItems(player)) do
		if item[1] == 6 and type(item[2]) == 'number' and item[2] > 0 then
			return true
		end
	end
	return false
end

function collectReceivingPlayersForHotline(hotline)
	-- collect all players to have the message sent to
	local receivingPlayers = setmetatable({}, {
		__index = {
			-- players:send({messages}, r, g, b)
			-- this is akin to defining function send(t, ...) somewhere somewow
			send = function(t, message, ...)
				for player in pairs(t) do
					if type(message) == 'string' then
						outputChatBox(message, player, ...)
					else
						for _, m in ipairs(message) do
							outputChatBox(m, player, ...)
						end
					end
				end
			end,
			beep = function(t)
				for player in pairs(t) do
					triggerClientEvent(player, "phones:radioDispatchBeep", player)
				end
			end
		}
	})

	local temp = {}
	-- factions?
	for _, faction in ipairs(hotline.factions or {}) do
		for _, player in ipairs(exports.factions:getPlayersInFaction(faction)) do
			temp[player] = true
		end
	end

	-- job?
	if hotline.job then
		for _, player in ipairs(exports.pool:getPoolElementsByType("player")) do
			if getElementData(player, "job") == hotline.job.id then
				if hotline.job.vehicle_models then
					local car = getPedOccupiedVehicle(player)
					if car then
						local vm = getElementModel(car)
						for _, model in ipairs(hotline.job.vehicle_models) do
							if model == vm then
								temp[player] = true
								break
							end
						end
					end
				else
					temp[player] = true
				end
			end
		end
	end

	for player in pairs(temp) do
		local available = true
		if hotline.require_radio and not hasTurnedOnRadio(player) then
			available = false
		end

		if hotline.require_phone and not exports.global:hasItem(player, 2) then
			available = false
		end

		if available then
			receivingPlayers[player] = true
		end
	end
	return receivingPlayers
end

local function finishCall(caller)
	-- finish up the call
	triggerEvent("phone:cancelPhoneCall", caller.element)
	removeElementData(caller.element, "calls:hotline:state")
	removeElementData(caller.element, "callprogress")
end

function handleEasyHotlines(caller, callingPhoneNumber, startingCall, message)
	local hotline = easyHotlines[callingPhoneNumber]
	if not hotline then
		return "error"
	end

	caller = setmetatable(caller, {
		__index = {
			-- caller:respond(message)
			respond = function(t, message)
				outputChatBox(hotline.operator .. " [Telefone]: " .. message, t.element, 200, 255, 200)
			end
		}
	})

	local callstate = not startingCall and getElementData(caller.element, "calls:hotline:state") or { progress = 1 }

	if hotline.no_players then
		local players = collectReceivingPlayersForHotline(hotline)
		if count(players) == 0 then
			caller:respond(hotline.no_players)
			finishCall(caller)
			return
		end
	end

	if not startingCall then
		-- we've presumably answered a question.
		local dialogue = hotline.dialogue[callstate.progress]
		if dialogue.check then
			local okay, err
			message, okay, err = dialogue.check(message)
			if not okay then
				caller:respond(err or "Sorry, no can do.")

				-- finish up the call
				finishCall(caller)
				return
			end
		end

		callstate[dialogue.as] = message
		callstate.progress = callstate.progress + 1
	end

	-- have we exhausted the dialogue yet?
	if callstate.progress <= #(hotline.dialogue or {}) then
		caller:respond(hotline.dialogue[callstate.progress].q)

		exports.anticheat:changeProtectedElementDataEx(caller.element, "calls:hotline:state", callstate, false)

		-- this prevents a global phone message from being sent.
		exports.anticheat:changeProtectedElementDataEx(caller.element, "callprogress", callstate.progress, false)
	else
		-- do we have a "done" dialogue?
		if hotline.dialogue and hotline.dialogue.done then
			caller:respond(hotline.dialogue.done)
		end

		if hotline.done then
			callstate = setmetatable(callstate, {
				-- fallback for non-existent keys
				__index = function(t, key)
					return "(( Error: '" .. key .. "' missing ))"
				end
			})

			local players = collectReceivingPlayersForHotline(hotline)
			hotline.done(caller, callstate, players)
		end

		finishCall(caller)
	end
end

(function()
	-- remove all hotlines that have factions assigned, but where none of those factions actually still exist on
	-- the server.
	local removedHotlines = {}

	local working, broken = 0, 0
	for number, hotline in pairs(easyHotlines) do
		if hotline.factions and #hotline.factions > 0 then
			local found = false
			for _, faction in ipairs(hotline.factions) do
				if isElement(exports.factions:getFactionFromID(faction)) then
					found = true
					working = working + 1
					break
				end
			end

			if not found then
				broken = broken + 1
				removedHotlines[number] = hotline
			end
		end

		if (not hotline.factions and not hotline.job) or not hotline.dialogue then
			broken = broken + 1
			removedHotlines[number] = hotline
		end
	end

	-- does not take the job numbers into account, so this check indicates -some- of the factions exist.
	if working > 0 then
		for number, hotline in pairs(removedHotlines) do
			easyHotlines[number] = {
				operator = "Anúncio de serviço",
				dialogue = { done = "Este número não está em serviço no momento." }
			}
			outputDebugString("Hotline " .. number .. " has no eligible faction for receiving messages.", 2)
		end
		return removedHotlines
	else
		return {}
	end
end)();

(function()
	-- sort all hotlines into a table containing { name, number, order }
	local hotlines = {}
	for number, hotline in pairs(easyHotlines) do
		if hotline.name then
			table.insert(hotlines, { hotline.name, number, hotline.order or 1000 })
		end
	end
	table.sort(hotlines, function(a, b) return a[3] < b[3] end)
	exports.anticheat:changeProtectedElementDataEx(resourceRoot, "hotlines:names", hotlines)
end)();

------------------------------------------------------------------------------------------------------------------------
function log911( message )
	local logMeBuffer = getElementData(getRootElement(), "911log") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)

	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "911log", logMeBuffer)
end

function read911Log(thePlayer)
	if exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "911log") or { }
		outputChatBox("Recent 911 calls:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("show911", read911Log)

function checkService(service)
	t = { "both", 		--1: all
		  "all", 		--2: all
		  "pd", 		--3: PD
		  "police", 	--4: PD
		  "lspd",		--5: PD
		  "lscsd",		--6: PD
		  "sasd", 		--7: PD
		  "es",			--8: ES/FD
		  "medic",		--9: ES/FD
		  "ems",		--10: ES/FD
		  "ambulance",	--11: ES/FD
		  "lsfd",		--12: FD
		  "fire",		--13: FD
		  "fd",			--14: FD
		  "hospital",	--15: ES
	}
	for row, names in ipairs(t) do
		if names == string.lower(service) then
			if row >= 1 and row <= 2 then
				return true, { 1, 2, 50, 164 } -- All!
			elseif row >= 3 and row <= 7 then
				return true, { 1, 50 } -- PD and SCoSA
			elseif row >= 8 and row <= 11 then
				return true, { 2, 164 } -- ES and FD
			elseif row >= 12 and row <= 14 then
				return true, { 2 } -- FD
			elseif row == 15 then
				return true, { 164 } -- ES
			end
		end
	end
	return false
end
