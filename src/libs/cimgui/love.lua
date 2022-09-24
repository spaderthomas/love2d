-- RenderDrawLists is based on love-imgui (https://github.com/slages/love-imgui) Copyright (c) 2016 slages, licensed under the MIT license

local path = (...):gsub("[^%.]*$", "")
local M = require(path .. "master")
local ffi = require("ffi")
local bit = require("bit")
local love = require("love")

local C = M.C
local L = M.love
local _common = M._common

local vertexformat = {
    {"VertexPosition", "float", 2},
    {"VertexTexCoord", "float", 2},
    {"VertexColor", "byte", 4}
}

local lovekeymap = {
    ["return"] = C.ImGuiKey_Enter,
    ["escape"] = C.ImGuiKey_Escape,
    ["backspace"] = C.ImGuiKey_Backspace,
    ["tab"] = C.ImGuiKey_Tab,
    ["space"] = C.ImGuiKey_Space,
    [","] = C.ImGuiKey_Comma,
    ["-"] = C.ImGuiKey_Minus,
    ["."] = C.ImGuiKey_Period,
    ["/"] = C.ImGuiKey_Slash,

    ["0"] = C.ImGuiKey_0,
    ["1"] = C.ImGuiKey_1,
    ["2"] = C.ImGuiKey_2,
    ["3"] = C.ImGuiKey_3,
    ["4"] = C.ImGuiKey_4,
    ["5"] = C.ImGuiKey_5,
    ["6"] = C.ImGuiKey_6,
    ["7"] = C.ImGuiKey_7,
    ["8"] = C.ImGuiKey_8,
    ["9"] = C.ImGuiKey_9,

    [";"] = C.ImGuiKey_Semicolon,
    ["="] = C.ImGuiKey_Equal,

    ["["] = C.ImGuiKey_LeftBracket,
    ["\\"] = C.ImGuiKey_Backslash,
    ["]"] = C.ImGuiKey_RightBracket,
    ["`"] = C.ImGuiKey_GraveAccent,

    ["a"] = C.ImGuiKey_A,
    ["b"] = C.ImGuiKey_B,
    ["c"] = C.ImGuiKey_C,
    ["d"] = C.ImGuiKey_D,
    ["e"] = C.ImGuiKey_E,
    ["f"] = C.ImGuiKey_F,
    ["g"] = C.ImGuiKey_G,
    ["h"] = C.ImGuiKey_H,
    ["i"] = C.ImGuiKey_I,
    ["j"] = C.ImGuiKey_J,
    ["k"] = C.ImGuiKey_K,
    ["l"] = C.ImGuiKey_L,
    ["m"] = C.ImGuiKey_M,
    ["n"] = C.ImGuiKey_N,
    ["o"] = C.ImGuiKey_O,
    ["p"] = C.ImGuiKey_P,
    ["q"] = C.ImGuiKey_Q,
    ["r"] = C.ImGuiKey_R,
    ["s"] = C.ImGuiKey_S,
    ["t"] = C.ImGuiKey_T,
    ["u"] = C.ImGuiKey_U,
    ["v"] = C.ImGuiKey_V,
    ["w"] = C.ImGuiKey_W,
    ["x"] = C.ImGuiKey_X,
    ["y"] = C.ImGuiKey_Y,
    ["z"] = C.ImGuiKey_Z,

    ["capslock"] = C.ImGuiKey_CapsLock,

    ["f1"] = C.ImGuiKey_F1,
    ["f2"] = C.ImGuiKey_F2,
    ["f3"] = C.ImGuiKey_F3,
    ["f4"] = C.ImGuiKey_F4,
    ["f5"] = C.ImGuiKey_F5,
    ["f6"] = C.ImGuiKey_F6,
    ["f7"] = C.ImGuiKey_F7,
    ["f8"] = C.ImGuiKey_F8,
    ["f9"] = C.ImGuiKey_F9,
    ["f10"] = C.ImGuiKey_F10,
    ["f11"] = C.ImGuiKey_F11,
    ["f12"] = C.ImGuiKey_F12,

    ["printscreen"] = C.ImGuiKey_PrintScreen,
    ["scrolllock"] = C.ImGuiKey_ScrollLock,
    ["pause"] = C.ImGuiKey_Pause,
    ["insert"] = C.ImGuiKey_Insert,
    ["home"] = C.ImGuiKey_Home,
    ["pageup"] = C.ImGuiKey_PageUp,
    ["delete"] = C.ImGuiKey_Delete,
    ["end"] = C.ImGuiKey_End,
    ["pagedown"] = C.ImGuiKey_PageDown,
    ["right"] = C.ImGuiKey_RightArrow,
    ["left"] = C.ImGuiKey_LeftArrow,
    ["down"] = C.ImGuiKey_DownArrow,
    ["up"] = C.ImGuiKey_UpArrow,

    ["numlock"] = C.ImGuiKey_NumLock,
    ["kp/"] = C.ImGuiKey_KeypadDivide,
    ["kp*"] = C.ImGuiKey_KeypadMultiply,
    ["kp-"] = C.ImGuiKey_KeypadSubtract,
    ["kp+"] = C.ImGuiKey_KeypadAdd,
    ["kpenter"] = C.ImGuiKey_KeypadEnter,
    ["kp0"] = C.ImGuiKey_Keypad0,
    ["kp1"] = C.ImGuiKey_Keypad1,
    ["kp2"] = C.ImGuiKey_Keypad2,
    ["kp3"] = C.ImGuiKey_Keypad3,
    ["kp4"] = C.ImGuiKey_Keypad4,
    ["kp5"] = C.ImGuiKey_Keypad5,
    ["kp6"] = C.ImGuiKey_Keypad6,
    ["kp7"] = C.ImGuiKey_Keypad7,
    ["kp8"] = C.ImGuiKey_Keypad8,
    ["kp9"] = C.ImGuiKey_Keypad9,
    ["kp."] = C.ImGuiKey_KeypadDecimal,
    ["kp="] = C.ImGuiKey_KeypadEqual,

    ["menu"] = C.ImGuiKey_Menu,

    ["lctrl"] = {C.ImGuiKey_LeftCtrl, C.ImGuiKey_ModCtrl},
    ["lshift"] = {C.ImGuiKey_LeftShift, C.ImGuiKey_ModShift},
    ["lalt"] = {C.ImGuiKey_LeftAlt, C.ImGuiKey_ModAlt},
    ["lgui"] = {C.ImGuiKey_LeftSuper, C.ImGuiKey_ModSuper},
    ["rctrl"] = {C.ImGuiKey_RightCtrl, C.ImGuiKey_ModCtrl},
    ["rshift"] = {C.ImGuiKey_RightShift, C.ImGuiKey_ModShift},
    ["ralt"] = {C.ImGuiKey_RightAlt, C.ImGuiKey_ModAlt},
    ["rgui"] = {C.ImGuiKey_RightSuper, C.ImGuiKey_ModSuper},
}
_common.lovekeymap = lovekeymap

local textureObject, textureShader
local strings = {}

_common.textures = setmetatable({},{__mode="v"})
_common.callbacks = setmetatable({},{__mode="v"})

local cliboard_callback_get, cliboard_callback_set
local io

local Alpha8_shader

function L.Init(format)
    Alpha8_shader = love.graphics.newShader [[
        vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
            float alpha = Texel(tex, texture_coords).r;
            return vec4(color.rgb, color.a*alpha);
        }
    ]]

    format = format or "RGBA32"
    C.igCreateContext(nil)
    io = C.igGetIO()
    L.BuildFontAtlas(format)

    cliboard_callback_get = ffi.cast("const char* (*)(void*)", function(userdata)
        return love.system.getClipboardText()
    end)
    cliboard_callback_set = ffi.cast("void (*)(void*, const char*)", function(userdata, text)
        love.system.setClipboardText(ffi.string(text))
    end)

    io.GetClipboardTextFn = cliboard_callback_get
    io.SetClipboardTextFn = cliboard_callback_set

    local dpiscale = love.window.getDPIScale()
    io.DisplayFramebufferScale.x, io.DisplayFramebufferScale.y = dpiscale, dpiscale

    love.filesystem.createDirectory("/")
    strings.ini_filename = love.filesystem.getSaveDirectory() .. "/imgui.ini"
    io.IniFilename = strings.ini_filename

    strings.impl_name = "cimgui-love"
    io.BackendPlatformName = strings.impl_name
    io.BackendRendererName = strings.impl_name

    io.BackendFlags = bit.bor(C.ImGuiBackendFlags_HasMouseCursors, C.ImGuiBackendFlags_HasSetMousePos)
