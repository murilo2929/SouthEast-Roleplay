# BONE ATTACH

## Video:
https://streamable.com/x9i4va

## Exported Functions:

### • AttachToBone (Shared)
    bool AttachToBone ( elem theElement, elem theObject, int theBone [, float offX = 0, float offY = 0, float offZ = 0, offRx or 0, offRy or 0, offRz or 0 ] )
Arguments: <br>
    theElement: to element you want to attach the object to.
    theObject: to object you want to attach.
    theBone: the bone you want to attach.
    offX, offY, offZ: the offset possition.
    offRx, offRy, offRz: the offset rotation.
<br>
### • DetachFromBone (Shared)
    bool DetachFromBone ( elem theObject )

Arguments: <br> 
    theObject: to object you want to detach.
<br>
## • UpdateAttachmentInfo (Shared)
    bool UpdateAttachmentInfo ( elem theObject, table theParams )

Arguments: <br> 
    theObject: to object you want to change the data.
    theParams: a table indicating which value will be changed.
        <br>
        Possible keys: elem, bone, x, y, z, rx, ry, rz
<br>
<br>
## • GetAttachmentInfo (Shared)
    bool GetAttachmentInfo ( elem theObject )

Arguments: <br> 
    theObject: to object you want get info.
<br>
<br>
## • GetElementsAttachedTo (Shared)
    bool GetElementsAttachedTo ( elem theElem )

Arguments: <br> 
    theElem: to object you want to get all attachments.

### Possible attachments:
| BONE ID | BONE NAME |
|:-|:-|
|0|BONE_ROOT|
|1|BONE_PELVIS1|
|2|BONE_PELVIS|
|3|BONE_SPINE1|
|4|BONE_UPPERTORSO|
|5|BONE_NECK|
|6|BONE_HEAD2|
|7|BONE_HEAD1|
|8|BONE_HEAD|
|22|BONE_RIGHTSHOULDER|
|23|BONE_RIGHTELBOW|
|24|BONE_RIGHTWRIST|
|25|BONE_RIGHTHAND|
|26|BONE_RIGHTTHUMB|
|31|BONE_LEFTUPPERTORSO|
|32|BONE_LEFTSHOULDER|
|33|BONE_LEFTELBOW|
|34|BONE_LEFTWRIST|
|35|BONE_LEFTHAND|
|36|BONE_LEFTTHUMB|
|41|BONE_LEFTHIP|
|42|BONE_LEFTKNEE|
|43|BONE_LEFTANKLE|
|44|BONE_LEFTFOOT|
|51|BONE_RIGHTHIP|
|52|BONE_RIGHTKNEE|
|53|BONE_RIGHTANKLE|
|54|BONE_RIGHTFOOT|
|201|BONE_BELLY|
|301|BONE_RIGHTBREAST|
|302|BONE_LEFTBREAST|
