--    automated build script for VSCode
--    requires moonscript, and 7-Zip in PATH

moonc = (outf, inf) ->
    e, v = os.execute "moonc -o #{outf} #{inf}"
    if e != 0
        print 'failed to compile'..inf
        error v

package = (ind, outf) ->
    os.execute "7z a #{outf}.zip #{ind}\\* >NUL"
    os.execute "del #{outf}.love"
    os.execute "rename #{outf}.zip #{outf}.love"

run = (love) ->
    os.execute "love #{love}.love"

src  = '.\\source\\'           --source path
dist = '.\\distribution\\'     --distro path

scomfy  = src..'comfy.moon'    --source
dcomfy  = dist..'comfy.lua'    --output

sguilty = src..'guilty3.moon'  --source
dguilty = dist..'guilty3.lua'  --output

stheme = src..'default-theme.moon' -- theme source
dtheme = dist..'default-theme.lua' -- theme compiled

sutil = src..'util.moon'       -- utility functions source
dutil = dist..'util.lua'       -- utility functions compiled

smain = src..'main.moon'       --main source
dmain = dist..'main.lua'       --main compiled

-- compile
moonc dcomfy,   scomfy
moonc dguilty,  sguilty
moonc dtheme,   stheme
moonc dutil,    sutil
moonc dmain,    smain

-- package
package dist, 'guilty'

-- run
run 'guilty'