end

local custom_shader

function L.SetShader(shader)
    custom_shader = shader
end

function L.BuildFontAtlas(format)
    format = format or "RGBA32"
    local pixels, width, height = ffi.new("unsigned char*[1]"), ffi.new("int[1]"), ffi.new("int[1]")
    local imgdata

    if format == "RGBA32" then
        C.ImFontAtlas_GetTexDataAsRGBA32(io.Fonts, pixels, width, height, nil)
        imgdata = love.image.newImageData(width[0], height[0], "rgba8", ffi.string(pixels[0], width[0]*height[0]*4))
        textureShader = nil
    elseif format == "Alpha8" then
        C.ImFontAtlas_GetTexDataAsAlpha8(io.Fonts, pixels, width, height, nil)
        imgdata = love.image.newImageData(width[0], height[0], "r8", ffi.string(pixels[0], width[0]*height[0]))
        textureShader = Alpha8_shader
    else
        error([[Format should be either "RGBA32" or "Alpha8".]], 2)
    end

    textureObject = love.graphics.newImage(imgdata)
end

function L.Update(dt)
    io.DisplaySize.x, io.DisplaySize.y = love.graphics.getDimensions()
    io.DeltaTime = dt

    if io.WantSetMousePos then
        love.mouse.setPosition(io.MousePos.x, io.MousePos.y)
    end
