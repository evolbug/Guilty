gui = require "guilty3"
lg = love.graphics

love.load = ->
    love.window.setMode 800,600, resizable: true--, borderless:true
    export window = gui.Container 10, 10, lg.getWidth!-20, lg.getHeight!-20
    
    with window
        with \attach gui.Rectangle 0,0, .w, .h
            .theme.color = gui.RGBA 0,0,0,1
            .theme.fill = 'line'

        debug = \attach gui.TextBox .w/2, 2, .w/2-2, .h-4
        
        with \attach gui.Button 10, 10, 100, 30, 'button up!'
            .onclick.any = (x, y) =>
                debug\add {gui.RGBA(0,1,0,1), "[button] #{x}:#{y} pressed\n"}
            .onclick.release = (x, y) =>
                debug\add {gui.RGBA(1,0,0,1), "[button] #{x}:#{y} released\n"}


        che1 = \attach gui.Checkbox 10,41, 20,20, 'i is checkbox'
        with \attach gui.Text 200, che1.y, 'turn up!'
            .visible = che1.state
            che1.onclick.any = (x, y) =>
                .visible = che1.state
                c = che1.state and gui.RGBA(0,1,0,1) or gui.RGBA(1,0,0,1)
                debug\add {"[check1] #{x}:#{y} toggled", c, " #{che1.state}\n"}

        che2 = \attach gui.Checkbox 10,62, 20,20, 'checkbox too'
        with \attach gui.Text 200, che2.y, 'turn up!'
            .visible = che2.state
            che2.onclick.any = (x, y) =>
                .visible = che2.state
                c = che2.state and gui.RGBA(0,1,0,1) or gui.RGBA(1,0,0,1)
                debug\add {"[check2] #{x}:#{y} toggled", c, " #{che2.state}\n"}

        che3 = \attach gui.Checkbox 10,83, 20,20, 'me check'
        with \attach gui.Text 200, che3.y, 'turn up!'
            .visible = che3.state
            che3.onclick.any = (x, y) =>
                .visible = che3.state
                c = che3.state and gui.RGBA(0,1,0,1) or gui.RGBA(1,0,0,1)
                debug\add {"[check2] #{x}:#{y} toggled", c, " #{che3.state}\n"}

love.draw = ->
    lg.clear gui.RGBA!
    window\draw!

love.mousepressed = (x, y, button, istouch) ->
    window\event mousepress: {x, y, button, istouch}

love.mousereleased = (x, y, button, istouch) ->
    window\event mouserelease: {x, y, button, istouch}

