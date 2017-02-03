--  evolbug 2016-2017, MIT license
--  Comfy, a lightweight component framework

class Receiver
    -- event receiver

    new: (event, callback) =>
        @parent = nil
        @ev = event
        @fn = callback

    event: (...) =>
        -- if receives a registered event, callback with data

        if ... == @ev
            self.fn(@parent)
        else
            if type(...) == 'table'
                for k, v in pairs(...)
                    if k == @ev then self.fn @parent, unpack v

class Component
    -- base component
    -- inherit this to use the component framework
    new: =>
        @children = {}
        @parent = nil

    attach: (...) =>
        -- attach components to self

        args = not (...).__class == Component and ... or {...}
        for comp in *args
            table.insert @children, comp
            comp.parent = self
        return unpack args

    detach: (child) =>
        -- detach child component from self

        table.remove @children, i for i,c in ipairs @children when c == child

    event: (events) =>
        -- falling event propagation
        -- event propagates from parent to children

        child\event events for child in *@children

    bubble: (...) =>
        -- bubble event propagation
        -- event is pushed down and propagates from the deepest branch up

        for child in *@children
            if child.__class != Receiver
                child\bubble ...

        for child in *@children
            if child.__class == Receiver
                child\event ...

    rise: (...) =>
        -- rising event propagation
        -- event is pushed upwards to all parents

        if @parent
            for child in *@parent.children
                if child.__class == Receiver
                    child\event ...
            @parent\rise ...



{ :Component, :Receiver }
