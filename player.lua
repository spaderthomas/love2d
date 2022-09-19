Player = lows.class('Player')

Player.spawn_point = lows.vec2(200, 200)

local state = {
  idle = 'idle',
  walk = 'walk'
}

local direction = {
  idle = 0,
  left = -1,
  right = 1
}

function Player:init(params)
  self.position = lows.vec2(0, 0)
  
  self.physics = {}
  self.physics.body = love.physics.newBody(
	lows.physics.world,
	Player.spawn_point.x, Player.spawn_point.y,
	'dynamic'
  )
  self.physics.shape = love.physics.newRectangleShape(100, 100)
  self.physics.fixture = love.physics.newFixture(self.physics.body, self.physics.shape, 1)

  self.max_run_speed = 350
  self.state = state.idle
  self.direction = direction.idle
end

function Player:update(dt)
  cvx, cvy = self.physics.body:getLinearVelocity()
  local controller = lows.controllers.data.gamecube
  local last_controller = lows.controllers.data_last.gamecube
  
  if self.state == state.idle then


	if player:initiated_dash() then
	  self.direction = direction_from_analog(controller.gray_stick.x)
	  self.state = state.dash
	  self.physics.body:setLinearVelocity(self.max_run_speed * self.direction, cvy)
	  print('dash')
	end

	-- Check if we're walking
	local walk_threshold = .05
	if math.abs(controller.gray_stick.x) > walk_threshold then
	  local vx = self.max_run_speed * self:sigmoid(controller.gray_stick.x)
	  self.physics.body:setLinearVelocity(vx, cvy)
	end
	
	self:clamp_linear_velocity()
  elseif self.state == state.walk then
  elseif self.state == state.dash then
	if player:initiated_dash() then
	  self.direction = direction_from_analog(controller.gray_stick.x)
	  self.state = state.dash
	end
	
	self.physics.body:setLinearVelocity(self.max_run_speed * self.direction, cvy)
  end
end

function direction_from_analog(x)
  if x > 0 then return direction.right end
  if x < 0 then return direction.left  end
  return direction.idle
end

function Player:initiated_dash()
  local controller = lows.controllers.data.gamecube
  local last_controller = lows.controllers.data_last.gamecube
  local dash_threshold = .15
  local delta = math.abs(controller.gray_stick.x) - math.abs(last_controller.gray_stick.x)
  return delta > dash_threshold 
end

function Player:clamp_linear_velocity()
  vx, vy = player.physics.body:getLinearVelocity()
  local clamped = math.min(math.abs(vx), self.max_run_speed)
  if vx > 0 then
	player.physics.body:setLinearVelocity(clamped, vy)
  else
	player.physics.body:setLinearVelocity(-1 * clamped, vy)
  end
end

function Player:sigmoid(x)
  local attack = .5
  local steepness = .2
  local curve = ((2 / (1 - steepness)) - 1)

  local absx = math.abs(x)
  local fx = 0
  if absx <= attack then
	fx = math.pow(absx, curve) / math.pow(attack, curve - 1)
  else
	fx = 1 - math.pow(1 - absx, curve) / math.pow(1 - attack, curve)
  end

  if x < 0 then fx = fx * -1 end
  return fx
end
