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
  if type(r) == 'string' and r:sub(1, 1) == '#' then
    return {
      tonumber(r:sub(2, 3), 16),
      tonumber(r:sub(4, 5), 16),
      tonumber(r:sub(6, 7), 16),
      tonumber(r:sub(8, 9), 16)
    }
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
local defaultfont = 'FiraCode-Regular.ttf'
local theme = {
  Rectangle = {
    color = RGBA('#455a64ff'),
    fill = 'fill'
  },
  Ellipse = {
    color = RGBA('#455a64ff'),
    fill = 'fill'
  },
  Text = {
    color = RGBA(0, 0, 0, 1),
    font = defaultfont,
    size = 12
  },
  Button = {
    on = {
      base = {
        color = RGBA('#ff3d00ff'),
        fill = 'fill'
      },
      label = {
        color = RGBA(),
        font = defaultfont,
        size = 12
      }
    },
    off = {
      base = {
        color = RGBA('#37474fff'),
        fill = 'line'
      },
      label = {
        color = RGBA(0, 0, 0, 1),
        font = defaultfont,
        size = 12
      }
    }
  },
  Checkbox = {
    on = {
      base = {
        color = RGBA('#37474fff'),
        fill = 'line'
      },
      check = {
        color = RGBA('#ff3d00ff'),
        fill = 'fill'
      },
      label = {
        color = RGBA(0, 0, 0, 1),
        font = defaultfont,
        size = 12
      }
    },
    off = {
      base = {
        color = RGBA('#37474fff'),
        fill = 'line'
      },
      check = {
        color = RGBA('#00000000'),
        fill = 'fill'
      },
      label = {
        color = RGBA(0, 0, 0, 1),
        font = defaultfont,
        size = 12
      }
    }
  },
  TextBox = {
    base = {
      color = RGBA('#37474fff'),
      fill = 'line'
    },
    text = {
      color = RGBA(0, 0, 0, 1),
      font = defaultfont,
      size = 12
    }
  }
}
local themeUpdate
themeUpdate = function(t1, t2)
  for k, v in pairs(t2) do
    if (type(v) == "table") and (type(t1[k] or false) == "table") then
      themeUpdate(t1[k], t2[k])
    else
      t1[k] = v
    end
  end
  return t1
