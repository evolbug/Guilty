-- evolbug 2016-2017, MIT license
-- Guilty testbench

gui = require "guilty"
lg = love.graphics
util = require "util"

love.load = ->
    love.window.setMode 500,500

    export window = with gui.Container 10, 10, lg.getWidth!-20, lg.getHeight!-20
        \attach gui.Border!

        panel1 = with \attach gui.Container 10,10, (.w-20)/2-2, (.h-20)
            \attach gui.Border!

            export texbax = with \attach gui.TextBoxScrollable 10,10, .w-20, .h-20
                .text\set 'hellooooooooooooooooooooooooooooo'

        panel2 = with \attach gui.Container (.w-20)/2+14, 10, (.w-20)/2-4, (.h-20)
            \attach gui.Border!

            \attach gui.List 10,10, .w-20, .h/2

            with \attach gui.Button .w-50, .h-50, 30, 30, 'buhn'
                \attach gui.Border!
                .onclick.any = -> texbax.text\add 'clikbax texbax \n'

love.draw = ->
    lg.clear gui.RGBA 0,0,0,1
    window\draw!

love.mousepressed = (x, y, button, istouch) ->
    window\event mousepress: {x, y, button, istouch}

love.mousereleased = (x, y, button, istouch) ->
    window\event mouserelease: {x, y, button, istouch}

love.wheelmoved = (x, y) ->
    window\event wheelmove: {x, y}

love.mousemoved = (x, y) ->
    window\event mousemove: {x, y}
