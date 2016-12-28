gui = require "guilty2"
lg = love.graphics

frame = gui.Widget {'center', 'center', 100, 100}
butt = frame\attach gui.Button {'center', 'center', 80, 80}, 'butn'

love.load = ->
    love.window.setMode 800,600, resizable: true, borderless:true

love.draw = ->
    lg.clear 0,0,0,0
    frame\event 'render'

love.mousepressed = (x, y, button, istouch) ->
    frame\event mousepress: {x, y, button, istouch}

love.mousereleased = (x, y, button, istouch) ->
    frame\event mouserelease: {x, y, button, istouch}

butt.onclick.secondary = ->
    love.event.quit!
