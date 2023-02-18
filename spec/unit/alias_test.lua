#!/usr/bin/env texlua

-- alias_test.lua: unit test for the texdoclib-alias.tlu
--
-- This file public domain.

kpse.set_program_name('luatex')
local texdoc = require('texdoclib')
local M = texdoc.alias

-- testing setup
local ok = true
local function printf(fmt, ...) print(fmt:format(...)) end

-- pseudo config
texdoc.config.setup_config_and_alias({})

-- directive alias
do
    local test_cases = {
        -- {<line>, <original>, <target>, <score>}
        {'alias foo = bar', 'foo', 'bar', nil},
        {'alias(101) foo1 = bar1', 'foo1', 'bar1', 101},
    }

    for _, c in ipairs(test_cases) do
        M.confline_to_alias(c[1])
        res = M.get_patterns(c[2], false)

        if res[1].name ~= c[2] then
            printf('confline_to_alias(%q) should register %q but failed',
                c[1], c[2])
            ok = false
        end

        if res[2].name ~= c[3] then
            printf('confline_to_alias(%q) should register %q but failed',
                c[1], c[3])
            ok = false
        end

        if res[2].score ~= c[4] then
            printf('confline_to_alias(%q) should register %q with score %q but failed',
                c[1], c[3], c[4])
            ok = false
        end
    end
end

-- directive stopalias
do
    M.confline_to_alias('stopalias baz')
    res = M.get_patterns('baz')

    if res.stop ~= true then
        printf('confline_to_alias("stopalias baz") should stop alias baz but failed')
    end
end

if not ok then
    os.exit(1)
end

