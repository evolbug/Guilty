local gui = require("guilty2")
local lg = love.graphics
local frame = gui.Widget({
  'center',
  'center',
  100,
  100
})
local butt = frame:attach(gui.Button({
  'center',
  'center',
  80,
  80
}, 'butn'))
love.load = function()
  return love.window.setMode(800, 600, {
    resizable = true,
    borderless = true
  })
end
love.draw = function()
  lg.clear(0, 0, 0, 0)
  return frame:event('render')
end
love.mousepressed = function(x, y, button, istouch)
  return frame:event({
    mousepress = {
      x,
      y,
      button,
      istouch
    }
  })
end
love.mousereleased = function(x, y, button, istouch)
  return frame:event({
    mouserelease = {
      x,
      y,
      button,
      istouch
    }
  })
end
butt.onclick.secondary = function()
  return love.event.quit()
end
