local LOCAL_PLAYER = localPlayer
local SCREENSIZE_X, SCREENSIZE_Y = guiGetScreenSize()
local RESOLUTION_OFFSET_RIGHT = 0.715
local RESOLUTION_OFFSET_BOTTOM = 0.997
local NUM_CUBOIDS = 6
local IMAGE_PREFIX = "images/"
local MOUSE_LEFT_DOWN = false
local FOR_LOOP_CALLBACK = {}
local CURSOR_CACHE = {}
local ITEM_OBJECT, ITEM_ID, ITEM_DEFAULT, ITEM_NAME_ID, POSITION_OBJECT, CACHE_CHECK, CURR_CHECK
local WEARABLE_GENUINE_CHECK = false
local POSITION_LOCALISATION = {}
local HOVER_ELEMENT
local OBJECT_X, OBJECT_Y, OBJECT_Z = 0.001, 0.001, 0.001
local OBJECT_RX, OBJECT_RY, OBJECT_RZ = 1, 1, 1
local OBJECT_SCALE = 0.01
local POSITION_BONE = 1
local POSITION_TABLE = {
  0,
  0,
  0,
  0,
  0,
  0,
  1
}
local CUBOID_PARAMETERS = {
  0,
  0,
  0,
  0.1,
  0.1,
  0.1
}
local LINE_PARAMETERS = {
  [2] = {
    0,
    255,
    0,
    230,
    0.5
  },
  [4] = {
    255,
    0,
    0,
    230,
    0.5
  },
  [6] = {
    181,
    34,
    203,
    230,
    0.5
  }
}
local POSITION_DATA = {
  CUBOIDS = {},
  CUB_IMAGES = {
    ["saveicon.png"] = {
      true,
      -145,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["arrowicon.png"] = {
      false,
      20,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["rotation.png"] = {
      true,
      -35,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["resizeicon.png"] = {
      true,
      -90,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["arrowiconx.png"] = {
      true,
      20,
      40,
      6,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["arrowicony.png"] = {
      true,
      20,
      40,
      3,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["arrowiconz.png"] = {
      true,
      20,
      40,
      2,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["resizeiconx.png"] = {
      false,
      20,
      40,
      6,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["resizeicony.png"] = {
      false,
      20,
      40,
      3,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["resizeiconz.png"] = {
      false,
      20,
      40,
      2,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["rotationx.png"] = {
      false,
      20,
      40,
      6,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["rotationy.png"] = {
      false,
      20,
      40,
      3,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["rotationz.png"] = {
      false,
      20,
      40,
      2,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_arrowicon.png"] = {
      true,
      20,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      true
    },
    ["h_arrowiconx.png"] = {
      false,
      20,
      40,
      6,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_arrowicony.png"] = {
      false,
      20,
      40,
      3,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_arrowiconz.png"] = {
      false,
      20,
      40,
      2,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_rotation.png"] = {
      false,
      -35,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_rotationx.png"] = {
      false,
      20,
      40,
      6,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_rotationy.png"] = {
      false,
      20,
      40,
      3,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_rotationz.png"] = {
      false,
      20,
      40,
      2,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_resizeicon.png"] = {
      false,
      -90,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_resizeiconx.png"] = {
      false,
      20,
      40,
      6,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_resizeicony.png"] = {
      false,
      20,
      40,
      3,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_resizeiconz.png"] = {
      false,
      20,
      40,
      2,
      {
        0,
        0,
        0,
        0
      },
      false
    },
    ["h_saveicon.png"] = {
      false,
      -145,
      40,
      1,
      {
        0,
        0,
        0,
        0
      },
      false
    }
  }
}
local ATTACH_OFFSETS = {
  [1] = {
    0.5,
    0,
    0.6
  },
  [2] = {
    -0.5,
    0,
    0.6
  },
  [3] = {
    0,
    0.5,
    0.6
  },
  [4] = {
    0,
    -0.5,
    0.6
  },
  [5] = {
    0,
    0,
    0.1
  },
  [6] = {
    0,
    0,
    1
  }
}
function wearable_initialize_lines()
  wearable_create_lines()
  wearable_icon_handler()
  wearable_draw_icons()
end
function wearable_is_main_icon(IMAGE_NAME)
  local MAIN_ICON_TABLE = {
    ["h_arrowicon.png"] = true,
    ["h_rotation.png"] = true,
    ["h_resizeicon.png"] = true
  }
  if MAIN_ICON_TABLE[IMAGE_NAME] and POSITION_DATA.CUB_IMAGES[IMAGE_NAME][6] then
    return true
  end
end
function wearable_recieve_security_check(SECURITY_TABLE)
  local SERVER_NAME, RESOURCE_NAME, PLAYER_SLOTS = unpack(SECURITY_TABLE)
  local LEGIT_CHECK = true
--  if SERVER_NAME ~= "|| Multi Theft Auto Roleplay | www.mtarp.co ||" then
--    LEGIT_CHECK = false
--  end
--  if RESOURCE_NAME ~= "wearable-system" then
--    LEGIT_CHECK = false
--  end
--  if PLAYER_SLOTS ~= 1024 then
--    LEGIT_CHECK = false
--  end
--  if LEGIT_CHECK then
--    
--    outputDebugString("[WEARABLE-SECURITY]: client sided security check succeeded!")
--  else
--    outputDebugString("[WEARABLE-SECURITY]: client sided security check failed.")
--  end
WEARABLE_GENUINE_CHECK = true
end
function wearable_update_dimension(P_DIMENSION, P_INTERIOR)
  if isElement(POSITION_OBJECT) then
    setElementDimension(POSITION_OBJECT, P_DIMENSION)
    setElementInterior(POSITION_OBJECT, P_INTERIOR)
  end
end
function wearable_update_position(POSITION_STATE)
  if POSITION_STATE == true then
    OBJECT_X, OBJECT_Y, OBJECT_Z = 0.001, 0.001, -0.001
    OBJECT_RX, OBJECT_RY, OBJECT_RZ = 1, 1, 1
    OBJECT_SCALE = 0.01
  elseif POSITION_STATE == false then
    OBJECT_X, OBJECT_Y, OBJECT_Z = -0.001, -0.001, 0.001
    OBJECT_RX, OBJECT_RY, OBJECT_RZ = -1, -1, -1
    OBJECT_SCALE = -0.01
  end
end
function wearable_shutdown_reinitialize()
  wearable_icon_action("h_arrowicon.png")
  if isElement(POSITION_OBJECT) then
    for OFFSET_ADDRESS = 1, NUM_CUBOIDS do
      local CUB_ELEMENT_TEMP = POSITION_DATA.CUBOIDS[OFFSET_ADDRESS]
      destroyElement(CUB_ELEMENT_TEMP)
    end
    destroyElement(POSITION_OBJECT)
    POSITION_TABLE = {
      0,
      0,
      0,
      0,
      0,
      0,
      1
    }
    showCursor(false)
  end
  MOUSE_LEFT_DOWN = false
  HOVER_ELEMENT = nil
  removeEventHandler("onClientPreRender", getRootElement(), wearable_initialize_lines)
end
function wearable_hover_image_check(CURSOR_X, CURSOR_Y, X, Y, W, H)
  local X_CHECK = X < CURSOR_X and CURSOR_X < X + W
  local Y_CHECK = Y < CURSOR_Y and CURSOR_Y < Y + H
  return X_CHECK and Y_CHECK
end
function wearable_icon_action(ICON_ACTION)
  local TOGGLE_ICONS = {}
  if wearable_is_main_icon(ICON_ACTION) then
    return
  end
  if ICON_ACTION == "h_saveicon.png" then
    do
      local CURRENT_ITEM_POSITION = {
        name = ITEM_ID_NAME,
        itemID = ITEM_ID,
        objectID = ITEM_OBJECT,
        bone = POSITION_BONE,
        position = {
          POSITION_TABLE[1],
          POSITION_TABLE[2],
          POSITION_TABLE[3],
          POSITION_TABLE[4],
          POSITION_TABLE[5],
          POSITION_TABLE[6],
          POSITION_TABLE[7]
        },
        default = ITEM_DEFAULT
      }
      triggerServerEvent("wearable-system:savePosition", LOCAL_PLAYER, CURRENT_ITEM_POSITION)
      wearable_shutdown_reinitialize()
    end
  elseif ICON_ACTION == "h_arrowicon.png" then
    TOGGLE_ICONS = {
      "arrow",
      "rotation",
      "h_arrowicon.png",
      "rotation.png"
    }
  elseif ICON_ACTION == "h_rotation.png" then
    TOGGLE_ICONS = {
      "rotation",
      "arrow",
      "h_rotation.png",
      "arrowicon.png"
    }
  end
  if next(TOGGLE_ICONS) then
    local ENABLE_ICON, DISABLE_ICON, MAIN_ICON, PREV_MAIN_ICON = unpack(TOGGLE_ICONS)
    for IMAGE_NAME, IMAGE_DATA in pairs(POSITION_DATA.CUB_IMAGES) do
      if IMAGE_NAME == MAIN_ICON then
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][1] = true
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][6] = true
      elseif string.find(IMAGE_NAME, DISABLE_ICON) then
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][1] = false
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][6] = false
        if IMAGE_NAME == PREV_MAIN_ICON then
          POSITION_DATA.CUB_IMAGES[IMAGE_NAME][1] = true
        end
      elseif string.find(IMAGE_NAME, ENABLE_ICON) and not string.find(IMAGE_NAME, "h_") then
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][1] = true
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][6] = false
      end
    end
  end
end
function wearable_on_click_handler(button, state)
  if HOVER_ELEMENT then
    if button == "left" and state == "down" then
      MOUSE_LEFT_DOWN = true
      if HOVER_ELEMENT == "h_saveicon.png" then
        wearable_icon_action(HOVER_ELEMENT)
      elseif HOVER_ELEMENT == "h_arrowicon.png" then
        wearable_icon_action(HOVER_ELEMENT)
      elseif HOVER_ELEMENT == "h_rotation.png" then
        wearable_icon_action(HOVER_ELEMENT)
      end
      return
    else
      MOUSE_LEFT_DOWN = false
    end
  elseif MOUSE_LEFT_DOWN then
    MOUSE_LEFT_DOWN = false
  end
  CURSOR_CACHE = {}
end
function wearable_mouse_move_handler(_, _, C_X, C_Y, W_X, W_Y, W_Z)
  if HOVER_ELEMENT and MOUSE_LEFT_DOWN then
    if not next(CURSOR_CACHE) then
      CURSOR_CACHE = {
        C_X,
        C_Y,
        W_X,
        W_Y,
        W_Z
      }
    end
    local CURSOR_X, CURSOR_Y, CURSOR_WX, CURSOR_WY, CURSOR_WZ = unpack(CURSOR_CACHE)
    POSITION_LOCALISATION = {
      X = {CURSOR_WX, W_X},
      Y = {CURSOR_WY, W_Y},
      Z = {CURSOR_WZ, W_Z}
    }
    if string.find(HOVER_ELEMENT, "x") then
      CACHE_CHECK, CURR_CHECK = unpack(POSITION_LOCALISATION.X)
    elseif string.find(HOVER_ELEMENT, "y") then
      CACHE_CHECK, CURR_CHECK = unpack(POSITION_LOCALISATION.Y)
    elseif string.find(HOVER_ELEMENT, "rotationz") then
      CACHE_CHECK, CURR_CHECK = unpack(POSITION_LOCALISATION.Y)
    elseif string.find(HOVER_ELEMENT, "z") then
      CACHE_CHECK, CURR_CHECK = unpack(POSITION_LOCALISATION.Z)
    else
      return
    end
    if CURR_CHECK < CACHE_CHECK then
      wearable_update_position(true)
    elseif CURR_CHECK > CACHE_CHECK then
      wearable_update_position(false)
    end
    if HOVER_ELEMENT == "h_arrowiconx.png" then
      wearable_move_object("X")
    elseif HOVER_ELEMENT == "h_arrowicony.png" then
      wearable_move_object("Y")
    elseif HOVER_ELEMENT == "h_arrowiconz.png" then
      wearable_move_object("Z")
    elseif HOVER_ELEMENT == "h_rotationx.png" then
      wearable_move_object("RX")
    elseif HOVER_ELEMENT == "h_rotationy.png" then
      wearable_move_object("RY")
    elseif HOVER_ELEMENT == "h_rotationz.png" then
      wearable_move_object("RZ")
    elseif string.find(HOVER_ELEMENT, "resizeicon") then
      wearable_move_object("OC")
    end
    setCursorPosition(CURSOR_X, CURSOR_Y)
  end
end
function wearable_check_position_exist()
  triggerServerEvent("wearable-system:requestPosition", LOCAL_PLAYER, ITEM_ID, ITEM_ID_NAME)
end
function wearable_recieve_position(ITEM_POSITION)
  if type(ITEM_POSITION) == "table" then
    exports.bone_attach:detachElementFromBone(POSITION_OBJECT)
    local ITEM_X, ITEM_Y, ITEM_Z, ITEM_RX, ITEM_RY, ITEM_RZ, ITEM_SCALE = ITEM_POSITION[1], ITEM_POSITION[2], ITEM_POSITION[3], ITEM_POSITION[4], ITEM_POSITION[5], ITEM_POSITION[6], ITEM_POSITION[7]
    POSITION_TABLE = {
      ITEM_X,
      ITEM_Y,
      ITEM_Z,
      ITEM_RX,
      ITEM_RY,
      ITEM_RZ,
      ITEM_SCALE
    }
    exports.bone_attach:attachElementToBone(POSITION_OBJECT, LOCAL_PLAYER, POSITION_BONE, ITEM_X, ITEM_Y, ITEM_Z, ITEM_RX, ITEM_RY, ITEM_RZ)
    setObjectScale(POSITION_OBJECT, ITEM_SCALE)
    outputChatBox("Your previous set position has been retrieved!")
  end
end
function wearable_initialize_system(WEARABLE_ITEM)
  ITEM_ID_NAME = WEARABLE_ITEM
  for k, v in ipairs(items) do
    if v.name == WEARABLE_ITEM and WEARABLE_GENUINE_CHECK then
      ITEM_ID = v.itemID
      ITEM_OBJECT = v.objectID
      POSITION_BONE = v.bone
      ITEM_DEFAULT = v.default
      break
    end
  end
  wearable_check_position_exist()
  POSITION_OBJECT = createObject(ITEM_OBJECT, 0, 0, 0)
  local _, _, X_ATTACH, Y_ATTACH, Z_ATTACH, RX_ATTACH, RY_ATTACH, RZ_ATTACH = exports.bone_attach:getElementBoneAttachmentDetails(POSITION_OBJECT)
  exports.bone_attach:attachElementToBone(POSITION_OBJECT, LOCAL_PLAYER, 1, 0, 0, 0, 0, 0, 0)
  for OFFSET_ADDRESS = 1, NUM_CUBOIDS do
    local CUB_X, CUB_Y, CUB_Z, CUB_WIDTH, CUB_DEPTH, CUB_HEIGHT = unpack(CUBOID_PARAMETERS)
    local X_OFF, Y_OFF, Z_OFF = unpack(ATTACH_OFFSETS[OFFSET_ADDRESS])
    local CUB_ELEMENT_TEMP = createColCuboid(CUB_X, CUB_Y, CUB_Z, CUB_WIDTH, CUB_DEPTH, CUB_HEIGHT)
    attachElements(CUB_ELEMENT_TEMP, POSITION_OBJECT, X_OFF, Y_OFF, Z_OFF, RX_ATTACH, RY_ATTACH, RZ_ATTACH)
    POSITION_DATA.CUBOIDS[OFFSET_ADDRESS] = CUB_ELEMENT_TEMP
  end
  addEventHandler("onClientPreRender", getRootElement(), wearable_initialize_lines)
  setElementDimension(POSITION_OBJECT, getElementDimension(LOCAL_PLAYER))
  setElementInterior(POSITION_OBJECT, getElementInterior(LOCAL_PLAYER))
end
function wearable_create_lines()
  local COUNT = 0
  for OFFSET_ADDRESS = 1, NUM_CUBOIDS do
    COUNT = COUNT + 1
    local CUB_ELEMENT = POSITION_DATA.CUBOIDS[OFFSET_ADDRESS]
    if COUNT == 2 then
      COUNT = 0
      local X_R, Y_R, Z_R = getElementPosition(CUB_ELEMENT)
      local X_L, Y_L, Z_L = getElementPosition(POSITION_DATA.CUBOIDS[OFFSET_ADDRESS - 1])
      local R, G, B, A, LINE_THICK = unpack(LINE_PARAMETERS[OFFSET_ADDRESS])
      dxDrawLine3D(X_L, Y_L, Z_L, X_R, Y_R, Z_R, tocolor(R, G, B, A), LINE_THICK)
    end
  end
end
function wearable_icon_handler()
  local CURSOR_X, CURSOR_Y
  local IMAGE_OVERLAY = false
  if not MOUSE_LEFT_DOWN and HOVER_ELEMENT then
    HOVER_ELEMENT = nil
  end
  if not isCursorShowing() then
    CURSOR_X, CURSOR_Y = 0, 0
  else
    CURSOR_X, CURSOR_Y = getCursorPosition()
  end
  CURSOR_X, CURSOR_Y = CURSOR_X * SCREENSIZE_X, CURSOR_Y * SCREENSIZE_Y
  for IMAGE_NAME, IMAGE_DATA in pairs(POSITION_DATA.CUB_IMAGES) do
    local IMAGE_SHOW, _, _, _, DX_TABLE = unpack(IMAGE_DATA)
    local DX_DRAW_IMAGE_X, DX_DRAW_IMAGE_Y, DX_DRAW_IMAGE_WIDTH, DX_DRAW_IMAGE_HEIGHT = unpack(DX_TABLE)
    local IMG_HIGHLIGHTED = string.find(IMAGE_NAME, "h_")
    local IMG_PREFIX_H = "h_" .. IMAGE_NAME
    local IMG_PREFIX = string.sub(IMAGE_NAME, 3)
    if IMAGE_SHOW then
      if not FOR_LOOP_CALLBACK[IMAGE_NAME] then
        break
      else
        FOR_LOOP_CALLBACK[IMAGE_NAME] = false
      end
      if not IMG_HIGHLIGHTED and wearable_is_main_icon(IMG_PREFIX_H) then
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][1] = false
        POSITION_DATA.CUB_IMAGES[IMG_PREFIX_H][1] = true
      end
      if DX_DRAW_IMAGE_X ~= 0 or DX_DRAW_IMAGE_Y ~= 0 then
        if wearable_hover_image_check(CURSOR_X, CURSOR_Y, DX_DRAW_IMAGE_X, DX_DRAW_IMAGE_Y, DX_DRAW_IMAGE_WIDTH, DX_DRAW_IMAGE_HEIGHT) then
          if MOUSE_LEFT_DOWN then
            if IMAGE_NAME ~= HOVER_ELEMENT then
              IMAGE_OVERLAY = true
            else
              IMAGE_OVERLAY = false
            end
          end
          if not IMG_HIGHLIGHTED and not IMAGE_OVERLAY then
            POSITION_DATA.CUB_IMAGES[IMAGE_NAME][1] = false
            POSITION_DATA.CUB_IMAGES[IMG_PREFIX_H][1] = true
          end
          if not IMAGE_OVERLAY then
            HOVER_ELEMENT = IMAGE_NAME
          end
        elseif IMG_HIGHLIGHTED and not MOUSE_LEFT_DOWN and not wearable_is_main_icon(IMAGE_NAME) then
          POSITION_DATA.CUB_IMAGES[IMAGE_NAME][1] = false
          POSITION_DATA.CUB_IMAGES[IMG_PREFIX][1] = true
        end
      end
    end
  end
end
function wearable_draw_icons()
  for IMAGE_NAME, IMAGE_DATA in pairs(POSITION_DATA.CUB_IMAGES) do
    local IMAGE_SHOW, IMAGE_X, IMAGE_Y, CUB_ADDRESS = unpack(IMAGE_DATA)
    local CUB_ELEMENT = POSITION_DATA.CUBOIDS[CUB_ADDRESS]
    local CUB_X, CUB_Y, CUB_Z = getElementPosition(CUB_ELEMENT)
    local FIN_IMAGE_NAME = IMAGE_PREFIX .. IMAGE_NAME
    if IMAGE_SHOW then
      local SCREEN_X, SCREEN_Y = getScreenFromWorldPosition(CUB_X, CUB_Y, CUB_Z, 0, false)
      if SCREEN_X or SCREEN_Y then
        local CAMERA_X, CAMERA_Y, CAMERA_Z, _, _, _, _, CAMERA_FOV = getCameraMatrix()
        local CUB_CAM_DIST = getDistanceBetweenPoints3D(CUB_X, CUB_Y, CUB_Z + 0.06, CAMERA_X, CAMERA_Y, CAMERA_Z)
        local U_SCREENSIZE_X = SCREENSIZE_X + RESOLUTION_OFFSET_RIGHT
        local U_SCREENSIZE_Y = SCREENSIZE_Y + RESOLUTION_OFFSET_BOTTOM
        local DX_DRAW_IMAGE_X = SCREEN_X - IMAGE_X / CUB_CAM_DIST * SCREENSIZE_X / 800 / 70 * CAMERA_FOV
        local DX_DRAW_IMAGE_Y = SCREEN_Y - IMAGE_Y / CUB_CAM_DIST * SCREENSIZE_Y / 600 / 70 * CAMERA_FOV
        local DX_DRAW_IMAGE_WIDTH = 50 / CUB_CAM_DIST * U_SCREENSIZE_X / 800 / 70 * CAMERA_FOV
        local DX_DRAW_IMAGE_HEIGHT = 50 / CUB_CAM_DIST * U_SCREENSIZE_Y / 600 / 70 * CAMERA_FOV
        POSITION_DATA.CUB_IMAGES[IMAGE_NAME][5] = {
          DX_DRAW_IMAGE_X,
          DX_DRAW_IMAGE_Y,
          DX_DRAW_IMAGE_WIDTH,
          DX_DRAW_IMAGE_HEIGHT
        }
        dxDrawImage(DX_DRAW_IMAGE_X, DX_DRAW_IMAGE_Y, DX_DRAW_IMAGE_WIDTH, DX_DRAW_IMAGE_HEIGHT, FIN_IMAGE_NAME)
        FOR_LOOP_CALLBACK[IMAGE_NAME] = true
      end
    end
  end
end
function wearable_move_object(POSITION_VALUE)
  exports.bone_attach:detachElementFromBone(POSITION_OBJECT)
  if POSITION_VALUE == "X" then
    do
      local CURR_OBJECT_X = POSITION_TABLE[1]
      POSITION_TABLE[1] = CURR_OBJECT_X + OBJECT_X
    end
  elseif POSITION_VALUE == "Y" then
    do
      local CURR_OBJECT_Y = POSITION_TABLE[2]
      POSITION_TABLE[2] = CURR_OBJECT_Y + OBJECT_Y
    end
  elseif POSITION_VALUE == "Z" then
    do
      local CURR_OBJECT_Z = POSITION_TABLE[3]
      POSITION_TABLE[3] = CURR_OBJECT_Z + OBJECT_Z
    end
  elseif POSITION_VALUE == "RX" then
    do
      local CURR_OBJECT_RX = POSITION_TABLE[4]
      POSITION_TABLE[4] = CURR_OBJECT_RX + OBJECT_RX
    end
  elseif POSITION_VALUE == "RY" then
    do
      local CURR_OBJECT_RY = POSITION_TABLE[5]
      POSITION_TABLE[5] = CURR_OBJECT_RY + OBJECT_RY
    end
  elseif POSITION_VALUE == "RZ" then
    do
      local CURR_OBJECT_RZ = POSITION_TABLE[6]
      POSITION_TABLE[6] = CURR_OBJECT_RZ + OBJECT_RZ
    end
  elseif POSITION_VALUE == "OC" then
    local CURR_OBJECT_SCALE = POSITION_TABLE[7]
    POSITION_TABLE[7] = CURR_OBJECT_SCALE + OBJECT_SCALE
  end
  local POSITION_ROWS = table.getn(POSITION_TABLE)
  for POSITION_OFFSET = 1, POSITION_ROWS do
    if POSITION_OFFSET > 0 and POSITION_OFFSET <= 3 then
      if POSITION_TABLE[POSITION_OFFSET] > 2 or POSITION_TABLE[POSITION_OFFSET] < -2 then
        POSITION_TABLE[POSITION_OFFSET] = 0
      end
    elseif POSITION_OFFSET > 3 and POSITION_OFFSET <= 6 and (POSITION_TABLE[POSITION_OFFSET] > 360 or POSITION_TABLE[POSITION_OFFSET] < -360) then
      POSITION_TABLE[POSITION_OFFSET] = 0
    end
  end
  if getObjectScale(POSITION_OBJECT) > 1.5 or getObjectScale(POSITION_OBJECT) < 0.5 then
    POSITION_TABLE[7] = 1
  end
  setObjectScale(POSITION_OBJECT, POSITION_TABLE[7])
  exports.bone_attach:attachElementToBone(POSITION_OBJECT, LOCAL_PLAYER, POSITION_BONE, POSITION_TABLE[1], POSITION_TABLE[2], POSITION_TABLE[3], POSITION_TABLE[4], POSITION_TABLE[5], POSITION_TABLE[6])
end
triggerServerEvent("wearable:security_check", LOCAL_PLAYER)
addEventHandler("onClientClick", getRootElement(), wearable_on_click_handler)
addEventHandler("onClientCursorMove", getRootElement(), wearable_mouse_move_handler)
addEventHandler("accounts:characters:spawn", getRootElement(), wearable_shutdown_reinitialize)
addEvent("wearable-system:recievePosition", true)
addEventHandler("wearable-system:recievePosition", getRootElement(), wearable_recieve_position)
addEvent("wearable:security_check:recieve", true)
addEventHandler("wearable:security_check:recieve", getRootElement(), wearable_recieve_security_check)
