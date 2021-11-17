--[[
 * ***********************************************************************************************************************
 * Copyright (c) 2015 OwlGaming Community - All Rights Reserved
 * All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ***********************************************************************************************************************
 ]]

--- clothe shop skins
blackMales = {293, 300, 284, 278, 274, 265, 19, 310, 311, 301, 302, 296, 297, 269, 270, 271, 7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 51, 66, 67, 79,
80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {126, 268, 288, 287, 286, 285, 283, 282, 281, 280, 279, 277, 276, 275, 267, 266, 239, 167, 71, 305, 306, 307, 308, 309, 312, 303, 299, 291, 292, 294, 295, 1, 2, 23, 26,
27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110,
111, 112, 113, 114, 115, 116, 120, 121, 124, 125, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177,
179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272 }
asianMales = {290, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294}
blackFemales = {--[[245, ]]9, 304, 298, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 256, 304 } -- 245 = Santa, so disabled.
whiteFemales = {91, 191, 12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 87, 88, 89, 90, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194,
196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}
-- Removed 9 as a black female
-- these are all the skins
disabledUpgrades = {
	[1142] = true,
	[1109] = true,
	[1008] = true,
	[1009] = true,
	[1010] = true,
	[1158] = true,
}

local restricted_skins = {
	[71] = true,
	[265] = true,
	[266] = true,
	[267] = true,
	[274] = true,
	[275] = true,
	[276] = true,
	[277] = true,
	[278] = true,
	[279] = true,
	[275] = true,
	[280] = true,
	[281] = true,
	[282] = true,
	[283] = true,
	[284] = true,
	[285] = true,
	[286] = true,
	[287] = true,
	[288] = true,
	[300] = true,
 }
 
bandanas = { [122] = true, [123] = true, [124] = true, [136] = true, [168] = true, [125] = true, [158] = true, [135] = true, [237] = true, [238] = true, [239] = true }

function getRestrictedSkins()
	return restricted_skins
end

function getDisabledUpgrades()
	return disabledUpgrades
end
skins = { 1, 2, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 263, 264 }
local wheelPrice = 2500
local priceReduce = 1

-- g_shops[1][1][1]['name'] == "Flowers"

g_shops = {
	{ -- 1
		name = "Armazém Geral",
		description = "Esta loja vende todos os tipos de itens de uso geral.",
		image = "general.png",

		{
			name = "Itens Gerais",
			--{ name = "Lottery Ticket", description = "A ticket that can make you or break you.", price = 75, itemID = 68, itemValue = nil, minimum_age = 18 },
			--{ name = "Flores", description = "Um buquê de lindas flores.", price = 5, itemID = 115, itemValue = 14 },
			{ name = "Lista Telefônica", description = "Uma grande agenda de números contendo o telefone de todos.", price = 30, itemID = 7 },
			{ name = "Dado", description = "Um dado branco de seis lados com pontos pretos, perfeito para jogos de azar.", price = 2, itemID = 10, itemValue = 1 },
			{ name = "Dados de 20 faces", description = "Um dado branco de vinte lados com pontos pretos, para a sensação de Dungeons & Dragons.", price = 5, itemID = 10, itemValue = 20 },
			--{ name = "Taco de Golfe", description = "Taco de golfe perfeito para acertar aquele buraco em um.", price = 60, itemID = 115, itemValue = 2 },
			{ name = "Bastão de Baseball", description = "Faça um home run com isso.", price = 110, itemID = 115, itemValue = 5 },
			--{ name = "Pá", description = "Ferramenta perfeita para cavar um buraco.", price = 40, itemID = 115, itemValue = 6 },
			--{ name = "Taco de Sinuca", description = "Para aquele jogo de bilhar de pub.", price = 35, itemID = 115, itemValue = 7 },
			--{ name = "Bengala", description = "Uma vara nunca foi tão elegante.", price = 65, itemID = 115, itemValue = 15 },
			--{ name = "Extintor de Incêndio", description = "Nunca se sabe quando precisa de um.", price = 50, itemID = 115, itemValue = 42 },
			{ name = "Lata de Spray", description = "Não faça arte na rua.", price = 50, itemID = 115, itemValue = 41 },
			--{ name = "Paraquedas", description = "Se você não quer respingar no chão, é melhor comprar um", price = 400, itemID = 115, itemValue = 46 },
			--{ name = "City Guide", description = "A small city guide booklet.", price = 15, itemID = 18 },
			{ name = "Mochila", description = "Uma mochila de tamanho razoável.", price = 150, itemID = 48 },
			{ name = "Vara de Pesca", description = "Uma vara de pesca de aço carbono de 7 pés.", price = 300, itemID = 49 },
			{ name = "Mascara", description = "Uma mascara de esqui.", price = 50, itemID = 56 },
			{ name = "Lata de Combustível", description = "Uma pequena lata de combustível de metal.", price = 35, itemID = 57, itemValue = 0 },
			{ name = "Kit de Primeiros Socorros", description = "Um pequeno kit de primeiros socorros", price = 80, itemID = 70, itemValue = 3 },
			{ name = "Seda", description = "Papéis para enrolar seus cigarros.", price = 10, itemID = 181, itemValue = 20 },
			--[[
			{ name = "Mini Notebook", description = "An empty Notebook, enough to write 5 notes.", price = 10, itemID = 71, itemValue = 5 },
			{ name = "Notebook", description = "An empty Notebook, enough to write 50 notes.", price = 15, itemID = 71, itemValue = 50 },
			{ name = "XXL Notebook", description = "An empty Notebook, enough to write 125 notes.", price = 20, itemID = 71, itemValue = 125 },
			]]
			{ name = "Capacete", description = "Um capacete comumente usado por pessoas que andam de bicicleta.", price = 100, itemID = 90 },
			{ name = "Capacete de Motociclista", description = "Um capacete comumente usado por pessoas que andam de bicicleta.", price = 100, itemID = 171},
			{ name = "Capacete de motociclista (Fechado)", description = "Um capacete comumente usado por pessoas que andam de bicicleta.", price = 100, itemID = 172},
			{ name = "Maço de Cigarro", description = "Coisas que você pode fumar...", price = 10, itemID = 105, itemValue = 20, minimum_age = 18 },
			{ name = "Isqueiro", description = "Para iluminar seu vício.", price = 45, itemID = 107 },
			--{ name = "Faca", description = "Para te ajudar na cozinha.", price = 15, itemID = 115, itemValue = 4 },
			{ name = "Baralho de Cartas", description = "Quer jogar um jogo?", price = 10, itemID = 77 },
			--{ name = "Porta-Retratos", description = "Você pode usá-los para decorar seu interior!", price = 350, itemID = 147, itemValue = 1 },
			{ name = "Briefcase", description = "Pasta marrom.", price = 75, itemID = 160},
			{ name = "Duffle Bag", description = "Uma grande bolsa cilíndrica feita de tecido com um fecho de cordão na parte superior.", price = 60, itemID = 163},
			--{ name = "Blank Book", description = "A hardcover book with nothing written in it.", price = 40, itemID = 178, itemValue = "New Book"},
			{ name = "Cadeado de Bicicleta", description = "Uma trava de metal que permite travar sua bicicleta", price = 250, itemID = 275, itemValue = 1},
		},
		{
			name = "Utilitários",
			{ name = "Corda", description = "Uma corda resistente.", price = 30, itemID = 46 },
		},
		{
			name = "Consumível",
			{ name = "Sanduíche", description = "Sanduiche de queijo.", price = 8, itemID = 8 },
			{ name = "Refrigerante", description = "Sprunk.", price = 10, itemID = 9 },
		},
	},
	{ -- 2
		name = "Loja de Amas e Munições",
		description = "Tudo o que sua arma necessita desde 1914.",
		image = "gun.png",

		{
			name = "Guns and Ammo",
			{ name = "Glock", description = "Uma Glock preta.", price = 850, itemID = 115, itemValue = 22, license = true },
			{ name = "Desert Eagle", description = "Uma brilhante Desert Eagle.", price = 1200, itemID = 115, itemValue = 24, license = true },
			{ name = "Shotgun", description = "Uma espingarda de prata.", price = 1049, itemID = 115, itemValue = 25, license = true },
			{ name = "Country Rifle", description = "Um rifle country.", price = 1599, itemID = 115, itemValue = 33, license = true },
			{ name = "Munição 9mm", description = "Cartucho: 9mm, Compatível com Glock, Silenced, Uzi, MP5, Tec-9. Estilo de Munição: Expansão da ponta flexível (FTX), Peso da bala: 7,45 gramas, Aplicação: Autodefesa.Expansão da ponta flexível (FTX), Peso da bala: 7,45 gramas, Aplicação: Autodefesa.", price = 100, itemID = 116, itemValue = 1, ammo = 25, license = true },
			{ name = "Munição .45 ACP", description = "Cartucho: .45 ACP, Compatível com Deagle. Estilo de Munição: Full Metal Jacket (FMJ), Caixa de Metal (MC), Peso da bala: 11,99 gramas, Aplicação: Alvo, Competição, Treinamento.", price = 110, itemID = 116, itemValue = 4, ammo = 20, license = true },
			{ name = "Munição Calibre 12", description = "Cartucho: 12 Gauge, Compatível com Shotgun, Sawed-off, Combat Shotgun. Estilo de Munição: Estilo de fábrica, Peso da bala: 31,89 gramas, Aplicação: Alvo, Caça.", price = 90, itemID = 116, itemValue = 5, ammo = 20, license = true },
			{ name = "Munição 7.62mm", description = "Cartucho: 7.62mm, Compatível com AK-47, Rifle, Sniper, Minigun. Estilo de Munição: Full Metal Jacket (FMJ), Peso da bala: 9,66 gramas, Aplicação: Prática, Alvo, Treinamento.", price = 150, itemID = 116, itemValue = 2, ammo = 30, license = true },
			{ name = "Munição 5.56mm", description = "Cartucho: 5.56mm, Compatível com M4. Estilo de Munição: Full Metal Jacket (FMJ), Peso da bala: 4,02 gramas, Aplicação: Polícia, Plinking.", price = 150, itemID = 116, itemValue = 3, ammo = 30, license = true },
		}
	},
	{ -- 3
		name = "Loja de Comida",
		description = "As comidas e bebidas menos envenenada do planeta.",
		image = "food.png",

		{
			name = "Food",
			{ name = "Sanduíche", description = "Sanduiche de queijo", price = 5, itemID = 8 },
			{ name = "Taco", description = "Um taco mexicano gorduroso", price = 7, itemID = 11 },
			{ name = "Burger", description = "Um cheeseburger duplo com bacon", price = 50, itemID = 12 },
			{ name = "Donut", description = "Rosquinha quente com cobertura de açúcar pegajoso", price = 3, itemID = 13 },
			{ name = "Cookie", description = "Um cookie de chocolate", price = 3, itemID = 14 },
			{ name = "Hotdog", description = "Hotdog bem quentinho!", price = 5, itemID = 1 },
			{ name = "Panqueca", description = "Panqueca com mel!!", price = 2, itemID = 108 },
		},
		{
			name = "Bebida",
			{ name = "Refrigerante", description = "Sprunk.", price = 8, itemID = 9 },
			{ name = "Agua", description = "Agua mineral.", price = 70, itemID = 15 },
		}
	},
	{ -- 4
		name = "Sex Shop",
		description = "Todos os itens que você precisa para uma noite perfeita.",
		image = "sex.png",

		{
			name = "Sexy",
			{ name = "Dildo Longo Roxo", description = "Um grande dildo roxo", price = 20, itemID = 115, itemValue = 10 },
			{ name = "Short Tan Dildo", description = "Um pequeno vibrador bronzeado.", price = 15, itemID = 115, itemValue = 11 },
			{ name = "Vibrador", description = "Um vibrador, o que mais precisa ser dito?", price = 25, itemID = 115, itemValue = 12 },
			{ name = "Flores", description = "Um buquê de lindas flores.", price = 5, itemID = 115, itemValue = 14 },
			{ name = "Algemas", description = "Um par de algemas de metal.", price = 90, itemID = 45 },
			{ name = "Venda", description = "Uma venda preta.", price = 15, itemID = 66 },
		},
		{
			name = "Roupas",
			{ name = "Roupas 87", description = "Roupas sensuais para pessoas sensuais.", price = 55, itemID = 16, itemValue = 87 },
			{ name = "Roupas 178", description = "Roupas sensuais para pessoas sensuais.", price = 55, itemID = 16, itemValue = 178 },
			{ name = "Roupas 244", description = "Roupas sensuais para pessoas sensuais.", price = 55, itemID = 16, itemValue = 244 },
			{ name = "Roupas 246", description = "Roupas sensuais para pessoas sensuais.", price = 55, itemID = 16, itemValue = 246 },
			{ name = "Roupas 257", description = "Roupas sensuais para pessoas sensuais.", price = 55, itemID = 16, itemValue = 257 },
		}
	},
	{ -- 5
		name = "Loja de Roupas",
		description = "Você não parece gordo nesses!",
		image = "clothes.png",
		-- Items to be generated elsewhere.
		{
			name = "Roupas que cabem em você"
		},
		{
			name = "Outros"
		},
	},
	{ -- 6
		name = "Academia",
		description = "O melhor lugar para aprender sobre combate corpo a corpo.",
		image = "general.png",

		{
			name = "Estilos de Luta",
			{ name = "Combate Padrão para Leigos", description = "Luta diária padrão.", price = 10, itemID = 20 },
			{ name = "Boxing para Leigos", description = "Mike Tyson, nas drogas.", price = 50, itemID = 21 },
			{ name = "Kung Fu para Leigos", description = "Eu sei kung-fu, você também pode.", price = 50, itemID = 22 },
			-- item ID 23 is just a greek book, anyhow :o
			{ name = "Grab & Kick  para Leigos", description = "Chute a cabeça dele!", price = 50, itemID = 24 },
			{ name = "Elbows  para Leigos", description = "Você pode parecer retardado, mas vai chutar a bunda dele!", price = 50, itemID = 25 },
		}
	},
	{ -- 7
		name = "Rapid Auto Parts - Viozy",
		description = "Se não for da Viozy, é fraude. Todas as vendas publicadas foram reduzidas em 50% para membros exclusivos.",
		image = "viozy-auto.png",
		{
			name = "Aplicação Insulfilm",
			{ name = "HP Charcoal Window Film", description = "Viozy Window Films ((50 /chance))", price = 305 / priceReduce, itemID = 184, itemValue = "Viozy HP Charcoal Window Tint Film ((50 /chance))" },
			{ name = "CXP70 Window Film", description = "Viozy CXP70 Window Film ((95 /chance))", price = 490 / priceReduce, itemID = 185, itemValue = "Viozy CXP70 Window Film ((95 /chance))" },
			{ name = "Border Edge Cutter (Red Anodized)", description = "Cortador de bordas para tingimento", price = 180 / priceReduce, itemID = 186, itemValue = "Viozy Border Edge Cutter (Red Anodized)" },
			{ name = "Solar Spectrum Tranmission Meter", description = "Medidor de espectro para testar o filme antes do uso", price = 1000 / priceReduce, itemID = 187, itemValue = "Viozy Solar Spectrum Tranmission Meter" },
			{ name = "Tint Chek 2800", description = "Mede a transmissão de luz visível em qualquer filme/vidro", price = 280 / priceReduce, itemID = 188, itemValue = "Viozy Tint Chek 2800" },
			{ name = "Equalizer Heatwave Heat Gun", description = "Pistola de calor fácil de usar, perfeita para reduzir janelas traseiras", price = 530 / priceReduce, itemID = 189, itemValue = "Viozy Equalizer Heatwave Heat Gun" },
			{ name = "36 Multi-Purpose Cutter Bucket", description = "Ideal para trabalhos de corte leve ao aplicar tinta", price = 120 / priceReduce, itemID = 190, itemValue = "Viozy 36 Multi-Purpose Cutter Bucket" },
			{ name = "Tint Demonstration Lamp", description = "Apresentação eficaz da aplicação colorida", price = 150 / priceReduce, itemID = 191, itemValue = "Viozy Tint Demonstration Lamp" },
			{ name = "Triumph Angled Scraper", description = "Raspador angular de 6 polegadas para aplicação de tinta", price = 100 / priceReduce, itemID = 192, itemValue = "Viozy Triumph Angled Scraper" },
			{ name = "Performax 48oz Hand Sprayer", description = "Pulverizador manual Performax para aplicação de tinta", price = 200 / priceReduce, itemID = 193, itemValue = "Viozy Performax 48oz Hand Sprayer" },
			{ name = "Ammonia Bottle", description = "Uma garrafa de solução de amônia", price = 50 / priceReduce, itemID = 260, itemValue = "Garrafa de Amônia" },
		},

		{
			name = "Mecanica",
			{ name = "Ignição de Veículo - 2010 ((20 /chance))", description = "Ignição de Veículo feito por Viozy para 2010", price = 196 / priceReduce, itemID = 194, itemValue = "Viozy Ignição de Veículo - 2010 ((20 /chance))" },
			{ name = "Ignição de Veículo - 2011 ((30 /chance))", description = "Ignição de Veículo feito por Viozy para 2011", price = 254 / priceReduce, itemID = 195, itemValue = "Viozy Ignição de Veículo - 2011 ((30 /chance))" },
			{ name = "Ignição de Veículo - 2012 ((40 /chance))", description = "Ignição de Veículo feito por Viozy para 2012", price = 364 / priceReduce, itemID = 196, itemValue = "Viozy Ignição de Veículo - 2012 ((40 /chance))" },
			{ name = "Ignição de Veículo - 2013 ((50 /chance))", description = "Ignição de Veículo feito por Viozy para 2013", price = 546 / priceReduce, itemID = 197, itemValue = "Viozy Ignição de Veículo - 2013 ((50 /chance))" },
			{ name = "Ignição de Veículo - 2014 ((70 /chance))", description = "Ignição de Veículo feito por Viozy para 2014", price = 929 / priceReduce, itemID = 198, itemValue = "Viozy Ignição de Veículo - 2014 ((70 /chance))" },
			{ name = "Ignição de Veículo - 2015 ((90 /chance))", description = "Ignição de Veículo feito por Viozy para 2015", price = 1765 / priceReduce, itemID = 199, itemValue = "Viozy Ignição de Veículo - 2015 ((90 /chance))" },
			{ name = "HVT 358 Portable Spark Nano 4.0 ((50 /chance))", description = "GPS HVT 358 Spark Nano 4.0 portatil ((50 /chance de ser encontrado)), by Viozy", price = 345 / priceReduce, itemID = 205, itemValue = "Viozy HVT 358 Portable Spark Nano 4.0 ((50 /chance))" },
			{ name = "Rastreador de Veículos Ocultos 272 Micro ((30 /chance))", description = "GPS HVT 272 Micro, facil instalação ((30 /chance de ser encontrado)), by Viozy", price = 840 / priceReduce, itemID = 204, itemValue = "Viozy Rastreador de Veículos Ocultos 272 Micro ((30 /chance))" },
			{ name = "Rastreador de Veículos Ocultos 315 Pro ((Indetectavel))", description = "GPS HVT 315 Pro, facil instalação ((and undetectable)), by Viozy", price = 2229 / priceReduce, itemID = 203, itemValue = "Viozy Rastreador de Veículos Ocultos 315 Pro ((Undetectable))" },
		},
		{
			name = "Pneus com Desconto",
			{ name = "Access", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1098 },
			{ name = "Virtual", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1097 },
			{ name = "Ahab", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1096 },
			{ name = "Atomic", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1085 },
			{ name = "Trance", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1084 },
			{ name = "Dollar", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1083 },
			{ name = "Import", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1082 },
			{ name = "Grove", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1081 },
			{ name = "Switch", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1080 },
			{ name = "Cutter", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1079 },
			{ name = "Twist", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1078 },
			{ name = "Classic", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1077 },
			{ name = "Wires", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1076 },
			{ name = "Rimshine", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1075 },
			{ name = "Mega", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1074 },
			{ name = "Shadow", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1073 },
			{ name = "Offroad", description = "Pneus Usados", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1025 },

		}

	},
	{ -- 8
		name = "Loja de Eletrônicos",
		description = "A tecnologia mais recente, extremamente cara apenas para você.",
		image = "general.png",

		{
			name = "Eletrônicos",
			{ name = "Celular", description = "Um celular elegante e fino.", price = 800, itemID = 2 },
			{ name = "Lanterna", description = "Ilumina o ambiente.", price = 25, itemID = 145, itemValue = 100 },
			--{ name = "Ghettoblaster", description = "Um ghettoblaster preto.", price = 250, itemID = 54 },
			{ name = "Camera", description = "Uma pequena câmera analógica preta.", price = 75, itemID = 115, itemValue = 43 },
			--{ name = "Radio", description = "Um rádio preto.", price = 50, itemID = 6 },
			--{ name = "Fone de Ouvido", description = "Um fone de ouvido que pode ser usado com um rádio.", price = 25, itemID = 88 },
			{ name = "Relógio", description = "Contar as horas nunca foi tão sexy!", price = 25, itemID = 17 },
			--{ name = "MP3 Player", description = "Um MP3 Player branco.", price = 120, itemID = 19 },
			--{ name = "Kit de Química", description = "Um pequeno conjunto de química.", price = 2000, itemID = 44 },
			{ name = "Cofre", description = "Um cofre para armazenar seus itens.", price = 500, itemID = 223, itemValue = "Safe:2332:50" }, -- Model ID is the old safe and cap is 50kg
			--{ name = "GPS", description = "A GPS Satnav for a car.", price = 300, itemID = 67 },
			{ name = "GPS Portátil", description = "Dispositivo de posicionamento global pessoal, com mapas recentes.", price = 200, itemID = 111 },
			{ name = "Macbook pro A1286 Core i7", description = "Um Macbook topo de gama para ver e-mails e navegar na Internet.", price = 2200, itemID = 96 },
			--{ name = "Portable TV", description = "A portable TV to watch the TV.", price = 750, itemID = 104 },
			--{ name = "Pedagio Sem-Parar", description = "Para seu carro: cobra automaticamente ao passar por um portão de pedágio.", price = 400, itemID = 118 },
			{ name = "Sistema de Alarme de Veículo", description = "Proteja seu veículo com um alarme.", price = 1000, itemID = 130 },
			{ name = "Carregador de Bateria de Carro", description = "Pode carregar rapidamente quase todos os tipos de bateria e é uma ótima escolha para mecânicos domésticos e pequenas lojas.", price = 150, itemID = 232, itemValue = 1},
			--{ name = "Óculos de Visão Noturna", description = "Um sistema de visão noturna robusto, confiável e de alto desempenho.", price = 4499, itemID = 115, itemValue = 44 },
			--{ name = "Óculos infravermelhos", description = "Lightweight, rugged and a top notch performer and an exceptional choice for hands-free usage.", price = 7499, itemID = 115, itemValue = 45 },
		}
	},
	{ -- 9
		name = "Loja de Álcool",
		description = "Tudo, de Vodka a Cerveja e vice-versa",
		image = "general.png",

		{
			name = "Bebidas",
			{ name = "Cerveja Ziebrand", description = "A melhor cerveja, importada da Holanda.", price = 10, itemID = 58, minimum_age = 21 },
			{ name = "Vodka Bastradov", description = "Para seus melhores amigos - Bastradov Vodka.", price = 25, itemID = 62, minimum_age = 21 },
			{ name = "Whisky Escocês", description = "O Melhor Whisky Escocês, agora exclusivamente feito de Haggis.", price = 15, itemID = 63, minimum_age = 21 },
			{ name = "Refrigerante", description = "Uma lata fria de Sprunk.", price = 3, itemID = 9 },
		}
	},
	{ -- 10
		name = "Loja de Livro",
		description = "Coisas novas para aprender? Soa como... engraçado?!",
		image = "general.png",

		{
			name = "Livros",
			--{ name = "City Guide", description = "A small city guide booklet.", price = 15, itemID = 18 },
			--{ name = "Los Santos Highway Code", description = "A paperback book.", price = 10, itemID = 50 },
			{ name = "Quimica 101", description = "Um livro acadêmico de capa dura.", price = 20, itemID = 51 },
			--{ name = "Blank Book", description = "A hardcover book with nothing written in it.", price = 40, itemID = 178, itemValue = "New Book"},
		}
	},
	{ -- 11
		name = "Cafe",
		description = "Você quer um pouco de chocolate na sua borda?",
		image = "food.png",

		{
			name = "Comida",
			{ name = "Donut", description = "Rosquinha quente com cobertura de açúcar pegajoso", price = 3, itemID = 13 },
			{ name = "Cookie", description = "Cookie de chocolate", price = 3, itemID = 14 },
		},
		{
			name = "Bebida",
			{ name = "Café", description = "Uma pequena xícara de café.", price = 1, itemID = 83, itemValue = 2 },
			{ name = "Refrigerante", description = "Uma lata fria de Sprunk.", price = 3, itemID = 9, itemValue = 3 },
			{ name = "Agua", description = "Agua mineral.", price = 1, itemID = 15, itemValue = 2 },
		}
	},
	{ -- 12
		name = "Santa's Grotto",
		description = "Ho-ho-ho, Merry Christmas.",
		image = "general.png",

		{
			name = "Christmas Items",
			--{ name = "Christmas Present", description = "What could be inside?", price = 0, itemID = 94 },
			--{ name = "Eggnog", description = "Yum Yum!", price = 0, itemID = 91 },
			--{ name = "Turkey", description = "Yum Yum!", price = 0, itemID = 92 },
			--{ name = "Christmas Pudding", description = "Yum Yum!", price = 0, itemID = 93 },
		}
	},
	{ -- 13
		name = "Funcionário da Prisão",
		description = "Agora isso parece ... vagamente saboroso.",
		image = "general.png",

		{
			name  = "Coisas Nojentas",
			{ name = "Bandeja de Jantar Mista", description = "Vamos jogar o jogo de adivinhação.", price = 0, itemID = 99 },
			{ name = "Caixa de Leite Pequena", description = "Grumos incluídos!", price = 0, itemID = 100 },
			{ name = "Caixa de Suco Pequeno", description = "Sede?", price = 0, itemID = 101 },
		}
	},
	{ -- 14
		name = "One Stop Mod Shop",
		description = "Todas as peças que você realmente precisa!",
		image = "general.png",

		-- items to be filled in later
		{
			name = "Peças de Veículos"
		}
	},
	{ -- 15
		name = "NPC",
		description = "(( Este é apenas um NPC, não foi feito para conter nenhum item. ))",
		image = "general.png",

		{
			name = "Sem Itens"
		}
	},
	{ -- 16
		name = "Loja de Ferramentas",
		description = "Necessita de algumas ferramentas?!",
		image = "general.png",

		{
			name = "Power Tools",
			{ name = "Power Drill", description = "An electric battery operated drill.", price = 50, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Power Drill"} },
			{ name = "Power Saw", description = "An electric plug-in saw.", price = 65, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Power Saw"} },
			{ name = "Pneumatic Nail Gun", description = "A pneumatic-operated nail gun.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Pneumatic Nail Gun"} },
			{ name = "Pneumatic Paint Gun", description = "A pneumatic-operated nail gun.", price = 90, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Pneumatic Paint Gun"} },
			{ name = "Air Wrench", description = "A pneumatic-operated wrench.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Air Wrench"} },
			{ name = "Torch", description = "A mobile natural-gas operated torch set.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Mobile Torch Set"} },
			{ name = "Electric Welder", description = "A mobile plug-in electricity operated electric welder.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Mobile Electric Welder"} },
		},
		{
			name = "Hand Tools",
			{ name = "Hammer", description = "An iron hammer.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Iron Hammer"} },
			{ name = "Phillips Screwdriver", description = "A phillips screwdriver.", price = 5, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Phillips Screwdriver"} },
			{ name = "Flathead Screwdriver", description = "A flathead screwdriver.", price = 5, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Flathead Screwdriver"} },
			{ name = "Robinson Screwdriver", description = "A robinson screwdriver.", price = 6, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Robinson Screwdriver"} },
			{ name = "Torx Screwdriver", description = "A torx screwdriver.", price = 8, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Torx Screwdriver"} },
			{ name = "Needlenose Pliers", description = "Pliers.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Needlenose Pliers"} },
			{ name = "Crowbar", description = "A large iron crowbar.", price = 30, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Iron Crowbar"} },
			{ name = "Tire Iron", description = "A tire iron.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Tire Iron"} },
			{ name = "Wrench", description = "An adjustable wrench.", price = 7, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Wrench"} },
			{ name = "Monkey Wrench", description = "A large monkey wrench.", price = 12, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Monkey Wrench"} },
			{ name = "Socket Wrench", description = "A socket wrench.", price = 8, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Socket Wrench"} },
			{ name = "Torque Wrench", description = "A large torque wrench.", price = 35, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Torque Wrench"} },
			{ name = "Vise Grip", decsription = "A vise grip.", price = 12, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Vise Grip"} },
			{ name = "Wirecutters", decsription = "Used to cut wires.", price = 6, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Wirecutters"} },
			{ name = "Hack Saw", description = "A hack saw.", price = 40, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Hack Saw"} },
		},
		{
			name = "Screws & Nails",
			{ name = "Phillips Screws", description = "A box of phillips screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Phillips Screws (100)"} },
			{ name = "Flathead Screws", description = "A box of flathead screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Flathead Screws (100)"} },
			{ name = "Robinson Screws", description = "A box of robinson screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Robinson Screws (100)"} },
			{ name = "Torx Screws", description = "A box of torx screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Torx Screws (100)"} },
			{ name = "Iron Nails", description = "A box of iron nails.", price = 2, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Iron Nails (100)"} },
		},
		{
			name = "Misc.",
			{ name = "Bosch 6 Gallon Air Compressor", description = "A 6 gallon Bosch air compressor.", price = 300, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Bosch 6 Gallon Air Compressor"} },
			{ name = "Gloves", description = "A pair of wearable gloves.", price = 2, itemID = 270, itemValue = 1 },
			{ name = "Chlorex Bleach", description = "A bottle of Chlorex bleach.", price = 13, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Chlorex Bleach"} },
			{ name = "Paint Can", description = "A can of paint in your colour of choice.", price = 10, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Paint Can"} },
			{ name = "Toolbox", description = "A red metal toolbox.", price = 20, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Red Metal Toolbox"} },
			{ name = "Rubbermaid Plastic Trashcan", description = "A Rubbermaid plastic trashcan.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Rubbermaid Plastic Trashcan"} },
		}
	},
	{ -- 17
		name = "Loja Custom",
		description = " ",
		image = "general.png",
	},
	{ -- 18
		name = "Faction Drop NPC - Itens Gerais",
		description = " ",
		image = "general.png",
	},
	{ -- 19
		name = "Faction Drop NPC - Armas",
		description = " ",
		image = "general.png",
	},
}

-- some initial updating once you start the resource
function loadLanguages( )
	local shop = g_shops[ 10 ]
	for i = 1, exports['language-system']:getLanguageCount() do
		local ln = exports['language-system']:getLanguageName(i)
		if ln then
			table.insert( shop[1], { name = ln .. " Dictionary", description = "Um dicionário, útil para aprender" .. ln .. ".", price = 25, itemID = 69, itemValue = i } )
		end
	end
end

addEventHandler( "onResourceStart", resourceRoot, loadLanguages )
addEventHandler( "onClientResourceStart", resourceRoot, loadLanguages )

-- util

function getMetaItemName(item)
	local metaName = type(item.metadata) == 'table' and item.metadata.item_name or nil

	return metaName ~= nil and metaName or ''
end

function checkItemSupplies(shop_type, supplies, itemID, itemValue, itemMetaName)
	if supplies then
		-- regular items
		if (supplies[itemID .. ":" .. (itemValue or 1)] and supplies[itemID .. ":" .. (itemValue or 1)] > 0) then
			return true
		-- generics with meta name
		elseif (supplies[itemID .. ":" .. (itemValue or 1) .. ":" .. itemMetaName] and supplies[itemID .. ":" .. (itemValue or 1) .. ":" .. itemMetaName] > 0) then
			return true
		-- clothes
		elseif (itemID == 16 and supplies[tostring(itemID)] and supplies[tostring(itemID)] > 0) then
			return true
		-- bandanas
		elseif (bandanas[itemID] and supplies["122"] and supplies["122"] > 0) then
			return true
		-- car mods
		elseif (itemID == 114 and vehicle_upgrades[tonumber(itemValue)-999] and vehicle_upgrades[tonumber(itemValue)-999][3] and supplies["114:" .. vehicle_upgrades[tonumber(itemValue)-999][3]] and supplies["114:" .. vehicle_upgrades[tonumber(itemValue)-999][3]] > 0) then
			return true
		end
	end
	return false
end

function getItemFromIndex( shop_type, index, usingStocks, interior )
	local shop = g_shops[ shop_type ]
	if shop then
		if usingStocks and interior then
			local status = getElementData(interior, "status")
			local supplies = fromJSON(status.supplies)
			local govOwned = status.type == 2
			local counter = 1
			for _, category in ipairs(shop) do
				for _, item in ipairs(category) do
					if checkItemSupplies(shop_type, supplies, item.itemID, item.itemValue, getMetaItemName(item)) or govOwned then
						if counter == index then
							return item
						end
						counter = counter + 1
					end
				end
			end
		else
			for _, category in ipairs(shop) do
				if index <= #category then
					return category[index]
				else
					index = index - #category
				end
			end
		end
	end
end

--
--local simplesmallcache = {}
function updateItems( shop_type, race, gender )
	if shop_type == 5 then -- clothes shop
		-- load the shop
		local shop = g_shops[shop_type]

		-- clear all items
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end

		-- uber complex logic to add skins
		local nat = {}
		local availableskins = fittingskins[gender][race]
		table.sort(availableskins)
		for k, v in ipairs(availableskins) do
			if not restricted_skins[v] then
				table.insert( shop[1], { name = "Coleção #" .. v, description = "Clique para expandir", price = 50, itemID = 16, itemValue = v, fitting = true } )
				nat[v] = true
			end
		end

		local otherSkins = {}
		for gendr = 0, 1 do
			for rac = 0, 2 do
				if gendr ~= gender or rac ~= race then
					for k, v in pairs(fittingskins[gendr][rac]) do
						if not nat[v] and not restricted_skins[v] then
							table.insert(otherSkins, v)
						end
					end
				end
			end
		end
		table.sort(otherSkins)

		for k, v in ipairs(otherSkins) do
			table.insert( shop[2], { name = "Coleção #" .. v, description = "Estes não parecem se encaixar bem em você", price = 50, itemID = 16, itemValue = v } )
		end

		shop[3] = {
			name = 'Bandanas',
			{ name = "Bandana Azul Claro", description = "Um pano azul claro.", price = 5, itemID = 122 },
			{ name = "Bandana Vermelha", description = "Um pano vermelho.", price = 5, itemID = 123 },
			{ name = "Bandana Amarela", description = "Um pano amarelo.", price = 5, itemID = 124 },
			{ name = "Bandana Roxa", description = "Um pano roxo.", price = 5, itemID = 125 },
			{ name = "Bandana Azul", description = "Um pano azul.", price = 5, itemID = 135 },
			{ name = "Bandana Marrom", description = "Um pano marrom.", price = 5, itemID = 136 },
			{ name = "Bandana Verde", description = "Um pano verde.", price = 5, itemID = 158 },
			{ name = "Bandana Laranja", description = "Um pano laranja.", price = 5, itemID = 168 },
			{ name = "Bandana Preta", description = "Um pano preto.", price = 5, itemID = 237 },
			{ name = "Bandana Cinza", description = "Um pano cinza.", price = 5, itemID = 238 },
			{ name = "Bandana Branca", description = "Um pano branco.", price = 5, itemID = 239 },
		}

		-- simplesmallcache[tostring(race) .. "|" .. tostring(gender)] = shop
	elseif shop_type == 14 then
		-- param (race)= vehicle model
		--[[local c = simplesmallcache["vm"]
		if c then
			return
		end]]

		-- remove old data
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end

		for v = 1000, 1193 do
			if vehicle_upgrades[v-999] then
				local str = exports['item-system']:getItemDescription( 114, v )

				local p = str:find("%(")
				local vehicleName = ""
				if p then
					vehicleName = str:sub(p+1, #str-1) .. " - "
					str = str:sub(1, p-2)
				end
				if not disabledUpgrades[v] then
					table.insert( shop[1], { name = vehicleName .. ( getVehicleUpgradeSlotName(v) or "Luzes" ), description = str, price = vehicle_upgrades[v-999][2], itemID = 114, itemValue = v})
				end
			end
		end
		-- bar battery
		table.insert( shop[1], { name = exports['item-system']:getItemName( 232 ), description = exports['item-system']:getItemDescription( 232, 1 ), price = 130*2, itemID = 232, itemValue = 1} )
	end
end

function getFittingSkins()
	return fittingskins
end


function getDiscount( player, shoptype )
	local discount = 1
	if shoptype == 7 then
		discount = discount * 0.5
	elseif shoptype == 14 then
		discount = discount * 0.5
	end

	if exports.donators:hasPlayerPerk( player, 8 ) then
		discount = discount * 0.8
	end
	return discount
end
