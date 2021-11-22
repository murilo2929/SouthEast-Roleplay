--MAXIME
local gvn = getVehicleName
function getVehicleName(theVehicle)
	if not theVehicle or (getElementType(theVehicle) ~= "vehicle") then
		return "?"
	end
	local name = "?"

	local model = getElementModel(theVehicle)
	local customID = tonumber(getElementData(theVehicle, exports.newmodels:getDataNameFromType("vehicle")))
	if customID then
		local isCustom,mod = exports.newmodels:isCustomModID(customID)
		if mod then
			name = mod.name
		end
	else
		name = gvn(theVehicle)
	end

	-- mostra-so so o MTA Model Name ou Custom Model Name
	return name
end