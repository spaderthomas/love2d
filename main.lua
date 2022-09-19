function love.load()
  lows = {}
  lows.classes = {}
  lows.scripts = {}
  lows.fonts = {}
  lows.physics = {}
  lows.controllers = {}
  
  dofile('hotload.lua')
  lows.hotload.init()

  lows.controllers.init()

  lows.fonts.inconsolata = love.graphics.newFont('inconsolata.ttf', 72)
  lows.fonts.apple_kid = love.graphics.newFont('apple_kid.ttf', 72)
  love.graphics.setFont(lows.fonts.inconsolata)

  lows.physics.meter = 64
  lows.physics.gravity = lows.vec2(0, 9.81)
  love.physics.setMeter(lows.physics.meter)
  lows.physics.world = love.physics.newWorld(
	lows.physics.gravity.x,
	lows.physics.gravity.y * lows.physics.meter,
	true)

  player = Player:new()

  objects = {} -- table to hold all our physical objects
  
  --let's create the ground
  objects.ground = {}
  objects.ground.body = love.physics.newBody(lows.physics.world, 650/2, 650-50/2) --remember, the shape (the rectangle we create next) anchors to the body from its center, so we have to move it to (650/2, 650-50/2)
  objects.ground.shape = love.physics.newRectangleShape(650, 50) --make a rectangle with a width of 650 and a height of 50
  objects.ground.fixture = love.physics.newFixture(objects.ground.body, objects.ground.shape) --attach shape to body
  
  --let's create a couple blocks to play around with
  objects.block1 = {}
  objects.block1.body = love.physics.newBody(lows.physics.world, 200, 550, "dynamic")
  objects.block1.shape = love.physics.newRectangleShape(0, 0, 50, 100)
  objects.block1.fixture = love.physics.newFixture(objects.block1.body, objects.block1.shape, 5) -- A higher density gives it more mass.

  objects.block2 = {}
  objects.block2.body = love.physics.newBody(lows.physics.world, 200, 400, "dynamic")
  objects.block2.shape = love.physics.newRectangleShape(0, 0, 100, 50)
  objects.block2.fixture = love.physics.newFixture(objects.block2.body, objects.block2.shape, 2)

  love.graphics.setBackgroundColor(0.41, 0.53, 0.97) --set the background color to a nice blue
  love.window.setMode(650, 650) --set the window dimensions to 650 by 650 with no fullscreen, vsync on, and no antialiasing
end

function love.update(dt)
  lows.controllers.update()
  lows.hotload.update()

  lows.physics.world:update(dt) --this puts the world into motion

  if love.keyboard.isDown("space") then
	player.physics.body:setPosition(Player.spawn_point.x, Player.spawn_point.y)
	player.physics.body:setLinearVelocity(0, 0)
  end
  player:update()

end

function love.draw()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.print('Hello World!', 200, 250, 0)

  love.graphics.setColor(0.28, 0.63, 0.05) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", objects.ground.body:getWorldPoints(objects.ground.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(1, 0.63, 0.05) -- set the drawing color to green for the ground
  love.graphics.polygon("fill", player.physics.body:getWorldPoints(player.physics.shape:getPoints())) -- draw a "filled in" polygon using the ground's coordinates

  love.graphics.setColor(0.20, 0.20, 0.20) -- set the drawing color to grey for the blocks
  love.graphics.polygon("fill", objects.block1.body:getWorldPoints(objects.block1.shape:getPoints()))
  love.graphics.polygon("fill", objects.block2.body:getWorldPoints(objects.block2.shape:getPoints()))
end
