local _ = [[  evolbug 2016-2017, MIT license

    guilty - Love2D gui framework
]]
local Component, Receiver
do
  local _obj_0 = require('comfy')
  Component, Receiver = _obj_0.Component, _obj_0.Receiver
end
local lg = love.graphics
local RGBA
do
  local _class_0
  local _base_0 = {
    unpack = function(self)
      return self.r, self.g, self.b, self.a
    end
  }
  _base_0.__index = _base_0
  _class_0 = setmetatable({
    __init = function(self)
      self.r, self.g, self.b, self.a = 255, 255, 255, 255
    end,
    __base = _base_0,
    __name = "RGBA"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  RGBA = _class_0
end
local Widget
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    onrender = function(self)
      return lg.draw(self.canvas, self:position())
    end,
    position = function(self)
      if self.parent then
        local px, py, pw, ph = self.parent:boundary()
        local cx = self.x == 'center' and (px + (pw / 2 - self.w / 2)) or px + self.x
        local cy = self.y == 'center' and (py + (ph / 2 - self.h / 2)) or py + self.y
        return cx, cy
      else
        return self.x, self.y
      end
    end,
    size = function(self)
      return self.w, self.h
    end,
    boundary = function(self)
      local x, y = self:position()
      local w, h = self:size()
      return x, y, w, h
    end,
    colored = function(self, color, func, ...)
      local r, g, b, a = lg.getColor()
      lg.setColor(unpack(color))
      func(...)
      return lg.setColor(r, g, b, a)
    end,
    draw = function(self, color, func, ...)
      lg.setCanvas(self.canvas)
      self:colored(color, func, ...)
      return lg.setCanvas()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self)
      self.x, self.y, self.w, self.h = x, y, w, h
      self.canvas = lg.newCanvas(w, h)
      return self:attach(Receiver('render', self.onrender))
    end,
    __base = _base_0,
    __name = "Widget",
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
  local self = _class_0
  _ = [[  widget base class, all widgets must inherit this  ]]
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Widget = _class_0
end
local Clickable
do
  local _class_0
  local _parent_0 = Widget
  local _base_0 = {
    onrender = function(self) end,
    within = function(self, x, y)
      local px, py, pw, ph = self.parent:boundary()
      return x >= px and x <= px + pw and y >= py and y <= py + ph
    end,
    onClick = function(self, x, y, button, istouch)
      if self:within(x, y) then
        if button == 1 then
          self.onclick.primary(x, y)
        end
        if button == 2 then
          self.onclick.secondary(x, y)
        end
        if button == 3 then
          self.onclick.tetriary(x, y)
        end
        self.onclick.any(x, y)
        return self.onclick._extra(x, y)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self:attach(Receiver('mousepress', self.onClick))
      self.onclick = {
        primary = function()
          return print('button->primary')
        end,
        secondary = function()
          return print('button->secondary')
        end,
        tetriary = function()
          return print('button->tetriary')
        end,
        any = function() end,
        _extra = function() end
      }
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
  local self = _class_0
  _ = [[ makes widgets clickable, component

    attach to widgets to make them respond to 'mousepress' event
    ]]
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Clickable = _class_0
end
local Label
do
  local _class_0
  local _parent_0 = Widget
  local _base_0 = {
    onrender = function(self)
      self:draw({
        self.color:unpack()
      }, lg.draw, self.text, self:position())
      return _class_0.__parent.__base.onrender(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, text, color)
      if color == nil then
        color = RGBA()
      end
      self.color = color
      self.text = lg.newText(lg.getFont(), text)
      return _class_0.__parent.__init(self, x, y, self.text:getWidth(), self.text:getHeight())
    end,
    __base = _base_0,
    __name = "Label",
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
  local self = _class_0
  _ = [[  generic text label class  ]]
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  Label = _class_0
end
local Button
do
  local _class_0
  local _parent_0 = Widget
  local _base_0 = {
    onrender = function(self, fill)
      if fill == nil then
        fill = self.fill
      end
      self:draw({
        self.color:unpack()
      }, lg.rectangle, fill, self:boundary())
      return _class_0.__parent.__base.onrender(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, text, boundary, color)
      if color == nil then
        color = RGBA()
      end
      _class_0.__parent.__init(self, unpack(boundary))
      self.color = color
      self.fill = 'line'
      self.clickable = self:attach(Clickable())
      self.onclick = self.clickable.onclick
      self.onclick._extra = function(self)
        self.fill = 'fill'
      end
      self:attach(Receiver('mouserelease', function()
        self.fill = 'line'
      end))
      return self:attach(Label('center', 'center', text))
    end,
    __base = _base_0,
    __name = "Button",
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
  Button = _class_0
end
local Frame
do
  local _class_0
  local _parent_0 = Widget
  local _base_0 = {
    onrender = function(self)
      self:draw({
        RGBA():unpack()
      }, lg.rectangle, 'line', self:boundary())
      return _class_0.__parent.__base.onrender(self)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Frame",
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
  Frame = _class_0
end
return {
  text = text,
  Button = Button,
  Widget = Widget,
  Label = Label,
  Frame = Frame
}