end
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
      local pw, ph, w, h = 0, 0, 0, 0
      if self.parent then
        pw, ph = self.parent.w, self.parent.h
      else
        pw, ph = lg.getDimensions()
      end
      if self.w and self.h then
        w, h = self.w, self.h
      end
      local cx = self.x == 'center' and math.floor(pw / 2 - w / 2) or self.x
      local cy = self.y == 'center' and math.floor(ph / 2 - h / 2) or self.y
      return cx, cy
    end,
    draw = function(self) end,
    colored = function(self, func, ...)
      local r, g, b, a = lg.getColor()
      local cr, cg, cb, ca
      do
        local _obj_0 = self.theme.color
        cr, cg, cb, ca = _obj_0[1], _obj_0[2], _obj_0[3], _obj_0[4]
      end
      lg.setColor(cr, cg, cb, ca)
      func(...)
      return lg.setColor(r, g, b, a)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self)
      self.x, self.y, self.w, self.h = x, y, w, h
      self.update = true
      self.theme = theme[self.__class.__name]
      self.visible = true
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
local Clickable
do
  local _class_0
  local _parent_0 = Component
  local _base_0 = {
    draw = function(self) end,
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
        self.parent.update = true
      end
    end,
    onRelease = function(self, x, y, button, istouch)
      if self.parent.visible and self:withinBoundary(x, y) then
        self:release(x, y)
        self:_release(x, y)
        self.parent.update = true
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.primary = function(self, x, y)
        return print(tostring(x) .. "," .. tostring(y) .. " -> primary")
      end
      self.secondary = function(self, x, y)
        return print(tostring(x) .. "," .. tostring(y) .. " -> secondary")
      end
      self.tertiary = function(self, x, y)
        return print(tostring(x) .. "," .. tostring(y) .. " -> tertiary")
      end
      self.any = function(self, x, y) end
      self._any = function(self, x, y) end
      self.release = function(self, x, y)
        return print(tostring(x) .. "," .. tostring(y) .. " -> released")
      end
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
    draw = function(self) end,
    withinBoundary = function(self, x, y)
      local px, py = self.parent:absolute()
      local pw, ph = self.parent.w, self.parent.h
      return x >= px and x <= px + pw and y >= py and y <= py + ph
    end,
    onClick = function(self, x, y)
      if self.parent.visible and self:withinBoundary(x, y) then
        if not self.focus then
          self.focus = true
          self:focused()
          self.parent.update = true
        end
      else
        if self.focus then
          self.focus = false
          self:lost()
          self.parent.update = true
        end
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self)
      _class_0.__parent.__init(self)
      self.focus = false
      self.focused = function(self)
        return print(self.parent.__class.__name .. ' got focus')
      end
      self.lost = function(self)
        return print(self.parent.__class.__name .. ' lost focus')
      end
      return self:attach(Receiver('mousepress', self.onClick))
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
local Container
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        if self.update then
          self.canvas:renderTo(lg.clear)
          local _list_0 = self.children
          for _index_0 = 1, #_list_0 do
            local child = _list_0[_index_0]
            if child.visible then
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
        return lg.draw(self.canvas, self.x, self.y)
      end
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self, x, y, w, h)
      self.canvas = lg.newCanvas(w, h)
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
local Composite
do
  local _class_0
  local _parent_0 = Container
  local _base_0 = {
    draw = function(self)
      if self.visible then
        self.canvas:renderTo(lg.clear)
        local _list_0 = self.children
        for _index_0 = 1, #_list_0 do
          local child = _list_0[_index_0]
          if child.visible then
            self.canvas:renderTo((function()
              local _base_1 = child
              local _fn_0 = _base_1.draw
              return function(...)
                return _fn_0(_base_1, ...)
              end
            end)())
          end
        end
        return lg.draw(self.canvas, self.x, self.y)
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
    __name = "Composite",
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
  Composite = _class_0
end
local Rectangle
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        local x, y = self:relative()
        return self:colored(lg.rectangle, self.theme.fill, x, y, self.w, self.h)
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
local Ellipse
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        local x, y = self:relative()
        return self:colored(lg.ellipse, self.theme.fill, x, y, self.w, self.h)
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
    __name = "Ellipse",
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
  Ellipse = _class_0
end
local Text
do
  local _class_0
  local _parent_0 = WidgetBase
  local _base_0 = {
    draw = function(self)
      if self.visible then
        return lg.draw(self.label, self:relative())
      end
    end,
    getDimensions = function(self)
      return self.label:getDimensions()
    end,
    getWidth = function(self)
      return self.label:getWidth()
    end,
    getHeight = function(self)
      return self.label:getHeight()
    end,
    set = function(self, text, wrap, align)
      if wrap == nil then
        wrap = self.parent.w
      end
      if align == nil then
        align = 'left'
      end
      self.text = self:colorize(text)
      self.label:setf(self.text, wrap, align)
      self.w, self.h = self.label:getDimensions()
    end,
    add = function(self, text, wrap, align)
      if wrap == nil then
        wrap = self.parent.w
      end
      if align == nil then
        align = 'left'
      end
      local _list_0 = self:colorize(text)
      for _index_0 = 1, #_list_0 do
        local item = _list_0[_index_0]
        table.insert(self.text, item)
      end
      self.label:setf(self.text, wrap, align)
      self.w, self.h = self.label:getDimensions()
    end,
    clear = function(self)
      self.label:clear()
      self.text = { }
    end,
    colorize = function(self, items)
      local newtable = { }
      local hascolor = false
      if type(items) ~= 'table' then
        return {
          self.theme.color,
          items
        }
      end
      for _index_0 = 1, #items do
        local item = items[_index_0]
        if type(item) == 'table' then
          hascolor = true
          table.insert(newtable, item)
        elseif hascolor then
          table.insert(newtable, item)
          hascolor = false
        else
          table.insert(newtable, self.theme.color)
          table.insert(newtable, item)
        end
      end
      return newtable
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, text)
      _class_0.__parent.__init(self, x, y)
      self.text = {
        self.theme.color,
        text
      }
      self.label = lg.newText(lg.newFont(self.theme.font, self.theme.size), self.text)
      self.w, self.h = self.label:getDimensions()
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
local Button
do
  local _class_0
  local _parent_0 = Composite
  local _base_0 = { }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h, text)
      _class_0.__parent.__init(self, x, y, w, h)
      self.panel = self:attach(Rectangle(0, 0, w, h))
      self.label = self:attach(Text('center', 'center', text))
      self.onclick = self:attach(Clickable())
      self.panel.theme = self.theme.off.base
      self.label.theme = self.theme.off.label
      self.onclick._any = function()
        self.panel.theme = self.theme.on.base
        self.label.theme = self.theme.on.label
        self.parent.update = true
      end
      self.onclick._release = function()
        self.panel.theme = self.theme.off.base
        self.label.theme = self.theme.off.label
        self.parent.update = true
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
  local _parent_0 = Composite
  local _base_0 = {
    toggle = function(self)
      self.state = not self.state
      self.parent.update = true
      self.base.theme = self.theme[self:namestate()].base
      self.check.theme = self.theme[self:namestate()].check
      self.label.theme = self.theme[self:namestate()].label
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
    __init = function(self, x, y, w, h, text, state)
      if text == nil then
        text = ''
      end
      if state == nil then
        state = false
      end
      self.state = state
      self.check = Rectangle(3, 'center', w - 6, h - 6)
      self.label = Text(w + 4, 'center', text)
      self.base = Rectangle(0, 0, w - .5, h)
      _class_0.__parent.__init(self, x, y, w + 6 + self.label:getWidth(), h)
      self:attach(self.base, self.label, self.check)
      self.onclick = self:attach(Clickable())
      self.base.theme = self.theme[self:namestate()].base
      self.check.theme = self.theme[self:namestate()].check
      self.label.theme = self.theme[self:namestate()].label
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
  local _parent_0 = Composite
  local _base_0 = {
    set = function(self, ...)
      self.text:set(...)
      self.parent.update = true
    end,
    add = function(self, ...)
      self.text:add(...)
      self.parent.update = true
    end,
    clear = function(self)
      self.text:clear()
      self.parent.update = true
    end,
    scroll = function(self, px)
      local diff = self.w - self.text.w
      return print(diff)
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, x, y, w, h)
      _class_0.__parent.__init(self, x, y, w, h)
      self.base = self:attach(Rectangle(0, 0, w, h))
      self.text = self:attach(Text(2, 2, ''))
      self.base.theme = self.theme.base
      self.text.theme = self.theme.text
      do
        local _with_0 = self:attach(Focus())
        self.focus = _with_0
        _with_0.focused = function(self)
          return self.base.theme
        end
        return _with_0
      end
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
return {
  RGBA = RGBA,
  Container = Container,
  Rectangle = Rectangle,
  Text = Text,
  Button = Button,
  Checkbox = Checkbox,
  TextBox = TextBox
}
