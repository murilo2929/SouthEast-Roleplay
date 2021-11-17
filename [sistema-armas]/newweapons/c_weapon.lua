

--made by furzy

armas = {
{"M4A1",2726},  -- Weapon, Object
{"M4A3 CCO",1730},
{"ar15Laser",1882},
{"FN FAL",2644},
{"M4A1 CCO SD",2646},
-------Taco de Baseball
{"Taco Madeira",1866},

----DESERT
{"1920",1868},
{"Desert",1869}, --GOLD
{"revolvergold",1871}, --gold
{"glockpd",1872},
{"berreta93r",1934},

----UZI
{"uzigol",1870},--GOLD
{"uzibet",1769},
{"uzipadrao",1924},

----MP5
{"mp7",1940},
{"hekmp5",1881},
}

-- 336 = Taco de Baseball
-- 356 = M4
-- 348 = Desert
-- 352 = UZI
-- 353 = MP5
weapsIDs = {356, 336, 348, 352, 353}
for i,weapID in pairs(weapsIDs)do
  txd = engineLoadTXD("models/None.txd",weapID)
  engineImportTXD(txd,weapID)
  dff = engineLoadDFF("models/None.dff",weapID)
  engineReplaceModel(dff,weapID)
end

for i,weaponData in pairs(armas) do
  file = weaponData[1]:gsub(' ','')
	if fileExists("models/"..file..".txd") and fileExists("models/"..file..".dff")then
	  txd = engineLoadTXD("models/"..file..".txd",weaponData[2])
	  engineImportTXD(txd,weaponData[2])
	  dff = engineLoadDFF("models/"..file..".dff",weaponData[2])
	  engineReplaceModel(dff,weaponData[2])
	else
	  outputChatBox("ERROR: models/"..file)
	end
end


local currentInterior, currentDimension = 0, 0
local localPlayer = getLocalPlayer()
local root = getRootElement()

function doCheckarma() 
	local newInterior, newDimension = getElementInterior(localPlayer), getElementDimension(localPlayer)
	if currentInterior ~= newInterior or currentDimension ~= newDimension then
		triggerServerEvent('arma:update', root, localPlayer, newInterior, newDimension)
		currentInterior, currentDimension = newInterior, newDimension
	end
end
addEventHandler('onClientPreRender', root, doCheckarma)

function playerJoined()
    local Variavel_1 = isWorldSoundEnabled ( 5 ) -- Colocamos esta variável aqui para verificar.
    setWorldSoundEnabled ( 5, not Variavel_1 ) -- E aqui a alternância acontece.
end
addEvent("playerJoined",true)
addEventHandler("playerJoined",getRootElement(),playerJoined)

function PlaySound(ID)
  wpn1 = getElementData(source,"cweapon")
  x,y,z = getPedWeaponMuzzlePosition(source)
  for _,weap in pairs(armas)do
      soundName = weap[1]:gsub(' ','')
      if wpn1 == weap[1] then
	  if not fileExists("Sounds/Primary/"..soundName..".wav")then return end
	  sound = playSound3D("Sounds/Primary/"..soundName..".wav",x,y,z, false)
	  setSoundMaxDistance(sound,200)
	end
  end
end
addEventHandler("onClientPlayerWeaponFire",root,PlaySound)

-- GUI PART


GUIEditor = {
    gridlist = {},
    window = {}
}


GUIEditor.window[1] = guiCreateWindow(0.21, 0.36, 0.18, 0.36, "NEW WEAPONS", true)
guiWindowSetSizable(GUIEditor.window[1], false)
guiSetVisible(GUIEditor.window[1], false)

GUIEditor.gridlist[1] = guiCreateGridList(0.06, 0.12, 0.87, 0.85, true, GUIEditor.window[1])
guiGridListAddColumn(GUIEditor.gridlist[1], "ARMAS", 0.9)
for data,item in pairs(armas) do 
for i = 0, data do
     guiGridListAddRow(GUIEditor.gridlist[1])
end
guiGridListSetItemText(GUIEditor.gridlist[1], data, 1, item[1], false, false)
end



--[[function guiOpen() 
if (guiGetVisible(GUIEditor.window[1]) == true) then
guiSetVisible(GUIEditor.window[1], false)
showCursor(false) 
else 
guiSetVisible(GUIEditor.window[1], true) 
showCursor(true)
end 
end 
bindKey("F2", "down", guiOpen)]]


--[[function click ( button, state, sx, sy, x, y, z, elem, gui )
            if ( guiGridListGetSelectedItem ( GUIEditor.gridlist[1] ) ) then
                local getwep = guiGridListGetSelectedItemText ( GUIEditor.gridlist[1] )
				for data,item in ipairs(armas) do 
				    setElementData(getLocalPlayer(),"cweapon",getwep)
                    triggerServerEvent("pckp",getLocalPlayer())
				end
        end
end

addEventHandler ( "onClientGUIClick", GUIEditor.gridlist[1], click )]]


function guiGridListGetSelectedItemText ( gridList, column )
    local item = guiGridListGetSelectedItem ( gridList )
    
    if item then
        return guiGridListGetItemText ( gridList, item, column or 1 )
    end

    return false
end


--[[addEventHandler("onClientRender", root,
	function ()
		local currentWeapon = getElementData(localPlayer, "cweapon")
		dxDrawText("Current weapon: "..currentWeapon, 10, 200)
	end
)]]