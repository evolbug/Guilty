-- evolbug 2016-2017, MIT license
-- Guilty - Love2D GUI framework
-- version .4


import
    Component, Receiver
    from require 'guilty.comfy'

import
    theme, RGBA, Theme
    from require 'guilty.theme'

import
    Clickable, Focus, Scroll, Input, Border, ScrollBar, Cursor, BlinkingCursor
    from require 'guilty.extensions'

import 
    WidgetBase, Rectangle, Ellipse, Text
    from require 'guilty.primitives'


{graphics:gr} = love


--  CONTAINER ------------------------------------------------------------

class Container extends WidgetBase
    -- basic widget container, use as basic windows
    
    new: (x, y, w, h) =>
        super x, y, w, h
        @canvas = gr.newCanvas w, h

    draw: =>
        if @visible
            if @update
                @canvas\renderTo gr.clear

                for child in *@children
                    @canvas\renderTo child\draw if child.visible and child\draw

                @update = false

            gr.draw @canvas, @relative!


--  COMPOSITES -----------------------------------------------------------

class Button extends Container
    new: (x, y, w, h, label) =>
        super x, y, w, h

        @panel = @attach Rectangle 0, 0, w, h
        @text = @attach Text 'center', 'center', label
        
        @onclick = @attach Clickable!

        @panel.theme = @theme.off.base
        @text.theme = @theme.off.text

        @onclick._any = ->
            @panel.theme = @theme.on.base
            @text.theme = @theme.on.text
            @rise 'update'

        @onclick._release = ->
            @panel.theme = @theme.off.base
            @text.theme = @theme.off.text
            @rise 'update'
                        

class Checkbox extends Container
    new: (x, y, radius, text='', state=false) =>
        @state = state -- checkbox state

        @check = Rectangle 3, 'center', radius-5, radius-5
        @base = Rectangle .5, .5, radius, radius -- account for subpixel errors

        @text = Text radius+8, 'center', text
        super x, y, radius+8 + @text.w, radius+1

        @attach @base, @text, @check
        @onclick = @attach Clickable!

        @base.theme  = @theme[@namestate!].base
        @check.theme = @theme[@namestate!].check
        @text.theme =  @theme[@namestate!].text

        @onclick._any = -> @toggle!

    toggle: =>
        @state = not @state
        @base.theme  = @theme[@namestate!].base
        @check.theme = @theme[@namestate!].check
        @text.theme =  @theme[@namestate!].text
        @rise 'update'

    namestate: => 'on' if @state else 'off'


class TextBox extends Container
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
        @base.theme = @theme.off.base
        @text.theme = @theme.off.text

        @buffer = "" -- text buffer for easier manipulation
        
        @cursor = @attach BlinkingCursor ((_, c) -> @refresh c), .7

        with @focus = @attach Focus 'mousepress'
            .focused = ->
                @base.theme = @theme.on.base
                @text.theme = @theme.on.text
                @rise 'update'

            .lost = ->
                @base.theme = @theme.off.base
                @text.theme = @theme.off.text
                @rise 'update'

        @attach Input @focus, self -- make widget receive keyboard events

    add: (text) =>
        @buffer ..= text
        @cursor\focused!

    remove: =>
        @buffer = @buffer\sub 1, -2
        @cursor\focused!

    refresh: (cursor) =>
        @text\set @buffer..cursor


{
    :RGBA
    :Container
    :Rectangle, :Border
    :Text, :TextBox, :TextBoxScrollable, :TextInput
    :Button, :Checkbox
    :theme, :Theme
}
