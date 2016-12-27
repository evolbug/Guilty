guilty = require "guilty"

frame = guilty.Widget 0, 0, love.graphics.getDimensions!
print frame.x, frame.y

exit = frame\attach guilty.Button 'exit', {10,10, 50, 20}

testbox = frame\attach guilty.Widget 100,100, 200,200

button1, button2 = testbox\attach {
    guilty.Button 'button1', {'center', 10, 150, 50}
    guilty.Button 'button2', {'center', 70, 150, 50}
}

love.draw = ->
    frame\event 'render'

love.mousepressed = (x, y, button, istouch) ->
    frame\event {mousepress: {x, y, button, istouch}}

love.mousereleased = (x, y, button, istouch) ->
    frame\event {mouserelease: {x, y, button, istouch}}

exit.onclick.any = ->
    love.event.quit!
