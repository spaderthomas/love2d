ItemSelector = engine.entity.define('ItemSelector')
ItemSelector.components = {}
ItemSelector.serialize_fields = {}

function ItemSelector:init(params)
end

function ItemSelector:update(dt)
  local mx, my = love.mouse.getPosition()
  local collidables = engine.entity.collect('Collider')
  for index, entity in pairs(collidables) do
	local collider = entity:find_component('Collider')
	if collider:is_point_inside(mx, my) then
	  print('hovered')
	end
  end
end

function ItemSelector:draw(dt)
end
