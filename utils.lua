local vec2_mixin = {
  unpack = function(self)
	return self.x, self.y
  end,
  add = function(self, other)
	return lows.vec2(self.x + other.x, self.y + other.y)
  end,
  subtract = function(self, other)
	if type(other) == 'table' then
	  return lows.vec2(self.x - other.x, self.y - other.y)
	elseif type(other) == 'number' then
	  return lows.vec2(self.x - other, self.y - other)
	end
  end,
  scale = function(self, scalar)
	return lows.vec2(self.x * scalar, self.y * scalar)
  end,
  truncate = function(self, digits)
	return lows.vec2(truncate(self.x, digits), truncate(self.y, digits))
  end,
  abs = function(self)
	return lows.vec2(math.abs(self.x), math.abs(self.y))
  end,
  equals = function(self, other, eps)
	eps = eps or lows.deq_epsilon
	return double_eq(self.x, other.x, eps) and double_eq(self.y, other.y, eps)
  end,
  clampl = function(self, scalar)
	return lows.vec2(math.max(scalar, self.x), math.max(scalar, self.y))
  end,
  pairwise_mult = function(self, other)
	return lows.vec2(self.x * other.x, self.y * other.y)
  end,
  distance = function(self, other)
	local d = self:subtract(other)
	return math.sqrt(d.x * d.x + d.y * d.y)
  end,
  scr_to_gl = function(self)
	return lows.vec2(self.x * 2 - 1, self.y * 2 - 1)
  end
}

local vec2_impl = lows.class('vec2_impl')
vec2_impl:include(vec2_mixin)

lows.vec2 = function(x, y)
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
