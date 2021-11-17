

addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('landlae2e.txd',true)
engineImportTXD(txd, 17513)
local dff = engineLoadDFF('lae2_ground04.dff', 0)
engineReplaceModel(dff, 17513)
local col = engineLoadCOL('lae2_ground04.col')
engineReplaceCOL(col, 17513)
engineSetModelLODDistance(17513, 500)

local txd = engineLoadTXD('lae2billboards.txd',true)
engineImportTXD(txd, 17916)
local dff = engineLoadDFF('lae2billbrds3.dff', 0)
engineReplaceModel(dff, 17916)
local col = engineLoadCOL('lae2billbrds3.col')
engineReplaceCOL(col, 17916)
engineSetModelLODDistance(17916, 500)

local txd = engineLoadTXD('furniture_lae2.txd',true)
engineImportTXD(txd, 17534)
local dff = engineLoadDFF('cluckinbell1_lae.dff', 0)
engineReplaceModel(dff, 17534)
engineSetModelLODDistance(17534, 500)

end)
