local currentStage = 1
local FINAL_STAGE = 13
local TUTORIAL_STAGES = {
    [1] = {"Bem Vindo", "Olá e bem-vindo ao Southeast Roleplay! \n\nVocê passou com sucesso o estágio de aplicação e está em sua jornada para começar a interpretar aqui. Para ajudá-lo a começar, criamos este tutorial, aproveite!", 1271.6337890625, -2037.69140625, 81.409843444824, 1125.6396484375, -2036.96484375, 69.880661010742},
    [2] = {"Propriedades", "Los Santos oferece uma variedade de propriedades que você pode comprar, incluindo locais comerciais e residenciais, como lojas, garagens, empresas e casas. Novos personagens recebem um token de propriedade que permite a você comprar uma casa com um valor de até $ 40.000, permitindo que você comece a interpretar imediatamente como se você já fosse um residente de Los Santos!\n\nAo comprar uma propriedade, você pode optar por usar um interior padrão fornecido ou pode carregar seu próprio interior mapeado personalizado, adquirido com GameCoins através de nosso Painel de Controle do Usuário.", 2092.314453125, -1220.6669921875, 35.311351776123, 2108.9404296875, -1240.2802734375, 27.001424789429},
    [3] = {"Veículos", "Há uma grande variedade de veículos sempre disponíveis nas lojas (não incluindo veículos vendidos pelo jogador): \n\n - Ocean Docks Car Shop (Veículos padrão) \n - Ocean Docks Truck/Industrial Shop (Veículos Industriais) \n - Jefferson Car Shop (Carros Padrões) \n - Santa Maria Beach Boat Shop (Barcos) \n - Grotti's Car Shop (Veículos Esportivos) \n - Idlewood Bike Shop (Motos) \n\nNovos personagens são fornecidos com um token de veículo, assim como tokens de propriedade, esses tokens permitem que você compre um veículo imediatamente sem ter que trabalhar. Eles têm um valor de até $ 35.000. Não se esqueça de usar /estacionar em seu veículo! Se ocorrer um respawn de veículo e você não o estacionar, ele será excluído.", 2111.3681640625, -2116.8876953125, 21.02206993103, 2128.1513671875, -2138.896484375, 15.001725196838},
    [4] = {"DMV", "Aqui no Departamento de Veículos Motorizados (também conhecido como DMV) você pode fazer muitas coisas. A principal razão pela qual você viria aqui é para adquirir uma carteira de motorista, mas você sempre pode adquirir muitos tipos diferentes de licenças aqui e até mesmo registrar/cancelar o registro de seus veículos. \n\nNo DMV, você também pode comprar papéis de transação no DMV, que permitem que você venda seu veículo a outro jogador dentro do estacionamento do DMV. (Você não pode vender seu veículo adquirido com Token).", 1061.421875, -1752.6943359375, 25.57329750061, 1105.625, -1792.9228515625, 17.421173095703},
    [5] = {"Banco", "Aqui está o Banco Los Santos. No banco, você pode sacar, depositar e transferir dinheiro entre outros jogadores e facções. O banco também é o local onde você pode solicitar cartões para caixas eletrônicos.", 626.2001953125, -1207.552734375, 35.195793151855, 600.30859375, -1239.025390625, 20.625173568726},
    [6] = {"ATMS", "Em torno de Los Santos, você notará muitos caixas eletrônicos.\n\nEles podem ser utilizados arrastando o cartão que você solicitou no banco para a própria máquina. Dependendo do cartão que você comprou no Banco, você poderá sacar uma certa quantia em um caixa eletrônico.\n\nOferecemos três tipos de cartões ATM, são eles: \n - Cartão ATM Básico ($0 -> $10,000) \n - Cartão ATM Premium ($0 -> $50,000) \n - Cartão ATM Black (Ilimitado)\n\nCada cartão ATM tem seu próprio custo, você pode ver os custos no NPC do Banco.", 1106.2578125, -1792.5869140625, 19.298328399658, 1110.90625, -1790.431640625, 16.59375},
    [7] = {"Prefeitura", "Aqui no County Hall, há uma variedade de empregos que você pode escolher, esses empregos são projetados para ajudá-lo a se levantar financeiramente. Eles incluem:\n- Manutenção da cidade\n- Condução de ônibus\n- Taxista\n- Motorista de entrega\n\nOutro trabalho inicial que você não pode se inscrever na Prefeitura é a pesca. Para começar a pescar, você precisa comprar uma vara de pescar em uma loja geral, um barco na loja de barcos e depois ir para o mar! Os jogadores que procuram o trabalho mecânico devem se reportar a um administrador para defini-lo para eles e deve ter um motivo RP para adquirir esse trabalho.", 1526.1279296875, -1712.4970703125, 25.736494064331, 1497.982421875, -1738.583984375, 18.620281219482},
    [8] = {"Taxista & Motorista de ônibus", "Aqui está o depósito de táxis e ônibus. \n\nVocê poderá encontrar táxis e ônibus prontos para você pegar (Você precisa do trabalho antes de dirigir o (s) veículo (s) e transportar os cidadãos de Los Santos!). Lembre-se de que esses veículos devem ser usados para fins de trabalho e não para transporte pessoal.", 1823.2099609375, -1912.7138671875, 30.250659942627, 1789.2900390625, -1910.4990234375, 19.221006393433},
    [9] = {"RSHaul", "Aqui está RSHaul \n\nNo RSHaul existem 5 níveis de progressão, começando com as pequenas vans e avançando até os grandes caminhões de transporte comercial. Como motorista RSHaul, você tem a tarefa de fazer entregas em locais decididos pela empresa de transporte, dependendo de cada trabalho, você receberá uma determinada quantia. Essas entregas são feitas para locais pré-programados e lojas de jogadores, portanto, sua entrega ajuda a estocar as lojas e fazer a diferença na economia do servidor.", -104.125, -1119.65234375, 2.7560873031616, -79.01953125, -1117.978515625, 1.078125},
    [10] = {"Pesca", "Você quer ser o próximo Ray Scott? \n\nPara pescar, tudo o que você precisa é de uma vara e um barco e, em seguida, vá para a baía! Você pode começar a pescar assim que tiver os itens com /pescar. Depois de alguns momentos, você verá que pescou um peixe. Depois de enrolar o peixe, você receberá o item de peixe que você poderá vender mais tarde para o Pescador John, que está localizado perto da loja de iscas em Los Santos, no cais.", 163.1201171875, -1903.20703125, 19.174238204956, 134.77734375, -1962.0517578125, 15.005571365356},
    [11] = {"Facções Legais", "Depois de ganhar um pouco de dinheiro inicial com um de nossos muitos trabalhos planejados, você pode querer começar a pensar em ingressar em uma facção legal.\n\nVocê normalmente pode encontrar recrutamento para facções legais em nosso Discord.", 1513.9677734375, -1674.328125, 33.480712890625, 1552.08203125, -1675.1279296875, 17.445131301882},
    [12] = {"Facções Ilegais", "Você gostaria de ganhar algum dinheiro, mas não quer fazê-lo por meios legais?\n\nNesse caso, você pode estar interessado em ingressar em uma facção ilegal. As facções ilegais são responsáveis por abastecer as ruas com contrabando. Cada facção fornece diferentes tipos de contrabando. Algumas facções ilegais interpretam nas ruas e algumas facções interpretam nos bastidores, dependendo de como você desenvolve seu personagem, você tem uma escolha de que tipo de facção ilegal você pode entrar.", 2180.5078125, -1647.9208984375, 29.288076400757, 2140.115234375, -1625.4150390625, 15.865843772888},
    [13] = {"Nota Final", "Interpretar papéis com facções é tão infinito quanto sua imaginação, explorando o servidor e conhecendo novas pessoas. Você encontrará muitos cenários interessantes, tanto legais quanto ilegais.", 1981.0166015625, -1349.6162109375, 61.649375915527, 1925.7919921875, -1400.3291015625, 34.439781188965}
}

