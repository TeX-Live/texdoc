#!/usr/bin/env texlua

-- score_test.lua: unit test for the texdoclib-score.tlu
--
-- This file public domain.

kpse.set_program_name(arg[-1], 'texdoc')
local texdoc = require('texdoclib')
local M = texdoc.score

-- testing setup
local ok = true
local function printf(fmt, ...) print(fmt:format(...)) end

-- pseudo config
local pseudo_config = {
    {'ext_list', 'pdf,txt,', '-x'},
}
texdoc.config.setup_config_and_alias(pseudo_config)

-- M.confline_to_score
do
    local test_cases = {
        -- {<directive>, <result>}
        {'adjscore foo = +10', true},
        {'adjscore bar = -2', true},
        {'adjscore baz  =7', true},
        {'adjscore foobar = *2', false},
        {'adjscore(foo) foofoo = 2', true},
        {'adjscore (bar) barbar = -1', false},
    }

    for _, c in ipairs(test_cases) do
        local res = M.confline_to_score(c[1])

        if res ~= c[2] then
            printf('confline_to_score(%q) should return %s but got %s',
                c[1], c[2], res)
            ok = false
        end
    end
end

-- M.is_exact
do
    local test_cases = {
        -- {<filename>, <pattern>, <result>}
        {'foo', 'foo', true},
        {'foofoo.pdf', 'foofoo.pdf', true},
        {'foo-en.pdf', 'foo-en.pdf', true},
        {'foo-en.pdf', 'bar-en.pdf', false},
        {'baz-en.pdf', 'baz-ja.pdf', false},
        {'barbar.pdf', 'barbar.txt', false},
        {'foo/bar.pdf', 'bar.pdf', true},
    }

    for _, c in ipairs(test_cases) do
        local res = M.is_exact(c[1], c[2])

        if res ~= c[3] then
            printf('is_exact(%q, %q) should return %s but got %s',
                c[1], c[2], c[3], res)
            ok = false
        end
    end
end

-- M.ext_pos
do
    local test_cases = {
        -- {<filename>, <result>}
        {'foo.pdf', 1},
        {'bar.txt', 2},
        {'baz', 3},
        {'foobar.baz', 4},
    }

    for _, c in ipairs(test_cases) do
        local res = M.ext_pos(c[1])

        if res ~= c[2] then
            printf('ext_pos(%q) should return %d but got %d',
                c[1], c[2], res)
            ok = false
        end
    end
end

if not ok then
    os.exit(1)
end
