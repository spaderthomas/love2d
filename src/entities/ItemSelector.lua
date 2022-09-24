ItemSelector = engine.entity.define('ItemSelector')
ItemSelector.components = {}
ItemSelector.serialize_fields = {}

local state = {
  idle = 'idle',
  hovered = 'hovered',
  selected = 'selected'
}

function ItemSelector:init(params)
  self.state = state.idle
  self.hovered = nil
end

function ItemSelector:update(dt)
  local mx, my = love.mouse.getPosition()
  local collidables = engine.entity.collect('Collider')
  
  if self.state == state.idle then
	for index, entity in pairs(collidables) do
	  local collider = entity:find_component('Collider')
	  if collider:is_point_inside(mx, my) then
		self.hovered = entity
		self.state = state.hovered
	  end
	end
	
  elseif self.state == state.hovered then
	local collider = entity:find_component('Collider')
	if not collider:is_point_inside(mx, my) then
	  self.hovered = nil
	  self.state = state.idle
	end
  end
  
end

function ItemSelector:draw(dt)
end
