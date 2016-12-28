local _ = [[    evolbug 2016-2017, MIT license

    Guilty - Love2D GUI framework
    alpha 1
]]
local Component, Receiver
do
  local _obj_0 = require('comfy')
  Component, Receiver = _obj_0.Component, _obj_0.Receiver
end
local lg = love.graphics
local RGBA
RGBA = function(r, g, b, a)
  if r == nil then
    r = 1
  end
  if g == nil then
    g = 1
  end
  if b == nil then
    b = 1
  end
  if a == nil then
    a = 1
  end
  if #(function()
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = {
      r,
      g,
      b,
      a
    }
    for _index_0 = 1, #_list_0 do
      local i = _list_0[_index_0]
      if i <= 1 then
        _accum_0[_len_0] = i
        _len_0 = _len_0 + 1
      end
    end
    return _accum_0
  end)() == 4 then
    return {
      r * 255,
      g * 255,
      b * 255,
      a * 255
    }
  end
  return {
    r,
    g,
    b,
    a
  }
end
local Widget
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    onrender = function(self)
      if self.parent then
        self.parent:draw(lg.draw, {
          self.canvas,
          self:position()
        })
      else
        lg.draw(self.canvas, self:position())
      end
      return self:draw(lg.clear, { })
    end,
    position = function(self)
      local pw, ph = unpack(self.parent and {
        self.parent:size()
      } or {
        lg.getDimensions()
      })
      local cx = self.x == 'center' and pw / 2 - self.w / 2 or self.x
      local cy = self.y == 'center' and ph / 2 - self.h / 2 or self.y
      return cx, cy
    end,
    aposition = function(self)
      local x, y = self:position()
      if self.parent then
        local px, py = self.parent:aposition()
        return x + px, y + py
      else
        return x, y
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
    draw = function(self, func, args, color)
      if color == nil then
        color = RGBA()
      end
      _ = [[contained colored draw function
            example:
                @draw lg.rectangle, {0, 0, 100, 100}, RGBA 1,0,0,1
        ]]
      return self.canvas:renderTo(function()
        local r, g, b, a = lg.getColor()
        lg.setColor(unpack(color))
        func(unpack(args))
        return lg.setColor(r, g, b, a)
      end)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, boundary)
      _class_0.__parent.__init(self)
      self.x, self.y, self.w, self.h = unpack(boundary)
      self.canvas = lg.newCanvas(self.w, self.h)
      self.renderRecv = self:attach(Receiver('render', self.onrender))
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
  local _parent_0 = Component
  local _base_0 = {
    within = function(self, x, y)
      local px, py = self.parent:aposition()
      local pw, ph = self.parent:size()
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
        primary = function(x, y)
          return print(tostring(x) .. ", " .. tostring(y) .. "->primary")
        end,
        secondary = function(x, y)
          return print(tostring(x) .. ", " .. tostring(y) .. "->secondary")
        end,
        tertiary = function(x, y)
          return print(tostring(x) .. ", " .. tostring(y) .. "->tertiary")
        end,
        any = function(x, y) end,
        _extra = function(x, y) end
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
      _class_0.__parent.__base.onrender(self)
      return self:draw(lg.draw, {
        self.text,
        0,
        0
      }, self.color)
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
      return _class_0.__parent.__init(self, {
        x,
        y,
        self.text:getWidth(),
        self.text:getHeight()
      })
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
      _class_0.__parent.__base.onrender(self)
      return self:draw(lg.rectangle, {
        fill,
        0,
        0,
        self:size()
      }, self.color)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, boundary, text, color)
      if color == nil then
        color = RGBA()
      end
      _class_0.__parent.__init(self, boundary)
      self.color = color
      self.fill = 'line'
      self.clickable = self:attach(Clickable())
      self.onclick = self.clickable.onclick
      self.label = self:attach(Label('center', 'center', text))
      self.onclick._extra = function()
        self.fill = 'fill'
        self.label.color = RGBA(0, 0, 0, 1)
      end
      return self:attach(Receiver('mouserelease', function()
        self.fill = 'line'
        self.label.color = RGBA(1, 1, 1, 1)
      end))
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
return {
  Widget = Widget,
  Renderer = Renderer,
  Button = Button
}
