local mem_permissions = {
	[1] = 	{"add_member",			"Convidar um membro"},
	[2] = 	{"del_member",			"Remover membros"},
	[3] = 	{"modify_ranks",		"Modificar Ranks, Permissões e Salarios"},
	[4] = 	{"modify_faction_note",	"Modificar nota de facção"},
	[5] = 	{"modify_factionl_note","Modificar Nota do Líder de Facção"},
	[6] = 	{"respawn_vehs",		"Respawnar Veículos da Facção"},
	[7] = 	{"change_member_rank",	"Promover/Rebaixar Membros"},
	[8] = 	{"manage_interiors",	"Gerenciar Interiores de Facção"},
	[9] = 	{"manage_finance",		"Gerenciar Finanças da Facção"}, 
	[10] = 	{"toggle_chat",			"Ativ/Desa Chat da Facção"},  
	[11] = 	{"modify_leader_note",	"Modificar Nota do Líder"}, 
	[12] =  {"edit_motd", 			"Editar Mensagem do Dia"},
	[13] = 	{"use_fl",				"Uso de /fl"}, 
	[14] = 	{"use_hq",				"Uso de /hq"}, 
	[15] = 	{"make_ads", 			"Crie anúncios de facção"},
	[16] = 	{"modify_duty_settings","Modificar configurações de trabalho"}, 	-- 16 and above are perms that do not exist for ALL factions
	[17] = 	{"set_member_duty",		"Definir deveres dos sócios"}, 		-- If you add something you'll have to edit 'getFactionPermissions'
	[18] = 	{"see_towstats",		"Ver as estatísticas"}, 
	}

-- Get Permissions
------------------->>
function hasMemberPermissionTo(player, fID, action)
	if (not player or not action or not fID) then return false end
	if (not isElement(player) or getElementType(player) ~= "player" or type(action) ~= "string") then return false end
	local fID = tonumber(fID)
	local rankID = 0
	local faction = getElementData(player, "faction")
	for i,v in pairs(faction) do
		if i == fID then
			rankID = tonumber(v.rank)
		end	
	end	
	local perm = factionRanks[rankID]["permissions"] or "" 
	if perm ~= true then 
		local perProfile = split(perm, ",")
		for i,v in ipairs(perProfile) do
			v = tonumber(v)
			if (mem_permissions[v][1] == action) then
				return true
			end
		end
	end	
	return false
end


-- Get Default Permissions
--------------------------->>

function getDefaultPermissionSet(permissions)
	if (not permissions or type(permissions) ~= "string") then return false end
	
	local permTable = {}
	if (permissions == "*") then		-- Founder/Leader Permissions
		for i=1,#mem_permissions do
			table.insert(permTable, i)
		end
		return permTable
	elseif (permissions == "New Member") then
		return {}
	end
end

