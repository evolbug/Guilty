local gui = require("guilty2")
local lg = love.graphics
local butt = gui.Button({
  'center',
  'center',
  80,
  80
}, 'butn')
love.load = function()
  return love.window.setMode(800, 600, {
    resizable = true,
    borderless = true
  })
end
love.draw = function()
  lg.clear(255, 255, 255, 255)
  return butt:event('render')
end
love.mousepressed = function(x, y, button, istouch)
  return butt:event({
    mousepress = {
      x,
      y,
      button,
      istouch
    }
  })
end
love.mousereleased = function(x, y, button, istouch)
  return butt:event({
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
