--[[
	List of maps to load on startup
	Required settings for each map:
	
	 - id: unique ID
	 - autoload: load map on startup or not
	 - name: custom name
	 - path: map file path
	 - int: interior world of the objects
	 - dim: dimensiom world of the objects
	 - pos: x,y,z teleport position

	If you get any of these settings wrong, the server will tell you upon starting the resource
]]


mapList = {
    {
    	id = 1,
		autoload = false,

    	name = "Office", path = "samp_maps/maps/office.pwn",
    	int = 1, dim = 2, pos = { 1928.7041015625, -343.6083984375, 50.75 },
	},
    {
    	id = 2,
		autoload = false,

    	name = "Mansion", path = "samp_maps/maps/mansion.pwn",
    	int = 1, dim = 3, pos = { 1395.462891,-17.192383,1001 },
	},
    {
    	id = 3,
		autoload = true,
		
    	name = "Presidio Twins", path = "samp_maps/maps/presidiotwins.pwn",
    	int = 18, dim = 25, pos = { 963.1025390625, 926.1123046875, 1001.0100097656 },
	},
}