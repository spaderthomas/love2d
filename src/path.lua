engine.paths = {}

local append_file_to_dir = function(dir, file)
  local path = dir .. '/' .. file
  if string.find(path, '.lua') then return path end
  return path .. '.lua'
end

engine.paths.clibs = 'libs'
engine.paths.asset = 'asset'
  engine.paths.fonts = engine.paths.asset .. '/' .. 'fonts'
    engine.paths.font = function(name) return engine.paths.fonts .. '/' .. name end
  engine.paths.images = engine.paths.asset .. '/' .. 'image'
    engine.paths.image = function(name) return engine.paths.images .. '/' .. name end
engine.paths.scripts = 'src'
  engine.paths.script = function(name) return append_file_to_dir(engine.paths.scripts, name) end
  engine.paths.editor = engine.paths.scripts .. '/' .. 'editor'
  engine.paths.components = engine.paths.scripts .. '/' .. 'components'
    engine.paths.component = function(name) return append_file_to_dir(engine.paths.components, name) end
  engine.paths.entities = engine.paths.scripts .. '/' .. 'entities'
    engine.paths.entity = function(name) return append_file_to_dir(engine.paths.entities, name) end
  engine.paths.libs = engine.paths.scripts .. '/' .. 'libs'
    engine.paths.lib = function(name) return engine.paths.libs .. '/' .. name end
