local gui = require("guilty3")
local lg = love.graphics
love.load = function()
  love.window.setMode(800, 600, {
    resizable = true
  })
  window = gui.Container(10, 10, lg.getWidth() - 20, lg.getHeight() - 20)
  do
    local _with_0 = window
    do
      local _with_1 = _with_0:attach(gui.Rectangle(0, 0, _with_0.w, _with_0.h))
      _with_1.theme.color = gui.RGBA(0, 0, 0, 1)
      _with_1.theme.fill = 'line'
    end
    local debug = _with_0:attach(gui.TextBox(_with_0.w / 2, 2, _with_0.w / 2 - 2, _with_0.h - 4))
    do
      local _with_1 = _with_0:attach(gui.Button(10, 10, 100, 30, 'button up!'))
      _with_1.onclick.any = function(self, x, y)
        return debug:add({
          gui.RGBA(0, 1, 0, 1),
          "[button] " .. tostring(x) .. ":" .. tostring(y) .. " pressed\n"
        })
      end
      _with_1.onclick.release = function(self, x, y)
        return debug:add({
          gui.RGBA(1, 0, 0, 1),
          "[button] " .. tostring(x) .. ":" .. tostring(y) .. " released\n"
        })
      end
    end
    local che1 = _with_0:attach(gui.Checkbox(10, 41, 20, 20, 'i is checkbox'))
    do
      local _with_1 = _with_0:attach(gui.Text(200, che1.y, 'turn up!'))
      _with_1.visible = che1.state
      che1.onclick.any = function(self, x, y)
        _with_1.visible = che1.state
        local c = che1.state and gui.RGBA(0, 1, 0, 1) or gui.RGBA(1, 0, 0, 1)
        return debug:add({
          "[check1] " .. tostring(x) .. ":" .. tostring(y) .. " toggled",
          c,
          " " .. tostring(che1.state) .. "\n"
        })
      end
    end
    local che2 = _with_0:attach(gui.Checkbox(10, 62, 20, 20, 'checkbox too'))
    do
      local _with_1 = _with_0:attach(gui.Text(200, che2.y, 'turn up!'))
      _with_1.visible = che2.state
      che2.onclick.any = function(self, x, y)
        _with_1.visible = che2.state
        local c = che2.state and gui.RGBA(0, 1, 0, 1) or gui.RGBA(1, 0, 0, 1)
        return debug:add({
          "[check2] " .. tostring(x) .. ":" .. tostring(y) .. " toggled",
          c,
          " " .. tostring(che2.state) .. "\n"
        })
      end
    end
    local che3 = _with_0:attach(gui.Checkbox(10, 83, 20, 20, 'me check'))
    do
      local _with_1 = _with_0:attach(gui.Text(200, che3.y, 'turn up!'))
      _with_1.visible = che3.state
      che3.onclick.any = function(self, x, y)
        _with_1.visible = che3.state
        local c = che3.state and gui.RGBA(0, 1, 0, 1) or gui.RGBA(1, 0, 0, 1)
        return debug:add({
          "[check2] " .. tostring(x) .. ":" .. tostring(y) .. " toggled",
          c,
          " " .. tostring(che3.state) .. "\n"
        })
      end
    end
    return _with_0
  end
end
love.draw = function()
  lg.clear(gui.RGBA())
  return window:draw()
end
love.mousepressed = function(x, y, button, istouch)
  return window:event({
    mousepress = {
      x,
      y,
      button,
      istouch
    }
  })
end
love.mousereleased = function(x, y, button, istouch)
  return window:event({
    mouserelease = {
      x,
      y,
      button,
      istouch
    }
  })
end
