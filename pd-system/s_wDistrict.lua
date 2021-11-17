addEvent("weaponDistrict:doDistrict", true)

function weaponDistrict_doDistrict(name)
	exports["chat-system"]:districtIC(client, _, "Você ouve uma série de altos tiros de " .. name .. " ecoando pela vizinhança")
end

addEventHandler("weaponDistrict:doDistrict", root, weaponDistrict_doDistrict)