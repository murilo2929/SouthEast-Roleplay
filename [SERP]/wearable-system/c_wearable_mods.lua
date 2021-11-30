replaceModelMod = function()
  txd = engineLoadTXD("mods/helmet.txd")
  engineImportTXD(txd, 2053)
  dff = engineLoadDFF("mods/helmet.dff", 2053)
  engineReplaceModel(dff, 2053)
  txd2 = engineLoadTXD("mods/duffelbag.txd")
  engineImportTXD(txd2, 1550)
  dff2 = engineLoadDFF("mods/duffelbag.dff", 1550)
  engineReplaceModel(dff2, 1550)
  txd3 = engineLoadTXD("mods/backpack.txd")
  engineImportTXD(txd3, 3026)
  dff3 = engineLoadDFF("mods/backpack.dff", 3026)
  
  txd4 = engineLoadTXD("mods/bottle.txd")
  engineImportTXD(txd4, 1484)
  dff4 = engineLoadDFF("mods/bottle.dff", 1484)
  engineReplaceModel(dff4, 1484)
  
    -- txd31 = engineLoadTXD("mods/Bere1.txd")
  -- engineImportTXD(txd31, 1906)
  -- dff31 = engineLoadDFF("mods/Bere1.dff", 1906)
  -- engineReplaceModel(dff31, 1906)
  -- setObjectScale ( dff31, 0.5)
  
  -- masks
  txd6 = engineLoadTXD("mods/mask1.txd")
  engineImportTXD(txd6, 2374)
  dff6 = engineLoadDFF("mods/mask1.dff", 2374)
  engineReplaceModel(dff6, 2374)
  txd7 = engineLoadTXD("mods/mask2.txd")
  engineImportTXD(txd7, 2396)
  dff7 = engineLoadDFF("mods/mask2.dff", 2396)
  engineReplaceModel(dff7, 2396)
  txd8 = engineLoadTXD("mods/mask3.txd")
  engineImportTXD(txd8, 2397)
  dff8 = engineLoadDFF("mods/mask3.dff", 2397)
  engineReplaceModel(dff8, 2397)
  txd9 = engineLoadTXD("mods/mask4.txd")
  engineImportTXD(txd9, 2398)
  dff9 = engineLoadDFF("mods/mask4.dff", 2398)
  engineReplaceModel(dff9, 2398)
  txd10 = engineLoadTXD("mods/mask5.txd")
  engineImportTXD(txd10, 2399)
  dff10 = engineLoadDFF("mods/mask5.dff", 2399)
  engineReplaceModel(dff10, 2399)
  txd11 = engineLoadTXD("mods/mask6.txd")
  engineImportTXD(txd11, 2407)
  dff11 = engineLoadDFF("mods/mask6.dff", 2407)
  engineReplaceModel(dff11, 2407)
  
  --glasses
  txd20 = engineLoadTXD("mods/glasses03blue.txd")
  engineImportTXD(txd20, 1900)
  dff20 = engineLoadDFF("mods/glasses03blue.dff", 1900)
  engineReplaceModel(dff20, 1900) 
  
  txd56 = engineLoadTXD("mods/glasses03red.txd")
  engineImportTXD(txd56, 1899)
  dff56 = engineLoadDFF("mods/glasses03red.dff", 1899)
  engineReplaceModel(dff56, 1899)
  
   txd21 = engineLoadTXD("mods/polissapka.txd")
  engineImportTXD(txd21, 1242)
  dff21 = engineLoadDFF("mods/polissapka.dff", 1242)
  engineReplaceModel(dff21, 1242)
  
  -- bandanas
  dff12 = engineLoadDFF("bandana/bandknot.dff", 2382)
  engineReplaceModel(dff12, 2382, true)
  txd13 = engineLoadTXD("bandana/bandefault.txd")
  engineImportTXD(txd13, 2382)
  dff14 = engineLoadDFF("bandana/bandmask.dff", 2392)
  engineReplaceModel(dff14, 2392, true)
  txd14 = engineLoadTXD("bandana/bandefault.txd")
  engineImportTXD(txd14, 2392)
  dff15 = engineLoadDFF("bandana/bandhead.dff", 2377)
  engineReplaceModel(dff15, 2377, true)
  txd15 = engineLoadTXD("bandana/bandefault.txd")
  engineImportTXD(txd15, 2377)
  
end

-- function SirenLoad()
    -- txd31 = engineLoadTXD("mods/Bere1.txd")
  -- engineImportTXD(txd31, 1906)
  -- dff31 = engineLoadDFF("mods/Bere1.dff", 1906)
  -- engineReplaceModel(dff31, 1906)
  -- setObjectScale ( dff31, 0.5)
-- end
-- addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), SirenLoad)

function applyTexture(resource, data)
	if type(data) ~= "table" then
		for _, player in ipairs(getElementsByType("player")) do
			if type(getElementData(player, "item:texture")) == "table" then
				local data = getElementData(player, "item:texture")
				local object = data[1]; local btype = data[2]
				if isElement(object) then
					local shader, tec = dxCreateShader ( "textures/texreplace.fx" )
					local tex = dxCreateTexture ( "textures/".. btype ..".png")
					engineApplyShaderToWorldTexture ( shader, "bandknot", object )
					engineApplyShaderToWorldTexture ( shader, "glassestype17map", object )
					dxSetShaderValue ( shader, "gTexture", tex )
				end
			end
		end
	end
	
	if type(data) == "table" then
		local object = data[1]
		local btype = data[2]
		--outputChatBox("APPLY TEXTURE CLIENT")

		local shader, tec = dxCreateShader ( "textures/texreplace.fx" )
		local tex = dxCreateTexture ( "textures/".. btype ..".png")
		engineApplyShaderToWorldTexture ( shader, "bandknot", object )
		engineApplyShaderToWorldTexture ( shader, "glassestype17map", object )
		dxSetShaderValue ( shader, "gTexture", tex )
	end
end

addEventHandler("accounts:characters:spawn", getRootElement(), applyTexture)
addEvent("wearable-system:applyTexture", true)
addEventHandler("wearable-system:applyTexture", getRootElement(), applyTexture)

setTimer(replaceModelMod, 2000, 1)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), replaceModelMod)

