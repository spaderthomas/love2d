lows.controller = {
  gamecube = 'gamecube'
}

local gamecube_controller = function()
  return {
	gray_stick = lows.vec2(0, 0),
	c_stick = lows.vec2(0, 0),
	left_trigger = lows.vec2(0, 0),
	right_trigger = lows.vec2(0, 0),
	x = false,
  }
end

function lows.controllers.init()
  lows.controllers.data = {}
  lows.controllers.data_last = {}
  
  lows.controllers.data.gamecube      = gamecube_controller()
  lows.controllers.data_last.gamecube = gamecube_controller()
end


function lows.controllers.update()
  lows.controllers.data_last = table.deep_copy(lows.controllers.data)
  
  local gamecube = lows.controllers.data.gamecube
  local joystick = love.joystick.getJoysticks()[1]
  gsx, gsy, csy, lt, rt, csx = joystick:getAxes()
  gamecube.gray_stick.x = gsx
  gamecube.gray_stick.y = gsy
  gamecube.c_stick.x    = csx
  gamecube.c_stick.y = csy
  gamecube.left_trigger = lt
  gamecube.right_trigger = rt
end
