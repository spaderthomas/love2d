-- Class stuff
function engine.include_mixin(class, mixin)
  assert(type(mixin) == 'table', "mixin must be a table")

  for name, member in pairs(mixin) do
    if name ~= "__static" then
	  class[name] = member
	end
  end

  for name, method in pairs(mixin.__static or {}) do
    class.__static[name] = method
  end

  return class
end

function engine.is_instance_of(object, class)
  local mt = getmetatable(object)
  return mt.__type == class
end

function engine.define_class(name)
  local class = {
	name = name,
	__static = {},
	__instance = {},
  }

  -- Allow the class to include mixins. Do not use 'class' as the parameter, because
  -- this will be called like ClassName:include(), and could be called multiple
  -- times
  class.__static.include = function(class_table, ...)
	for _, mixin in ipairs({...}) do
	  engine.include_mixin(class_table, mixin)
	end
	return self
  end

  -- Find the class type
  class.__static.new = function(self)
	class = engine.classes[self.name]
	if not class then
	  return nil
	end
	
	-- Create the table we'll return to the user
	local instance = {}

	-- Give it a metatable
	local metatable = {}
	metatable.__index = function(tbl, key)
	  return engine.classes[self.name].__instance[key]
	end
	metatable.__type = self.name
	setmetatable(instance, metatable)

	return instance
  end

  -- Set up the class to look in its members if it calls something that isn't a static method
  on_static_method_not_found = function(_, key)
	return rawget(class.__instance,key)
  end
  
  setmetatable(class.__static, {
				 __index = on_static_method_not_found
  })

  local metatable = {
	__index = class.__static,
	__tostring = function(self) return self.name end,
	__newindex = function(class, member_name, member)
	  class.__instance[member_name] = member
	end
  }
  setmetatable(class, metatable)

  return class
end

function engine.class(name)
  local class = engine.define_class(name)
  engine.classes[name] = class
  return class
end

function engine.does_class_exist(name)
  local class = engine.classes[name]
  if class then return true else return false end
end
