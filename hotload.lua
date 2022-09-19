lows.hotload = {}

function lows.hotload.script(script)
  local info = love.filesystem.getInfo(script)
  lows.scripts[script] = info.modtime
  dofile(script)
end

function lows.hotload.update()
  for script, modtime in pairs(lows.scripts) do
	local info = love.filesystem.getInfo(script)
	if info.modtime > modtime then
	  print('hotload:', script)
	  lows.hotload.script(script)
	end
  end
end

function lows.hotload.init()
  lows.hotload.script('main.lua')
  lows.hotload.script('hotload.lua')
  lows.hotload.script('inspect.lua')
  lows.hotload.script('class.lua')
  lows.hotload.script('utils.lua')
  lows.hotload.script('player.lua')
  lows.hotload.script('input.lua')
end
