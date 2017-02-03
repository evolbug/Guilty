-- evolbug 2016-2017, MIT license
-- Guilty - Love2D GUI framework
-- alpha 3


import Component, Receiver from require 'comfy'
import theme from require 'theme'
import RGBA, approach, themeUpdate from require 'util'
lg = love.graphics


class WidgetBase extends Component
    new: (x, y, w, h) =>
        super!
        @x, @y, @w, @h = x, y, w, h
        @update = true -- rerender flag
        @theme = theme[@@__name]

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
        pw, ph, w, h = 0,0,0,0
        if @parent
            pw, ph = @parent.w, @parent.h
        else
            pw, ph = lg.getDimensions!

        if @w and @h then w, h = @w, @h

        cx = @x == 'center' and math.floor(pw/2 - w/2) or @x
        cy = @y == 'center' and math.floor(ph/2 - h/2) or @y

        return cx, cy

    draw: => -- override to draw things

    colored: (func, ...) =>
        lg.push 'all' -- save state
        {cr, cg, cb, ca} = @theme.color
        lg.setColor cr, cg, cb, ca
        func ...
        lg.pop! -- restore state


--  EXTENSIONS -----------------------------------------------------------

class Clickable extends Component
    --  attach to widgets to make them respond to 'mousepress' event

    new: =>
        super!

        -- mouse/touch events
        @primary    = (x,y) => print "#{x},#{y} -> primary"
        @secondary  = (x,y) => print "#{x},#{y} -> secondary"
        @tertiary   = (x,y) => print "#{x},#{y} -> tertiary"
        @any        = (x,y) => -- any button
        @_any       = (x,y) => -- extra event

        @release    = (x,y) => print "#{x},#{y} -> released"
        @_release   = (x,y) => -- extra event

        @attach Receiver 'mousepress', @onClick
        @attach Receiver 'mouserelease', @onRelease

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
            @rise 'update'

    onRelease: (x, y, button, istouch) => -- received click event
        if @parent.visible and @withinBoundary x, y
            @release x, y
            @_release x, y
            @rise 'update'

class Focus extends Component
    --  widget focus component

    new: (response='mousepress') =>
        super!

        @focus = false
        @focused = => print @parent.__class.__name..' got focus'
        @lost    = => print @parent.__class.__name..' lost focus'

        @attach Receiver response, @onFocus

    withinBoundary: (x, y) =>
        px, py = @parent\absolute!
        pw, ph = @parent.w, @parent.h
        return x>=px and x<=px+pw and y>=py and y<=py+ph

    onFocus: (x, y) => -- received click event
        if @parent.visible and @withinBoundary x, y
            if not @focus
                @focus = true
                @focused!
                @rise 'update'

        else
            if @focus and not @persistent
                @focus = false
                @lost!
                @rise 'update'


class Scroll extends Component
    --  widget scroll component

    new: (focus, object) =>
        super!
        @focus = focus
        @object = object
        @speed = 0
        @attach Receiver 'wheelmove', @onWheel

    withinBoundary: (x, y) =>
        px, py = @parent\absolute!
        pw, ph = @parent.w, @parent.h
        return x>=px and x<=px+pw and y>=py and y<=py+ph

    onWheel: (x, y) => -- received wheel event
        if @parent.visible
            @speed = @parent.h/4
            @scroll x, y if @focus.focus
            @rise 'update'

    scroll: (x, y) =>
        if y>0 -- scroll down
            if @object.y <= 0
                @object.y = approach @object.y, 0, y*@speed

        else -- scroll up
            if @object.y >= @parent.h - @object.h
                @object.y = approach @object.y, @parent.h - @object.h, y*@speed

            @rise 'update'

class Input extends Component
    --  widget input component

    new: (focus, object) =>
        super!
        @focus = focus
        @object = object
        @attach Receiver 'textinput', @onInput

    onInput: (t) => -- received wheel event
        if @parent.visible
            @speed = @parent.h/4
            @scroll x, y if @focus.focus
            @rise 'update'

--  CONTAINER TYPES ------------------------------------------------------

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
                @canvas\renderTo child\draw if child.visible and child\draw
            lg.draw @canvas, @x, @y
            if @update
                @rise 'update'
                @update = false



--  PRIMITIVES -----------------------------------------------------------

class Rectangle extends WidgetBase
    draw: =>
        if @visible
            x, y = @relative!
            @colored lg.rectangle, @theme.fill, x, y, @w, @h

class Border extends Rectangle
    new: => super 0,0,1,1
    draw: =>
        if @visible
            x, y = @relative!
            @colored lg.rectangle, 'line', x, y, @parent.w, @parent.h

class ScrollBar extends WidgetBase
    new: (scroller, scrolledObject) =>
        super scrolledObject.parent.w, 0, 0, 0
        @x -= @theme.width
        @w = @theme.width
        @scroller = scroller
        @scrolledObject = scrolledObject

    draw: =>
        if @visible
            with @scrolledObject
                @h = .parent.h / (.h / .parent.h)
                @y = -.y / (.h / .parent.h)

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

    draw: => lg.draw @label, @relative! if @visible

    getDimensions: => @label\getDimensions!
    getWidth: => @label\getWidth!
    getHeight: => @label\getHeight!

    set: (text, wrap=@parent.w, align='left') =>
        @text = @colorize text
        @label\setf @text, wrap, align
        @w, @h = @label\getDimensions!
        @rise 'update'

    add: (text, wrap=@parent.w, align='left') =>
        table.insert @text, item for item in *@colorize text
        @label\setf @text, wrap, align
        @w, @h = @label\getDimensions!
        @y = @parent.h-@h if @h > @parent.h
        @rise 'update'

    clear: =>
        @label\clear!
        @text = {}
        @rise 'update'

    colorize: (items) => -- make sure all elements are paired with colors
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
            @rise 'update'

        @onclick._release = ->
            @panel.theme = @theme.off.base
            @label.theme = @theme.off.label
            @rise 'update'


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
        @text = @attach Text 0, 0, ''

        @base.theme = @theme.base
        @text.theme = @theme.text


class TextBoxScrollable extends TextBox
    new: (x, y, w, h) =>
        super x, y, w, h

        @base.theme = @theme.off.base
        @text.theme = @theme.off.text

        with @focus = @attach Focus 'mousemove' -- focuses when mouse hovered
            .focused = ->
                @base.theme = @theme.on.base
                @text.theme = @theme.on.text
                @rise 'update'

            .lost = ->
                @base.theme = @theme.off.base
                @text.theme = @theme.off.text
                @rise 'update'

        @scroller = @attach Scroll @focus, @text -- scroll functionality
        @scrollbar = @attach ScrollBar @scroller, @text

class TextInput extends TextBox
    new: (x, y, w, h) =>
        super x, y, w, h



class List extends Composite
    new: (x, y, w, h) =>
        super x, y, w, h

        @base = @attach Rectangle 0, 0, w, h


{
    :RGBA,
    :Container,
    :Rectangle, :Border,
    :Text, :TextBox, :TextBoxScrollable,
    :Button, :Checkbox,
    :List,
    :themeUpdate, :theme
}
