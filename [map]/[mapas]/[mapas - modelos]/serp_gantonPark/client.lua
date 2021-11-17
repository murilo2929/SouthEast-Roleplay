
addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('hub_alpha.txd',true)
engineImportTXD(txd, 17876)
local dff = engineLoadDFF('hubst3_alpha.dff', 0)
engineReplaceModel(dff, 17876)
engineSetModelLODDistance(17876, 500)

local txd = engineLoadTXD('landhub.txd',true)
engineImportTXD(txd, 17614)
local dff = engineLoadDFF('Lae2_landHUB02.dff', 0)
engineReplaceModel(dff, 17614)
local col = engineLoadCOL('Lae2_landHUB02.col')
engineReplaceCOL(col, 17614)
engineSetModelLODDistance(17614, 500)
end)
