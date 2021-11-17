-- Generated using GM2MC ( GTA:SA Models To MTA:SA Converter ) by SoRa

addEventHandler('onClientResourceStart',resourceRoot,function () 

--------- MASCULINAS
	txd = engineLoadTXD( '[LSPD]/masculina/GED/gedM1.txd' ) 
	engineImportTXD( txd, 280 ) 
	dff = engineLoadDFF('[LSPD]/masculina/GED/gedM1.dff', 280) 
	engineReplaceModel( dff, 280 )
	txd = engineLoadTXD( '[LSPD]/masculina/GED/gedM2.txd' ) 
	engineImportTXD( txd, 281 ) 
	dff = engineLoadDFF('[LSPD]/masculina/GED/gedM2.dff', 281) 
	engineReplaceModel( dff, 281 )

	txd = engineLoadTXD( '[LSPD]/masculina/MARY/maryM1.txd' ) 
	engineImportTXD( txd, 282 ) 
	dff = engineLoadDFF('[LSPD]/masculina/MARY/maryM1.dff', 282) 
	engineReplaceModel( dff, 282 )

	txd = engineLoadTXD( '[LSPD]/masculina/PATROL/patrolM1.txd' ) 
	engineImportTXD( txd, 283 ) 
	dff = engineLoadDFF('[LSPD]/masculina/PATROL/patrolM1.dff', 283) 
	engineReplaceModel( dff, 283 )
	txd = engineLoadTXD( '[LSPD]/masculina/PATROL/patrolM2.txd' ) 
	engineImportTXD( txd, 284 ) 
	dff = engineLoadDFF('[LSPD]/masculina/PATROL/patrolM2.dff', 284) 
	engineReplaceModel( dff, 284 ) 

---------- FEMININAS
	txd = engineLoadTXD( '[LSPD]/feminina/GED/gedF1.txd' ) 
	engineImportTXD( txd, 286 ) 
	dff = engineLoadDFF('[LSPD]/feminina/GED/gedF1.dff', 286) 
	engineReplaceModel( dff, 286 )
	txd = engineLoadTXD( '[LSPD]/feminina/GED/gedF2.txd' ) 
	engineImportTXD( txd, 288 ) 
	dff = engineLoadDFF('[LSPD]/feminina/GED/gedF2.dff', 288) 
	engineReplaceModel( dff, 288 )

	txd = engineLoadTXD( '[LSPD]/feminina/MARY/maryF1.txd' ) 
	engineImportTXD( txd, 265 ) 
	dff = engineLoadDFF('[LSPD]/feminina/MARY/maryF1.dff', 265) 
	engineReplaceModel( dff, 265 )

	txd = engineLoadTXD( '[LSPD]/feminina/PATROL/patrolF1.txd' ) 
	engineImportTXD( txd, 266 ) 
	dff = engineLoadDFF('[LSPD]/feminina/PATROL/patrolF1.dff', 266) 
	engineReplaceModel( dff, 266 )
	txd = engineLoadTXD( '[LSPD]/feminina/PATROL/patrolF2.txd' ) 
	engineImportTXD( txd, 267 ) 
	dff = engineLoadDFF('[LSPD]/feminina/PATROL/patrolF2.dff', 267) 
	engineReplaceModel( dff, 267 )


	txd = engineLoadTXD( '[LSPD]/swat6branco.txd' ) 
	engineImportTXD( txd, 285 ) 
	dff = engineLoadDFF('[LSPD]/swat6branco.dff', 285) 
	engineReplaceModel( dff, 285 )
	txd = engineLoadTXD( '[LSPD]/swat6negro.txd' ) 
	engineImportTXD( txd, 287 ) 
	dff = engineLoadDFF('[LSPD]/swat6negro.dff', 287) 
	engineReplaceModel( dff, 287 )
end)
