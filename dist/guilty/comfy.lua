local Receiver
do
  local _class_0
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
  _class_0 = setmetatable({
    __init = function(self, event, callback)
      self.parent = nil
      self.ev = event
      self.fn = callback
    end,
    __base = _base_0,
    __name = "Receiver"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Receiver = _class_0
end
local Component
do
  local _class_0
  local _base_0 = {
    attach = function(self, ...)
      local args = not (...).__class == Component and ... or {
        ...
      }
      for _index_0 = 1, #args do
        local comp = args[_index_0]
        table.insert(self.children, comp)
        comp.parent = self
      end
      return unpack(args)
    end,
    detach = function(self, child)
      for i, c in ipairs(self.children) do
        if c == child then
          table.remove(self.children, i)
        end
      end
    end,
    event = function(self, events)
      local _list_0 = self.children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        child:event(events)
      end
    end,
    bubble = function(self, events)
      local _list_0 = self.children
      for _index_0 = 1, #_list_0 do
        local child = _list_0[_index_0]
        if child.__class ~= Receiver then
          child:bubble(events)
        end
      end
      local _list_1 = self.children
      for _index_0 = 1, #_list_1 do
        local child = _list_1[_index_0]
        if child.__class == Receiver then
          child:event(events)
        end
      end
    end,
    rise = function(self, events)
      if self.parent then
        local _list_0 = self.parent.children
        for _index_0 = 1, #_list_0 do
          local child = _list_0[_index_0]
          if child.__class == Receiver then
            child:event(events)
          end
        end
        return self.parent:rise(events)
      end
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
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
return {
  Component = Component,
  Receiver = Receiver
}
