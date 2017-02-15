local RGBA
RGBA = function(color)
  if color == nil then
    color = {
      255,
      255,
      255,
      255
    }
  end
  if type(color) == 'string' and color:sub(1, 1) == '#' then
    if #color == 5 then
      return {
        16 * tonumber(color:sub(2, 2), 16),
        16 * tonumber(color:sub(3, 3), 16),
        16 * tonumber(color:sub(4, 4), 16),
        16 * tonumber(color:sub(5, 5), 16)
      }
    end
    return {
      tonumber(color:sub(2, 3), 16),
      tonumber(color:sub(4, 5), 16),
      tonumber(color:sub(6, 7), 16),
      tonumber(color:sub(8, 9), 16)
    }
  end
  if #(function()
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #color do
      local i = color[_index_0]
      if i <= 1 then
        _accum_0[_len_0] = i
        _len_0 = _len_0 + 1
      end
    end
    return _accum_0
  end)() == 4 then
    local _accum_0 = { }
    local _len_0 = 1
    for _index_0 = 1, #color do
      local i = color[_index_0]
      _accum_0[_len_0] = i * 255
      _len_0 = _len_0 + 1
    end
    return _accum_0
  end
  return color
end
local Theme
Theme = function(themeTable)
  if themeTable == nil then
    themeTable = { }
  end
  local theme = { }
  theme['update'] = function(self, otherTheme)
    for k, v in pairs(otherTheme) do
      if "table" == type(v) then
        if type(self[k] or false) == "table" then
          self.update(self[k] or { }, otherTheme[k] or { })
        else
          self[k] = v
        end
      elseif k ~= 'update' then
        self[k] = v
      end
    end
  end
  theme:update(themeTable)
  return theme
end
local theme
do
  local _with_0 = Theme({
    color = {
      primary = '#e5e8ecff',
      secondary = '#cbd0d8ff',
      accent = '#d94452ff',
      fill = 'fill'
    },
    font = {
      "GohuFont-Medium.ttf",
      11
    }
  })
  _with_0:update(Theme({
    Rectangle = {
      color = function()
        return RGBA(_with_0.color.primary)
      end,
      fill = function()
        return _with_0.color.fill
      end
    },
    Border = {
      color = function()
        return RGBA(_with_0.color.accent)
      end
    },
    ScrollBar = {
      color = function()
        return RGBA(_with_0.color.accent)
      end,
      fill = function()
        return 'fill'
      end,
      width = function()
        return 3
      end
    },
    Button = {
      on = {
        base = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          fill = function()
            return _with_0.color.fill
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.primary)
          end,
          font = function()
            return _with_0.font
          end
        }
      },
      off = {
        base = {
          color = function()
            return RGBA(_with_0.color.primary)
          end,
          fill = function()
            return _with_0.color.fill
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          font = function()
            return _with_0.font
          end
        }
      }
    },
    Checkbox = {
      on = {
        base = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          fill = function()
            return 'line'
          end
        },
        check = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          fill = function()
            return 'fill'
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          font = function()
            return _with_0.font
          end
        }
      },
      off = {
        base = {
          color = function()
            return RGBA(_with_0.color.primary)
          end,
          fill = function()
            return 'line'
          end
        },
        check = {
          color = function()
            return RGBA('#0000')
          end,
          fill = function()
            return 'fill'
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          font = function()
            return _with_0.font
          end
        }
      }
    },
    Text = {
      color = function()
        return RGBA(_with_0.color.accent)
      end,
      font = function()
        return _with_0.font
      end
    },
    TextBox = {
      base = {
        color = function()
          return RGBA(_with_0.color.primary)
        end,
        fill = function()
          return _with_0.color.fill
        end
      },
      text = {
        color = function()
          return RGBA(_with_0.color.accent)
        end,
        font = function()
          return _with_0.font
        end
      }
    },
    TextBoxScrollable = {
      on = {
        base = {
          color = function()
            return RGBA(_with_0.color.primary)
          end,
          fill = function()
            return _with_0.color.fill
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          font = function()
            return _with_0.font
          end
        }
      },
      off = {
        base = {
          color = function()
            return RGBA(_with_0.color.secondary)
          end,
          fill = function()
            return _with_0.color.fill
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          font = function()
            return _with_0.font
          end
        }
      }
    },
    TextInput = {
      on = {
        base = {
          color = function()
            return RGBA(_with_0.color.primary)
          end,
          fill = function()
            return _with_0.color.fill
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          font = function()
            return _with_0.font
          end
        }
      },
      off = {
        base = {
          color = function()
            return RGBA(_with_0.color.primary)
          end,
          fill = function()
            return _with_0.color.fill
          end
        },
        text = {
          color = function()
            return RGBA(_with_0.color.accent)
          end,
          font = function()
            return _with_0.font
          end
        }
      }
    }
  }))
  theme = _with_0
end
return {
  theme = theme,
  RGBA = RGBA,
  Theme = Theme
}
