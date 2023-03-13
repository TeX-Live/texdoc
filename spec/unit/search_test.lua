#!/usr/bin/env texlua

-- search_test.lua: unit test for the texdoclib-search.tlu
--
-- This file public domain.

kpse.set_program_name(arg[-1], 'texdoc')
local texdoc = require('texdoclib')
local M = texdoc.search

-- testing setup
local ok = true
local function printf(fmt, ...) print(fmt:format(...)) end

-- M.levenshtein
do
    local test_cases = {
        -- {<string1>, <string2>, <distance>}
        {'foo', 'foo', 0},
        {'foo', 'bar', 3},
        {'foo', 'fooo', 1},
        {'foo', 'foaox', 2},
    }

    for _, c in ipairs(test_cases) do
        local res = M.levenshtein(c[1], c[2])

        if res ~= c[3] then
            printf('Levenshtein(%q, %q) should be %d but got %d',
                c[1], c[2], c[3], res)
            ok = false
        end
    end
end

if not ok then
    os.exit(1)
end
