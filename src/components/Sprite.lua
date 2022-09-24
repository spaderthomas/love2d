Sprite = engine.class.define('Sprite')

function Sprite:init(params)
  self.image = params.image or 'stardew-tv.png'
end

function Sprite:update(dt)
end

function Sprite:draw()
  local image = engine.image.find(self.image)
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(image)
end
