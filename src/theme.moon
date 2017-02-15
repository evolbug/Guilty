-- theme class prototype

RGBA = (color={255,255,255,255}) -> -- multiform color function
    if type(color) == 'string' and color\sub(1,1) == '#' -- hexadecimal
        if #color == 5
            return { -- #rgba
                16*tonumber color\sub(2,2), 16  -- r
                16*tonumber color\sub(3,3), 16  -- g
                16*tonumber color\sub(4,4), 16  -- b
                16*tonumber color\sub(5,5), 16  -- a
            }
        return { -- #rrggbbaa
            tonumber color\sub(2,3), 16  -- r
            tonumber color\sub(4,5), 16  -- g
            tonumber color\sub(6,7), 16  -- b
            tonumber color\sub(8,9), 16  -- a
        }

    if #[i for i in *color when i<=1] == 4 -- opengl-style (<=1)
        return [i*255 for i in *color]

    return color -- standard rgba 0->255


Theme = (themeTable={}) -> -- function to define new themes
    theme = {}

    theme['update'] = (self, otherTheme) ->
        for k,v in pairs otherTheme
            if "table" == type v
                if type(self[k] or false) == "table"
                    self.update self[k] or {}, otherTheme[k] or {}
                else
                    self[k] = v
            elseif k != 'update'
                self[k] = v

    theme\update themeTable
    return theme



-- DEFAULT THEME DEFINITION ----------------------------------------------

theme = with Theme
        color: -- default base values
            primary:   '#e5e8ecff' -- typically lighter
            secondary: '#cbd0d8ff' -- typically darker
            accent:    '#d94452ff' -- colors for accenting (text, etc)
            fill:      'fill' -- widget fill style
    
        font: {"GohuFont-Medium.ttf", 11} -- gohufont allows only 11 or 14px


    \update Theme -- extend the theme after base values are defined
        Rectangle:
            color: -> RGBA .color.primary
            fill: -> .color.fill
    
        Border: color: -> RGBA .color.accent
    
        ScrollBar:
            color: -> RGBA .color.accent
            fill: -> 'fill'
            width: -> 3
            
        Button:
            on:
                base:
                    color: -> RGBA .color.accent
                    fill: -> .color.fill
                text:
                    color: -> RGBA .color.primary
                    font: -> .font
            
            off:
                base:
                    color: -> RGBA .color.primary
                    fill: -> .color.fill
                text:
                    color: -> RGBA .color.accent
                    font: -> .font
    
        Checkbox:
            on:
                base:
                    color: -> RGBA .color.accent
                    fill: -> 'line'
                check:
                    color: -> RGBA .color.accent
                    fill: -> 'fill'
                text:
                    color: -> RGBA .color.accent
                    font: -> .font
            
            off:
                base:
                    color: -> RGBA .color.primary
                    fill: -> 'line'
                check:
                    color: -> RGBA '#0000'
                    fill: -> 'fill'
                text:
                    color: -> RGBA .color.accent
                    font: -> .font
    
        Text:
            color: -> RGBA .color.accent
            font: -> .font
    
        TextBox:
            base:
                color: -> RGBA .color.primary
                fill: -> .color.fill
            text:
                color: -> RGBA .color.accent
                font: -> .font
    
        TextBoxScrollable:
            on:
                base:
                    color: -> RGBA .color.primary
                    fill: -> .color.fill
                text:
                    color: -> RGBA .color.accent
                    font: -> .font
            
            off:
                base:
                    color: -> RGBA .color.secondary
                    fill: -> .color.fill
                text:
                    color: -> RGBA .color.accent
                    font: -> .font
    
        TextInput:
            on:
                base:
                    color: -> RGBA .color.primary
                    fill: -> .color.fill
                text:
                    color: -> RGBA .color.accent
                    font: -> .font
            
            off:
                base:
                    color: -> RGBA .color.primary
                    fill: -> .color.fill
                text:
                    color: -> RGBA .color.accent
                    font: -> .font
    
{:theme, :RGBA, :Theme}
