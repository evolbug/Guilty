-- evolbug 2016-2017, MIT license
-- Guilty extension components


import
    Component, Receiver
    from require 'guilty.comfy'

import
    WidgetBase, Rectangle
    from require 'guilty.primitives'

{graphics:gr} = love


approach = (curr, goal, step) ->
    if curr+step >= goal
        return step>0 and goal or curr+step
    else
        return step<0 and goal or curr+step


class Clickable extends Component
    --  attach to widgets to make them respond to 'mousepress' event

    new: =>
        super!

        -- mouse click callbacks
        @primary    = (x,y) => -- primary button
        @secondary  = (x,y) => 
        @tertiary   = (x,y) => 
        @any        = (x,y) => -- any button
        @_any       = (x,y) => -- extra event (internal)

        @release    = (x,y) => -- button released
        @_release   = (x,y) => -- extra event (internal)

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
                @rise 'update'
                @focused!

        else
            if @focus and not @persistent
                @focus = false
                @rise 'update'
                @lost!


class Border extends Rectangle
    new: => super 0,0,1,1
    draw: =>
        if @visible
            x, y = @relative!
            @colored gr.rectangle, 'line', x, y, @parent.w, @parent.h


class ScrollBar extends WidgetBase
    new: (scroller, scrolledObject) =>
        super scrolledObject.parent.w, 0, 0, 0
        @x -= @theme.width!
        @w = @theme.width!
        @scroller = scroller
        @scrolledObject = scrolledObject

    draw: =>
        if @visible
            with @scrolledObject
                @h = .parent.h / (.h / .parent.h)
                @y = -.y / (.h / .parent.h)

            x, y = @relative!
            @colored gr.rectangle, @theme.fill!, x, y, @w, @h


class Scroll extends Component
    --  widget scroll component

    new: (focus, object) =>
        super!
        @focus = focus
        @object = object -- a Text object
        @speed = @object.theme.font![2]
        @attach Receiver 'wheelmove', @onWheel

    withinBoundary: (x, y) =>
        px, py = @parent\absolute!
        pw, ph = @parent.w, @parent.h
        return x>=px and x<=px+pw and y>=py and y<=py+ph

    onWheel: (x, y) => -- received wheel event
        if @parent.visible
            @scroll x, y if @focus.focus
            @rise 'update'

    scroll: (x, y) =>
        if y>0 -- scroll down
            if @object.y <= 0
                @object.y = approach @object.y, 0, @speed

        else -- scroll up
            if @object.y >= @parent.h - @object.h
                @object.y = approach @object.y, @parent.h - @object.h, -@speed

            @rise 'update'


class Input extends Component
    --  widget input component

    new: (focus, writableObject) =>
        super!
        @focus = focus
        @text = writableObject -- requires 'add', 'remove'
        @attach Receiver 'textinput', @onInput
        @attach Receiver 'keypress', @onOtherKey

    onInput: (text) => -- received text event
        @text\add text if @focus.focus

    onOtherKey: (key) => -- received generic keypress
        if @focus.focus
            switch key
                when 'backspace'
                    @text\remove!
                
                when 'return'
                    @text\add '\n'
                    

class Cursor extends Component
    -- text cursor extension

    new: (callback) =>
        super!
        
        @cursor = '│' -- cursor character
        @callback = callback -- when state changes, gets called with cursor

    focused: => @callback @cursor
        
    focuslost: => @callback ''


class BlinkingCursor extends Cursor
    -- blinking text cursor

    new: (callback, delay) =>
        super callback
        
        @delay = delay -- cursor blink delay
        @timer = 0 -- blink timer
        @toggle = false
        
        @attach Receiver 'delta', @onDelta

    onDelta: (dt) =>
        if @parent.focus.focus
            @timer += dt

            if @timer >= @delay
                @toggle = not @toggle
                @focused! if @toggle else @focuslost!
                @timer = 0

        elseif @toggle
            @focuslost!
            @toggle = not @toggle

{
    :Clickable, :Focus, :Scroll, :Input, :Border, :ScrollBar, :Cursor
    :BlinkingCursor
}
