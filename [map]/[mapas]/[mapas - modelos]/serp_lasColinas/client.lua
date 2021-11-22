
addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('easthills_lahills.txd',true)
engineImportTXD(txd, 13710)
local dff = engineLoadDFF('hillseast05_lae.dff', 0)
engineReplaceModel(dff, 13710)
local col = engineLoadCOL('hillseast05_lae.col')
engineReplaceCOL(col, 13710)
engineSetModelLODDistance(13710, 500)

local txd = engineLoadTXD('landlae2c.txd',true)
engineImportTXD(txd, 17677)
local dff = engineLoadDFF('lae2_ground15.dff', 0)
engineReplaceModel(dff, 17677)
local col = engineLoadCOL('lae2_ground15.col')
engineReplaceCOL(col, 17677)
engineSetModelLODDistance(17677, 500)

local txd = engineLoadTXD('ganghouse1_lax.txd',true)
engineImportTXD(txd, 3655)
local dff = engineLoadDFF('ganghous03_lax.dff', 0)
engineReplaceModel(dff, 3655)
engineSetModelLODDistance(3655, 500)
end)
