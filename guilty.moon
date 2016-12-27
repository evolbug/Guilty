[[  evolbug 2016-2017, MIT license

    guilty - Love2D gui framework
]]

import Component, Receiver from require 'comfy' -- component framework

lg = love.graphics -- shorthand

class RGBA -- convenience color class
    new: => @r, @g, @b, @a = 255, 255, 255, 255
    unpack: => @r, @g, @b, @a

class Widget extends Component
    [[  widget base class, all widgets must inherit this  ]]

    new: (x, y, w, h) =>
        super!
        @x, @y, @w, @h = x, y, w, h
        @canvas = lg.newCanvas w, h

        @attach Receiver 'render', @onrender -- render event receiver
    
    onrender: =>
        lg.draw @canvas, @position!

    position: => -- return absolute widget position
        if @parent
            px, py, pw, ph = @parent\boundary!
            cx = @x=='center' and (px + (pw/2 - @w/2)) or px + @x
            cy = @y=='center' and (py + (ph/2 - @h/2)) or py + @y
            cx, cy
        else
            @x, @y

    size: => @w, @h -- return widget size

    boundary: => -- get absolute widget position and size
        x, y = @position!
        w, h = @size!
        x, y, w, h

    colored: (color, func, ...) => -- contained coloring convenience function
        r, g, b, a = lg.getColor!
        lg.setColor unpack color
        func ...
        lg.setColor r, g, b, a

    draw: (color, func, ...) =>
        lg.setCanvas @canvas
        @colored color, func, ...
        lg.setCanvas!


class Clickable extends Widget
    [[ makes widgets clickable, component

    attach to widgets to make them respond to 'mousepress' event
    ]]

    new: =>
        super!
        @attach Receiver 'mousepress', @onClick

        @onclick = -- button events
            primary:    -> print 'button->primary'   -- left button
            secondary:  -> print 'button->secondary' -- right button
            tetriary:   -> print 'button->tetriary'  -- middle button
            any:        ->                           -- any button
            _extra:     ->                           -- extra event
    
    onrender: =>

    within: (x, y) => -- check if click within boundary
        px, py, pw, ph = @parent\boundary!
        return x>=px and x<=px+pw and y>=py and y<=py+ph

    onClick: (x, y, button, istouch) => -- received click event
        if @within x, y -- if click within widget, call respective function
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
        super x, y, @text\getWidth!, @text\getHeight!
        
    onrender: =>
        @draw {@color\unpack!}, lg.draw, @text, @position!
        super!
            
class Button extends Widget
    new: (text, boundary, color = RGBA!) =>
        super unpack boundary
        @color = color
        @fill = 'line'

        @clickable = @attach Clickable!
        @onclick = @clickable.onclick
        @onclick._extra = => @fill = 'fill'

        @attach Receiver 'mouserelease', -> @fill = 'line'
        @attach Label 'center', 'center', text

    onrender: (fill=@fill) =>
        @draw {@color\unpack!}, lg.rectangle, fill, @boundary!
        super!

class Frame extends Widget
    onrender: =>
        @draw {RGBA!\unpack!}, lg.rectangle, 'line', @boundary!
        super!


{ :text, :Button, :Widget, :Label, :Frame }
