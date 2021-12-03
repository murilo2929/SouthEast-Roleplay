-- @author:Hanz
self = {
    tab = {},
    staticimage = {},
    tabpanel = {},
    label = {},
    button = {},
    window = {},
    gridlist = {}
}
addEvent("mechanic:gui", true)
addEventHandler("mechanic:gui", root,
    function()
        self.window[1] = guiCreateWindow(578, 351, 767, 409, "Interface Mecânico © v1", false)
        guiWindowSetSizable(self.window[1], false)

        self.tabpanel[1] = guiCreateTabPanel(9, 25, 748, 374, false, self.window[1])

        self.tab[1] = guiCreateTab("Interfaces", self.tabpanel[1])

        close = guiCreateButton(10, 316, 728, 24, "Fechar", false, self.tab[1])
        self.tabpanel[2] = guiCreateTabPanel(20, 15, 695, 287, false, self.tab[1])

        self.tab[2] = guiCreateTab("Rodas", self.tabpanel[2])

        jantpanel = guiCreateButton(23, 213, 650, 40, "Rodas", false, self.tab[2])
        --self.label[1] = guiCreateLabel(216, 179, 255, 19, "Agora você poderá instalar rodas no veículo com mais facilidade. ", false, self.tab[2])
        self.staticimage[1] = guiCreateStaticImage(276, 33, 136, 136, "wheel/main/main.png", false, self.tab[2])

        self.tab[3] = guiCreateTab("Spoiler", self.tabpanel[2])

        spoilerpanel = guiCreateButton(23, 213, 650, 40, "Spoiler", false, self.tab[3])
        --self.label[1] = guiCreateLabel(216, 179, 255, 19, "Agora você pode instalar spoilers de veículos com mais facilidade. ", false, self.tab[3])
        self.staticimage[1] = guiCreateStaticImage(276, 33, 136, 136, "spoiler/main/main.png", false, self.tab[3])
		
        --self.tab[4] = guiCreateTab("Buzina", self.tabpanel[2])
		
        --kornapanel = guiCreateButton(23, 213, 650, 40, "Buzina", false, self.tab[4])
        --self.label[4] = guiCreateLabel(216, 179, 255, 19, "Agora você poderá instalar buzinas de veículos com mais facilidade. ", false, self.tab[4])
        --self.staticimage[1] = guiCreateStaticImage(276, 33, 136, 136, "korna/main/main.png", false, self.tab[4])
		
        --[[self.tab[5] = guiCreateTab("Características adicionais", self.tabpanel[2])

        self.label[2] = guiCreateLabel(271, 114, 155, 15, "Esta interface está em construção.", false, self.tab[5])
        self.label[3] = guiCreateLabel(316, 129, 58, 16, "© v1", false, self.tab[5])]]



        self.tab[6] = guiCreateTab("", self.tabpanel[1])

        close2 = guiCreateButton(10, 317, 728, 23, "Fechar", false, self.tab[6])
        --[[self.gridlist[1] = guiCreateGridList(18, 20, 710, 287, false, self.tab[6])
        guiGridListAddColumn(self.gridlist[1], "Ajuda", 0.9)
        for i = 1, 14 do
            guiGridListAddRow(self.gridlist[1])
        end
        guiGridListSetItemText(self.gridlist[1], 0, 1, "Bem-vindo à interface de ajuda do mecânico, vamos fornecer algumas informações imediatamente.", false, false)
        guiGridListSetItemText(self.gridlist[1], 1, 1, "Se você é mecânico e tem uma loja, pode acessar esta interface.", false, false)
        guiGridListSetItemText(self.gridlist[1], 2, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 3, 1, "O que esta interface faz??", false, false)
        guiGridListSetItemColor(self.gridlist[1], 3, 1, 254, 18, 0, 255)
        guiGridListSetItemText(self.gridlist[1], 4, 1, "Graças a esta interface, você pode realizar suas operações mecânicas e de reparo com muito mais rapidez e de acordo com as regras.", false, false)
        guiGridListSetItemColor(self.gridlist[1], 4, 1, 108, 249, 4, 255)
        guiGridListSetItemText(self.gridlist[1], 5, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 6, 1, "Quero largar o emprego de mecânico e entregá-lo ao meu amigo. Como eu posso fazer isso?", false, false)
        guiGridListSetItemColor(self.gridlist[1], 6, 1, 249, 3, 3, 255)
        guiGridListSetItemText(self.gridlist[1], 7, 1, "Se você deseja transferir ou vender seu mecânico para um amigo, você pode transferi-lo como /Mechanicaltransfer <Nome do personagem ou ID>.", false, false)
        guiGridListSetItemColor(self.gridlist[1], 7, 1, 108, 249, 4, 255)
        guiGridListSetItemText(self.gridlist[1], 8, 1, "Você pode transferi-lo de forma muito simples..", false, false)
        guiGridListSetItemColor(self.gridlist[1], 8, 1, 108, 249, 4, 255)
        guiGridListSetItemText(self.gridlist[1], 9, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 10, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 11, 1, "", false, false)
        guiGridListSetItemText(self.gridlist[1], 12, 1, "Você teve a ajuda de que precisava. Se você tiver quaisquer problemas, você pode pedir ajuda enviando um report.", false, false)
        guiGridListSetItemText(self.gridlist[1], 13, 1, "Roleplay - Scripting Team", false, false)]]    
    end
)

addEventHandler("onClientGUIClick", root,
	function(b)
		if (b == "left") then
			if (source == close) or (source == close2)  then
				destroyElement(self.window[1])
				
			elseif (source == jantpanel) then
				if localPlayer:getData("job") == 5 then 
					destroyElement(self.window[1])
					triggerEvent("jant:gui", localPlayer)
				else
					outputChatBox("[-]#f9f9f9 Você não tem permissão para acessar esta interface.", 255, 0, 0, true)
				end
			elseif (source == spoilerpanel) then
				if localPlayer:getData("job") == 5 then 
					destroyElement(self.window[1])
					triggerEvent("spoiler:gui", localPlayer)
				else
					outputChatBox("[-]#f9f9f9 Você não tem permissão para acessar esta interface.", 255, 0, 0, true)
				end
			elseif (source == kornapanel) then
				if localPlayer:getData("job") == 5 then 
					destroyElement(self.window[1])
					triggerEvent("korna:gui", localPlayer)
				else
					outputChatBox("[-]#f9f9f9 Você não tem permissão para acessar esta interface.", 255, 0, 0, true)
				end				
			end
		end
	end
)
