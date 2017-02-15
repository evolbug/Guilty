local Component, Receiver
do
  local _obj_0 = require('guilty.comfy')
  Component, Receiver = _obj_0.Component, _obj_0.Receiver
end
local WidgetBase, Rectangle
do
  local _obj_0 = require('guilty.primitives')
  WidgetBase, Rectangle = _obj_0.WidgetBase, _obj_0.Rectangle
end
local gr
gr = love.graphics
local approach
approach = function(curr, goal, step)
  if curr + step >= goal then
    return step > 0 and goal or curr + step
  else
    return step < 0 and goal or curr + step
  end
end
local Clickable
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    withinBoundary = function(self, x, y)
      local px, py = self.parent:absolute()
      local pw, ph = self.parent.w, self.parent.h
      return x >= px and x <= px + pw and y >= py and y <= py + ph
    end,
    onClick = function(self, x, y, button, istouch)
      if self.parent.visible and self:withinBoundary(x, y) then
        self:_any(x, y)
        self:any(x, y)
        if button == 1 then
          self:primary(x, y)
        end
        if button == 2 then
          self:secondary(x, y)
        end
        if button == 3 then
          self:tertiary(x, y)
        end
        return self:rise('update')
      end
    end,
    onRelease = function(self, x, y, button, istouch)
      if self.parent.visible and self:withinBoundary(x, y) then
        self:release(x, y)
        self:_release(x, y)
        return self:rise('update')
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.primary = function(self, x, y) end
      self.secondary = function(self, x, y) end
      self.tertiary = function(self, x, y) end
      self.any = function(self, x, y) end
      self._any = function(self, x, y) end
      self.release = function(self, x, y) end
      self._release = function(self, x, y) end
      self:attach(Receiver('mousepress', self.onClick))
      return self:attach(Receiver('mouserelease', self.onRelease))
    end,
    __base = _base_0,
    __name = "Clickable",
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
  Clickable = _class_0
end
local Focus
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    withinBoundary = function(self, x, y)
      local px, py = self.parent:absolute()
      local pw, ph = self.parent.w, self.parent.h
      return x >= px and x <= px + pw and y >= py and y <= py + ph
    end,
    onFocus = function(self, x, y)
      if self.parent.visible and self:withinBoundary(x, y) then
        if not self.focus then
          self.focus = true
          self:rise('update')
          return self:focused()
        end
      else
        if self.focus and not self.persistent then
          self.focus = false
          self:rise('update')
          return self:lost()
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, response)
      if response == nil then
        response = 'mousepress'
      end
      _class_0.__parent.__init(self)
      self.focus = false
      self.focused = function(self)
        return print(self.parent.__class.__name .. ' got focus')
      end
      self.lost = function(self)
        return print(self.parent.__class.__name .. ' lost focus')
      end
      return self:attach(Receiver(response, self.onFocus))
    end,
    __base = _base_0,
    __name = "Focus",
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
  Focus = _class_0
end
local Border
do
  local _class_0
  local _parent_0 = Rectangle
  local _base_0 = {
    draw = function(self)
      if self.visible then
        local x, y = self:relative()
        return self:colored(gr.rectangle, 'line', x, y, self.parent.w, self.parent.h)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      return _class_0.__parent.__init(self, 0, 0, 1, 1)
    end,
    __base = _base_0,
    __name = "Border",
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
  Border = _class_0
end
local ScrollBar
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        do
          local _with_0 = self.scrolledObject
          self.h = _with_0.parent.h / (_with_0.h / _with_0.parent.h)
          self.y = -_with_0.y / (_with_0.h / _with_0.parent.h)
        end
        local x, y = self:relative()
        return self:colored(gr.rectangle, self.theme.fill(), x, y, self.w, self.h)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, scroller, scrolledObject)
      _class_0.__parent.__init(self, scrolledObject.parent.w, 0, 0, 0)
      self.x = self.x - self.theme.width()
      self.w = self.theme.width()
      self.scroller = scroller
      self.scrolledObject = scrolledObject
    end,
    __base = _base_0,
    __name = "ScrollBar",
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
  ScrollBar = _class_0
end
local Scroll
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    withinBoundary = function(self, x, y)
      local px, py = self.parent:absolute()
      local pw, ph = self.parent.w, self.parent.h
      return x >= px and x <= px + pw and y >= py and y <= py + ph
    end,
    onWheel = function(self, x, y)
      if self.parent.visible then
        if self.focus.focus then
          self:scroll(x, y)
        end
        return self:rise('update')
      end
    end,
    scroll = function(self, x, y)
      if y > 0 then
        if self.object.y <= 0 then
          self.object.y = approach(self.object.y, 0, self.speed)
        end
      else
        if self.object.y >= self.parent.h - self.object.h then
          self.object.y = approach(self.object.y, self.parent.h - self.object.h, -self.speed)
        end
        return self:rise('update')
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, focus, object)
      _class_0.__parent.__init(self)
      self.focus = focus
      self.object = object
      self.speed = self.object.theme.font()[2]
      return self:attach(Receiver('wheelmove', self.onWheel))
    end,
    __base = _base_0,
    __name = "Scroll",
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
  Scroll = _class_0
end
local Input
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    onInput = function(self, text)
      if self.focus.focus then
        return self.text:add(text)
      end
    end,
    onOtherKey = function(self, key)
      if self.focus.focus then
        local _exp_0 = key
        if 'backspace' == _exp_0 then
          return self.text:remove()
        elseif 'return' == _exp_0 then
          return self.text:add('\n')
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, focus, writableObject)
      _class_0.__parent.__init(self)
      self.focus = focus
      self.text = writableObject
      self:attach(Receiver('textinput', self.onInput))
      return self:attach(Receiver('keypress', self.onOtherKey))
    end,
    __base = _base_0,
    __name = "Input",
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
  Input = _class_0
end
local Cursor
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    focused = function(self)
      return self:callback(self.cursor)
    end,
    focuslost = function(self)
      return self:callback('')
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, callback)
      _class_0.__parent.__init(self)
      self.cursor = '│'
      self.callback = callback
    end,
    __base = _base_0,
    __name = "Cursor",
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
  Cursor = _class_0
end
local BlinkingCursor
do
  local _class_0
  local _parent_0 = Cursor
  local _base_0 = {
    onDelta = function(self, dt)
      if self.parent.focus.focus then
        self.timer = self.timer + dt
        if self.timer >= self.delay then
          self.toggle = not self.toggle
          if self.toggle then
            self:focused()
          else
            self:focuslost()
          end
          self.timer = 0
        end
      elseif self.toggle then
        self:focuslost()
        self.toggle = not self.toggle
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, callback, delay)
      _class_0.__parent.__init(self, callback)
      self.delay = delay
      self.timer = 0
      self.toggle = false
      return self:attach(Receiver('delta', self.onDelta))
    end,
    __base = _base_0,
    __name = "BlinkingCursor",
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
  BlinkingCursor = _class_0
end
return {
  Clickable = Clickable,
  Focus = Focus,
  Scroll = Scroll,
  Input = Input,
  Border = Border,
  ScrollBar = ScrollBar,
  Cursor = Cursor,
  BlinkingCursor = BlinkingCursor
}
