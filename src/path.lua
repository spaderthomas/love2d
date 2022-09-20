engine.paths = {}

engine.paths.asset = 'asset'
  engine.paths.fonts = engine.paths.asset .. '/' .. 'fonts'
    engine.paths.font = function(name) return engine.paths.fonts .. '/' .. name end
engine.paths.scripts = 'src'
  engine.paths.script = function(name) return engine.paths.scripts .. '/' .. name .. '.lua' end
  engine.paths.entities = engine.paths.scripts .. '/' .. 'entities'
    engine.paths.entity = function(name) return engine.paths.entities .. '/' .. name .. '.lua' end
