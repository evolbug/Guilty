-- evolbug 2016-2016, MIT license
-- Guilty primitives


import
    Component, Receiver
    from require 'guilty.comfy'

import
    theme, Theme
    from require 'guilty.theme'


{graphics:lg} = love


class WidgetBase extends Component
    -- primitive widget base
    
    new: (x, y, w, h) =>
        super!
        @x, @y, @w, @h = x, y, w, h
        @update = true -- rerender flag
        @theme = Theme theme[@@__name]

        @visible = true
        @attach Receiver 'update', -> @update=true

    absolute: => -- absolute widget position
        x, y = @relative!
        if @parent
            px, py = @parent\absolute!
            return x+px, y+py
        else
            return x, y

    relative: => -- widget position relative to parent
        cx, cy = @x, @y
        
        if @x == 'center'
            w = @w or 0
            cx = math.floor (@parent and @parent.w or lg.getWidth!)/2 - w/2

        if @y == 'center'
            h = @h or 0
            cy = math.floor (@parent and @parent.h or lg.getHeight!)/2 - h/2

        return cx, cy

    draw: => -- override to draw things

    colored: (func, ...) =>
        lg.push 'all' -- save state
        {cr, cg, cb, ca} = @theme.color!
        lg.setColor cr, cg, cb, ca
        func ...
        lg.pop! -- restore state


class Rectangle extends WidgetBase
    draw: =>
        if @visible
            x, y = @relative!
            @colored lg.rectangle, @theme.fill!, x, y, @w, @h


class Text extends WidgetBase
    new: (x, y, text) =>
        super x, y
        @buffer = text
        
        font, fsize = unpack @theme.font!
        @text = lg.newText lg.newFont(font, fsize), @buffer

        @w, @h = @text\getDimensions!

    draw: => @colored lg.draw, @text, @relative! if @visible

    refresh: => -- refresh text dimensions and display position
        @w, @h = @text\getDimensions!
        @y = @parent.h-@h if @h > @parent.h else 0
        @rise 'update'

    set: (text, wrap=@parent.w, align='left') => -- set/overwrite text
        @buffer = text
        @text\setf @buffer, wrap, align
        @refresh!


    add: (text, wrap=@parent.w, align='left') => -- append text to existing
        @buffer ..= text
        @text\addf @buffer, wrap, align
        @refresh!

    remove: (a=#@buffer-1, b=#@buffer) => -- remove _elements_ from 'a' to 'b'
        @buffer = @buffer\sub(0, a)..@buffer\sub(b, #@buffer-b)
        @text\setf @buffer, @parent.w, 'left'
        @refresh!

    clear: =>
        @text\clear!
        @buffer = ''
        @rise 'update'


{
    :WidgetBase, :Rectangle, :Text
}
