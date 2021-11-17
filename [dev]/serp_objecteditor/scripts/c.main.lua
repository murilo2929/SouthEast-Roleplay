Serverside = false

addEventHandler('onClientResourceStart', resourceRoot, function()
    triggerServerEvent('Attach:RequestAttachments', localPlayer)
end)

addEvent('Attach:ReceiveAttachments', true)
addEventHandler('Attach:ReceiveAttachments', root, function(arr)
    Attachments = arr
    
    for k, v in pairs(arr) do
        if v['customSize'] then
            setObjectScale(k, v['customSize'])
        end
    end
    
    local eventName = getVersion()['sortable'] >= '1.5.8-9.20704.0' and 'onClientPedsProcessed' or 'onClientPreRender'
    addEventHandler(eventName, root, AttachTheShit)
    
    addEvent('Attach:AttachToBone', true)
    addEventHandler('Attach:AttachToBone', resourceRoot, AttachToBone)
    
    addEvent('Attach:DetachFromBone', true)
    addEventHandler('Attach:DetachFromBone', resourceRoot, DetachFromBone)
    
    addEvent('Attach:UpdateAttachmentInfo', true)
    addEventHandler('Attach:UpdateAttachmentInfo', resourceRoot, UpdateAttachmentInfo)
    
    addEvent('onAttachElementToBone', true)
    addEvent('onDetachElementFromBone', true)
end)

ClearLocalObjectOnDestroy = function()
    if (not isElement(source)) then
        return false
    end
    if (not isElementLocal(source)) then
        return false
    end
    if PlayerAttachments[source] then
        for k in pairs(PlayerAttachments[source]) do
            DetachFromBone(k)
        end
        PlayerAttachments[source] = nil
    else
        DetachFromBone(source)
    end
end
addEventHandler('onClientElementDestroy', root, ClearLocalObjectOnDestroy)

local cos = math.cos
local sin = math.sin
local rad = math.rad

-- http://wiki.mtasa.com/attachElementToBone
SyncMatrix = function(ob, elem, bone, offX, offY, offZ, offRx, offRy, offRz)
    local boneMatrix = getElementBoneMatrix(elem, bone)
    
    if (not boneMatrix) then
        return false
    end
    
    offX = offX or 0
    offY = offY or 0
    offZ = offZ or 0
    
    offRx = rad(offRx or 0)
    offRy = rad(offRy or 0)
    offRz = rad(offRz or 0)
    
    local sroll = sin(offRz)
    local croll = cos(offRz)
    
    local spitch = sin(offRy)
    local cpitch = cos(offRy)
    
    local syaw = sin(offRx)
    local cyaw = cos(offRx)
    
    local rotMatix = {
        {
            sroll * spitch * syaw + croll * cyaw,
            sroll * cpitch,
            sroll * spitch * cyaw - croll * syaw
        },
        {
            croll * spitch * syaw - sroll * cyaw,
            croll * cpitch,
            croll * spitch * cyaw + sroll * syaw
        },
        {
            cpitch * syaw,
            -spitch,
            cpitch * cyaw
        }
    }
    
    local boneMatrix11 = boneMatrix[1][1]
    local boneMatrix12 = boneMatrix[1][2]
    local boneMatrix13 = boneMatrix[1][3]
    
    local boneMatrix21 = boneMatrix[2][1]
    local boneMatrix22 = boneMatrix[2][2]
    local boneMatrix23 = boneMatrix[2][3]
    
    local boneMatrix31 = boneMatrix[3][1]
    local boneMatrix32 = boneMatrix[3][2]
    local boneMatrix33 = boneMatrix[3][3]
    
    local rotMatrix11 = rotMatix[1][1]
    local rotMatrix12 = rotMatix[1][2]
    local rotMatrix13 = rotMatix[1][3]
    
    local rotMatrix21 = rotMatix[2][1]
    local rotMatrix22 = rotMatix[2][2]
    local rotMatrix23 = rotMatix[2][3]
    
    local rotMatrix31 = rotMatix[3][1]
    local rotMatrix32 = rotMatix[3][2]
    local rotMatrix33 = rotMatix[3][3]
    
    setElementMatrix(ob, {
        {
            (boneMatrix21 * rotMatrix12) + (boneMatrix11 * rotMatrix11) + (rotMatrix13 * boneMatrix31),
                (boneMatrix32 * rotMatrix13) + (boneMatrix12 * rotMatrix11) + (boneMatrix22 * rotMatrix12), -- right
                (boneMatrix23 * rotMatrix12) + (boneMatrix33 * rotMatrix13) + (rotMatrix11 * boneMatrix13),
                0
            },
            {
            (rotMatrix23 * boneMatrix31) + (boneMatrix21 * rotMatrix22) + (rotMatrix21 * boneMatrix11),
                (boneMatrix32 * rotMatrix23) + (boneMatrix22 * rotMatrix22) + (boneMatrix12 * rotMatrix21), -- front
                (rotMatrix21 * boneMatrix13) + (boneMatrix33 * rotMatrix23) + (boneMatrix23 * rotMatrix22),
                0
            },
            {
            (boneMatrix21 * rotMatrix32) + (rotMatrix33 * boneMatrix31) + (rotMatrix31 * boneMatrix11),
                (boneMatrix32 * rotMatrix33) + (boneMatrix22 * rotMatrix32) + (rotMatrix31 * boneMatrix12), -- up
                (rotMatrix31 * boneMatrix13) + (boneMatrix33 * rotMatrix33) + (boneMatrix23 * rotMatrix32),
                0
            },
            {
            (offZ * boneMatrix11) + (offY * boneMatrix21) + (offX * boneMatrix31) + boneMatrix[4][1],
                (offZ * boneMatrix12) + (offY * boneMatrix22) + (offX * boneMatrix32) + boneMatrix[4][2], -- pos
                (offZ * boneMatrix13) + (offY * boneMatrix23) + (offX * boneMatrix33) + boneMatrix[4][3],
                1
            },
        })
    
    return true
end

local hideWeapons = {
    [34] = true,
}

AttachTheShit = function()
    for ob, arr in pairs(Attachments) do
        if isElement(ob) and isElement(arr.elem) then
            setElementCollidableWith(ob, arr.elem, false)
            if isElementStreamedIn(ob) and isElementOnScreen(ob) then
                SyncMatrix(ob, arr.elem, arr.bone, arr.x, arr.y, arr.z, arr.rx, arr.ry, arr.rz)
            else
                setElementPosition(ob, getElementPosition(arr.elem))
            end
            if (arr.elem == localPlayer) then
                if getPedControlState(localPlayer, 'aim_weapon') and hideWeapons[getPedWeapon(localPlayer)] then
                    setElementAlpha(ob, 0)
                else
                    setElementAlpha(ob, getElementAlpha(localPlayer))
                end
            end
        end
    end
end
