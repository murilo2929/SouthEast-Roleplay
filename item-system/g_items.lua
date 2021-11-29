g_items = {
	[1] = { "Hotdog", "Um hotdog fumegante, bonito e saboroso.", 1, 2215, 205, 205, 0, 0.01, weight = 0.1 },
	[2] = { "Celular", "Um celular elegante, parece novo também.", 7, 330, 90, 90, 0, 0, weight = 0.3, metadata = { item_name = { type = 'string', rank = 'player' } } },
	[3] = { "Chave do Carro", "Uma chave de veículo com um crachá do fabricante.", 2, 1581, 270, 270, 0, 0, weight = 0.1, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[4] = { "Chave da Casa", "Uma chave de casa verde.", 2, 1581, 270, 270, 0, 0, weight = 0.1, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[5] = { "Chave de Empresa", "Uma chave de empresa azul.", 2, 1581, 270, 270, 0, 0, weight = 0.1, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[6] = { "Radio", "Um radio preto.", 7, 330, 90, 90, 0, -0.05, weight = 0.2 },
	[7] = { "Lista Telefônica", "Uma lista telefônica.", 5, 2824, 0, 0, 0, -0.01, weight = 2 },
	[8] = { "Sanduíche", "Um sanduíche de queijo.", 1, 2355, 205, 205, 0, 0.06, weight = 0.3 },
	[9] = { "Refrigerante", "Uma lata de sprunk", 1, 2647, 0, 0, 0, 0.12, weight = 0.2 },
	[10] = { "Dado", "Um dado vermelho com pontos brancos #v lados.", 4, 1271, 0, 0, 0, 0.285, weight = 0.1 },
	[11] = { "Taco", "Um taco mexicano.", 1, 2215, 205, 205, 0, 0.06, weight = 0.1 },
	[12] = { "Burger", "Um cheeseburger duplo com bacon.", 1, 2703, 265, 0, 0, 0.06, weight = 0.3 },
	[13] = { "Donut", "Rosquinha quente com cobertura de açúcar pegajoso.", 1, 2222, 0, 0, 0, 0.07, weight = 0.2 },
	[14] = { "Cookie", "Um luxuoso biscoito de chocolate.", 1, 2222, 0, 0, 0, 0.07, weight = 0.1 },
	[15] = { "Water", "Aguá mineral.", 1, 1484, -15, 30, 0, 0.2, weight = 1 },
	[16] = { "Roupas", "Um conjunto de roupas limpas. (( Skin ID ##v ))", 6, 2386, 0, 0, 0, 0.1, weight = 1, metadata = { item_name = { type = 'string', rank = 'player', max_length = 50 } } },
	[17] = { "Relógio", "Um relógio para ver as horas.", 6, 1271, 0, 0, 0, 0.285, weight = 0.1, metadata = { item_name = { type = 'string', rank = 'staff' } } },
	[18] = { "Guia da Cidade", "Um pequeno livreto de guia da cidade.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[19] = { "MP3 Player", "Um MP3 Player branco e elegante. Da marca EyePod.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 },
	[20] = { "Luta padrão para Leigos", "Um livro sobre como aprender a lutar.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[21] = { "Boxe para Leigos", "Um livro sobre como aprender boxe.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[22] = { "Kung Fu para Leigos", "Um livro sobre como aprender Kung Fu.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[23] = { "Knee Head Fighting for Dummies", "Um livro sobre como lutar.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[24] = { "Grab Kick Fighting for Dummies", "Um livro sobre como lutar com o cotovelo.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[25] = { "Elbow Fighting for Dummies", "Um livro sobre como lutar com o cotovelo.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[26] = { "Máscara de Gas", "Uma máscara de gás preta, bloqueia os efeitos de gás e flashbangs.", 6, 2386, 0, 0, 0, 0.1, weight = 0.5 },
	[27] = { "Flashbang", "Uma pequena lata de granada com FB escrito ao lado.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[28] = { "Glowstick", "Um bastão luminoso verde.", 4, 343, 0, 0, 0, 0.1, weight = 0.2 },
	[29] = { "Door Ram", "Um aríete de metal vermelho.", 4, 1587, 90, 0, 0, 0.05, weight = 3 },
	[30] = { "Cannabis Sativa", "Cannabis Sativa, quando misturada pode criar algumas drogas fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[31] = { "Cocaína Alcalóide", "Cocaína Alcalóide, quando misturada pode criar algumas drogas fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[32] = { "Ácido lisérgico", "Ácido lisérgico, quando misturada pode criar algumas drogas fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[33] = { "PCP não processado", "PCP não processado, quando misturada pode criar algumas drogas fortes.", 3, 1279, 0, 0, 0, 0, weight = 0.1 },
	[34] = { "Cocaina", "Uma substância em pó que dá um grande impulso de energia.", 3, 1575, 0, 0, 0, 0, weight = 0.1 },
	[35] = { "Morfina", "Uma pílula ou substância líquida com efeitos fortes.", 3, 1578, 0, 0, 0, -0.02, weight = 0.1 },
	[36] = { "Ecstasy", "Comprimidos com visuais fortes e europhoria.", 3, 1576, 0, 0, 0, 0.07, weight = 0.1 },
	[37] = { "Heroina", "Uma substância em pó ou líquida com fortes efeitos de desaceleração e forte europoria.", 3, 1579, 0, 0, 0, 0, weight = 0.1 },
	[38] = { "Maconha", "Erva daninha verde e saborosa.", 3, 3044, 0, 0, 0, 0.04, weight = 0.1 },
	[39] = { "Metanfetamina", "Uma substância semelhante a um cristal com fortes efeitos de chute de energia.", 3, 1580, 0, 0, 0, 0, weight = 0.1 },
	[40] = { "Epinefrina (adrenalina)", "Epinefrina - uma substância líquida que aumenta a adrenalina.", 3, 1575, 0, 0, 0, -0.02, weight = 0.1 },
	[41] = { "LSD", "Ácido lisérgico com dietilamida, dá visuais engraçados.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[42] = { "Cogumelos", "Cogumelos dourados secos.", 3, 1577, 0, 0, 0, 0, weight = 0.1 },
	[43] = { "PCP", "Pó de fenciclidina.", 3, 1578, 0, 0, 0, 0, weight = 0.1 },
	[44] = { "Kit de Química", "Um pequeno conjunto de química.", 4, 1210, 90, 0, 0, 0.1, weight = 3 },
	[45] = { "Algemas", "Um par de algemas de metal.", 4, 2386, 0, 0, 0, 0.1, weight = 0.4 },
	[46] = { "Corda", "Uma corda comprida.", 4, 1271, 0, 0, 0, 0.285, weight = 0.3 },
	[47] = { "Chaves de Algema", "Um pequeno par de chaves de algemas.", 4, 2386, 0, 0, 0, 0.1, weight = 0.05 },
	[48] = { "Mochila", "Uma mochila de tamanho razoável.", 4, 3026, 270, 0, 0, 0, weight = 1 },
	[49] = { "Vara de Pescar", "Uma vara de pesca de aço carbono de 7 pés.", 4, 338, 80, 0, 0, -0.02, weight = 1.5 },
	[50] = { "Código Rodoviário de Los Santos", "The Los Santos Highway Code.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[51] = { "Química 101",  "Uma introdução à química útil.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[52] = { "Police Officer's Manual", "The Police Officer's Manual.", 5, 2824, 0, 0, 0, -0.01, weight = 0.3 },
	[53] = { "Bafômetro", "Um pequeno bafômetro preto.", 4, 1271, 0, 0, 0, 0.285, weight = 0.2 },
	[54] = { "Ghettoblaster (CD Player)", "Tem a cor preta.", 7, 2226, 0, 0, 0, 0, weight = 3 },
	[55] = { "Cartão de Visitas", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[56] = { "Máscara de Esqui", "Uma máscara de esqui.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 },
	[57] = { "Lata de Combustível", "Uma pequena lata de combustível de metal.", 4, 1650, 0, 0, 0, 0.30, weight = 1 }, -- would prolly to make sense to make it heavier if filled
	[58] = { "Cerveja Ziebrand", "A melhor cerveja, importada da Holanda.", 1, 1520, 0, 0, 0, 0.15, weight = 1 },
	--[59] = { "Mudkip", "So i herd u liek mudkips? mabako's Favorite.", 1, 1579, 0, 0, 0, 0, weight = 0 },
	[60] = { "Cofre", "Um cofre para guardar seus itens.", 4, 2332, 0, 0, 0, 0, weight = 5 },
	[61] = { "Sirene de Emergência", "Uma sirene de emergência que você pode colocar em seu carro.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 },
	[62] = { "Vodka Bastradov", "Para seus melhores amigos - Bastradov Vodka.", 1, 1512, 0, 0, 0, 0.25, weight = 1 },
	[63] = { "Whisky escocês", "O Melhor Whisky Escocês, agora exclusivamente feito de Haggis.", 1, 1512, 0, 0, 0, 0.25, weight = 1 },
	[64] = { "Distintivo LSPD", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[65] = { "Distintivo LSFD", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[66] = { "Venda", "Uma venda preta.", 6, 2386, 0, 0, 0, 0.1, weight = 0.1 },
	--[67] = { "GPS", "(( This item is currently disabled. ))", 6, 1210, 270, 0, 0, 0.1, weight = 0.8 },
	[68] = { "Bilhete de Loteria", "Um bilhete da loteria Los Santos.", 6, 2894, 0, 0, 0, -0.01, weight = 0.1 },
	[69] = { "Dicionário", "Um dicionário.", 5, 2824, 0, 0, 0, -0.01, weight = 1.5 },
	[70] = { "Kit de Primeiros Socorros", "Salva uma Vida. Pode ser usado #v vez(es).", 4, 1240, 90, 0, 0, 0.05, weight = function(v) return v/3 end },
	[71] = { "Papel", "Uma pequena coleção de papéis em branco, úteis para escrever notas. Existem #v página(s) restantes. ((/writenote))", 4, 2894, 0, 0, 0, -0.01, weight = function(v) return v*0.01 end },
	[72] = { "Nota", "A nota diz: #v", 4, 2894, 0, 0, 0, 0.01, weight = 0.01 },
	[73] = { "Controle Remoto de Elevador", "Um pequeno controle remoto para alterar o modo de um elevador.", 2, 364, 0, 0, 0, 0.05, weight = 0.3, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	--[74] = { "Bomb", "What could possibly happen when you use this?", 4, 363, 270, 0, 0, 0.05, weight = 2 },
	--[75] = { "Bomb Remote", "Has a funny red button.", 4, 364, 0, 0, 0, 0.05, weight = 100000 },
	[76] = { "Escudo de Choque", "Um escudo de choque pesado.", 4, 1631, -90, 0, 0, 0.1, weight = 5 },
	[77] = { "Baralho de Cartas", "Um baralho de cartas para jogar alguns jogos.", 4,2824, 0, 0, 0, -0.01, weight = 0.1 },
	[78] = { "Certificado de Piloto de San Andreas", "Uma permissão oficial para pilotar aviões e helicópteros.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[79] = { "Fita Porno", "Uma fita porno, #v", 4,2824, 0, 0, 0, -0.01, weight = 0.2 },
	[80] = { "Item Generico", "#v", 4, 1271, 0, 0, 0, 0, weight = 1, newPickupMethod = true, metadata = { 
			item_name = { type = 'string', rank = 'staff:once' }, model = { type = 'integer', rank = 'staff:once' }, scale = { type = 'string', rank = 'staff:once' },
			url = { type = 'string', rank = 'staff' }, texture = { type = 'string', rank = 'staff' }, weight = { type = 'string', rank = 'staff:once' },
		}
	}, --itemValue= name:model:scale:texUrl:texName --Do not use http:// in URL (since the : is divider), script will add http:// for this item.
	[81] = { "Geladeira", "Uma geladeira para armazenar alimentos e bebidas.", 7, 2147, 0, 0, 0, 0, weight = 0.1, storage = true, capacity = 50, acceptItems = {[-1] = true} },
	[82] = { "Identificação de Serviço de Trafico", "Esta Identificação da Agência de Serviços de Tráfego foi emitida para #v.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[83] = { "Cafe", "Uma pequena xícara de café.", 1, 2647, 0, 0, 0, 0.12, weight = 0.25 },
	[84] = { "Escort 9500ci Detector de Radar", "Detecta a polícia a menos de meia milha.", 7, 330, 90, 90, 0, -0.05, weight = 1 },
	[85] = { "Sirene de Emergência (Policia)", "Uma sirene de emergência para colocar no seu carro.", 7, 330, 90, 90, 0, -0.05, weight = 0.2 },
	[86] = { "Identificação SAN", "#v.", 10, 330, 90, 90, 0, -0.05, weight = 0.3 },
	[87] = { "Distintivo do Governo", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.5 },
	[88] = { "Fone de Ouvido", "Um pequeno fone de ouvido pode ser conectado a um rádio.", 7, 1581, 270, 270, 0, 0, weight = 0.15 },
	[89] = { "Comida Generica", "#v", 1, 2222, 0, 0, 0, 0.07, weight = 0.5, newPickupMethod = true },
	[90] = { "Capacete de Motocross", "Ideal para andar de moto.", 6, 2799, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true, metadata = { url = { type = 'string', rank = 'player', max_length = 50 } } },
	[91] = { "Gemada", "Yum Yum.", 1, 2647, 0, 0, 0, 0.1, weight = 0.5 }, --91
	[92] = { "Turkey", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1, weight = 3.8 },
	[93] = { "Pudim de Natal", "Yum Yum.", 1, 2222, 0, 0, 0, 0.1, weight = 0.4 },
	[94] = { "Presente de Natal", "Todo mundo quer um.", 4, 1220, 0, 0, 0, 0.1, weight = 1 },
	[95] = { "Bebida Generica", "#v", 1, 1455, 0, 0, 0, 0, weight = 0.5, newPickupMethod = true }, --[95] = { "Drink", "", 1, 1484, -15, 30, 0, 0.2, weight = 1 },
	[96] = { "Macbook Pro A1286 Core i7", "Um Macbook para ver e-mails e navegar na Internet.", 6, 2886, 0, 0, 180, 0.1, weight = function(v) return v == 1 and 0.2 or 1.5 end },
	[97] = { "Manual de Procedimentos LSFD", "Manual de procedimentos do Serviço de Emergência de Los Santos.", 5, 2824, 0, 0, 0, -0.01, weight = 0.5 },
	[98] = { "Controle Remoto de Garagem", "Um pequeno controle remoto para abrir ou fechar uma garagem.", 2, 364, 0, 0, 0, 0.05, weight = 0.3, metadata = { key_name = { type = 'string', rank = 'player' } }, ooc_item_value = true },
	[99] = { "Bandeja de Jantar Mista", "Vamos jogar o jogo de adivinhação.", 1, 2355, 205, 205, 0, 0.06, weight = 0.4 },
	[100] = { "Caixa de Leite Pequena", "Gosta de leite?!", 1, 2856, 0, 0, 0, 0, weight = 0.2 },
	[101] = { "Caixa de Suuco Pequena", "Sede?", 1, 2647, 0, 0, 0, 0.12, weight = 0.2 },
	[102] = { "Repolho", "Para os vegetarianos.", 1, 1271, 0, 0, 0, 0.1, weight = 0.4 },
	[103] = { "Prateleira", "Uma grande prateleira para guardar coisas", 4, 3761, -0.15, 0, 85, 1.95, weight = 0.1, storage = true, capacity = 100 },
	[104] = { "TV Portatil", "Uma TV portátil para assistir programas", 6, 1518, 0, 0, 0, 0.29, weight = 1 },
	[105] = { "Maço de Cigarro", "Maço com #v cigarros dentro.", 6, 3044 , 270, 0, 0, 0.1, weight = function(v) return 0.1 + v*0.03 end }, -- 105
	[106] = { "Cigarro", "Isso faz mal.", 6, 3044 , 270, 0, 0, 0.1, weight = 0.03 }, -- 106
	[107] = { "Isqueiro", "Faz fogo se você usá-lo corretamente.", 6, 1210, 270, 0, 0, 0.1, weight = 0.05 }, -- 107
	[108] = { "Panqueca", "Uma panqueca!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.5 }, -- 108
	[109] = { "Fruta", "Comida saudavel!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.35 }, -- 109
	[110] = { "Vegetal", "Comida saudavel!.", 1, 2222, 0, 0, 0, 0.07, weight = 0.35  }, -- 110
	[111] = { "GPS Portatil", "Um GPS, também contém os mapas recentes.", 6, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 111
	[112] = { "Distintivo da Patrulha Rodoviária", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, -- 142
	[113] = { "Pacote de GlowSticks", "Pacote com #v glowsticks dentro.", 6, 1210, 270, 0, 0, 0.1, weight = function(v) return v * 0.2 end }, -- 113
	[114] = { "Upgrade Veículo", "#v", 4, 1271, 0, 0, 0, 0.285, weight = 1.5 }, -- 114
	[115] = { "Arma", "#v ", 8, 2886, 270, 0, 1, 0.1, 2, weight = function( v )
																		local weaponID = tonumber( explode(":", v)[1] )
																		return weaponID and weaponweights[ weaponID ] or 1
																	end
	}, -- 115
	[116] = { "Ammopack", "Ammopack with #v bullets inside.", 9, 2040, 0, 1, 0, 0.1, 3,
		weight = function( v )
			local packs = explode(":", v)
			local ammo_id = tonumber( packs[1] )
			local bullets = tonumber( packs[2] )
			if ammo_id and bullets then
				local ammunition = exports.weapon:getAmmo(ammo_id)
				return ammunition and exports.global:round(ammunition.bullet_weight*bullets, 3)
			end
			return 0.2
		end
	}, -- 2886 / 116
	[117] = { "Rampa", "Útil para carregar DFT-30s.", 4, 1210, 270, 1, 0, 0.1, 3, weight = 5 }, -- 117
	[118] = { "Pedagio Sem Parar", "Coloque no seu carro, cobra cada vez que você dirige em uma cabine de pedágio.", 6, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 118
	[119] = { "Sanitary Andreas ID", "Carteira de Identidade Sanitária.", 10, 1210, 270, 0, 0, 0.1, weight = 0.2 }, -- 119
	[120] = { "Equipamento de Mergulho", "Permite que você fique debaixo d'água por algum tempo", 6, 1271, 0, 0, 0, 0.285, weight = 4 }, --120
	[121] = { "Caixa com Suprimentos", "Caixa bem grande cheia de suprimentos!", 4, 1271, 0, 0, 0, 0.285, weight = function(v) return tonumber(v) and tonumber(v) or 50 end }, --121
	[122] = { "Bandana Azul Claro", "Um pano azul claro.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 122
	[123] = { "Bandana Vermelha", "Um pano vermelho.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 123
	[124] = { "Bandana Amarela", "Um pano amarelo", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 124
	[125] = { "Bandana Roxa", "Um pano roxo.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 125
	[126] = { "Cinto Tatico", "Um cinto liso de couro preto, com muitos coldres.", 4, 2386, 270, 0, 0, 0, weight = 1 }, -- 126
	[127] = { "Identificação LSIA", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --127
	[128] = { "UNUSED BADGE", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --128 | ADD TTR FACTION BAGDE ITEM | 24.1.14
	[129] = { "Importações Diretas ID", "Um ID de importação direta.", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --129
	[130] = { "Sistema de Alarme de Veículo", "Um sistema de alarme de veículo.", 6, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 130
	[131] = { "Distintivo LSCSD", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, -- 131
	[132] = { "Frasco de Prescrição", "Um frasco de remédio contém remédios prescritos.", 3, 1575, 0, 0, 0, 0.04, weight = 0.1 }, --132
	[133] = { "Carteira de Habilitação - Automotiva", "Carteira de habilitação de Los Santos.", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[134] = { "Dinheiro", "Moeda dos Estados Unidos.", 10, 1212, 0, 0, 0, 0.04, weight = 0.3 }, -- 134
	[135] = { "Bandana Azul", "Um pano azul.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 135
	[136] = { "Bandana Marrom", "Um pano marrom.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 136
	[137] = { "Camera Sonda", "Usado em operações da SWAT.", 7, 330, 90, 90, 0, -0.05, weight = 0.3 }, -- 137
	[138] = { "Sistema de Isca para Veículos", "Um dispositivo usado em operações policiais.", 4, 1271, 0, 0, 0, 0.285, weight = 0.5 }, -- 138
	[139] = { "Rastreador de Veículo", "Um dispositivo usado para rastrear a posição dos veículos", 7, 1271, 0, 0, 0, 0.285, weight = 0.2 }, --139
	[140] = { "Sirene Laranja", "Uma luz estroboscópica laranja que você pode colocar no carro.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 }, --140
	[141] = { "Megafone", "Um dispositivo em forma de cone usado para intensificar ou direcionar sua voz.", 7, 1210, 270, 0, 0, 0.1, weight = 0.1 }, --141
	[142] = { "Los Santos Cab & Bus ID", "Um cartão de identificação de táxi e ônibus Los Santos.", 10, 1210, 270, 0, 0, 0.1, weight = 0.3 }, -- 142
	[143] = { "Terminal de Dados Móvel", "Um terminal de dados móveis.", 7, 2886, 0, 0, 180, 0.1, weight = 0.1 }, -- 143
	[144] = { "Sirene Amarela", "Um estroboscópio amarelo para colocar no seu carro.", 7, 2886, 270, 0, 0, 0.1, weight = 0.1 }, -- 144
	[145] = { "Lanterna", "Bateria: #v%", 7, 15060, 0, 90, 0, 0.05, weight = 0.3 },
	[146] = { "Cartão de Identificação do Tribunal Distrital de Los Santos", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[147] = { "Wallpaper", "Para retexturizar seu interior.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, --147
	[148] = { "Licença de Porte de Arma Aberta", "Uma licença de porte de arma de fogo que permite a uma pessoa portar abertamente uma arma de fogo.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[149] = { "Licença de Porte Oculto de Arma - LSPD", "Uma licença de arma de fogo que permite a posse oculta de uma arma, emitida pela LSPD.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[150] = { "Cartão ATM", "Um cartão de plástico usado para fazer transações com um valor muito limitado por dia em um caixa eletrônico (ATM).", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[151] = { "Lift Remote", "Um dispositivo remoto para elevador de veículos.", 2, 364, 0, 0, 0, 0.05, weight = 0.3 },
	[152] = { "Cartão de Identificação San Andreas", "Um cartão de identificação.", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[153] = { "Carteira de Motorista - Moto", "Carteira de habilitação de Los Santos.", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[154] = { "Licença de Pesca", "Uma licença de pesca de Los Santos", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[155] = { "Carteira de Motorista - Barco", "Carteira de habilitação de Los Santos.", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[156] = { "Tribunal Superior de San Andreas ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.1 },
	[157] = { "Caixa de Ferramentas", "Uma caixa de ferramentas vermelha metálica contendo várias ferramentas.", 4, 1271, 0, 0, 0, 0, weight = 0.5 },
	[158] = { "Bandana Verde", "Um pano verde.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 }, -- 158
	[159] = { "Sparta Inc. ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, -- 159 | Sparta Incorporated ID
	[160] = { "Pasta", "Uma pasta.", 6, 1210, 90, 0, 0, 0.1, weight = 0.4}, -- Exciter
	[161] = { "Arquitetura e Construção flamenga ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, -- 161 | anumaz Fleming Architecture and Construction ID
	[162] = { "Colete", "Colete a prova de balas.", 6, 3916, 90, 0, 0, 0.1, weight = 4}, -- Exciter
	[163] = { "Duffle Bag", "Uma mochila.", 6, 3915, 90, 0, 0, 0.2, weight = 0.4}, -- Exciter
	[164] = { "Maleta Médica", "Bolsa com equipamento médico avançado.", 6, 3915, 0, 0, 0, 0.2, weight = 1, texture = {{":artifacts/textures/medicbag.png", "hoodyabase5"}} }, -- Exciter
	[165] = { "DVD", "Um disco de vídeo.", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, -- Exciter
	[166] = { "ClubTec VS1000", "Sistema de veideo.", 4, 3388, 0, 0, 90, -0.01, weight = 5, scale = 0.6, preventSpawn = true, newPickupMethod = true }, -- Exciter
	[167] = { "Imagem Emoldurada (moldura dourada)", "Coloque sua foto e pendure-a na parede.", 4, 2287, 0, 0, 0, 0, weight = 1, doubleSided = true, newPickupMethod = true }, -- Exciter
	[168] = { "Bandana Laranja", "Um pano laranja.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2 },
	[169] = { "Fechadura Digital", "Esse sistema de segurança sofisticado é muito mais seguro do que uma fechadura com chave tradicional porque não pode ser arrombado ou batido.", 6, 2922, 0, 0, 180, 0.2, weight = 0.5 }, --Maxime
	[170] = { "Keycard", "Um cartão magnético para #v", 2, 1581, 270, 270, 0, 0, weight = 0.1 }, -- Exciter
	[171] = { "Capacete de Moto", "Ideal para andar de moto.", 6, 3911, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true, metadata = { url = { type = 'string', rank = 'player', max_length = 50 } } },
	[172] = { "Capacede de Moto (Fechado)", "Ideal para andar de moto.", 6, 3917, 0, 0, 0, 0.2, weight = 1.5, scale = 1, hideItemValue = true, metadata = { url = { type = 'string', rank = 'player', max_length = 50 } } },
	[173] = { "Transferência de Veículo DMV", "Documento necessário para vender um veículo a outra pessoa.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, -- Anumaz
	[174] = { "FAA Electronical Map Book", "Dispositivo eletrônico exibindo informações e mapas de toda San Andreas.", 4, 1271, 0, 0, 0, -0.01, weight = 0.01 }, -- Anumaz
	[175] = { "Poster", "Um cartaz publicitário.", 4, 2717, 0, 0, 0, 0.7, weight = 0.01, hideItemValue = true }, -- Exciter
	[176] = { "Alto Falante", "Grande alto-falante preto que parece incrível, oferece um som grande o suficiente para preencher qualquer espaço, som nítido em qualquer volume.", 7, 2232, 0, 0, 0, 0.6, weight = 3 }, -- anumaz
	[177] = { "Intranet", "Um dispositivo intranet remoto conectado ao Centro de Despacho.", 7, 1581, 0, 0, 0, 0.6, weight = 0.01 }, -- anumaz
    [178] = { "Livro", "#v", 5, 2824, 0, 0, 0, -0.1, weight = 0.1}, -- Chaos
    [179] = { "Motivo do Carro", "Um motivo para decorar seu carro com.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 }, -- Exciter
    [180] = { "SAPT ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, -- Exciter
    [181] = { "Seda", "Sedas transparentes. O pacote contém #v seda(s).", 4, 3044 , 270, 0, 0, 0.1, weight = function(v) return 0.1 + v*0.03 end },
    [182] = { "Baseado Enrolado", "Um baseado enrolado de maconha pura.", 4, 1485, 270, 0, 0, 0.1, weight = 0.03 },
    [183] = { "Cartão de Sócio Viozy", "Associação Exclusiva Viozy Businesses", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --  Chase
    [184] = { "Insulfime HP Charcoal", "Viozy HP Charcoal Window Film ((50 /chance))", 4, 1271, 0, 0, 0, 0, weight = 0.6 }, -- Chase
    [185] = { "Insulfime CXP70", "Viozy CXP70 Window Film ((95 /chance))", 4, 1271, 0, 0, 0, 0, weight = 0.3 }, -- Chase
    [186] = { "Viozy Cortador de borda (vermelho anodizado)", "Cortador de bordas para tingimento", 4, 1271, 0, 0, 0, 0, weight = 0.05 }, -- Chase
    [187] = { "Viozy Medidor de Transmissão de Espectro Solar", "Medidor de espectro para testar o filme antes do uso", 7, 1271, 0, 0, 0, 0, weight = 2 }, -- Chase
    [188] = { "Viozy Tint Chek 2800", "Mede a transmissão de luz visível em qualquer filme/vidro", 7, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [189] = { "Viozy Pistola de Calor", "Pistola de calor fácil de usar, perfeita para reduzir janelas traseiras", 7, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [190] = { "Viozy 36 Multi-Purpose Cutter Bucket", "Iideal para trabalhos de corte leve ao aplicar tinta", 4, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    [191] = { "Viozy Lâmpada de Demonstração de Tonalidade", "Apresentação eficaz da aplicação colorida", 7, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    [192] = { "Viozy Raspador Angular Triumph", "Raspador angular de 6 polegadas para aplicação de tinta", 4, 1271, 0, 0, 0, 0, weight = 0.3 }, -- Chase
    [193] = { "Viozy Pulverizador manual Performax 48oz", "Pulverizador manual Performax para aplicação de tinta", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [194] = { "Viozy Ignição de Veículo - 2010 ((20 /chance))", "Ignição de Veículo feito por Viozy para 2010", 4, 1271, 0, 0, 0, 0, weight = 1.5 }, -- Chase
    [195] = { "Viozy Ignição de Veículo - 2011 ((30 /chance))", "Ignição de Veículo feito por Viozy para 2011", 4, 1271, 0, 0, 0, 0, weight = 1.3 }, -- Chase
    [196] = { "Viozy Ignição de Veículo - 2012 ((40 /chance))", "Ignição de Veículo feito por Viozy para 2012", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase
    [197] = { "Viozy Ignição de Veículo - 2013 ((50 /chance))", "Ignição de Veículo feito por Viozy para 2013", 4, 1271, 0, 0, 0, 0, weight = 0.8 }, -- Chase
    [198] = { "Viozy Ignição de Veículo - 2014 ((70 /chance))", "Ignição de Veículo feito por Viozy para 2014", 4, 1271, 0, 0, 0, 0, weight = 0.6 }, -- Chase
    [199] = { "Viozy Ignição de Veículo - 2015 ((90 /chance))", "Ignição de Veículo feito por Viozy para 2015", 4, 1271, 0, 0, 0, 0, weight = 0.4 }, -- Chase
    --[200] = { "Viozy Ignição de Veículo - 2016", "Ignição de Veículo not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    --[201] = { "Viozy Ignição de Veículo - 2017", "Ignição de Veículo not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    --[202] = { "Viozy Ignição de Veículo - 2018", "Ignição de Veículo not yet in production", 4, 1271, 0, 0, 0, 0, weight = 1 }, -- Chase (not to be used)
    [203] = { "Viozy Hidden Vehicle Tracker 315 Pro ((Indetectavel))", "GPS HVT 315 Pro, facil instalação ((e indetectavel)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 3 }, -- Chase
    [204] = { "Viozy Hidden Vehicle Tracker 272 Micro ((30 /chance))", "GPS HVT 272 Micro, facil instalação ((30 /chance para ser encontrado)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 0.5 }, -- Chase
    [205] = { "Viozy HVT 358 Portable Spark Nano 4.0 ((50 /chance))", "GPS HVT 358 Spark Nano 4.0 Portatil ((50 /chance para ser encontrado)), by Viozy", 7, 1271, 0, 0, 0, 0, weight = 0.2 }, -- Chase
	--[206] = { "Wheat Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	--[207] = { "Barley Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	--[208] = { "Oat Seed", "A nice seed with potential", 7, 1271, 0, 0, 0, 0, weight = 0.1 }, -- Chaos
	[209] = { "FLU Device", "Um dispositivo eletrônico da unidade de Licenciamentos de Armas", 7, 1271, 0, 0, 0, 0, weight = 0.1}, -- anumaz
	[210] = { "Coca-Cola Natal", "Uma garrafa de coca, edição natal.", 1, 2880, 180, 0, 0, 0, weight = 0.2}, -- Exciter
	[211] = { "Um bilhete de loteria de Natal", "Da Coca-Cola Santa.", 10, 1581, 270, 270, 0, 0, weight = 0.1, preventSpawn = true}, -- Exciter
	[212] = { "Pneus de Veve", "Fique no chão como velcro!", 4, 1098, 0, 0, 0, 0, weight = 1}, -- Exciter
	[213] = { "Pinnekjott", "Favorito de Natal do papai.", 1, 2215, 205, 205, 0, 0.06, weight = 0.1, preventSpawn = true}, -- Exciter
	[214] = { "Droga Generica", "#v", 3, 1576, 0, 0, 0, 0.07, weight = 0.1}, -- Chaos
	[215] = { "Licença de Porte Oculto de Arma - SAHP", "Licença de porte oculto de arma de fogo, emitida pelo SAHP.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[216] = { "Licença de Armamento de Tier 3 - SAN ANDREAS", "Uma licença de arma de fogo que permite o manuseio de armamento Tier 3, emitida pelo escritório ATF.", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[217] = { "Beeper", "Um bip eletrônico usado em frequências específicas.", 7, 1271, 0, 0, 0, 0, weight = 0.1}, -- anumaz, currently used for lsfd /alarm
	[219] = { "Colete Fino (TIPO2)", "Oculto e protetor.", 6, 1581, 270, 270, 0, 0, weight = 2 },
	[220] = { "Colete Kevlar (TIPO3)", "Visível e de boa qualidade.", 6, 1581, 270, 270, 0, 0, weight = 2 },
	[221] = { "Colete Kevlar High End (TIPO4)", "Armadura de nível militar.", 6, 1581, 270, 270, 0, 0, weight = 2 },
	[222] = { "SACMA ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, -- Chaos
	[223] = { "Armazenamento Generico", "#v", 4, 3761, -0.15, 0, 85, 0.2, weight = 2, storage = true, capacity = 10 }, -- Chaos --value= Name:ModelID:Capacity
	[224] = { "Crack", "Uma pequena substância parecida com uma rocha, quando fumada dá uma intensa sensação de euforia.", 3, 1575, 0, 0, 0, 0, weight = 0.1 },
	[225] = { "Cetamina", "Uma substância em pó quando injetada produz uma experiência fora do corpo, quando cheirada uma pequena explosão de energia e euforia.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[226] = { "Oxicodona", "Um analgésico com prescrição médica, geralmente prescrito para dores moderadas a fortes.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[227] = { "Rohypnol", "Uma substância parecida com uma pílula, freqüentemente transformada em pó; também conhecido como a droga 'estupro'. Os usuários freqüentemente experimentam perda de controle muscular, confusão, sonolência e amnésia.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[228] = { "Xanax", "Uma substância semelhante a uma pílula comumente prescrita para ajudar a aliviar os sintomas de ansiedade e pânico.", 3, 1576, 0, 0, 0, 0, weight = 0.1 },
	[229] = { "JGC ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, --Exciter
	[230] = { "RPMF Incorporated ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3}, --Exciter
	[231] = { "Container de Remessa", "Um grande contêiner de carga.", 4, 2934, 0, 0, 0, 1.44, weight = 0.1, hideItemValue = true, storage = true, capacity = 200 }, --Exciter --preventSpawn = true --value= registration;textureSides;textureDoors
	[232] = { "Carregador de Bateria de Carro", "Pode carregar rapidamente quase todos os tipos de bateria e é uma ótima escolha para mecânicos domésticos e pequenas lojas.", 7, 2040, 0, 1, 0, 0.1, 3, weight = 4.3 },
	[233] = { "Distintivo DOC", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[234] = { "USMCR ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[235] = { "Dinoco ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[236] = { "National Park Service ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 },
	[237] = { "Bandana Preta", "Um pano preto.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2}, -- George
	[238] = { "Bandana Cinza", "Um pano cinza.", 6, 2386, 0, 0, 0, 0.1, weight = 0.2}, -- George
	[239] = { "Bandana Branca", "Um pano branco.", 6, 2386, 0, 0, 0, 0.1, weight = 0.1}, -- George
	[240] = { "Chapeu de Natal", "Um chapéu festivo.", 6, 954, 0, 0, 0, 0.1, weight = 0.1, preventSpawn = false}, -- Chaos
	--{ "Armor", "Kevlar-made armor.", 6, 373, 90, 90, 0, -0.05, weight = 1 }, -- 138
	--{ "Dufflebag", "LOL", 10, 2462, 0, 0, 0, 0.04, weight = 0.1 }, -- 135
	[241] = { "Red Rose Funeral Home ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Exciter
	[242] = { "Bancada de Trabalho", "Um banco para construir coisas.", 4, 936, 0, 0, 0, 0, weight = 4, storage = true, capacity = 20 }, --Exciter, factory system --preventSpawn = true
	[243] = { "Máquina de Fábrica", "Uma máquina para produzir coisas.", 4, 14584, 0, 0, 0, 0, weight = 5, storage = true, capacity = 50 }, --Exciter, factory system --preventSpawn = true
	[244] = { "Forno", "Um forno para cozinhar e assar.", 4, 2417, 0, 0, 0, 0, weight = 4, storage = true, capacity = 10 }, --Exciter, factory system --preventSpawn = true
	[245] = { "Legal Corporation ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Exciter
	[246] = { "Bank of Los Santos ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Exciter
	[247] = { "Astro Corporation ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Exciter
	[248] = { "Projector Remote", "A small remote to control the projector ##v.", 2, 364, 0, 0, 0, 0.05, weight = 0.3, ooc_item_value = true },
	[249] = { "Western Solutions ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Unitts
	[250] = { "St John Ambulance ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Exciter
	[251] = { "Pizza Stack ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Exciter
	[252] = { "Lixeira", "Uma lixeira.", 4, 1344, 0, 0, 0, 0, weight = 4, hideItemValue = true, storage = true, capacity = 200 }, --Exciter
	[253] = { "Lata de Lixo", "Uma lata de lixo.", 4, 1344, 270, 270, 0, 0, weight = 3, hideItemValue = true, storage = true, capacity = 50 }, --Exciter
	[254] = { "Litter", "#vkg de lixo.", 4, 1344, 270, 270, 0, 0, weight = function(v) return v end }, --Exciter --math.floor((v/50)*(10^2)+0.5)/(10^2)
	[255] = { "Desperdício", "#vkg De resíduos.", 4, 1344, 270, 270, 0, 0, weight = function(v) return v end }, --Exciter
	[256] = { "Blu-Ray", "A video disc.", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, --Exciter
	[257] = { "ClubTec VS2000", "Video System.", 4, 3388, 0, 0, 90, -0.01, weight = 6, preventSpawn = true, newPickupMethod = true, image = 166 }, --Exciter
	[258] = { "Lamborghini Automotive ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3, image = 129 }, --Exciter
	[259] = { "SL Incorporated ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3, image = 129 }, --Exciter
	[260] = { "Garrafa de Amônia", "Uma garrafa de amoníaco.", 1, 1484, -15, 30, 0, 0.2, weight = 1 }, --Chaos
	[261] = { "Sirene de Emergência (Caminhão de Bombeiros)", "Uma sirene de emergência para colocar no seu carro.", 7, 330, 90, 90, 0, -0.05, weight = 0.2, image = 85 }, -- Chaos
	[262] = { "Token (( Token de Casa ))", "Um pequeno token de plástico. (( Usado para comprar uma nova casa de valor < $40,000 ))", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, --Chaos
	[263] = { "Token (( Token de Veículo ))", "Um pequeno token de plástico. (( Usado para comprar um novo carro de valor < $35,000 ))", 4, 2894, 0, 0, 0, -0.01, weight = 0.1 }, --Chaos
	[264] = { "VMAT ADS-B", "Airport ground vehicle tracking unit.", 6, 2886, 0, 0, 180, 0.1, weight = 0.9, preventSpawn = true }, --Exciter
	[265] = { "Saint Ernest Medical Center Staff ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3 }, --Exciter
	[266] = { "SAAN Staff ID", "#v", 10, 1581, 270, 270, 0, 0, weight = 0.3, image = 129 },
	[267] = { "Multa", "Um bilhete emitido pelas autoridades.", 4, 2894, 0, 0, 0, -0.01, weight = 0.01 },
	[268] = { "Prancha de Surfe", "Uma prancha de surfe.", 4, 2406, 0, 0, 0, 1.2, weight = 2 }, --Exciter
	[269] = { "Sirene de Emergência (Ambulância)", "Uma sirene de emergência para colocar no seu carro.", 7, 330, 90, 90, 0, -0.05, weight = 0.2, image = 85 }, -- Hurley
	[270] = { "Luvas", "Um par de luvas que você pode usar.", 6, 2386, 0, 0, 0, 0.1, weight = 0.1, hideItemValue = true, metadata = { item_name = { type = 'string', rank = 'player', max_length = 50 } } }, -- Hurley
	[271] = { "Cartucho", "#v", 4, 2061, 90, 0, 0, 0, weight = 0.1, scale = 0.2 }, 
	[272] = { "Labrador", "#v", 4, 2351, 0, 0, 0, 0.9, weight = 5 }, -- (Dog) Yannick
	[273] = { "Peixe Generico", "#v", 4, 1604, 0, 90, 0, 0.07, weight = 0.1, preventSpawn = true},
	[274] = { "Patins de Gelo", "Perfeito para patinar no gelo!", 6, 1852, 0, 0, 0, 1, weight = 0.1},
	[275] = { "Cadeado de Bicicleta", "Cadeado de bicicleta.", 4, 1271, 0, 0, 0, 0, weight = 0.1}, -- SjoerdPSV 
	[276] = { "MP7 (SKIN)", "MP7.", 8, 1581, 270, 270, 0, 0, weight = 0.1 },
	[284] = { "Sistema ANPR", "Reconhecimento Automático da Placa Numérica.", 4, 367, 270, 270, 0, 0, weight = 0.1},
}

	-- name, description, category, model, rx, ry, rz, zoffset, weight

	-- categories:
	-- 1 = Food & Drink
	-- 2 = Keys
	-- 3 = Drugs
	-- 4 = Other
	-- 5 = Books
	-- 6 = Clothing & Accessories
	-- 7 = Electronics
	-- 8 = guns
	-- 9 = bullets
	-- 10 = wallet

weaponmodels = {
	[1]=331, [2]=333, [3]=326, [4]=335, [5]=336, [6]=337, [7]=338, [8]=339, [9]=341,
	[15]=326, [22]=346, [23]=347, [24]=1872, [25]=349, [26]=350, [27]=351, [28]=1924,
	[29]=1902, [32]=372, [30]=355, [31]=2726, [33]=357, [34]=358, [35]=359, [36]=360,
	[37]=361, [38]=362, [16]=342, [17]=343, [18]=344, [39]=363, [41]=365, [42]=366,
	[43]=367, [10]=321, [11]=322, [12]=323, [14]=325, [44]=368, [45]=369, [46]=371,
	[40]=364, [100]=373
}

-- other melee weapons?
weaponweights = {
	[22] = 1.14, [23] = 1.24, [24] = 2, [25] = 3.1, [26] = 2.1, [27] = 4.2, [28] = 3.6, [29] = 2.640, [30] = 4.3, [31] = 2.68, [32] = 3.6, [33] = 4.0, [34] = 4.3
}

--
-- Vehicle upgrades as names
--
vehicleupgrades = {
	"Pro Spoiler", "Win Spoiler", "Drag Spoiler", "Alpha Spoiler", "Champ Scoop Hood",
	"Fury Scoop Hood", "Roof Scoop", "Right Saia lateral", "5x Nitro", "2x Nitro",
	"10x Nitro", "Race Scoop Hood", "Worx Scoop Hood", "Round Fog Lights", "Champ Spoiler",
	"Race Spoiler", "Worx Spoiler", "Left Saia lateral", "Upswept Escape", "Twin Escape",
	"Large Escape", "Medium Escape", "Small Escape", "Fury Spoiler", "Square Fog Lights",
	"Offroad Wheels", "Right Alien Saia lateral (Sultan)", "Left Alien Saia lateral (Sultan)",
	"Alien Escape (Sultan)", "X-Flow Escape (Sultan)", "Left X-Flow Saia lateral (Sultan)",
	"Right X-Flow Saia lateral (Sultan)", "Alien Respiradouro de telhado (Sultan)", "X-Flow Respiradouro de telhado (Sultan)",
	"Alien Escape (Elegy)", "X-Flow Respiradouro de telhado (Elegy)", "Right Alien Saia lateral (Elegy)",
	"X-Flow Escape (Elegy)", "Alien Respiradouro de telhado (Elegy)", "Left X-Flow Saia lateral (Elegy)",
	"Left Alien Saia lateral (Elegy)", "Right X-Flow Saia lateral (Elegy)", "Right Chrome Saia lateral (Broadway)",
	"Slamin Escape (Chrome)", "Chrome Escape (Broadway)", "X-Flow Escape (Flash)", "Alien Escape (Flash)",
	"Right Alien Saia lateral (Flash)", "Right X-Flow Saia lateral (Flash)", "Alien Spoiler (Flash)",
	"X-Flow Spoiler (Flash)", "Left Alien Saia lateral (Flash)", "Left X-Flow Saia lateral (Flash)",
	"X-Flow Roof (Flash)", "Alien Roof (Flash)", "Alien Roof (Stratum)", "Right Alien Saia lateral (Stratum)",
	"Right X-Flow Saia lateral (Stratum)", "Alien Spoiler (Stratum)", "X-Flow Escape (Stratum)",
	"X-Flow Spoiler (Stratum)", "X-Flow Roof (Stratum)", "Left Alien Saia lateral (Stratum)",
	"Left X-Flow Saia lateral (Stratum)", "Alien Escape (Stratum)", "Alien Escape (Jester)",
	"X-FLow Escape (Jester)", "Alien Roof (Jester)", "X-Flow Roof (Jester)", "Right Alien Saia lateral (Jester)",
	"Right X-Flow Saia lateral (Jester)", "Left Alien Saia lateral (Jester)", "Left X-Flow Saia lateral (Jester)",
	"Shadow Wheels", "Mega Wheels", "Rimshine Wheels", "Wires Wheels", "Classic Wheels", "Twist Wheels",
	"Cutter Wheels", "Switch Wheels", "Grove Wheels", "Import Wheels", "Dollar Wheels", "Trance Wheels",
	"Atomic Wheels", "Stereo System", "Hydraulics", "Alien Roof (Uranus)", "X-Flow Escape (Uranus)",
	"Right Alien Saia lateral (Uranus)", "X-Flow Roof (Uranus)", "Alien Escape (Uranus)",
	"Right X-Flow Saia lateral (Uranus)", "Left Alien Saia lateral (Uranus)", "Left X-Flow Saia lateral (Uranus)",
	"Ahab Wheels", "Virtual Wheels", "Access Wheels", "Left Chrome Saia lateral (Broadway)",
	"Chrome Grill (Remington)", "Left 'Chrome Flames' Saia lateral (Remington)",
	"Left 'Saia lateral de tira cromada (Savanna)", "Covertible (Blade)", "Chrome Escape (Blade)",
	"Slamin Escape (Blade)", "Right 'Chrome Arches' Saia lateral (Remington)",
	"Left 'Saia lateral de tira cromada (Blade)", "Right 'Saia lateral de tira cromada (Blade)",
	"Chrome Rear Bullbars (Slamvan)", "Slamin Rear Bullbars (Slamvan)", false, false, "Chrome Escape (Slamvan)",
	"Slamin Escape (Slamvan)", "Chrome Front Bullbars (Slamvan)", "Slamin Front Bullbars (Slamvan)",
	"Chrome Pára-choque dianteiro (Slamvan)", "Right 'Chrome Trim' Saia lateral (Slamvan)",
	"Right 'Wheelcovers' Saia lateral (Slamvan)", "Left 'Chrome Trim' Saia lateral (Slamvan)",
	"Left 'Wheelcovers' Saia lateral (Slamvan)", "Right 'Chrome Flames' Saia lateral (Remington)",
	"Bullbar Chrome Bars (Remington)", "Left 'Chrome Arches' Saia lateral (Remington)", "Bullbar Chrome Lights (Remington)",
	"Chrome Escape (Remington)", "Slamin Escape (Remington)", "Vinyl Hardtop (Blade)", "Chrome Escape (Savanna)",
	"Hardtop (Savanna)", "Softtop (Savanna)", "Slamin Escape (Savanna)", "Right 'Saia lateral de tira cromada (Savanna)",
	"Right 'Saia lateral de tira cromada (Tornado)", "Slamin Escape (Tornado)", "Chrome Escape (Tornado)",
	"Left 'Saia lateral de tira cromada (Tornado)", "Alien Spoiler (Sultan)", "X-Flow Spoiler (Sultan)",
	"X-Flow Pára-choque Traseiro (Sultan)", "Alien Pára-choque Traseiro (Sultan)", "Left Oval Vents", "Right Oval Vents",
	"Left Square Vents", "Right Square Vents", "X-Flow Spoiler (Elegy)", "Alien Spoiler (Elegy)",
	"X-Flow Pára-choque Traseiro (Elegy)", "Alien Pára-choque Traseiro (Elegy)", "Alien Pára-choque Traseiro (Flash)",
	"X-Flow Pára-choque Traseiro (Flash)", "X-Flow Pára-choque dianteiro (Flash)", "Alien Pára-choque dianteiro (Flash)",
	"Alien Pára-choque Traseiro (Stratum)", "Alien Pára-choque dianteiro (Stratum)", "X-Flow Pára-choque Traseiro (Stratum)",
	"X-Flow Pára-choque dianteiro (Stratum)", "X-Flow Spoiler (Jester)", "Alien Pára-choque Traseiro (Jester)",
	"Alien Pára-choque dianteiro (Jester)", "X-Flow Pára-choque Traseiro (Jester)", "Alien Spoiler (Jester)",
	"X-Flow Spoiler (Uranus)", "Alien Spoiler (Uranus)", "X-Flow Pára-choque dianteiro (Uranus)",
	"Alien Pára-choque dianteiro (Uranus)", "X-Flow Pára-choque Traseiro (Uranus)", "Alien Pára-choque Traseiro (Uranus)",
	"Alien Pára-choque dianteiro (Sultan)", "X-Flow Pára-choque dianteiro (Sultan)", "Alien Pára-choque dianteiro (Elegy)",
	"X-Flow Pára-choque dianteiro (Elegy)", "X-Flow Pára-choque dianteiro (Jester)", "Chrome Pára-choque dianteiro (Broadway)",
	"Slamin Pára-choque dianteiro (Broadway)", "Chrome Pára-choque Traseiro (Broadway)", "Slamin Pára-choque Traseiro (Broadway)",
	"Slamin Pára-choque Traseiro (Remington)", "Chrome Pára-choque dianteiro (Remington)", "Chrome Pára-choque Traseiro (Remington)",
	"Slamin Pára-choque dianteiro (Blade)", "Chrome Pára-choque dianteiro (Blade)", "Slamin Pára-choque Traseiro (Blade)",
	"Chrome Pára-choque Traseiro (Blade)", "Slamin Pára-choque dianteiro (Remington)", "Slamin Pára-choque Traseiro (Savanna)",
	"Chrome Pára-choque Traseiro (Savanna)", "Slamin Pára-choque dianteiro (Savanna)", "Chrome Pára-choque dianteiro (Savanna)",
	"Slamin Pára-choque dianteiro (Tornado)", "Chrome Pára-choque dianteiro (Tornado)", "Chrome Pára-choque Traseiro (Tornado)",
	"Slamin Pára-choque Traseiro (Tornado)"
}

--
-- Badges
--

function getBadges( )
	return {
		-- [itemID] = {elementData, name, factionIDs, color, iconID} iconID 1 = ID, 2 = badge
		-- old faction badges that existed since being inscribed on stone tablets thousands of years ago
		[156]  = { "Tribunal Superior de San Andreas ID", 		"um cartão de identificação do Tribunal Superior de San Andreas",			{[50] = true},				 	 {0, 102, 255}, 2},
		[64]  = { "Distintivo LSPD", 		"um distintivo da LSPD",			{[1] = true},				 	{0,100,255, true},	2},
		--[112]  = { "SAHP badge", 		"a SAHP badge",			{[59] = true},				 	{222, 184, 135, true},	2}, -- Sheriff department
		[65]  = { "Distintivo LSFD", 		"um distintivo da LSFD", {[2] = true},	    {175, 50, 50},	1},
		[86]  = { "Distintivo SAN",		"um cartão de identificação SAN",				{[20] = true},					{150,150,255},	1},
		[87]  = { "Distintivo GOV",		"um distintivo do Governo",		{[3] = true},					{0, 80, 0},	1},

		-- bandanas
		[122] = { "Bandana Azul Claro", "uma Bandana Azul Claro",				{[-1] = true},					{0,185,200},	122, bandana = true},
		[123] = { "Bandana Vermelha", "uma Bandana Vermelha",				{[-1] = true},					{190,0,0},	123, bandana = true},
		[124] = { "Bandana Amarela", "uma Bandana Amarela",				{[-1] = true},					{255,250,0},	124, bandana = true},
		[125] = { "Bandana Roxa", "uma Bandana Roxa",				{[-1] = true},					{220,0,255},	125, bandana = true},
		[135] = { "Bandana Azul", "uma Bandana Azul",				{[-1] = true},					{0,100,255},	135, bandana = true},
		[136] = { "Bandana Marrom", "uma Bandana Marrom",				{[-1] = true},					{125,63,50},	136, bandana = true},
		[158] = { "Bandana Verde", "uma Bandana Verde",				{[-1] = true},					{50,150,50},	158, bandana = true},
		[168] = { "Bandana Laranja", "uma Bandana Laranja",				{[-1] = true},					{210,105,30},	168, bandana = true},
		[237] = { "Bandana Preta", "uma Bandana Preta", {[-1] = true}, {0,0,0}, 215, bandana = true},
		[238] = { "Bandana Cinza", "uma Bandana Cinza", {[-1] = true}, {255,255,255}, 216, bandana = true},
		[239] = { "Bandana Branca", "uma Bandana Branca", {[-1] = true}, {100,100,100}, 217, bandana = true},

		-- newer faction badges
		[127] = { "LSIA Identification",		"a LSIA ID card",	{[47] = true},	{255,140,0},	1},
		[82] = { "Bureau of Traffic Services ID", "An ID from the Bureau of Traffic Services",	{[4] = true},	{255,136,0},	1}, --MAXIME | ADD TTR FACTION BAGDE ITEM | 24.1.14
		[159] = { "Sparta Inc. ID", "An ID from Sparta Inc.", {[212] = true},  {52, 152, 219}, 1}, -- anumaz, Cargo Group ID
		[180] = { "SAPT ID", "An ID from San Andreas Public Transport", {[64] = true},  {73, 136, 245}, 1}, -- Exciter
		[222] = { "LSMA ID", "an LSMA ID", {[130] = true}, {143, 52, 173}, 1},
		[229] = { "JGC ID", "a JGC ID", {[74] = true}, {178, 0, 0}, 1},
		[230] = { "RPMF Incorporated ID", "a RPMF Incorporated ID", {[78] = true}, {0, 69, 156}, 1},
		[233] = { "Department of Corrections ID Card", "DOC Badge", {[84] = true}, {11, 97, 11}, 2},
		[234] = { "United States Marine Corps ID Card", "USMCR ID", {[81] = true}, {41, 57, 8}, 2},
		[235] = { "Dinoco ID Card", "a Dinoco ID", {[147] = true}, {0, 240, 255}, 1},
		[236] = { "National Park Service ID Card", "National Park Serv. ID", {[86] = true}, {45, 74, 31}, 1},
		[241] = { "Sharp Towing ID", "a Sharp Towing ID", {[101] = true}, {189, 189, 189}, 1},
		[245] = { "Legal Corporation ID", "a Legal Corporation ID", {[99] = true}, {255, 127, 0}, 1},
		[246] = { "Bank of Los Santos ID", "a Bank of Los Santos ID", {[17] = true}, {144, 195, 212}, 1},
		[247] = { "Astro Corporation ID", "a Astro Corporation ID", {[91] = true}, {173, 151, 64}, 1},
		--[131] = { "LSCSD Badge", "a Los Santos County Sheriff's Deparment badge", {[1] = true, [142] = true}, {222, 184, 135, true},	2},
		[249] = { "Western Solutions ID", "a Western Solutions ID card", {[159] = true}, {255,215,0}, 1},
		[250] = { "St John Ambulance ID", "a St John Ambulance ID card", {[134] = true}, {0, 171, 23}, 1},
		[251] = { "Pizza Stack ID", "a Pizza Stack ID card", {[172] = true}, {255, 173, 51}, 1},
		[258] = { "Lamborghini Automotive ID", "a Lamborghini Automotive ID card", {[93] = true}, {10, 10, 10}, 1},
		[259] = { "SL Incorporated ID", "a SL Incorporated ID card", {[104] = true}, {66, 66, 66}, 1},
		[265] = { "Saint Ernest Medical Center Staff ID", "a Saint Ernest Medical Center Staff ID card", {[164] = true}, {255, 112, 229}, 1},
		[266] = { "SAAN Staff ID", "a San Andreas Action News ID card", {[145] = true}, {255, 156, 51}, 1},
		[241] = { "Red Rose Funeral Home ID", "a Red Rose Funeral Home ID card", {[210] = true}, {255, 153, 153}, 1}
	}
end

-- badges/IDs should generally be in the wallet.
for k, v in pairs(getBadges()) do
	if not v[3][-1] and g_items[k][3] ~= 10 then
		outputDebugString('Badge/ID' .. k .. ' is not in wallet.')
	end
end

--
-- Mask Data
--
function getMasks( )
	return {
		-- [itemID] = { elementData, textWhenPuttingOn, textWhentakingOff, hideIdentity }
		[26]  = {"gasmask",			"coloca uma máscara de gás preta no rosto",	"tira uma máscara de gás preta do rosto",	true},
		[56]  = {"mask",			"coloca uma máscara no rosto",				"tira uma máscara do rosto",				true},
		[90]  = {"helmet",			"coloca um #name sobre a cabeça",				"tira um #name de sua cabeça",				false},
		[120] = {"scuba",			"coloca equipamento de mergulho",				"takes scuba gear off",						true},
		[171] = {"bikerhelmet",		"coloca um #name sobre a cabeça",				"tira um #name de sua cabeça",				false},
		[172] = {"fullfacehelmet",	"coloca um #name sobre a cabeça",				"tira um #name de sua cabeça",				true},
		[240] = {"christmashat",	"coloca um #name em sua cabeça",				"tira um #name de sua cabeça",				false},
	}
end

replacedModelsWithWrongCollisionCheck = { [3915] = true }
