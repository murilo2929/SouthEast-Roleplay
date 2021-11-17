
addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('jeffers5a_lae.txd',true)
engineImportTXD(txd, 5406)
local dff = engineLoadDFF('laecrackmotel4.dff', 0)
engineReplaceModel(dff, 5406)
local col = engineLoadCOL('laecrackmotel4.col')
engineReplaceCOL(col, 5406)
engineSetModelLODDistance(5406, 500)

local txd = engineLoadTXD('glenpark1_lae.txd',true)
engineImportTXD(txd, 5459)
local dff = engineLoadDFF('laejeffers01.dff', 0)
engineReplaceModel(dff, 5459)
local col = engineLoadCOL('laejeffers01.col')
engineReplaceCOL(col, 5459)
engineSetModelLODDistance(5459, 500)

local txd = engineLoadTXD('jeffers5a_lae.txd',true)
engineImportTXD(txd, 5414)
local dff = engineLoadDFF('laejeffers02.dff', 0)
engineReplaceModel(dff, 5414)
local col = engineLoadCOL('laejeffers02.col')
engineReplaceCOL(col, 5414)
engineSetModelLODDistance(5414, 500)
end)
