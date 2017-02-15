local Component, Receiver
do
  local _obj_0 = require('guilty.comfy')
  Component, Receiver = _obj_0.Component, _obj_0.Receiver
end
local theme, RGBA, Theme
do
  local _obj_0 = require('guilty.theme')
  theme, RGBA, Theme = _obj_0.theme, _obj_0.RGBA, _obj_0.Theme
end
local Clickable, Focus, Scroll, Input, Border, ScrollBar, Cursor, BlinkingCursor
do
  local _obj_0 = require('guilty.extensions')
  Clickable, Focus, Scroll, Input, Border, ScrollBar, Cursor, BlinkingCursor = _obj_0.Clickable, _obj_0.Focus, _obj_0.Scroll, _obj_0.Input, _obj_0.Border, _obj_0.ScrollBar, _obj_0.Cursor, _obj_0.BlinkingCursor
end
local WidgetBase, Rectangle, Ellipse, Text
do
  local _obj_0 = require('guilty.primitives')
  WidgetBase, Rectangle, Ellipse, Text = _obj_0.WidgetBase, _obj_0.Rectangle, _obj_0.Ellipse, _obj_0.Text
end
local gr
gr = love.graphics
local Container
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        if self.update then
          self.canvas:renderTo(gr.clear)
          local _list_0 = self.children
          for _index_0 = 1, #_list_0 do
            local child = _list_0[_index_0]
            if child.visible and (function()
              local _base_1 = child
              local _fn_0 = _base_1.draw
              return function(...)
                return _fn_0(_base_1, ...)
              end
            end)() then
              self.canvas:renderTo((function()
                local _base_1 = child
                local _fn_0 = _base_1.draw
                return function(...)
                  return _fn_0(_base_1, ...)
                end
              end)())
            end
          end
          self.update = false
        end
        return gr.draw(self.canvas, self:relative())
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self, x, y, w, h)
      self.canvas = gr.newCanvas(w, h)
    end,
    __base = _base_0,
    __name = "Container",
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
  Container = _class_0
end
local Button
do
  local _class_0
  local _parent_0 = Container
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h, label)
      _class_0.__parent.__init(self, x, y, w, h)
      self.panel = self:attach(Rectangle(0, 0, w, h))
      self.text = self:attach(Text('center', 'center', label))
      self.onclick = self:attach(Clickable())
      self.panel.theme = self.theme.off.base
      self.text.theme = self.theme.off.text
      self.onclick._any = function()
        self.panel.theme = self.theme.on.base
        self.text.theme = self.theme.on.text
        return self:rise('update')
      end
      self.onclick._release = function()
        self.panel.theme = self.theme.off.base
        self.text.theme = self.theme.off.text
        return self:rise('update')
      end
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
local Checkbox
do
  local _class_0
  local _parent_0 = Container
  local _base_0 = {
    toggle = function(self)
      self.state = not self.state
      self.base.theme = self.theme[self:namestate()].base
      self.check.theme = self.theme[self:namestate()].check
      self.text.theme = self.theme[self:namestate()].text
      return self:rise('update')
    end,
    namestate = function(self)
      if self.state then
        return 'on'
      else
        return 'off'
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, radius, text, state)
      if text == nil then
        text = ''
      end
      if state == nil then
        state = false
      end
      self.state = state
      self.check = Rectangle(3, 'center', radius - 5, radius - 5)
      self.base = Rectangle(.5, .5, radius, radius)
      self.text = Text(radius + 8, 'center', text)
      _class_0.__parent.__init(self, x, y, radius + 8 + self.text.w, radius + 1)
      self:attach(self.base, self.text, self.check)
      self.onclick = self:attach(Clickable())
      self.base.theme = self.theme[self:namestate()].base
      self.check.theme = self.theme[self:namestate()].check
      self.text.theme = self.theme[self:namestate()].text
      self.onclick._any = function()
        return self:toggle()
      end
    end,
    __base = _base_0,
    __name = "Checkbox",
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
  Checkbox = _class_0
end
local TextBox
do
  local _class_0
  local _parent_0 = Container
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self, x, y, w, h)
      self.base = self:attach(Rectangle(0, 0, w, h))
      self.text = self:attach(Text(0, 0, ''))
      self.base.theme = self.theme.base
      self.text.theme = self.theme.text
    end,
    __base = _base_0,
    __name = "TextBox",
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
  TextBox = _class_0
end
local TextBoxScrollable
do
  local _class_0
  local _parent_0 = TextBox
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self, x, y, w, h)
      self.base.theme = self.theme.off.base
      self.text.theme = self.theme.off.text
      do
        local _with_0 = self:attach(Focus('mousemove'))
        self.focus = _with_0
        _with_0.focused = function()
          self.base.theme = self.theme.on.base
          self.text.theme = self.theme.on.text
          return self:rise('update')
        end
        _with_0.lost = function()
          self.base.theme = self.theme.off.base
          self.text.theme = self.theme.off.text
          return self:rise('update')
        end
      end
      self.scroller = self:attach(Scroll(self.focus, self.text))
      self.scrollbar = self:attach(ScrollBar(self.scroller, self.text))
    end,
    __base = _base_0,
    __name = "TextBoxScrollable",
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
  TextBoxScrollable = _class_0
end
local TextInput
do
  local _class_0
  local _parent_0 = TextBox
  local _base_0 = {
    add = function(self, text)
      self.buffer = self.buffer .. text
      return self.cursor:focused()
    end,
    remove = function(self)
      self.buffer = self.buffer:sub(1, -2)
      return self.cursor:focused()
    end,
    refresh = function(self, cursor)
      return self.text:set(self.buffer .. cursor)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self, x, y, w, h)
      self.base.theme = self.theme.off.base
      self.text.theme = self.theme.off.text
      self.buffer = ""
      self.cursor = self:attach(BlinkingCursor((function(_, c)
        return self:refresh(c)
      end), .7))
      do
        local _with_0 = self:attach(Focus('mousepress'))
        self.focus = _with_0
        _with_0.focused = function()
          self.base.theme = self.theme.on.base
          self.text.theme = self.theme.on.text
          return self:rise('update')
        end
        _with_0.lost = function()
          self.base.theme = self.theme.off.base
          self.text.theme = self.theme.off.text
          return self:rise('update')
        end
      end
      return self:attach(Input(self.focus, self))
    end,
    __base = _base_0,
    __name = "TextInput",
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
  TextInput = _class_0
end
return {
  RGBA = RGBA,
  Container = Container,
  Rectangle = Rectangle,
  Border = Border,
  Text = Text,
  TextBox = TextBox,
  TextBoxScrollable = TextBoxScrollable,
  TextInput = TextInput,
  Button = Button,
  Checkbox = Checkbox,
  theme = theme,
  Theme = Theme
}
