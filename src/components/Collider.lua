Collider = engine.class.define('Collider')

function Collider:init(params)
  local size = params.size or engine.vec2(50, 50)
  local position = params.position or engine.vec2(50, 50)
  
  self.body = love.physics.newBody(engine.physics.world, position.x, position.y)
  self.shape = love.physics.newRectangleShape(size.x, size.y)
  self.fixture = love.physics.newFixture(self.body, self.shape)
end

function Collider:update(dt)
end

function Collider:is_point_inside(x, y)
  return self.fixture:testPoint(x, y)
end
