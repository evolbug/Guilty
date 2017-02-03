local gui = require("guilty")
local lg = love.graphics
local util = require("util")
love.load = function()
  love.window.setMode(500, 500)
  do
    local _with_0 = gui.Container(10, 10, lg.getWidth() - 20, lg.getHeight() - 20)
    _with_0:attach(gui.Border())
    local panel1
    do
      local _with_1 = _with_0:attach(gui.Container(10, 10, (_with_0.w - 20) / 2 - 2, (_with_0.h - 20)))
      _with_1:attach(gui.Border())
      do
        local _with_2 = _with_1:attach(gui.TextBoxScrollable(10, 10, _with_1.w - 20, _with_1.h - 20))
        _with_2.text:set('hellooooooooooooooooooooooooooooo')
        texbax = _with_2
      end
      panel1 = _with_1
    end
    local panel2
    do
      local _with_1 = _with_0:attach(gui.Container((_with_0.w - 20) / 2 + 14, 10, (_with_0.w - 20) / 2 - 4, (_with_0.h - 20)))
      _with_1:attach(gui.Border())
      _with_1:attach(gui.List(10, 10, _with_1.w - 20, _with_1.h / 2))
      do
        local _with_2 = _with_1:attach(gui.Button(_with_1.w - 50, _with_1.h - 50, 30, 30, 'buhn'))
        _with_2:attach(gui.Border())
        _with_2.onclick.any = function()
          return texbax.text:add('clikbax texbax \n')
        end
      end
      panel2 = _with_1
    end
    window = _with_0
  end
end
love.draw = function()
  lg.clear(gui.RGBA(0, 0, 0, 1))
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
love.mousemoved = function(x, y)
  return window:event({
    mousemove = {
      x,
      y
    }
  })
end
