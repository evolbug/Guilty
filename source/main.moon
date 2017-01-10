gui = require "guilty3"
lg = love.graphics

love.load = ->
    love.window.setMode 500,500
    export window = gui.Container 10, 10, lg.getWidth!-20, lg.getHeight!-20
    
    with window
        with \attach gui.Rectangle 0,0, .w, .h
            .theme.fill = 'line'

        debug = \attach gui.ScrollText .w/2, 2, .w/2-2, .h-4
        
        with \attach gui.Button 10, 10, 100, 30, 'button up!'
            z=0
            .onclick.any = (x, y) =>
                z += 1
                debug.text\add {gui.RGBA(0,1,0,1), "#{z}\n"}
            .onclick.release = (x, y) =>
                debug.text\add {gui.RGBA(1,0,0,1), "[button] #{x}:#{y} released\n"}

        for i=1, 3
            \attach gui.Checkbox 10, 41 + 21 * (i-1), 20, 20, "chekbax #{i}"


love.draw = ->
    lg.clear gui.RGBA!
    window\draw!

love.mousepressed = (x, y, button, istouch) ->
    window\event mousepress: {x, y, button, istouch}

love.mousereleased = (x, y, button, istouch) ->
    window\event mouserelease: {x, y, button, istouch}

love.wheelmoved = (x, y) ->
    window\event wheelmove: {x, y}
