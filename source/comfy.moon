[[  evolbug 2016-2017, MIT license

Comfy, a lightweight component framework
]]
class Component
    new: =>
        @__component__ = true
        @children = {}
        @parent = nil
    
    @__inherited: (child) =>
        print child.__name, 'inherited', @@__name

    attach: (...) =>
        args = not (...).__component__ and ... or {...}
        for comp in *args do @children[#@children+1] = comp
        for comp in *args do comp.parent = self
        return unpack args

    detach: (child) =>
        table.remove @children, i for i,c in ipairs @children when c==child

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
