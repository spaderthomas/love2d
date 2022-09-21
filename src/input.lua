engine.input.is_down = {}
engine.input.was_down = {}

function love.keypressed(key, scancode, is_repeat)
  engine.input.is_down[key] = true
end

function love.mousepressed(key, scancode, is_repeat)
  -- @spader: do this, figure out how to make it not special cased w/ iterating over keys
  -- maybe mouse_buffer and key_buffer?
  -- maybe buffer.mouse and buffer.keys?
end

function engine.input.end_frame()
  for key, _ in pairs(engine.input.was_down) do
	engine.input.was_down[key] = nil
  end

  for key, _ in pairs(engine.input.is_down) do
	engine.input.was_down[key] = true

	-- Nil it out instead of setting it to false so that this map is readable if
	-- you ever need to debug it
	local is_down = love.keyboard.isDown(key)
	if is_down then
	  engine.input.is_down[key] = true
	else
	  engine.input.is_down[key] = nil
	end
  end
end

function engine.input.was_pressed(key)
  return engine.input.is_down[key] and not engine.input.was_down[key]
end
