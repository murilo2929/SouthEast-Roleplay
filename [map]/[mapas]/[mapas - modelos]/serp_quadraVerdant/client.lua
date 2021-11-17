

addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('freeway_las.txd',true)
engineImportTXD(txd, 4872)
local dff = engineLoadDFF('laroads_042e_las.dff', 0)
engineReplaceModel(dff, 4872)
local col = engineLoadCOL('laroads_042e_las.col')
engineReplaceCOL(col, 4872)
engineSetModelLODDistance(4872, 500)
end)
