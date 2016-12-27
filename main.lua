local guilty = require("guilty")
local frame = guilty.Widget(0, 0, love.graphics.getDimensions())
print(frame.x, frame.y)
local exit = frame:attach(guilty.Button('exit', {
  10,
  10,
  50,
  20
}))
local testbox = frame:attach(guilty.Widget(100, 100, 200, 200))
local button1, button2 = testbox:attach({
  guilty.Button('button1', {
    'center',
    10,
    150,
    50
  }),
  guilty.Button('button2', {
    'center',
    70,
    150,
    50
  })
})
love.draw = function()
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
exit.onclick.any = function()
  return love.event.quit()
end
