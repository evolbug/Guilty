#!/usr/local/bin/moon
--    requires moonscript, and 7-Zip in PATH

moonc = (files) ->
    for outf, inf in pairs files
        e, v = os.execute "moonc -o #{outf} #{inf}"
        if e == nil
            print 'failed to compile '..inf
            error v

package = (targets) ->
    for dir, package in pairs targets
        os.execute "7z a #{package}.zip #{dir}/* >/dev/null"
        os.execute "mv #{package}.zip #{package}.love"

run = (love) ->
    os.execute "echo Running...; love #{love}.love; echo Done."

-- compile
moonc
    'dist/theme.lua': 'src/theme.moon'
    'dist/comfy.lua': 'src/comfy.moon'
    'dist/guilty.lua': 'src/guilty.moon'
    'dist/util.lua': 'src/util.moon'
    'dist/main.lua': 'src/main.moon'

-- package
package
    './dist': 'Guilty'

-- run
run 'Guilty'
