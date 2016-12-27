local _ = [[  evolbug 2016-2017, MIT license

Comfy, a lightweight component framework
]]
local Component
do
  local _class_0
  local _base_0 = {
    attach = function(self, ...)
      local args = not (...).__component__ and ... or {
        ...
      }
      for _index_0 = 1, #args do
        local comp = args[_index_0]
        self.children[#self.children + 1] = comp
      end
      for _index_0 = 1, #args do
        local comp = args[_index_0]
        comp.parent = self
      end
      return unpack(args)
    end,
    event = function(self, events)
      local _list_0 = self.children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child:event(events)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.__component__ = true
      self.children = { }
      self.parent = nil
    end,
    __base = _base_0,
    __name = "Component"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Component = _class_0
end
local Receiver
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    event = function(self, ...)
      if ... == self.ev then
        return self.fn(self.parent)
      else
        if type(...) == 'table' then
          for k, v in pairs(...) do
            if k == self.ev then
              self.fn(self.parent, unpack(v))
            end
          end
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, event, callback)
      _class_0.__parent.__init(self)
      self.ev = event
      self.fn = callback
    end,
    __base = _base_0,
    __name = "Receiver",
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Receiver = _class_0
end
return {
  Component = Component,
  Receiver = Receiver
}
