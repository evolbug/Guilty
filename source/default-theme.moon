import RGBA from require 'util'

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
            color: RGBA 0,0,0,1
            fill: 'line'
        text:
            color: RGBA 0,0,0,1
            font: defaultfont
            size: 12

    ScrollText:
        on:
            base:
                color: RGBA 0,0,0,1
                fill: 'line'
            text:
                color: RGBA 0,0,0,1
                font: defaultfont
                size: 12
        off:
            base:
                color: RGBA 0,0,0,.3
                fill: 'line'
            text:
                color: RGBA 0,0,0,.7
                font: defaultfont
                size: 12

    ScrollBar:
        color: RGBA '#455a6450'
        fill: 'fill'
        width: 7

{ :theme }
