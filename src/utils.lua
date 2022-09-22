local vec2_mixin = {
  unpack = function(self)
	return self.x, self.y
  end,
  add = function(self, other)
	return engine.vec2(self.x + other.x, self.y + other.y)
  end,
  subtract = function(self, other)
	if type(other) == 'table' then
	  return engine.vec2(self.x - other.x, self.y - other.y)
	elseif type(other) == 'number' then
	  return engine.vec2(self.x - other, self.y - other)
	end
  end,
  scale = function(self, scalar)
	return engine.vec2(self.x * scalar, self.y * scalar)
  end,
  truncate = function(self, digits)
	return engine.vec2(truncate(self.x, digits), truncate(self.y, digits))
  end,
  abs = function(self)
	return engine.vec2(math.abs(self.x), math.abs(self.y))
  end,
  equals = function(self, other, eps)
	eps = eps or engine.deq_epsilon
	return double_eq(self.x, other.x, eps) and double_eq(self.y, other.y, eps)
  end,
  clampl = function(self, scalar)
	return engine.vec2(math.max(scalar, self.x), math.max(scalar, self.y))
  end,
  pairwise_mult = function(self, other)
	return engine.vec2(self.x * other.x, self.y * other.y)
  end,
  distance = function(self, other)
	local d = self:subtract(other)
	return math.sqrt(d.x * d.x + d.y * d.y)
  end,
  scr_to_gl = function(self)
	return engine.vec2(self.x * 2 - 1, self.y * 2 - 1)
  end
}

local vec2_impl = engine.class.define('vec2_impl')
vec2_impl:include(vec2_mixin)

engine.vec2 = function(x, y)
  local vec = vec2_impl:new()

  if type(x) == 'table' then
	vec.x = x.x
	vec.y = x.y
	return vec
  else
	x = x or 0
	y = y or 0
	vec.x = x
	vec.y = y
	return vec
  end
end

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
	t2[k] = v
  end
  return t2
end

function table.deep_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
	if type(v) == 'table' then
	  t2[k] = table.deep_copy(v)
	else
	  t2[k] = v
	end
  end
  return t2
end

function table.clear(t)
  for k, _ in pairs(t) do
	t[k] = nil
  end
end

function engine.uuid()
  local random = math.random
  local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
  local sub = function (c)
	local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
	return string.format('%x', v)
  end
  return string.gsub(template, '[xy]', sub)
end

function engine.split_string(str, sep)
  output = {}
  
  for match in string.gmatch(str, "([^" .. sep .. "]+)") do
	table.insert(output, match)
  end
  
  return output
end
