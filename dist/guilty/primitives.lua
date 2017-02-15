local Component, Receiver
do
  local _obj_0 = require('guilty.comfy')
  Component, Receiver = _obj_0.Component, _obj_0.Receiver
end
local theme, Theme
do
  local _obj_0 = require('guilty.theme')
  theme, Theme = _obj_0.theme, _obj_0.Theme
end
local lg
lg = love.graphics
local WidgetBase
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    absolute = function(self)
      local x, y = self:relative()
      if self.parent then
        local px, py = self.parent:absolute()
        return x + px, y + py
      else
        return x, y
      end
    end,
    relative = function(self)
      local cx, cy = self.x, self.y
      if self.x == 'center' then
        local w = self.w or 0
        cx = math.floor((self.parent and self.parent.w or lg.getWidth()) / 2 - w / 2)
      end
      if self.y == 'center' then
        local h = self.h or 0
        cy = math.floor((self.parent and self.parent.h or lg.getHeight()) / 2 - h / 2)
      end
      return cx, cy
    end,
    draw = function(self) end,
    colored = function(self, func, ...)
      lg.push('all')
      local cr, cg, cb, ca
      do
        local _obj_0 = self.theme.color()
        cr, cg, cb, ca = _obj_0[1], _obj_0[2], _obj_0[3], _obj_0[4]
      end
      lg.setColor(cr, cg, cb, ca)
      func(...)
      return lg.pop()
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self)
      self.x, self.y, self.w, self.h = x, y, w, h
      self.update = true
      self.theme = Theme(theme[self.__class.__name])
      self.visible = true
      return self:attach(Receiver('update', function()
        self.update = true
      end))
    end,
    __base = _base_0,
    __name = "WidgetBase",
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
  WidgetBase = _class_0
end
local Rectangle
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        local x, y = self:relative()
        return self:colored(lg.rectangle, self.theme.fill(), x, y, self.w, self.h)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = "Rectangle",
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
  Rectangle = _class_0
end
local Text
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        return self:colored(lg.draw, self.text, self:relative())
      end
    end,
    refresh = function(self)
      self.w, self.h = self.text:getDimensions()
      if self.h > self.parent.h then
        self.y = self.parent.h - self.h
      else
        local _ = 0
      end
      return self:rise('update')
    end,
    set = function(self, text, wrap, align)
      if wrap == nil then
        wrap = self.parent.w
      end
      if align == nil then
        align = 'left'
      end
      self.buffer = text
      self.text:setf(self.buffer, wrap, align)
      return self:refresh()
    end,
    add = function(self, text, wrap, align)
      if wrap == nil then
        wrap = self.parent.w
      end
      if align == nil then
        align = 'left'
      end
      self.buffer = self.buffer .. text
      self.text:addf(self.buffer, wrap, align)
      return self:refresh()
    end,
    remove = function(self, a, b)
      if a == nil then
        a = #self.buffer - 1
      end
      if b == nil then
        b = #self.buffer
      end
      self.buffer = self.buffer:sub(0, a) .. self.buffer:sub(b, #self.buffer - b)
      self.text:setf(self.buffer, self.parent.w, 'left')
      return self:refresh()
    end,
    clear = function(self)
      self.text:clear()
      self.buffer = ''
      return self:rise('update')
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, text)
      _class_0.__parent.__init(self, x, y)
      self.buffer = text
      local font, fsize = unpack(self.theme.font())
      self.text = lg.newText(lg.newFont(font, fsize), self.buffer)
      self.w, self.h = self.text:getDimensions()
    end,
    __base = _base_0,
    __name = "Text",
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
  Text = _class_0
end
return {
  WidgetBase = WidgetBase,
  Rectangle = Rectangle,
  Text = Text
}
