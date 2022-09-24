ffi = require('ffi')

function love.load()
  -- Phase 0 init: Make sure that the game's base tables exist
  engine = {}
  engine.frame = {}
  engine.scripts = {}
  engine.class = {}
  engine.class.classes = {}
  engine.fonts = {}
  engine.physics = {}
  engine.input = {}
  engine.platform = {}
  engine.image = {}
  engine.entity = {}
  engine.entity.entities = {}
  engine.entity.entities_to_add = {}
  engine.entity.entities_to_destroy = {}
  engine.next_entity_id = 1

  -- Phase 1: Load all the 's scripts
  dofile('src/hotload.lua')
  dofile('src/path.lua')
  engine.hotload.init()

  package.cpath = string.format(
	"%s;%s/?.%s",
	package.cpath,
	engine.paths.clibs, engine.platform.dll_extension())

  require(engine.paths.lib('cimgui'))
  imgui.love.Init('RGBA32')

  local io = imgui.C.igGetIO()
  io.ConfigFlags = bit.bor(io.ConfigFlags, imgui.ImGuiConfigFlags_DockingEnable)

  -- Phase 2: Initialize the game itself
  engine.entity.init()
  engine.image.init()
  engine.frame.count = 0
  engine.frame.dt_buffer = {}

  
  engine.fonts.inconsolata = love.graphics.newFont(engine.paths.font('inconsolata.ttf'), 72)
  engine.fonts.apple_kid = love.graphics.newFont(engine.paths.font('apple_kid.ttf'), 72)
  love.graphics.setFont(engine.fonts.inconsolata)

  engine.physics.meter = 64
  engine.physics.gravity = engine.vec2(0, 9.81)
  love.physics.setMeter(engine.physics.meter)
  engine.physics.world = love.physics.newWorld(
	engine.physics.gravity.x,
	engine.physics.gravity.y * engine.physics.meter,
	true)

  love.graphics.setBackgroundColor(1, 1, 1)
  love.window.setMode(1600, 900)

  engine.entity.create('Editor')
  engine.entity.create('Item')
  engine.entity.create('ItemSelector')
end

function love.update(dt)
  engine.frame.dt = dt
  engine.frame.count = engine.frame.count + 1

  local ring_buffer_index = engine.frame.count % 10 + 1
  engine.frame.dt_buffer[ring_buffer_index] = dt
  if engine.frame.count % 60 == 0 then
	local sum = 0
	for i, dt in pairs(engine.frame.dt_buffer) do
	  sum = sum + dt
	end
	engine.frame.framerate = 10 / sum
  end
  
  imgui.love.Update(dt)
  imgui.love.UpdateSyncedFields()
  imgui.NewFrame()
  
  engine.hotload.update()
  engine.entity.update(dt)
  engine.physics.world:update(dt)
  engine.input.end_frame()
end

function love.draw()
  engine.entity.draw()

  love.graphics.setColor(1, 1, 1, 1)
  imgui.Render()
  imgui.love.RenderDrawLists()
end

