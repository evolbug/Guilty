local dump
dump = function(table, tab)
  if tab == nil then
    tab = ''
  end
  for key, item in pairs(table) do
    if 'table' == type(item) then
      print(tab .. key .. ': --[' .. tostring(item) .. ']')
      dump(item, tab .. '  ')
    else
      print(tab .. key .. ': ' .. item)
    end
  end
end
local RGBA
RGBA = function(r, g, b, a)
  if r == nil then
    r = 1
  end
  if g == nil then
    g = 1
  end
  if b == nil then
    b = 1
  end
  if a == nil then
    a = 1
  end
  if type(r) == 'string' and r:sub(1, 1) == '#' then
    return {
      tonumber(r:sub(2, 3), 16),
      tonumber(r:sub(4, 5), 16),
      tonumber(r:sub(6, 7), 16),
      tonumber(r:sub(8, 9), 16)
    }
  end
  if #(function()
    local _accum_0 = { }
    local _len_0 = 1
    local _list_0 = {
      r,
      g,
      b,
      a
    }
    for _index_0 = 1, #_list_0 do
      local i = _list_0[_index_0]
      if i <= 1 then
        _accum_0[_len_0] = i
        _len_0 = _len_0 + 1
      end
    end
    return _accum_0
  end)() == 4 then
    return {
      r * 255,
      g * 255,
      b * 255,
      a * 255
    }
  end
  return {
    r,
    g,
    b,
    a
  }
end
local approach
approach = function(curr, goal, step)
  if curr + step >= goal then
    return step > 0 and goal or curr + step
  else
    return step < 0 and goal or curr + step
  end
end
local themeUpdate
themeUpdate = function(t1, t2)
  for k, v in pairs(t2) do
    if "table" == type(v) then
      if type(t1[k] or false) == "table" then
        themeUpdate(t1[k] or { }, t2[k] or { })
      else
        t1[k] = v
      end
    else
      t1[k] = v
    end
  end
  return t1
end
return {
  RGBA = RGBA,
  approach = approach,
  themeUpdate = themeUpdate,
  dump = dump
}
