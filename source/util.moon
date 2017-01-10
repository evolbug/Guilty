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
    
approach = (curr, goal, step) ->
    if curr+step >= goal
        return step>0 and goal or curr+step
    else
        return step<0 and goal or curr+step

themeUpdate = (t1, t2) ->
    for k, v in pairs t2
        if (type(v) == "table") and (type(t1[k] or false) == "table")
            themeUpdate t1[k], t2[k]
        else
            t1[k] = v
    return t1

{:RGBA, :approach, :themeUpdate}
