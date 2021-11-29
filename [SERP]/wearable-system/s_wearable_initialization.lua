rootTable = {
    table1 = { },
    table2 = { },
    table3 = { },
	table4 = { },
	table5 = { 
	[1] = "helmets", [2] = "briefcase", [3] =  "duffelbag", [4] = "backpack", [5] = "briefcaseleft", [6] = "duffelleft", [7] = "bottle", [8] = "normaldrink", [9] = "food", [10] = "eaten", [11] = "drank", [12] = "drinkitem", [13] = "fooditem", [14] = "hunger", [15] = "thirst", [16] = "deleteduffel", [17] = "twoduffelbag", [18] = "briefdestroyed", [19] = "deletebrief", [20] = "twobriefcase", [21] = "briefdestroyed", [22] = "dufleft", [23] = "briefleft", [24] = "weaponenabled", [25] = "hud:backpack"
	},
	table6 = {},
	table7 = {},
	table8 = {},
	table9 = {},
	table10 = {}
}

helmets = rootTable.table1
briefcase = rootTable.table2
duffelbag = rootTable.table3
backpack = rootTable.table4
bottle = rootTable.table6
food = rootTable.table7
duffelbag2 = rootTable.table8
briefcase2 = rootTable.table9
newitems = rootTable.table10
masks = exports['item-system']:getMasks()
mysql = exports.mysql

-- functions for the element data

function getElementDataEx(theElement, theParameter)
	return getElementData(theElement, theParameter)
end

function setElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	if syncToClient == nil then
		syncToClient = false
	end
	
	if noSyncAtall == nil then
		noSyncAtall = false
	end
	
	if tonumber(theValue) then
		theValue = tonumber(theValue)
	end
	
	exports.anticheat:changeProtectedElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	return true
end

-- function to return a true value to everything in the table

function trueCheck (dataList)
  local trueCheck = {}
  for _, i in ipairs(dataList) do trueCheck[i] = true end
  return trueCheck
end

drinktable = trueCheck { 9, 15, 58, 62, 63 }
foodtable = trueCheck { 1, 8, 11, 12, 13, 14, 59, 91, 92, 93, 94, 99, 102, 108, 109, 110}
skins = trueCheck {9, 10, 11, 14, 15, 16, 17, 18, 19, 20, 21, 24, 25, 26, 28, 30, 32, 39, 44, 45, 46, 47, 48, 49, 53, 54, 57, 58, 59, 60, 61, 62, 64, 66, 67, 68, 70, 71, 72, 73, 75, 78, 79, 80, 81, 85, 87, 88, 90, 95, 96, 98, 100, 102, 106, 108, 109, 110, 111, 112, 113, 114, 115, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 133, 134, 135, 136, 142, 146, 147, 153, 154, 159, 160, 162, 163, 164, 165, 166, 168, 170, 174, 175, 176, 179, 180, 182, 183, 184, 185, 186, 187, 188, 196, 199, 202, 204, 205 --[[ LOL]], 206, 207, 209, 210, 212, 213, 217, 218, 221, 222, 223, 227, 228, 229, 232, 236, 238, 239, 243, 244, 247, 250, 253, 254, 257, 258, 261, 262, 265, 266, 267, 268, 272, 274, 275, 276, 280, 281, 282, 285, 286, 287, 292, 294, 295, 301, 302, 303, 305, 306, 307, 308, 309, 312}
skinsfix = trueCheck {1, 172, 197, 240, 252, 259, 271, 290, 291, 296, 297, 299, 300, 310}
backpacknormal = trueCheck {10, 11, 12, 13, 14, 15, 16, 18, 19, 30, 31, 32, 33, 34, 38, 39, 40, 41, 43, 44, 45, 49, 51, 52, 53, 54, 55, 56, 57, 58, 60, 63, 64, 66, 67, 69, 75, 76, 77, 80, 81, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 98, 99, 101, 103, 105, 109, 110, 111, 112, 113, 117, 118, 124, 127, 129, 130, 131, 132, 134, 136, 137, 138, 139, 140, 141, 145, 146, 148, 150, 151, 152, 154, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 169, 172, 174, 178, 181, 182, 188, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 201, 205, 207, 209, 210, 211, 212, 214, 215, 216, 217, 218, 224, 225, 226, 227, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 242, 243, 244, 245, 246, 251, 252, 253, 256, 257, 258, 259, 261, 263, 264, 265, 266, 267, 269, 270, 272, 274, 275, 276, 277, 278, 279, 280, 281, 282, 283, 284, 285, 286, 287, 288, 292, 293, 294, 295, 296, 298, 299, 302, 304, 311}