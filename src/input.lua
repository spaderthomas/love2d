local is_down = {}
local was_down = {}
local is_clicked = {}
local was_clicked = {}

love.mousemoved = function(x, y, ...)
    imgui.love.MouseMoved(x, y)
end

love.mousepressed = function(x, y, button, ...)
    imgui.love.MousePressed(button)
    if not imgui.love.GetWantCaptureMouse() then
	  local label = ''
	  if button == 1 then label = 'lclick' end
	  if button == 2 then label = 'rclick' end
	  is_clicked[label] = true
    end
end

love.mousereleased = function(x, y, button, ...)
    imgui.love.MouseReleased(button)
    if not imgui.love.GetWantCaptureMouse() then
	  local label = ''
	  if button == 1 then label = 'lclick' end
	  if button == 2 then label = 'rclick' end
	  is_clicked[label] = nil
    end
end

love.wheelmoved = function(x, y)
    imgui.love.WheelMoved(x, y)
    if not imgui.love.GetWantCaptureMouse() then
	  return
    end
end

love.keypressed = function(key, ...)
    imgui.love.KeyPressed(key)
    if not imgui.love.GetWantCaptureKeyboard() then
	  is_down[key] = true
    end
end

love.keyreleased = function(key, ...)
    imgui.love.KeyReleased(key)
    if not imgui.love.GetWantCaptureKeyboard() then
	  return
    end
end

love.textinput = function(t)
    imgui.love.TextInput(t)
    if imgui.love.GetWantCaptureKeyboard() then
	  return
    end
end

love.quit = function()
    return imgui.love.Shutdown()
end

function engine.input.end_frame()
  -- Mouse
  table.clear(was_clicked)
  for mouse, _ in pairs(is_clicked) do
	was_clicked[mouse] = true
  end

  -- Keys
  table.clear(was_down)
  if imgui.love.GetWantCaptureKeyboard() then return end
  
  for key, _ in pairs(is_down) do
	was_down[key] = true

	if love.keyboard.isDown(key) then
	  is_down[key] = true
	else
	  is_down[key] = nil
	end
  end
end

function engine.input.was_pressed(key)
  return is_down[key] and not was_down[key]
end

function engine.input.is_down(key)
  return is_down[key]
end

function engine.input.was_clicked(mouse)
  return is_clicked[mouse] and not was_clicked[mouse]
end

function engine.input.is_clicked(mouse)
  return is_clicked[mouse]
end
