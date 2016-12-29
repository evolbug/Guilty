[[
    evolbug 2016-2017, MIT license

    Guilty - Love2D GUI framework
    alpha 1
]]

import Component, Receiver from require 'comfy'

lg = love.graphics

RGBA = (r=1, g=1, b=1, a=255) -> -- convenience color function
    if #[i for i in *{r, g, b, a} when i<=1] == 4 -- opengl-style colours (<1)
        return {r*255, g*255, b*255, a*255}
    return {r, g, b, a}

class Widget extends Component
    [[  widget base class, all widgets must inherit this  ]]

    new: (boundary) =>
        super!
        @x, @y, @w, @h = unpack boundary
        @canvas = lg.newCanvas @w, @h -- personal canvas
        @renderRecv = @attach Receiver 'render', @onrender -- 'render' event

    onrender: =>
        if @parent
            @parent\draw lg.draw, {@canvas, @position!} -- draw to parent
        else
            lg.draw @canvas, @position! -- draw to screen
        @draw lg.clear, {} -- clear canvas for next render

            
    position: => -- return widget position relative to parent
        pw, ph = unpack @parent and {@parent\size!} or {lg.getDimensions!}
        cx = @x=='center' and math.floor pw/2-@w/2 or @x
        cy = @y=='center' and math.floor ph/2-@h/2 or @y
        cx, cy

    aposition: => -- get absolute widget position and size
        x, y = @position!
        if @parent
            px, py = @parent\aposition!
            x+px, y+py
        else
            x, y

    size: => @w, @h -- return widget size

    boundary: => -- get relative widget position and size
        x, y = @position!
        w, h = @size!
        x, y, w, h

    draw: (func, args, color = RGBA!) =>
        [[contained colored draw function
            example:
                @draw lg.rectangle, {0, 0, 100, 100}, RGBA 1,0,0,1
        ]]
        @canvas\renderTo ->
            r, g, b, a = lg.getColor!
            lg.setColor unpack color
            func unpack args
            lg.setColor r, g, b, a


class Clickable extends Component
    [[ makes widgets clickable, component

    attach to widgets to make them respond to 'mousepress' event
    ]]

    new: =>
        super!
        @attach Receiver 'mousepress', @onClick
        @onclick = -- button events
            primary:    (x,y) -> print "#{x}, #{y}->primary"   -- left button
            secondary:  (x,y) -> print "#{x}, #{y}->secondary" -- right button
            tertiary:   (x,y) -> print "#{x}, #{y}->tertiary"  -- middle button
            any:        (x,y) -> -- any button
            _extra:     (x,y) -> -- extra event

    within: (x, y) => -- check if click within boundary
        px, py= @parent\aposition! -- get widget's absolute position
        pw, ph= @parent\size! -- get widget's size
        return x>=px and x<=px+pw and y>=py and y<=py+ph

    onClick: (x, y, button, istouch) => -- received click event
        if @within x, y -- if within widget, call respective function
            if button == 1 then @onclick.primary    x, y
            if button == 2 then @onclick.secondary  x, y
            if button == 3 then @onclick.tetriary   x, y
            @onclick.any x, y
            @onclick._extra x, y

class Label extends Widget
    [[  generic text label class  ]]

    new: (x, y, text, color = RGBA!) =>
        @color = color
        @text = lg.newText lg.getFont!, text
        super {x, y, @text\getWidth!, @text\getHeight!}
        
    onrender: (color=@color) =>
        @draw lg.draw, {@text, 0,0}, color
        super!

class Button extends Widget
    new: (boundary, text, color = RGBA .5,.5,.5,1) =>
        super boundary
        @color = color
        @fill = 'fill'
        
        @label = Label 'center', 'center', text -- button label

        @clickable = @attach Clickable! -- make widget clickable
        @onclick = @clickable.onclick -- pull in onclick event table

        @onclick._extra = ->
--            @fill = 'fill' -- set fill style on click
            @color = RGBA 0,0,0,1
            @label.color = RGBA 1,1,1,1
--            @event 'render'

        @attach Receiver 'mouserelease', ->
--            @fill = 'line' -- reset fill
            @color = RGBA .5,.5,.5,1
            @label.color = RGBA 0,0,0,1
--            @event 'render'

    onrender: (fill=@fill) =>
        @draw lg.rectangle, {fill, 0,0, @size!}, @color -- draw widget border
        @label\event 'render'
        super!


{ :Widget, :Renderer, :Button }
