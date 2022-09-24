function engine.image.init()
  engine.image.images = {}
  
  local files = love.filesystem.getDirectoryItems(engine.paths.images)
  for i, file in pairs(files) do
	local full_path = engine.paths.image(file)
	print(full_path)
	engine.image.images[file] = love.graphics.newImage(full_path)
  end
end

function engine.image.find(filename)
  return engine.image.images[filename]
end
