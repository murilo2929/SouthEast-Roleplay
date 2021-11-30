local intdim = {}
local done = false
function wearableIntDim ()
    local dim = getElementDimension(localPlayer)
    local int = getElementInterior(localPlayer)
	local logged = getElementData(localPlayer, "loggedin")
		
	if not (logged==1) then
		return
	end
	
	if (done == false) then
		local table = {dim, int}
		intdim[localPlayer] = table
		done = true
	end
	 
	if (done == true) then
		local dim2 = intdim[localPlayer][1]
		local int2 = intdim[localPlayer][2]
		if (dim2 ~= dim or int2 ~= int) then
			local table = {dim, int}
			intdim[localPlayer] = table
			setTimer(function()
				triggerServerEvent("wearableCheckDimension", localPlayer, localPlayer, dim, int)
			end, 250, 1)
			
			wearable_update_dimension(dim, int)
			--outputDebugString(dim .. " - " .. int)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), wearableIntDim)

function tempCheck()
	removeEventHandler("onClientRender", localPlayer, wearableIntDim)
	setTimer(function()
		-- temp check to prevent some errors
		addEventHandler("onClientRender", localPlayer, wearableIntDim)
	end, 2500 , 1)
end
addEvent("errorCheck", true)
addEventHandler("errorCheck", getRootElement(), tempCheck)

-- function attachBackpack()
	-- triggerServerEvent("attachBackpackServer", localPlayer, localPlayer)
-- end
-- addEventHandler("accounts:characters:spawn", getRootElement(), attachBackpack)

function trueCheck (dataList)
  local trueCheck = {}
  for _, i in ipairs(dataList) do trueCheck[i] = true end
  return trueCheck
end

local weapons = trueCheck {0, 22, 24, 28, 32, 26}
function disableGun (prevSlot, newSlot)
	gunID = getPedWeapon (localPlayer, newSlot)	
	if (getElementData(localPlayer, "duffelbag") == 1 or getElementData(localPlayer, "briefcase") == 1 or getElementData(localPlayer, "food") == 1 or getElementData(localPlayer, "bottle") == 1) then
		if (getElementData(localPlayer, "weaponenabled") == 1) then
			if (getElementData(localPlayer, "duffelbag") == 1) then
				if (getElementData(localPlayer, "briefcase") == 1) then setPedWeaponSlot(getLocalPlayer(),prevSlot) return end
				if not weapons[gunID] then
					setPedWeaponSlot(getLocalPlayer(),prevSlot)
				end
			elseif (getElementData(localPlayer, "briefcase") == 1) then
				if (getElementData(localPlayer, "duffelbag") == 1) then setPedWeaponSlot(getLocalPlayer(),prevSlot) return end
				if not weapons[gunID] then
					setPedWeaponSlot(getLocalPlayer(),prevSlot)
				end
			end
		else
			setPedWeaponSlot(getLocalPlayer(),prevSlot)
		end
	end
end
addEventHandler ( "onClientPlayerWeaponSwitch", localPlayer, disableGun )

--outputChatBox ("| #E02020This server is using: #FFFFFFFusionz's wearable-system | #E02020Author: #FFFFFFFusionz | #E02020Version: #FFFFFF0.5.7 alpha |", 255, 255, 255, true)