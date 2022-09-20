Item = engine.entity.define('Item')
Item.components = {
  'Click'
}

function Item:init(params)
  print('item init')
end

function Item:update(dt)
  --print('item update')
end
