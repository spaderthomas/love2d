Editor = engine.entity.define('Editor')
Editor:set_mask('editor')

function Editor:init()
  self.editor = imgui.love.TableEditor(engine.entity.entities)
  self.editor:replace_array_indices(function(index)
	  local entity = engine.entity.entities[index]
	  if #entity.tag > 0 then
		return string.format('%s [%s] [%s]', entity.name, entity.tag, entity:get_mask())
	  else
		return string.format('%s [%s]', entity.name, entity:get_mask())
	  end
  end)

  local params = {
	depth = 2
  }
  self.mask_editor = imgui.love.TableEditor(engine.entity.masks, params)
end

function Editor:update()
  if engine.input.was_pressed('f1') then
	local current = engine.entity.masks.update.game
	engine.entity.masks.update.game = not current
  end
end

function Editor:draw()
  love.graphics.setColor(1, 1, 1, 1)
  imgui.Begin('love2d')
  imgui.love.Table(engine.frame)
  if imgui.CollapsingHeader_TreeNodeFlags('masks') then
	self.mask_editor:draw()
  end
  imgui.End()

  imgui.Begin('Entity')
  self.editor:draw()
  imgui.End()

end
