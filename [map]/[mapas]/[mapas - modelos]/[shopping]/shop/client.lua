

addEventHandler('onClientResourceStart', resourceRoot,
function()

local txd = engineLoadTXD('lsmall.txd',true)
engineImportTXD(txd, 1901)
local dff = engineLoadDFF('lsmall_1.dff', 0)
engineReplaceModel(dff, 1901)
local col = engineLoadCOL('lsmall_1.col')
engineReplaceCOL(col, 1901)
engineSetModelLODDistance(1901, 500)

local txd = engineLoadTXD('lsmall.txd',true)
engineImportTXD(txd, 1902)
local dff = engineLoadDFF('lsmall_2.dff', 0)
engineReplaceModel(dff, 1902)
local col = engineLoadCOL('lsmall_2.col')
engineReplaceCOL(col, 1902)
engineSetModelLODDistance(1902, 500)

local txd = engineLoadTXD('lsmall.txd',true)
engineImportTXD(txd, 1903)
local dff = engineLoadDFF('lsmall_3.dff', 0)
engineReplaceModel(dff, 1903)
local col = engineLoadCOL('lsmall_3.col')
engineReplaceCOL(col, 1903)
engineSetModelLODDistance(1903, 500)

local txd = engineLoadTXD('lsmall.txd',true)
engineImportTXD(txd, 1904)
local dff = engineLoadDFF('lsmall_4.dff', 0)
engineReplaceModel(dff, 1904)
local col = engineLoadCOL('lsmall_4.col')
engineReplaceCOL(col, 1904)
engineSetModelLODDistance(1904, 500)

local txd = engineLoadTXD('lsmall.txd',true)
engineImportTXD(txd, 1911)
local dff = engineLoadDFF('lsmall_5.dff', 0)
engineReplaceModel(dff, 1911)
local col = engineLoadCOL('lsmall_5.col')
engineReplaceCOL(col, 1911)
engineSetModelLODDistance(1911, 500)

end)




