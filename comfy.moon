[[  evolbug 2016-2017, MIT license

Comfy, a lightweight component framework
]]
class Component
    new: =>
        @__component__ = true
        @children = {}
        @parent = nil

    attach: (...) =>
        args = not (...).__component__ and ... or {...}
        @children[#@children+1] = comp for comp in *args
        comp.parent = self for comp in *args
        return unpack args

    event: (events) => for child in *@children do child\event events

class Receiver extends Component
    new: (event, callback) =>
        super!
        @ev = event
        @fn = callback
    
    event: (...) =>
        if ... == @ev
            self.fn(@parent)
        else
            if type(...) == 'table'
                for k, v in pairs(...)
                    if k == @ev then self.fn @parent, unpack v


{ :Component, :Receiver }
