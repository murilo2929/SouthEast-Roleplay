-- Language commands
function getLanguageByName( language )
	for i = 1, call( getResourceFromName( "language-system" ), "getLanguageCount" ) do
		if language:lower() == call( getResourceFromName( "language-system" ), "getLanguageName", i ):lower() then
			return i
		end
	end
	return false
end

function setLanguage(thePlayer, commandName, targetPlayerName, language, skill1)
	local skill = skill1
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		if not targetPlayerName or not language then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador] [Idioma] [Skill]", thePlayer, 255, 194, 14)
		else
			if not tonumber( skill ) then
				skill = 100
			end
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Jogador não esta logado.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				local skill = tonumber( skill )
				if not lang then
					outputChatBox( language .. " não é um idioma valido.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "language-system" ), "getLanguageName", lang )
					local success, reason = call( getResourceFromName( "language-system" ), "learnLanguage", targetPlayer, lang, false, skill )
					if success then
						outputChatBox( targetPlayerName .. " aprendeu " .. langname .. ".", thePlayer, 0, 255, 0 )
						outputChatBox( targetPlayerName .. " aprendeu " .. langname .. ".", targetPlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " não pode aprender " .. langname .. ": " .. tostring( reason ), thePlayer, 255, 0, 0 )
						outputChatBox( targetPlayerName .. " não pode aprender " .. langname .. ": " .. tostring( reason ), targetPlayer, 255, 0, 0 )
					end
					exports.logs:dbLog(thePlayer, 4, targetPlayer, "SETLANGUAGE "..langname.." "..tostring(skill))
				end
			end
		end
	end
end
addCommandHandler("setlanguage", setLanguage)
addCommandHandler("setlang", setLanguage)
addCommandHandler("setaridioma", setLanguage)

function deleteLanguage(thePlayer, commandName, targetPlayerName, language)
	if exports.integration:isPlayerTrialAdmin(thePlayer) then
		if not targetPlayerName or not language then
			outputChatBox("SYNTAX: /" .. commandName .. " [Nome Parcial Jogador] [Idioma]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Jogador não esta logado.", thePlayer, 255, 0, 0 )
			else
				local lang = tonumber( language ) or getLanguageByName( language )
				if not lang then
					outputChatBox( language .. " não é um idioma valido.", thePlayer, 255, 0, 0 )
				else
					local langname = call( getResourceFromName( "language-system" ), "getLanguageName", lang )
					if call( getResourceFromName( "language-system" ), "removeLanguage", targetPlayer, lang ) then
						outputChatBox( targetPlayerName .. " esqueceu " .. langname .. ".", thePlayer, 0, 255, 0 )
						outputChatBox( targetPlayerName .. " esqueceu " .. langname .. ".", targetPlayer, 0, 255, 0 )
					else
						outputChatBox( targetPlayerName .. " não fala " .. langname, thePlayer, 255, 0, 0 )
						outputChatBox( targetPlayerName .. " esqueceu " .. langname .. ".", targetPlayer, 0, 255, 0 )
					end
				end
			end
		end
	end
end
addCommandHandler("dellanguage", deleteLanguage)
addCommandHandler("removeridioma", deleteLanguage)

