local entity = {
  get_name = function(self) return self.name end,
  serialize = function(self)
	local data = {}
	data.uuid = self.uuid
	data.kind = self.kind
	data.tag = #self.tag > 0 and self.tag or nil

	if self.serialize_fields then
	  for _, field in pairs(self.serialize_fields) do
		local value = self[field]
		if type(value) == 'table' and value.serialize then
		  data[field] = value:serialize()
		else
		  data[field] = deep_copy_any(value)
		end
	  end
	end

	if self.components then
	  data.components = {}
	  for name, component in pairs(self.components) do
		local serialized_component = self.serialize(component)
		data.components[name] = serialized_component
	  end
	end
	
	return data
  end,
  add_component = function(self, name, data)
	data = data or {}

	local ComponentType = engine.class.find(name)
	local component = ComponentType:new(data)
	component.name = name
	component.tag = data.tag or ''
	component.uuid = data.uuid or engine.uuid()
	component.entity = entity
	component:init(data)
	
	self.components[name] = component
  end,
  ensure_component = function(self, name) engine.ensure_component(self, name) end,
  find_component = function(self, name)
	return self.components[name]
  end,
  __static = {
	serialize_field = function(entity_type, field_name)
	  table.insert(entity_type.serialize_fields, field_name)
	end,
  }
}


function engine.entity.define(name)
  local class = engine.class.define(name)
  class:include(entity)

  return class
end

function engine.entity.compare(a, b)
  local entity_a = engine.entity.entities[a]
  local entity_b = engine.entity.entities[b]

  local name_a = entity_a:get_name()
  local name_b = entity_b:get_name()
  if name_a == name_b then
	return entity_a.id < entity_b.id
  else
	return name_a < name_b
  end
end

local find_entity_impl = function(name, id, tag)
  local check_entity = function(entity)
	if name and entity.name == name then return true end
	if id   and entity.id   == id   then return true end
	if tag  and entity.tag  == tag  then return true end
	return false
  end
  
  for id, entity in pairs(engine.entity.entities) do
	if engine.entities_to_destroy[id] then goto continue end
	if check_entity(entity) then return entity end
	::continue::
  end

  for id, entity in pairs(engine.entity.entities_to_add) do
	if engine.entity.entities_to_destroy[id] then goto continue end
	if check_entity(entity) then return entity end
	::continue::
  end
  
  return nil  
end

function engine.entity.find(name)
  return find_entity_impl(name, nil, nil)
end

function engine.entity.find_by_id(id, entities)
  return find_entity_impl(nil, id, nil)
end

function engine.entity.find_by_tag(tag, entities)
  return find_entity_impl(nil, nil, tag)
end

function engine.entity.find_by_any(descriptor)
   if descriptor.id then
	  return engine.entity.find_by_id(descriptor.id)
   elseif descriptor.tag then
	  return engine.entity.find_by_tag(descriptor.tag)
   elseif descriptor.entity then
	  return engine.entity.find(descriptor.entity)
   else
	  engine.log('@no_descriptor_to_find')
	  return nil
   end
end

local next_entity_id = function()
  local id = engine.next_entity_id
  engine.next_entity_id = engine.next_entity_id + 1
  return id
end

local create_entity_impl = function(name, data)
  data = data or {}
  data.components = data.components or {}
  
  -- Find the matching type in Lua
  EntityType = engine.class.classes[name]
  if not EntityType then
	log.warn(string.format("could not find entity type: type = %s", name))
	return nil
  end
  
  -- Construct the entity with a do-nothing constructor
  local entity = EntityType:new()

  -- Fill in its identifiers
  local id = next_entity_id()
  entity.id = id
  entity.name = name
  entity.uuid = data.uuid or engine.uuid()
  entity.tag = data.tag or ''
  entity.imgui_ignore = {}

  -- Look in the list of components this entity specifies. For each such type, check in the
  -- serialized data to see if such a component was saved. Create the component type, giving
  -- it the data found or empty parameters if no data is found.
  --
  -- This way, we can remove a component, and the serialized data for that component will
  -- just be ignored.
  entity.components = {}
  if EntityType.components then
	for _, component_name in pairs(EntityType.components) do
	  local component_data = data.components[component_name]
	  entity:add_component(component_name, component_data)
	end
  end
  
  -- Call into the entity to initialize
  entity:init(data)

  -- Call late_init() on each component if need be
  for _, component in pairs(entity.components) do
	if component.late_init then component:late_init() end
  end

  return entity
end

function engine.entity.create(name, data)
  local entity = create_entity_impl(name, data)
  engine.entity.entities_to_add[entity.id] = entity
  
  return entity
end

function engine.entity.create_anonymous(name, data)
  return create_entity_impl(name, data)
end

function engine.entity.destroy(id)
  engine.entities_to_destroy[id] = true
end


local add_entities = function()
  for id, entity in pairs(engine.entity.entities_to_add) do
	engine.entity.entities[id] = entity
  end
  engine.entity.entities_to_add = {}
end

local destroy_entities = function()
  for id, _ in pairs(engine.entity.entities_to_destroy) do
	engine.entity.entities[id] = nil
  end
  engine.entity.entities_to_destroy = {}
end

function engine.entity.update(dt)
  for id, entity in pairs(engine.entity.entities) do
	entity:update(dt)

	for name, component in pairs(entity.components) do
	  if component.update then component:update(dt) end
	end
  end

  add_entities()
  destroy_entities()
end
