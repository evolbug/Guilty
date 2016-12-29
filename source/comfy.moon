[[  evolbug 2016-2017, MIT license

Comfy, a lightweight component framework
]]

class Receiver
    new: (event, callback) =>
        @__component__ = true
        @parent = nil
        @ev = event
        @fn = callback

    event: (...) =>
        if ... == @ev
            self.fn(@parent)
        else
            if type(...) == 'table'
                for k, v in pairs(...)
                    if k == @ev then self.fn @parent, unpack v

class Component
    new: =>
        @__component__ = true
        @children = {}
        @parent = nil
    
    attach: (...) =>
        args = not (...).__component__ and ... or {...}
        for comp in *args
            table.insert @children, comp
            comp.parent = self
        return unpack args

    detach: (child) =>
        table.remove @children, i for i,c in ipairs @children when c==child

    event: (events) =>
        for child in *@children
            child\event events

    bubble: (...) =>
        for child in *@children
            if child.__class != Receiver
                child\bubble ...

        for child in *@children
            if child.__class == Receiver
                child\event ...


{ :Component, :Receiver }