end

local function love_texture_test(t)
    return t:typeOf("Texture")
end

local cursors = {
    [C.ImGuiMouseCursor_Arrow] = love.mouse.getSystemCursor("arrow"),
    [C.ImGuiMouseCursor_TextInput] = love.mouse.getSystemCursor("ibeam"),
    [C.ImGuiMouseCursor_ResizeAll] = love.mouse.getSystemCursor("sizeall"),
    [C.ImGuiMouseCursor_ResizeNS] = love.mouse.getSystemCursor("sizens"),
    [C.ImGuiMouseCursor_ResizeEW] = love.mouse.getSystemCursor("sizewe"),
    [C.ImGuiMouseCursor_ResizeNESW] = love.mouse.getSystemCursor("sizenesw"),
    [C.ImGuiMouseCursor_ResizeNWSE] = love.mouse.getSystemCursor("sizenwse"),
    [C.ImGuiMouseCursor_Hand] = love.mouse.getSystemCursor("hand"),
    [C.ImGuiMouseCursor_NotAllowed] = love.mouse.getSystemCursor("no"),
}

local mesh, meshdata
local max_vertexcount = -math.huge

function L.RenderDrawLists()
    -- Avoid rendering when minimized
    if io.DisplaySize.x == 0 or io.DisplaySize.y == 0 or not love.window.isVisible() then return end

    love.graphics.push("all")

    _common.RunShortcuts()
    local data = C.igGetDrawData()

    -- change mouse cursor
    if bit.band(io.ConfigFlags, C.ImGuiConfigFlags_NoMouseCursorChange) ~= C.ImGuiConfigFlags_NoMouseCursorChange then
        local cursor = cursors[C.igGetMouseCursor()]
        if io.MouseDrawCursor or not cursor then
            love.mouse.setVisible(false) -- Hide OS mouse cursor if ImGui is drawing it
        else
            love.mouse.setVisible(true)
            love.mouse.setCursor(cursor)
        end
    end

    for i = 0, data.CmdListsCount - 1 do
        local cmd_list = data.CmdLists[i]

        local vertexcount = cmd_list.VtxBuffer.Size
        local data_size = vertexcount*ffi.sizeof("ImDrawVert")
        if vertexcount > max_vertexcount then
            max_vertexcount = vertexcount
            if mesh then mesh:release() end
            if meshdata then meshdata:release() end
            meshdata = love.data.newByteData(math.max(data_size, ffi.sizeof("ImDrawVert")))
            ffi.copy(meshdata:getFFIPointer(), cmd_list.VtxBuffer.Data, data_size)
            mesh = love.graphics.newMesh(vertexformat, meshdata, "triangles", "static")
        else
            ffi.copy(meshdata:getFFIPointer(), cmd_list.VtxBuffer.Data, data_size)
            mesh:setVertices(meshdata)
        end

        local IdxBuffer = {}
        for k = 1, cmd_list.IdxBuffer.Size do
            IdxBuffer[k] = cmd_list.IdxBuffer.Data[k - 1] + 1
        end
        mesh:setVertexMap(IdxBuffer)

        for k = 0, cmd_list.CmdBuffer.Size - 1 do
            local cmd = cmd_list.CmdBuffer.Data[k]
            if cmd.UserCallback ~= nil then
                local callback = _common.callbacks[ffi.string(ffi.cast("void*", cmd.UserCallback))] or cmd.UserCallback
                callback(cmd_list, cmd)
            elseif cmd.ElemCount > 0 then
                local clipX, clipY = cmd.ClipRect.x, cmd.ClipRect.y
                local clipW = cmd.ClipRect.z - clipX
                local clipH = cmd.ClipRect.w - clipY

                love.graphics.setBlendMode("alpha", "alphamultiply")

                local texture_id = C.ImDrawCmd_GetTexID(cmd)
                if texture_id ~= nil then
                    local obj = _common.textures[tostring(texture_id)]
                    local status, value = pcall(love_texture_test, obj)
                    assert(status and value, "Only LÖVE Texture objects can be passed as ImTextureID arguments.")
                    if obj:typeOf("Canvas") then
                        love.graphics.setBlendMode("alpha", "premultiplied")
                    end
                    love.graphics.setShader()
                    mesh:setTexture(obj)
                else
                    love.graphics.setShader(custom_shader or textureShader)
                    mesh:setTexture(textureObject)
                end

                love.graphics.setScissor(clipX, clipY, clipW, clipH)
                mesh:setDrawRange(cmd.IdxOffset + 1, cmd.ElemCount)
                love.graphics.draw(mesh)
            end
        end
    end
    love.graphics.pop()
