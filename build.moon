#!/bin/moon
-- evolbug 2016-2017, MIT license
-- Guilty build and test script
-- requires moonscript, and 7-Zip in PATH


fsrc = './src'
fdst = './dist'

pacname = 'Guilty'


make_filelist = (directory) ->
    [filename for filename in io.popen("ls -A '#{directory}'")\lines!]

moonc = (files) ->
    assert os.execute "moonc -o #{outf} #{inf}" for outf, inf in pairs files

package = (targets) ->
    for dir, package in pairs targets
        assert os.execute "7z a #{package}.zip #{dir}/* >/dev/null"
        os.execute "mv #{package}.zip #{package}.love"

run = (love) ->
    os.execute "echo Running...; love #{love}.love; echo Done."

make_buildlist = (filelist) ->
    buildlist = {}

    for file in *filelist
        fname = file\sub 0, file\find('.', 0, true)-1 -- get filename
        buildlist["#{fdst}/guilty/#{fname}.lua"] = "#{fsrc}/#{fname}.moon"

    buildlist



moonc make_buildlist make_filelist fsrc
package [fdst]: pacname
run pacname
