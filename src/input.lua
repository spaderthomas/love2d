engine.controller = {
  gamecube = 'gamecube'
}

local gamecube_controller = function()
  return {
	gray_stick = engine.vec2(0, 0),
	c_stick = engine.vec2(0, 0),
	left_trigger = engine.vec2(0, 0),
	right_trigger = engine.vec2(0, 0),
	x = false,
  }
end

function engine.controllers.init()
  engine.controllers.data = {}
  engine.controllers.data_last = {}
  
  engine.controllers.data.gamecube      = gamecube_controller()
  engine.controllers.data_last.gamecube = gamecube_controller()
end


function engine.controllers.update()
  engine.controllers.data_last = table.deep_copy(engine.controllers.data)
  
  local gamecube = engine.controllers.data.gamecube
  local joystick = love.joystick.getJoysticks()[1]
  gsx, gsy, csy, lt, rt, csx = joystick:getAxes()
  gamecube.gray_stick.x = gsx
  gamecube.gray_stick.y = gsy
  gamecube.c_stick.x    = csx
  gamecube.c_stick.y = csy
  gamecube.left_trigger = lt
  gamecube.right_trigger = rt
end
