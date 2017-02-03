local themeUpdate, RGBA, dump
do
  local _obj_0 = require('util')
  themeUpdate, RGBA, dump = _obj_0.themeUpdate, _obj_0.RGBA, _obj_0.dump
end
local default = {
  font = function()
    return 'FiraMono-Regular.ttf'
  end,
  font_size = function()
    return 12
  end,
  base = function()
    return RGBA('#303030ff')
  end,
  base2 = function()
    return RGBA('#202020ff')
  end,
  accent = function()
    return RGBA('#ff3d00ff')
  end,
  fill = function()
    return 'fill'
  end
}
local Box
Box = function(override)
  if override == nil then
    override = { }
  end
  return themeUpdate({
    color = default.base(),
    fill = default.fill()
  }, override)
end
local Text
Text = function(override)
  if override == nil then
    override = { }
  end
  return themeUpdate({
    color = default.accent(),
    font = default.font(),
    size = default.font_size()
  }, override)
end
local LabeledPanel
LabeledPanel = function(override)
  if override == nil then
    override = { }
  end
  return themeUpdate({
    base = Box(),
    label = Text()
  }, override)
end
local theme = {
  Rectangle = Box(),
  Ellipse = Box(),
  Text = Text(),
  Border = {
    color = default.accent()
  },
  Button = {
    on = LabeledPanel({
      base = Box({
        color = default.accent()
      }),
      label = Text({
        color = default.base()
      })
    }),
    off = LabeledPanel(),
    hover = LabeledPanel({
      base = Box({
        color = default.base2()
      })
    })
  },
  Checkbox = {
    on = {
      base = Box({
        fill = 'line'
      }),
      check = Box({
        color = default.accent()
      }),
      label = Text()
    },
    off = {
      base = Box({
        fill = 'line'
      }),
      check = Box({
        color = RGBA('#00000000')
      }),
      label = Text({
        color = default.base()
      })
    }
  },
  TextBox = {
    base = Box(),
    text = Text()
  },
  TextBoxScrollable = {
    on = {
      base = Box(),
      text = Text()
    },
    off = {
      base = Box({
        color = default.base2()
      }),
      text = Text()
    }
  },
  ScrollBar = Box({
    color = RGBA('#ffffff50'),
    width = 3
  }),
  List = {
    base = Box()
  }
}
return {
  theme = theme
}