end

function L.MouseMoved(x, y)
    if love.window.hasMouseFocus() then
        io:AddMousePosEvent(x, y)
    end
end

local mouse_buttons = {true, true, true}

function L.MousePressed(button)
    if mouse_buttons[button] then
        io:AddMouseButtonEvent(button - 1, true)
    end
end

function L.MouseReleased(button)
    if mouse_buttons[button] then
        io:AddMouseButtonEvent(button - 1, false)
    end
end

function L.WheelMoved(x, y)
    io:AddMouseWheelEvent(x, y)
end

function L.KeyPressed(key)
    local t = lovekeymap[key]
    if type(t) == "table" then
        io:AddKeyEvent(t[1], true)
        io:AddKeyEvent(t[2], true)
    else
        io:AddKeyEvent(t or C.ImGuiKey_None, true)
    end
end

function L.KeyReleased(key)
    local t = lovekeymap[key]
    if type(t) == "table" then
        io:AddKeyEvent(t[1], false)
        io:AddKeyEvent(t[2], false)
    else
        io:AddKeyEvent(t or C.ImGuiKey_None, false)
    end
end

function L.TextInput(text)
    C.ImGuiIO_AddInputCharactersUTF8(io, text)
end

function L.Shutdown()
    C.igDestroyContext(nil)
    io = nil
    cliboard_callback_get:free()
    cliboard_callback_set:free()
    cliboard_callback_get, cliboard_callback_set = nil
end

function L.JoystickAdded(joystick)
    if not joystick:isGamepad() then return end
    io.BackendFlags = bit.bor(io.BackendFlags, C.ImGuiBackendFlags_HasGamepad)
end

function L.JoystickRemoved()
    for _, joystick in ipairs(love.joystick.getJoysticks()) do
        if joystick:isGamepad() then return end
    end
    io.BackendFlags = bit.band(io.BackendFlags, bit.bnot(C.ImGuiBackendFlags_HasGamepad))
end

