
-- Furzy weapons system.

armas = {
{"M4A1",2726},  -- Weapon, Object
{"M4A3 CCO",1730},
{"ar15Laser",1882},
{"FN FAL",2644},
{"M4A1 CCO SD",1822},

-------Taco de Baseball
{"Taco Madeira",1866},

----DESERT
{"1920",1868},
{"Desert",1869}, --GOLD
{"revolvergold",1871},-- gold
{"glockpd",1872},
{"berreta93r",1934},

----UZI
{"uzigol",1870}, --GOLD
{"uzibet",1769},
{"uzipadrao",1924},

----MP5
{"mp7",1940},
{"hekmp5",1881},
}

addEvent('arma:update', true)

--[[function Pickup ()
    takeAllWeapons(source)
    local x,y,z = getElementPosition(source)
	local weapon = getElementData(source,"cweapon")
	for k,v in ipairs(armas) do 
	    if weapon == v[1] then
        giveWeapon(source,31,999999)
		end
    end 
end	

addEvent("pckp",true)
addEventHandler("pckp",getRootElement(),Pickup)]]


elementWeaponRaplace = {}
function weaponReplace(previousWeaponID,currentWeaponID)
  local weapon = getElementData(source,"cweapon")
  if not weapon then return end
  local x,y,z = getElementPosition(source)
  local rx,ry,rz = getElementRotation(source)
  local dim = getElementDimension(source)
  local int = getElementInterior(source)
        if previousWeaponID and getPedWeaponSlot(source) == 0 then
            if elementWeaponRaplace[source]then
					exports.lsrp_pAttach:detach(elementWeaponRaplace[source])
                    destroyElement(elementWeaponRaplace[source])
                    elementWeaponRaplace[source] = false
                end
	        for id,item in ipairs(armas)do
	        if weapon == item[1] then
		        elementWeaponRaplace[source] = createObject(item[2],x,y,z)
		    --setObjectScale(elementWeaponRaplace[source],0.825)
			setObjectScale(elementWeaponRaplace[source],1)
			setElementDimension(elementWeaponRaplace[source], dim)
			setElementInterior(elementWeaponRaplace[source], int) 
	    end
	end
	exports.lsrp_pAttach:attach(elementWeaponRaplace[source], source, 24, 0, 0, 0, 0, 0, 0)
        elseif currentWeaponID and getPedWeaponSlot(source) == 5 or getPedWeaponSlot(source) == 1 or getPedWeaponSlot(source) == 2 or getPedWeaponSlot(source) == 4 then
			exports.lsrp_pAttach:detach(elementWeaponRaplace[source])
	            if elementWeaponRaplace[source] then
	            destroyElement(elementWeaponRaplace[source])
	        end
	    elementWeaponRaplace[source] = false
			setElementData(source,"cweapon", false)
	end
end

addEventHandler("onPlayerWeaponSwitch", getRootElement(), weaponReplace)

addEventHandler('arma:update', root,
function(player, newInt, newDim) --This is used by the client-side int/dim change check, to update the int/dim of all attached weapons when player changes int/dim
    local weapon = getElementData(player,"cweapon")
	if elementWeaponRaplace[player] then
		for id,item in ipairs(armas) do
			if weapon == item[1] then
				setElementInterior(elementWeaponRaplace[player], newInt)
				setElementDimension(elementWeaponRaplace[player], newDim)
			end
		end
	end
end)


function removeQuit()
  if elementWeaponRaplace[source] then
	exports.lsrp_pAttach:detach(elementWeaponRaplace[source])
	destroyElement(elementWeaponRaplace[source])
	elementWeaponRaplace[source] = false
  end
end


addEventHandler("onPlayerQuit",getRootElement(),removeQuit)
addEventHandler("onPlayerWasted",getRootElement(),removeQuit)


function giveNewWeapon(player,wep)
	if not player or getElementType(player) ~= "player" then return false end 
	local weapon = getElementData(player, "cweapon")
	local ammoinclip = getElementData(player, "balas-fuzil")
    if type(wep) == "string" then
	giveWeapon(player,31,ammoinclip)
	setElementData(player,"cweapon",wep)
    return true
	end
end

function giveNewWeaponTaco(player,wep)
	if not player or getElementType(player) ~= "player" then return false end 
	local weapon = getElementData(player, "cweapon")
    if type(wep) == "string" then
	giveWeapon(player, 5, 1)
	setElementData(player,"cweapon",wep)
    return true
	end
end

function giveNewWeaponDesert(player,wep)
	if not player or getElementType(player) ~= "player" then return false end 
	local weapon = getElementData(player, "cweapon")
	local ammoinclip = getElementData(player, "balas-pistola")
    if type(wep) == "string" then
	giveWeapon(player, 24, ammoinclip)
	setElementData(player,"cweapon",wep)
    return true
	end
end

function giveNewWeaponUZI(player,wep)
	if not player or getElementType(player) ~= "player" then return false end 
	local weapon = getElementData(player, "cweapon")
	local ammoinclip = getElementData(player, "balas-submetralhadora")
    if type(wep) == "string" then
	giveWeapon(player, 28, ammoinclip)
	setElementData(player,"cweapon",wep)
    return true
	end
end

function giveNewWeaponMP5(player,wep)
	if not player or getElementType(player) ~= "player" then return false end 
	local weapon = getElementData(player, "cweapon")
	local ammoinclip = getElementData(player, "balas-submetralhadora")
    if type(wep) == "string" then
	giveWeapon(player, 29, ammoinclip)
	setElementData(player,"cweapon",wep)
    return true
	end
end


		
		
		
		
function loadweapon1(conta)
	if conta then
	local source = getAccountPlayer(conta)
	local emp = getElementData ( source, "cweapon" ) or false
	setAccountData ( conta, "cweapon", false )
	end	
end

--[[function loadweapon(conta)
	if not (isGuestAccount (conta)) then
		if (conta) then	
			local source = getAccountPlayer(conta)	
			local emp = getAccountData ( conta, "cweapon" ) or false
			setElementData ( source, "cweapon", false )
		end
	end	
end]]

--[[addEventHandler("onPlayerLogin", root,
  function( _, acc )
	setTimer(loadweapon,50,1,acc)
  end
)]]


function sair ( quitType )
	local acc = getPlayerAccount(source)
	if not (isGuestAccount (acc)) then
		if acc then
			loadweapon1(acc)
		end
	end
end
addEventHandler ( "onPlayerQuit", getRootElement(), sair )
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
