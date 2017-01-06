-- evolbug 2016-2017, MIT license
-- Guilty - Love2D GUI framework
-- alpha 3


import Component, Receiver from require 'comfy'
lg = love.graphics


RGBA = (r=1, g=1, b=1, a=1) ->
    if type(r) == 'string' and r\sub(1,1) == '#' -- hex (#xxxxxxxx)
        return {
            tonumber r\sub(2,3), 16  -- r
            tonumber r\sub(4,5), 16  -- g
            tonumber r\sub(6,7), 16  -- b
            tonumber r\sub(8,9), 16  -- a
        }

    if #[i for i in *{r, g, b, a} when i<=1] == 4 -- opengl-style (<=1)
        return {r*255, g*255, b*255, a*255}

    return {r, g, b, a} -- standard rgba 0->255



defaultfont = 'FiraCode-Regular.ttf'
theme =
    Rectangle:
        color: RGBA '#455a64ff'
        fill: 'fill'

    Ellipse:
        color: RGBA '#455a64ff'
        fill: 'fill'

    Text:
        color: RGBA 0,0,0,1
        font: defaultfont
        size: 12

    Button:
        on:
            base:
                color: RGBA '#ff3d00ff'
                fill: 'fill'
            label:
                color: RGBA!
                font: defaultfont
                size: 12
        off:
            base:
                color: RGBA '#37474fff'
                fill: 'line'
            label:
                color: RGBA 0,0,0,1
                font: defaultfont
                size: 12

    Checkbox:
        on:
            base:
                color: RGBA '#37474fff'
                fill: 'line'
            check:
                color: RGBA '#ff3d00ff'
                fill: 'fill'
            label:
                color: RGBA 0,0,0,1
                font: defaultfont
                size: 12
        off:
            base:
                color: RGBA '#37474fff'
                fill: 'line'
            check:
                color: RGBA '#00000000'
                fill: 'fill'
            label:
                color: RGBA 0,0,0,1
                font: defaultfont
                size: 12

    TextBox:
        base:
            color: RGBA '#37474fff'
            fill: 'line'
        text:
            color: RGBA 0,0,0,1
            font: defaultfont
            size: 12

themeUpdate = (t1, t2) ->
    for k, v in pairs t2
        if (type(v) == "table") and (type(t1[k] or false) == "table")
            themeUpdate t1[k], t2[k]
        else
            t1[k] = v
    return t1



class WidgetBase extends Component
    new: (x, y, w, h) =>
        super!
        @x, @y, @w, @h = x, y, w, h
        @update = true -- rerender flag
        @theme = theme[@@__name]

        @visible = true

    absolute: => -- absolute widget position
        x, y = @relative!
        if @parent
            px, py = @parent\absolute!
            x+px, y+py
        else
            x, y

    relative: => -- widget position relative to parent
        pw, ph, w, h = 0,0,0,0
        if @parent
            pw, ph = @parent.w, @parent.h
        else
            pw, ph = lg.getDimensions!
        
        if @w and @h then w, h = @w, @h

        cx = @x == 'center' and math.floor(pw/2 - w/2) or @x
        cy = @y == 'center' and math.floor(ph/2 - h/2) or @y

        return cx, cy
    
    draw: =>

    colored: (func, ...) =>
        r, g, b, a = lg.getColor!
        {cr, cg, cb, ca} = @theme.color
        lg.setColor cr, cg, cb, ca
        func ...
        lg.setColor r, g, b, a



--  EXTENSIONS
class Clickable extends Component
    --  attach to widgets to make them respond to 'mousepress' event

    new: =>
        super!

        -- mouse/touch events
        @primary   = (x,y) => print "#{x},#{y} -> primary"
        @secondary = (x,y) => print "#{x},#{y} -> secondary"
        @tertiary  = (x,y) => print "#{x},#{y} -> tertiary"
        @any       = (x,y) => -- any button
        @_any    = (x,y) => -- extra event

        @release   = (x,y) => print "#{x},#{y} -> released"
        @_release   = (x,y) => -- extra event
        
        @attach Receiver 'mousepress', @onClick
        @attach Receiver 'mouserelease', @onRelease

    draw: =>

    withinBoundary: (x, y) =>
        px, py = @parent\absolute!
        pw, ph = @parent.w, @parent.h
        return x>=px and x<=px+pw and y>=py and y<=py+ph

    onClick: (x, y, button, istouch) => -- received click event
        if @parent.visible and @withinBoundary x, y
            @_any x, y
            @any x, y
            if button == 1 then @primary    x, y 
            if button == 2 then @secondary  x, y
            if button == 3 then @tertiary   x, y
            @parent.update = true

    onRelease: (x, y, button, istouch) => -- received click event
        if @parent.visible and @withinBoundary x, y
            @release x, y
            @_release x, y
            @parent.update = true


class Focus extends Component
    --  widget focus component

    new: =>
        super!

        @focus = false
        @focused = => print @parent.__class.__name..' got focus'
        @lost    = => print @parent.__class.__name..' lost focus'
        
        @attach Receiver 'mousepress', @onClick

    draw: =>

    withinBoundary: (x, y) =>
        px, py = @parent\absolute!
        pw, ph = @parent.w, @parent.h
        return x>=px and x<=px+pw and y>=py and y<=py+ph

    onClick: (x, y) => -- received click event
        if @parent.visible and @withinBoundary x, y
            if not @focus
                @focus = true
                @focused!
                @parent.update = true
        else
            if @focus
                @focus = false
                @lost!
                @parent.update = true


--  CONTAINER TYPES
class Container extends WidgetBase
    new: (x, y, w, h) =>
        super x, y, w, h
        @canvas = lg.newCanvas w, h

    draw: =>
        if @visible
            if @update
                @canvas\renderTo lg.clear
                for child in *@children
                    @canvas\renderTo child\draw if child.visible
                @update = false
            lg.draw @canvas, @x, @y


class Composite extends Container
    draw: =>
        if @visible
            @canvas\renderTo lg.clear
            for child in *@children
                @canvas\renderTo child\draw if child.visible
            lg.draw @canvas, @x, @y



--  PRIMITIVES
class Rectangle extends WidgetBase
    draw: =>
        if @visible
            x, y = @relative!
            @colored lg.rectangle, @theme.fill, x, y, @w, @h


class Ellipse extends WidgetBase
    draw: =>
        if @visible
            x, y = @relative!
            @colored lg.ellipse, @theme.fill, x, y, @w, @h


class Text extends WidgetBase
    new: (x, y, text) =>
        super x, y
        @text = {@theme.color, text}

        @label = lg.newText lg.newFont(@theme.font, @theme.size), @text
        @w, @h = @label\getDimensions!

    draw: =>
        if @visible then lg.draw @label, @relative!

    getDimensions: => @label\getDimensions!
    getWidth: => @label\getWidth!
    getHeight: => @label\getHeight!

    set: (text, wrap=@parent.w, align='left') =>
        @text = @colorize text
        @label\setf @text, wrap, align
        @w, @h = @label\getDimensions!

    add: (text, wrap=@parent.w, align='left') =>
        table.insert @text, item for item in *@colorize text
        @label\setf @text, wrap, align
        @w, @h = @label\getDimensions!

    clear: =>
        @label\clear!
        @text = {}

    colorize: (items) =>
        newtable = {}
        hascolor = false

        if type(items) ~= 'table' then return {@theme.color, items}

        for item in *items
            if type(item) == 'table' -- color table
                hascolor = true
                table.insert newtable, item

            elseif hascolor -- this element has color
                table.insert newtable, item
                hascolor = false -- reset for next element
            
            else -- this element isn't colored
                table.insert newtable, @theme.color
                table.insert newtable, item

        return newtable


--  COMPOSITES
class Button extends Composite
    new: (x, y, w, h, text) =>
        super x, y, w, h
        
        @panel = @attach Rectangle 0, 0, w, h
        @label = @attach Text 'center', 'center', text
        @onclick = @attach Clickable!

        @panel.theme = @theme.off.base
        @label.theme = @theme.off.label

        @onclick._any = ->
            @panel.theme = @theme.on.base
            @label.theme = @theme.on.label
            @parent.update = true

        @onclick._release = ->
            @panel.theme = @theme.off.base
            @label.theme = @theme.off.label
            @parent.update = true


class Checkbox extends Composite
    new: (x, y, w, h, text='', state=false) =>
        @state = state -- checkbox state
        
        @check = Rectangle 3, 'center', w-6, h-6
        @label = Text w+4, 'center', text
        @base = Rectangle 0, 0, w-.5, h

        super x, y, w+6 + @label\getWidth!, h

        @attach @base, @label, @check
        @onclick = @attach Clickable!

        @base.theme  = @theme[@namestate!].base
        @check.theme = @theme[@namestate!].check
        @label.theme = @theme[@namestate!].label

        @onclick._any = -> @toggle!

    toggle: =>
        @state = not @state
        @parent.update = true
        @base.theme  = @theme[@namestate!].base
        @check.theme = @theme[@namestate!].check
        @label.theme = @theme[@namestate!].label

    namestate: => 'on' if @state else 'off'


class TextBox extends Composite
    new: (x, y, w, h) =>
        super x, y, w, h
        
        @base = @attach Rectangle 0, 0, w, h
        @text = @attach Text 2, 2, ''

        @base.theme = @theme.base
        @text.theme = @theme.text

        with @focus = @attach Focus!
            .focused = => @base.theme

    set: (...) =>
        @text\set ...
        @parent.update = true

    add: (...) =>
        @text\add ...
        @parent.update = true

    clear: =>
        @text\clear!
        @parent.update = true
    
    scroll: (px) =>
        diff = @w - @text.w
        print diff



{
    :RGBA,
    :Container,
    :Rectangle, :Text,
    :Button, :Checkbox, :TextBox
}