function runTutorial()
    tutorialWindow = guiCreateWindow(0.78, 0.63, 0.21, 0.35, "", true)
    guiWindowSetMovable(tutorialWindow, false)
    guiWindowSetSizable(tutorialWindow, false)
    showCursor(true)
    fadeCamera(true, 2.5)

    tutorialLabel = guiCreateLabel(0.02, 0.08, 0.95, 0.77, "", true, tutorialWindow)
    guiSetFont(tutorialLabel, "clear-normal")
    guiLabelSetHorizontalAlign(tutorialLabel, "left", true)

    backButton = guiCreateButton(0.02, 0.87, 0.45, 0.10, "Voltar", true, tutorialWindow)
    nextButton = guiCreateButton(0.52, 0.87, 0.45, 0.10, "Proximo", true, tutorialWindow)

    setStage(1)
    addEventHandler("onClientGUIClick", tutorialWindow, buttonFunctionality)
end
addEvent("tutorial:run", true)
addEventHandler("tutorial:run", root, runTutorial)

function setStage(stage)
    if (stage > FINAL_STAGE) then 
        currentStage = -1
        fadeCamera(false)
        guiSetText(tutorialWindow, "Southeast Roleplay - Tutorial Finalizado")
        guiSetText(tutorialLabel, "Você concluiu o tutorial, o que gostaria de fazer a seguir?")
        guiSetText(nextButton, "Terminar Tutorial")
    else
        guiSetText(tutorialWindow, "Southeast Roleplay Tutorial - " .. TUTORIAL_STAGES[stage][1])
        guiSetText(tutorialLabel, TUTORIAL_STAGES[stage][2])
        setCameraMatrix(TUTORIAL_STAGES[stage][3], TUTORIAL_STAGES[stage][4], TUTORIAL_STAGES[stage][5], TUTORIAL_STAGES[stage][6], TUTORIAL_STAGES[stage][7], TUTORIAL_STAGES[stage][8], 0, 90)
        
        if not guiGetVisible(tutorialWindow) then 
            guiSetVisible(tutorialWindow, true)
        end
    end
end

function buttonFunctionality(button, state)
    if (button == "left") and (source == backButton) then 
        if (currentStage == 1) then 
            return
        elseif (currentStage == -1) then 
            currentStage = FINAL_STAGE
            fadeClientScreen()
            guiSetText(nextButton, "Proximo")
            setTimer(setStage, 1000, 1, currentStage)
        else
            currentStage = currentStage - 1
            fadeClientScreen()
            setTimer(setStage, 1000, 1, currentStage)
        end            
    elseif (button == "left") and (source == nextButton) then 
        if (currentStage == -1) then 
            removeEventHandler("onClientGUIClick", tutorialWindow, buttonFunctionality)
            destroyElement(tutorialWindow)   
            triggerServerEvent("accounts:tutorialFinished", resourceRoot)
        else
            currentStage = currentStage + 1
            fadeClientScreen()
            setTimer(setStage, 1000, 1, currentStage)
        end
    end
end

function fadeClientScreen()
    fadeCamera(false)
    setTimer(function()
        fadeCamera(true, 2.5)
    end, 1000, 1)
end
