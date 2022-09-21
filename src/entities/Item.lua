Item = engine.entity.define('Item')
Item.components = {
  'Collider',
  'Click'
}

function Item:init(params)
  print('item init')
end

function Item:update(dt)
  if engine.input.was_pressed('a') then
	print('a pressed')
  end
  --print(inspect(engine.input.is_down))
end
