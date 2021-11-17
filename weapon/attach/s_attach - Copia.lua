--[[
	attach.lua
	Allows players to attach weapon models to their bones
]]


--[[
	Event createWeaponModel
	Creates a weapon model attached to the ped's bone, synced through clients.

	@param weapon - the GTASA weapon ID of the weapon to be attached
	@param bone   - bone ID to attach the weapon model to, refer to resource bone_attach
	@param x      - the x-offset of the weapon from the bone
	@param y      - the y-offset of the weapon from the bone
	@param z      - the z-offset of the weapon from the bone
	@param rx     - angle of the weapon with respect to the x-axis
	@param ry     - angle of the weapon with respect to the y-axis
	@param rz     - angle of the weapon with respect to the z-axis
]]
armas = {
{"M4A1",2726},  -- Weapon, Object
{"M4A3 CCO",1730},
{"ar15Laser",1882},
{"FN FAL",2644},
{"M4A1 CCO SD",2646},
-------Taco de Baseball
{"PICARETA",1866},
{"PICARETAPREMIUM",1867},

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
{"mp7",1902},
{"hekmp5",1881},
}

addEvent("createWeaponModel", true)
addEventHandler("createWeaponModel", root,
	function (weapon, bone, x, y, z, rx, ry, rz)
		local slot = getSlotFromWeapon(weapon)
		local weapons = getElementData(source,"cweapon")

		if slot == 0 then
			return
		end

		-- Try destroying the weapon model if it already exists
		triggerEvent("destroyWeaponModel", source, weapon)

		for id,item in ipairs(armas)do
			if weapons == item[1] then
				local object = createObject(item[2],x,y,z)
				setElementCollisionsEnabled(object, false)
				setElementInterior(object, getElementInterior(source))
				setElementDimension(object, getElementDimension(source))
				exports.bone_attach:attachElementToBone(object, source, bone, x, y, z, rx, ry, rz)
				setElementData(object, "weaponID", weapon)
			end
		end

		if getPedOccupiedVehicle(source) then
			setElementAlpha(object, 0)
		end

		-- each weapon model holds their GTASA weapon ID
		--setElementData(object, "weaponID", weapon)

		setElementData(source, "attachedSlot" .. slot, object)
	end
)

--[[
	Event destroyWeaponModel
	Destroys an attached weapon model from, synced through clients.

	@param weapon - the GTASA weapon ID associated with the model to be destroyed
]]
addEvent("destroyWeaponModel", true)
addEventHandler("destroyWeaponModel", root,
	function (weapon)
		local slot = getSlotFromWeapon(weapon)
		local object = getElementData(source, "attachedSlot" .. slot)

		if isElement(object) then
			local id = getElementData(object, "weaponID")

			if id == weapon then
				destroyElement(object)
				setElementData(source, "attachedSlot" .. slot, false)
			end
		end
	end
)

--[[
	Method destroyAllWeaponModels
	Destroys all weapon models attached to a player.
]]
function destroyAllWeaponModels()
	for i = 1, 12 do
		local object = getElementData(source, "attachedSlot" .. i)

		if isElement(object) then
			destroyElement(object)
			setElementData(source, "attachedSlot" .. i, false)
		end
	end
end
addEventHandler("accounts:characters:change", root, destroyAllWeaponModels)
addEventHandler("accounts:characters:logout", root, destroyAllWeaponModels)
addEventHandler("onPlayerQuit", root, destroyAllWeaponModels)

-- FIXME: Use setElementAlpha() to show and hide the weapon models
addEventHandler("onPlayerVehicleEnter", root, destroyAllWeaponModels)

--[[
	Event alphaWeaponModel

	@param weapon - the GTASA weapon ID associated with the model to set alpha value of
	@param hide   - whether the weapon model will be hidden or not
]]
addEvent("alphaWeaponModel", true)
addEventHandler("alphaWeaponModel", root,
	function (weapon, hide)
		local object = getElementData(source, "attachedSlot" .. getSlotFromWeapon(weapon))

		-- FIXME: Replace this with setElementAlpha. This was used as a temporary solution
		-- to make it work in Eloquent's development server when setElementAlpha didn't work.
		if isElement(object) then
			destroyElement(object)
		end
	end
)

-- Handle inventory related changes to update models
addEventHandler("updateLocalGuns", root,
	function()
		for i = 1, 12 do
			local object = getElementData(source, "attachedSlot" .. i)

			if isElement(object) then
				local id = getElementData(object, "weaponID")

				if getPedWeapon(source, i) ~= id then
					destroyElement(object)
					setElementData(source, "attachedSlot" .. i, false)
				end
			end
		end
	end
)