local gamepad_map = {
    start = C.ImGuiKey_GamepadStart,
    back = C.ImGuiKey_GamepadBack,
    a = C.ImGuiKey_GamepadFaceDown,
    b = C.ImGuiKey_GamepadFaceRight,
    y = C.ImGuiKey_GamepadFaceUp,
    x = C.ImGuiKey_GamepadFaceLeft,
    dpleft = C.ImGuiKey_GamepadDpadLeft,
    dpright = C.ImGuiKey_GamepadDpadRight,
    dpup = C.ImGuiKey_GamepadDpadUp,
    dpdown = C.ImGuiKey_GamepadDpadDown,
    leftshoulder = C.ImGuiKey_GamepadL1,
    rightshoulder = C.ImGuiKey_GamepadR1,
    leftstick = C.ImGuiKey_GamepadL3,
    rightstick = C.ImGuiKey_GamepadR3,
    --analog
    triggerleft = C.ImGuiKey_GamepadL2,
    triggerright = C.ImGuiKey_GamepadR2,
    leftx = {C.ImGuiKey_GamepadLStickLeft, C.ImGuiKey_GamepadLStickRight},
    lefty = {C.ImGuiKey_GamepadLStickUp, C.ImGuiKey_GamepadLStickDown},
    rightx = {C.ImGuiKey_GamepadRStickLeft, C.ImGuiKey_GamepadRStickRight},
    righty = {C.ImGuiKey_GamepadRStickUp, C.ImGuiKey_GamepadRStickDown},
}

function L.GamepadPressed(button)
    io:AddKeyEvent(gamepad_map[button] or C.ImGuiKey_None, true)
end

function L.GamepadReleased(button)
    io:AddKeyEvent(gamepad_map[button] or C.ImGuiKey_None, false)
end

function L.GamepadAxis(axis, value, threshold)
    threshold = threshold or 0
    local imguikey = gamepad_map[axis]
    if type(imguikey) == "table" then
        if value > threshold then
            io:AddKeyAnalogEvent(imguikey[2], true, value)
            io:AddKeyAnalogEvent(imguikey[1], false, 0)
        elseif value < -threshold then
            io:AddKeyAnalogEvent(imguikey[1], true, -value)
            io:AddKeyAnalogEvent(imguikey[2], false, 0)
        else
           io:AddKeyAnalogEvent(imguikey[1], false, 0)
           io:AddKeyAnalogEvent(imguikey[2], false, 0)
        end
    elseif imguikey then
        io:AddKeyAnalogEvent(imguikey, value ~= 0, value)
    end
end

-- input capture

function L.GetWantCaptureMouse()
    return io.WantCaptureMouse
end

function L.GetWantCaptureKeyboard()
    return io.WantCaptureKeyboard
end

function L.GetWantTextInput()
    return io.WantTextInput
end

-- flag helpers
local flags = {}

for name in pairs(M) do
    name = name:match("^(%w+Flags)_")
    if name and not flags[name] then
        flags[name] = true
    end
end

