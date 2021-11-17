
addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('railway_las.txd',true)
engineImportTXD(txd, 4873)
local dff = engineLoadDFF('unionstwarc2_las.dff', 0)
engineReplaceModel(dff, 4873)
local col = engineLoadCOL('unionstwarc2_las.col')
engineReplaceCOL(col, 4873)
engineSetModelLODDistance(4873, 500)
end)
