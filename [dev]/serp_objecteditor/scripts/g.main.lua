Attachments = {}

PlayerAttachments = {}

AttachToBone = function(elem, ob, bone, x, y, z, rx, ry, rz, customSize)
    if (not isElement(elem)) then
        return false
    end
    
    if (not isElement(ob)) then
        return false
    end
    
    if (not bone) or (not VALID_BONES[bone]) then
        return false
    end
    
    if (not VALID_ELEM_TYPES[getElementType(elem)]) then
        return false
    end
    
    setElementCollisionsEnabled(ob, false)
    
    if customSize then
        setObjectScale(ob, customSize)
    end
    
    Attachments[ob] = {
        elem = elem,
        bone = bone,
        x = x,
        y = y,
        z = z,
        rx = rx,
        ry = ry,
        rz = rz,
        customSize = customSize,
    }
    
    if (not PlayerAttachments[elem]) then
        PlayerAttachments[elem] = {}
    end
    
    PlayerAttachments[elem][ob] = true
    
    if Serverside then
        triggerClientEvent('Attach:AttachToBone', resourceRoot, elem, ob, bone, x, y, z, rx, ry, rz, customSize)
    else
        triggerEvent('onAttachElementToBone', elem, ob)
    end
    
    return true
end

DetachFromBone = function(ob)
    if (not Attachments[ob]) then
        return false
    end
    
    if PlayerAttachments[Attachments[ob].elem] then
        PlayerAttachments[Attachments[ob].elem][ob] = nil
        
        if IsTableEmpty(PlayerAttachments[Attachments[ob].elem]) then
            PlayerAttachments[Attachments[ob].elem] = nil
        end
    end
    
    if Serverside and (getResourceState(resource) == 'running') then
        triggerClientEvent('Attach:DetachFromBone', resourceRoot, ob)
    else
        triggerEvent('onDetachElementFromBone', Attachments[ob].elem, ob)
    end
    
    Attachments[ob] = nil
    
    return true
end

UpdateAttachmentInfo = function(ob, arr)
    if (not Attachments[ob]) then
        return false
    end
    for k, v in pairs(arr) do
        Attachments[ob][k] = v
    end
    if Serverside then
        triggerClientEvent('Attach:UpdateAttachmentInfo', resourceRoot, ob, arr)
    end
    return true
end

GetAttachmentInfo = function(ob)
    return (ob and Attachments[ob]) or false
end

GetElementsAttachedTo = function(elem)
    local attached = {}
    if PlayerAttachments[elem] then
        for k in pairs(PlayerAttachments[elem]) do
            table.insert(attached, k)
        end
    end
    return attached
end

IsTableEmpty = function(arr)
    for k in pairs(arr) do
        return false
    end
    return true
end
