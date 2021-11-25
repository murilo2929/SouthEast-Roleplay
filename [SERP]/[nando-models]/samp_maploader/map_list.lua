--[[
	map_list.lua

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
		autoload = true,

    	name = "INT Prisao", path = "maps/prisao.pwn",
    	int = 18, dim = 25, pos = {  961.9951171875, 926.3984375, 1001.0100097656 }, -- se bem q isto n serve pra nada kkk a n ser q vc quiser fazer /gotomap
	},
}