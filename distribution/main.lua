local gui = require("guilty3")
local lg = love.graphics
love.load = function()
  love.window.setMode(500, 500)
  window = gui.Container(10, 10, lg.getWidth() - 20, lg.getHeight() - 20)
  do
    local _with_0 = window
    do
      local _with_1 = _with_0:attach(gui.Rectangle(0, 0, _with_0.w, _with_0.h))
      _with_1.theme.fill = 'line'
    end
    local debug = _with_0:attach(gui.ScrollText(_with_0.w / 2, 2, _with_0.w / 2 - 2, _with_0.h - 4))
    do
      local _with_1 = _with_0:attach(gui.Button(10, 10, 100, 30, 'button up!'))
      local z = 0
      _with_1.onclick.any = function(self, x, y)
        z = z + 1
        return debug.text:add({
          gui.RGBA(0, 1, 0, 1),
          tostring(z) .. "\n"
        })
      end
      _with_1.onclick.release = function(self, x, y)
        return debug.text:add({
          gui.RGBA(1, 0, 0, 1),
          "[button] " .. tostring(x) .. ":" .. tostring(y) .. " released\n"
        })
      end
    end
    for i = 1, 3 do
      _with_0:attach(gui.Checkbox(10, 41 + 21 * (i - 1), 20, 20, "chekbax " .. tostring(i)))
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
love.wheelmoved = function(x, y)
  return window:event({
    wheelmove = {
      x,
      y
    }
  })
end
