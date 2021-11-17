--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

donationPerks = {
			[1] = { "Ativ/Des mensagem privada", 																					50, 		0 },
			[2] = { "Ativ/Des anuncios", 																							50, 		0 },
			[3] = { "Ativ/Des novos alertas", 																						50, 		0 },
			[4] = { "+ $25 por payday", 																						50, 		7 },
			[5] = { "+ $75 por payday",																						100, 		7 },
			[6] = { "Sem contas de telefone", 																						50, 		0 },
			[7] = { "Gasolina gratis", 																								100, 		7 },
			[8] = { "Cartão de desconto - 20% off em lojas regulares",																50, 		0 },
			[9] = { "Skin (Custom) (+1 slot de fabricação extra)", 																50, 		1 },
			[10] = { "Ativ/Des canal de doador (/don)", 																			50, 		0 },
			[11] = { "Ativ/Des nametag dourada", 																					50, 		0 },
			[12] = { "Ativ/Des status oculto do placar", 																			150, 		0 },
			[13] = { "Transferência de Game Coins", 																				35, 	1 },
			[14] = { "Aumentar slots interiores", 																			    	100, 		1 },
			[15] = { "Aumentar slots de veículos", 																				    100,		1},
			[16] = { "Name Change", 																		250, 		1 },
			[17] = { "Um par de fechaduras digitais sem chave para um interior",													400,		0 },
			[18] = { "Telefone com número personalizado (min 6 digitos, deve conter 2 dígitos diferentes)",							500,		1},
			[19] = { "Telefone com número personalizado (min 5 digitos, nenhuma restrição de dígitos diferentes)",					2500,		1},
			[20] = { "Transferência de ativos de um personagem para outro",															750,		0},
			[21] = { "Interior personalizado",																						500,		0},
			[22] = { "Carteira de motorista instantânea e licença de pesca",														50,		0},
			[23] = { "Placa do veículo personalizada",																				100,		1},
			[24] = { "Tela de seleção de personagem única (Grove St)",																750,		1},
			[25] = { "Tela de seleção de personagem única (Star Tower)",															1000,		1},
			[26] = { "Tela de seleção de personagem única (Mount Chiliad)",															1250,		1},
			[27] = { "Abra automaticamente qualquer pedágio a 40 metros de distância",									150,		7},
			[28] = { "Nova estação de rádio que é transmitida globalmente em todos os rádios de carros e ghettoblasters",			500,		0},
			[29] = { "Customized country flags typing icon",																		150,		0},
			[30] = { "Cartão ATM - Premium, pode ser usado para fazer transações com um valor justo por dia. (($50,000 a cada 5 horas))",	300,		0},
			[31] = { "Cartão ATM - Ultimate, pode ser usado para fazer transações com quantia ilimitada por dia.",					1500,		0},
			[32] = { "15 horas jogadas instantaneamente",																			250,		0},
			[33] = { "Número privado do celular",																					50,			-1},
			[34] = { "Aprenda o idioma instantaneamente",																			150,		0},
			[35] = { "Número de série adicional na lista de permissões",															150,		0},
			[36] = { "Proteção de inatividade interior",																			15,		7},
			[37] = { "Mensagem privada offline",																					3,		-1},
			[38] = { "Proteção de inatividade do veículo",																			15,		7},
			[39] = { "Sem impostos (veículos)",																					300,	-1},
			[40] = { "Sem impostos (interiores)",																				200,	-1},
			[41] = { "Aluguel de interiores grátis",																				400,	0},
			[42] = { "Espaço de personagem extra",																					15,		1},
			[43] = { "Fabricação Skin (Custom) instantânea",																				50,		1},
			[44] = { "Skin MP7",																					1500,		0},

--					Title																											Points	Time
}

function getPerks(perkId)
	if not perkId or not tonumber(perkId) or not donationPerks[tonumber(perkId)] then
		return donationPerks
	else
		return donationPerks[tonumber(perkId)]
	end
end
