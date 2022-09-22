engine.hotload = {}

function engine.hotload.script(script)
  local info = love.filesystem.getInfo(script)
  engine.scripts[script] = info.modtime
  dofile(script)
end

function engine.hotload.directory(dir)
  local files = love.filesystem.getDirectoryItems(dir)
  for i, file in pairs(files) do
	local full_path = dir .. '/' .. file
	engine.hotload.script(full_path)
  end
end

function engine.hotload.update()
  for script, modtime in pairs(engine.scripts) do
	local info = love.filesystem.getInfo(script)
	if info.modtime > modtime then
	  print('hotload:', script)
	  engine.hotload.script(script)
	end
  end
end

function engine.hotload.init()
  engine.hotload.script(engine.paths.script('path'))
  engine.hotload.script(engine.paths.script('hotload'))
  engine.hotload.script(engine.paths.script('love'))
  engine.hotload.script(engine.paths.script('log'))
  engine.hotload.script(engine.paths.script('debugger'))
  engine.hotload.script(engine.paths.script('inspect'))
  engine.hotload.script(engine.paths.script('class'))
  engine.hotload.script(engine.paths.script('platform'))
  engine.hotload.script(engine.paths.script('utils'))
  engine.hotload.script(engine.paths.script('input'))
  engine.hotload.script(engine.paths.script('entity'))

  
  engine.hotload.directory(engine.paths.entities)
  engine.hotload.directory(engine.paths.components)
end