for name in pairs(flags) do
    local shortname = name:gsub("^ImGui", "")
    shortname = shortname:gsub("^Im", "")
    L[shortname] = function(...)
        local t = {}
        for _, flag in ipairs({...}) do
            t[#t + 1] = M[name .. "_" .. flag]
        end
        return bit.bor(unpack(t))
    end
end

-- revert to old implementation names, i.e., imgui.RenderDrawLists instead of imgui.love.RenderDrawLists, etc.
local old_names = {}

for k, v in pairs(L) do
    old_names[k] = v
end

function L.RevertToOldNames()
    for k, v in pairs(old_names) do
        M[k] = v
    end
end


-----------------------
-- CUSTOM EXTENSIONS --
-----------------------
local function sync_buffer_set(buffer, value)
  if not buffer then return end
  
  if type(value) == 'string' then
	ffi.copy(buffer, value)
  elseif type(value) == 'number' then
	buffer[0] = value
  elseif type(value) == 'boolean' then
	buffer[0] = value
  end
end

local function sync_buffer_allocate(value)
  local buffer
  if type(value) == 'string' then
	buffer = ffi.new('char [256]')
  elseif type(value) == 'number' then
	buffer =  ffi.new('float [1]')
  elseif type(value) == 'boolean' then
	buffer = ffi.new('bool [1]')
  end

  sync_buffer_set(buffer, value)
  return buffer
end

local function sync_buffer_get(buffer, value)
  if type(value) == 'string' then
	return ffi.string(buffer)
  elseif type(value) == 'number' then
	return buffer[0]
  elseif type(value) == 'boolean' then
	return buffer[0]
  end
end

local function sync_buffer_render(buffer, dirty, t, k)
  local value = t[k]
  local id = '##' .. table.address(t) .. ':' .. k
  if type(value) == 'string' then
	if imgui.InputText(id, buffer, 256) then dirty[k] = true end
  elseif type(value) == 'number' then
	if imgui.InputFloat(id, buffer) then dirty[k] = true end
  elseif type(value) == 'boolean' then
	if imgui.Checkbox(id, buffer) then dirty[k] = true end
  end
end

local sync_infos = {}
function L.SyncField(t, k)
  local value = t[k]
  if type(value) == 'table' then
	for key, _ in pairs(value) do
	  L.SyncField(value, key)
	end
	return
  end
  
  local address = table.address(t)
  local entry = sync_infos[address]
  if not entry then
	sync_infos[address] = {
	  tbl = t,
	  fields = {},
	  dirty = {}
	}
	entry = sync_infos[address]
  end

  local field = entry.fields[k]
  if not field then
	entry.fields[k] = sync_buffer_allocate(t[k])
	return
  end
end

function L.UpdateSyncedFields()
  for address, table_entry in pairs(sync_infos) do
	for field, buffer in pairs(table_entry.fields) do
	  local lua_value = table_entry.tbl[field]
	  
	  if table_entry.dirty[field] then 
		-- Pull value from C if the corresponding input field returned a change
		local next_value = sync_buffer_get(buffer, lua_value)
		table_entry.tbl[field] = next_value
		
		-- Mark that we're now up to date
		table_entry.dirty[field] = nil
	  else
		-- Otherwise, set C buffer to what's in Lua. This is really inefficient!
		-- Every frame, every field on the UI is memcpy'd into C. We can avoid this the other
		-- way around, because we have simple change detection from ImGui, but unless
		-- we do something equally heavy we have no way of doing change detection on pure Lua 
		sync_buffer_set(buffer, lua_value)
	  end
	end
  end
end

function L.Input(t, k)
  local address = table.address(t)
  local entry = sync_infos[address]

  if not entry then dbg() end
  local buffer = entry.fields[k]
  if not buffer then
	L.SyncField(t, k)
	buffer = entry.fields[k]
  end

  sync_buffer_render(buffer, entry.dirty, t, k)
end


------------
-- TABLES --
------------
function L.VariableName(name, color)
   color = color or engine.color32(0, 200, 200, 255)
   imgui.PushStyleColor_U32(imgui.ImGuiCol_Text, color)
   imgui.Text(tostring(name))
   imgui.PopStyleColor()
   if imgui.IsItemHovered() then
	 if true then return end
	 local padding = imgui.ImVec2_Float(5, 3)
	 local size = imgui.GetItemRectSize();
	 local min = imgui.GetItemRectMin();
	 min = min - padding
	 max = min + size + padding

	 local color4 = imgui.ImVec4_Float(0, 1, 0, .3)
	 local color = imgui.ColorConvertFloat4ToU32(color4)
	 local draw_list = imgui.ImDrawList()
	 imgui.C.ImDrawList_AddRectFilled(draw_list, min, max, color, 0, 0)
   end

end

function L.Table(t, ignore)
  ignore = ignore or {}
  for member, value in pairs(t) do
	if not ignore[member] then
	  local value_type = type(value)
	  
	  if value_type == 'string' then
		imgui.love.VariableName(member)
		imgui.SameLine()
		imgui.PushTextWrapPos(0)
		imgui.Text(value)
		imgui.PopTextWrapPos()
	  elseif value_type == 'number' then
		imgui.love.VariableName(member)
		imgui.SameLine()
		imgui.Text(tostring(value))
	  elseif value_type == 'boolean' then
		imgui.love.VariableName(member)
		imgui.SameLine()
		imgui.Text(tostring(value))
	  elseif value_type == 'table' then
		imgui.love.TableMenuItem(member, value)
	  end
	end
  end
end

function L.TableMenuItem(name, t)
  local address = table.address(t)
  local imgui_id = name .. '##' .. address

  if imgui.TreeNode_Str(imgui_id) then
	imgui.love.Table(t)
	imgui.TreePop()
  end
end


------------------
-- TABLE EDITOR --
------------------
local function table_editor_padding(editor)
  -- Very hacky way to line up the inputs: Figure out the largest key, then when drawing a key,
  -- use the difference in length between current key and largest key as a padding. Does not work
  -- that well, but kind of works
  local padding_threshold = 12
  local padding_target = 0
  for key, value in pairs(editor.editing) do
	local key_len = 0
	if type(key) == 'string' then key_len = #key end
	if type(key) == 'number' then key_len = #tostring(key) end -- whatever
	if type(key) == 'boolean' then key_len = #tostring(key) end
	padding_target = math.max(padding_target, key_len)
  end

  local min_padding = 60
  local padding = math.max(padding_target * 5, min_padding)
  return padding
end

local function propagate_table_editor_params(editor)
  local params = {}
  params.add_field_on_rclick = editor.add_field_on_rclick
  params.depth = editor.depth + 1
  params.seen = table.shallow_copy(editor.seen)
  return params
end

local function draw_table_editor(editor)
  -- If the user right clicked a sub-table, we show a prompt to add an entry to the sub-table.
  -- Record whether a field was added in this way to return to the user
  local field_added = false
  if editor.add_field_on_rclick then field_added = imgui.internal.draw_table_field_add(editor) end

  local field_changed = false

  -- Figure out ImGui stuff for alignment
  local cursor = imgui.GetCursorPosX()
  local padding = table_editor_padding(editor)
  local open_item_context_menu = false

  -- Sort the keys
  local sorted_keys = {}
  for key, value in pairs(editor.editing) do
	table.insert(sorted_keys, key)
  end
  local sortf = function(a, b)
	local va = editor.editing[a]
	local ta = type(va) == 'table'
	local vb = editor.editing[b]
	local tb = type(vb) == 'table'
	
	if ta and not tb then return true end
	if tb and not ta then return false end
	return a < b
  end
  table.sort(sorted_keys, sortf)

  -- Display each KVP
  for _, key in ipairs(sorted_keys) do
	local value = editor.editing[key]

	-- Assign a UNIQUE label to this entry
	local label = string.format('##%s', table.hash_entry(editor.editing, tostring(key)))

	if not editor:is_field_ignored(key) then
	  -- Strings
	  if type(value) ~= 'table' then
		L.VariableName(key)
		imgui.SameLine()
		imgui.SetCursorPosX(cursor + padding)
		imgui.PushItemWidth(-1)
		L.Input(editor.editing, key)
		imgui.PopItemWidth()

	  elseif editor:is_self_referential(value) then
		L.VariableName(key)
		imgui.SameLine()
		imgui.SetCursorPosX(cursor + padding)
		imgui.PushItemWidth(-1)
		
		imgui.Text('self referential')
		imgui.PopItemWidth()
		
      -- All other tables
	  elseif type(value) == 'table' then
		-- If this is the first time we've seen this sub-table, make an editor for it.
		local address = table.address(value)
		if not editor.children[address] then
		  local params = propagate_table_editor_params(editor)
		  editor.children[address] = L.TableEditor(value, params)
		  field_changed = true
		end
		local child = editor.children[address]
		child.editing = value

		-- Modals! If the table's tree node is clicked, we want to draw it. If it's right clicked,
		-- we want to open a popup where you can add new fields.
		local open_context_menu = false
		
		local key_for_display = key
		if editor._replace_array_indices then
		  key_for_display = editor._on_replace(key)
		end
		  
		local unique_treenode_id = key_for_display .. label
		local on_collapsed = function()
		  if imgui.IsItemClicked(1) then open_context_menu = true end
		  draw_table_editor(child, seen)
		end

		-- This is a little wonky. Normal use case for this:
		-- - Make a table editor for a whole table.
		-- - Show all table items every frame
		-- - Use CollapsingHeader for top level sub-tables, because it is pretty
		-- - Use TreeNode for sub-tables in _that_, because nested CollapsingHeader is confusing
		if child.depth and child.depth > 2 then
		  if imgui.TreeNode_Str(unique_treenode_id) then
			on_collapsed()
			imgui.TreePop()
		  end
		else
		  if imgui.CollapsingHeader_TreeNodeFlags(unique_treenode_id) then
			on_collapsed()
		  end
		end

		-- At this point, table + header are drawn. We've just got to show any popups.
		-- Show the context menu
		local open_field_editor = false
		local context_menu_id = label .. ':context_menu'
		if open_context_menu then
		  imgui.OpenPopup(context_menu_id)
		end
		if imgui.BeginPopup(context_menu_id) then
		  if imgui.MenuItem('Add field') then
			open_field_editor = true
		  end
		  imgui.EndPopup()
		end

		-- Show the aforementioned field editor modal
		local field_editor_id = label .. ':field_editor'
		if open_field_editor then
		  imgui.OpenPopup(field_editor_id)
		end
		if imgui.BeginPopup(field_editor_id) then
		  if imgui.internal.draw_table_field_add(child) then
			imgui.CloseCurrentPopup()
		  end
		  imgui.EndPopup()
		end

		::done_table::
	  end
	end
  end

  -- If any variable was right clicked, we show a little context menu where you can delete it
  local item_context_menu_id = '##' .. table.hash_entry(editor.editing, editor.context_menu_item)
  if open_item_context_menu then
	imgui.OpenPopup(item_context_menu_id)
  end
  if imgui.BeginPopup(item_context_menu_id) then
	if imgui.Button('Delete') then
	  editor.editing[editor.context_menu_item] = nil
	  editor.context_menu_item = nil
	  imgui.CloseCurrentPopup()
	end
	imgui.EndPopup()
  end

  return field_added, field_changed
end

function L.TableEditor(editing, params)
  if not params then params = {} end
  local editor = {
	is_table_editor = true,
	editing = editing,
	children = {},

	-- Mapping of string -> bool. Any fields in this table won't be
	-- displayed with the table editor
	imgui_ignore = params.imgui_ignore or {},
	
	-- If this is enabled, when you right click a sub-table, you get a
	-- popup to add a new field
	add_field_on_rclick = params.add_field_on_rclick or false,
	
	-- Depth from the root table of this tree of editors
	depth = params.depth or 1,

	-- When a variable is right clicked, we show a context menu. This keeps track
	-- of the variable that the context menu was opened for.
	context_menu_item = nil,

	-- A list of tables we've already seen in this tree, to avoid infinite
	-- self-reference
	seen = params.seen or {},
	
	draw = function(self) return draw_table_editor(self) end,

	is_field_ignored = function(self, k)
	  local value = self.editing[k]
	  
	  local ignore = false
	  ignore = ignore or self.imgui_ignore[k]
	  ignore = ignore or self.editing.imgui_ignore and self.editing.imgui_ignore[k]
	  ignore = ignore or type(value) == 'function'
	  ignore = ignore or type(value) == 'table' and value.is_table_editor
	  return ignore
	end,
	is_self_referential = function(self, t)
	  local address = table.address(t)
	  return self.seen[address]
	end,
	add_child = function(self, key, child)
	  if type(child) ~= 'table' then
		L.SyncField(self.editing, key)
		return
	  end
	  
	  recurse = recurse and not (child == self.editing)
	  recurse = recurse and not self.editing.is_table_editor
	  recurse = recurse and not self:is_field_ignored(key)
	  recurse = recurse and not self:is_self_referential(child)
	  if recurse then
		local params = propagate_table_editor_params(self)
		local address = table.address(child)

		-- Important: Child tables are indexed by address, not by key. If they were indexed by key,
		-- then if the table was replaced at runtime, our entries in the SyncField bookkeeping would
		-- point to a stale table.
		self.children[address] = imgui.love.TableEditor(child, params)
	  end
	end,
	replace_array_indices = function(self, on_replace)
	  self._replace_array_indices = true
	  self._on_replace = on_replace
	end
  }

  editor.imgui_ignore.imgui_ignore = true
  editor.imgui_ignore.__type = true
  editor.seen[table.address(editor.editing)] = true

  -- Each child member that is a non-recursive table also gets an editor
  for key, value in pairs(editing) do
	editor:add_child(key, value)
  end

  return editor
end

