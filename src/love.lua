ffi = require('ffi')

function love.load()
  -- Phase 0 init: Make sure that the game's base tables exist
  engine = {}
  engine.scripts = {}
  engine.class = {}
  engine.class.classes = {}
  engine.fonts = {}
  engine.physics = {}
  engine.input = {}
  engine.platform = {}
  engine.entity = {}
  engine.entity.entities = {}
  engine.entity.entities_to_add = {}
  engine.entity.entities_to_destroy = {}
  engine.next_entity_id = 1

  -- Phase 1: Load all the game's scripts
  dofile('src/hotload.lua')
  dofile('src/path.lua')
  engine.hotload.init()

  package.cpath = string.format(
	"%s;%s/?.%s",
	package.cpath,
	engine.paths.clibs, engine.platform.dll_extension())

  require(engine.paths.lib('cimgui'))
  imgui.love.Init('RGBA32')

  -- Phase 2: Initialize the game itself
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

  love.graphics.setBackgroundColor(.188, 0.207, 0.271)
  love.window.setMode(650, 650)

  item = engine.entity.create('Item')
end

function love.update(dt)
  imgui.love.Update(dt)
  imgui.NewFrame()
  
  engine.hotload.update()
  engine.entity.update(dt)
  engine.physics.world:update(dt)
  engine.input.end_frame()
end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Hello World!', 125, 250, 0)

  local collider = item:find_component('Collider')
  love.graphics.setColor(0.188, 0.103, 0.094) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", collider.body:getWorldPoints(collider.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  
  love.graphics.setColor(1,1,1)
  imgui.Render()
  imgui.love.RenderDrawLists()
end

