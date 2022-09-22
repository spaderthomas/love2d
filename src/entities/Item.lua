Item = engine.entity.define('Item')
Item.components = {
  'Collider',
  'Click'
}

function Item:init(params)
  self.buffer = ffi.new('char [256]')
end

function Item:update(dt)
  imgui.Begin('love2d')
  imgui.Text('hello, world!')
  imgui.InputText('hello', self.buffer, 256)
  --print(ffi.string(self.buffer))
  imgui.End()
end
