myWindow = nil
pressed = false

function bindKeys()
	bindKey("F1", "down", F1RPhelp)
end
addEventHandler("onClientResourceStart", getRootElement(), bindKeys)

function resetState()
	pressed = false
end

function F1RPhelp( key, keyState )
	if not (pressed) then
		pressed = true
		setTimer(resetState, 200, 1)
		if ( myWindow == nil ) then		
			local xmlExplained = xmlLoadFile( "whatisroleplaying.xml" )
			local xmlOverview = xmlLoadFile( "overview.xml" )
			
			myWindow = guiCreateWindow ( 0.3, 0.3, 0.7, 0.7, "Southeast Roleplay - F1 Ajuda", true )
			guiWindowSetSizable(myWindow, false)
			local tabPanel = guiCreateTabPanel ( 0, 0.1, 1, 1, true, myWindow )
			
			local tabRules = guiCreateTab( "Regras", tabPanel )
			local memoRules = guiCreateMemo ( 0, 0.1, 1, 1, getElementData(getResourceRootElement(getResourceFromName("account-system")), "rules:text") or "Error Fetching Rules!", true, tabRules )
			guiMemoSetReadOnly(memoRules, true)
			
			local tabExplained = guiCreateTab( "Roleplay explicado", tabPanel )
			local memoExplained = guiCreateMemo ( 0, 0.1, 1, 1, xmlNodeGetValue( xmlExplained ), true, tabExplained )
			guiMemoSetReadOnly(memoExplained, true)
			
			local tabOverview = guiCreateTab( "Visão Geral Roleplay", tabPanel )
			local memoOverview = guiCreateMemo ( 0, 0.1, 1, 1, xmlNodeGetValue( xmlOverview ), true, tabOverview )
			guiMemoSetReadOnly(memoOverview, true)
			
			showCursor( true )
		else
			destroyElement(myWindow)
			myWindow = nil
			showCursor(false)
		end
	end
end