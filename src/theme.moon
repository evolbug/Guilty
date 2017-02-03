import themeUpdate, RGBA, dump from require 'util'

default =
    font:       -> 'FiraMono-Regular.ttf'
    font_size:  -> 12
    base:       -> RGBA '#303030ff'
    base2:      -> RGBA '#202020ff'
    accent:     -> RGBA '#ff3d00ff'
    fill:       -> 'fill'

Box = (override={}) ->
    themeUpdate {color:default.base!, fill:default.fill!}, override

Text = (override={}) ->
    themeUpdate {color:default.accent!, font:default.font!, size:default.font_size!}, override

LabeledPanel = (override={}) ->
    themeUpdate base:Box!, label:Text!, override

theme =
    Rectangle: Box!
    Ellipse: Box!
    Text: Text!

    Border: color:default.accent!

    Button:
        on: LabeledPanel
        	base: Box color: default.accent!
        	label: Text color: default.base!

        off: LabeledPanel!
        hover: LabeledPanel base: Box color: default.base2!

    Checkbox:
        on:
            base: Box fill: 'line'
            check: Box color: default.accent!
            label: Text!
        off:
            base: Box fill: 'line'
            check: Box color: RGBA '#00000000'
            label: Text color: default.base!

    TextBox:
        base: Box!
        text: Text!

    TextBoxScrollable:
        on:
            base: Box!
            text: Text!
        off:
            base: Box color: default.base2!
            text: Text!

    ScrollBar: Box {color: RGBA('#ffffff50'), width: 3}

    List:
        base: Box!

{ :theme }
