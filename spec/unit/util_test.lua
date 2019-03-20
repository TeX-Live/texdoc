#!/usr/bin/env texlua

-- util_test.lua: unit test for the texdoclib-util.tlu
--
-- This file public domain.

kpse.set_program_name('luatex')
local texdoc = require('texdoclib')
local M = texdoc.util

-- testing setup
local ok = true
local function printf(fmt, ...) print(fmt:format(...)) end

-- M.w32_path
do
    local test_cases = {
        -- {<arg>, <result on non-windows>, <result on windows>}
        {'foo', 'foo', 'foo'},
        {'foo/bar/baz', 'foo/bar/baz', 'foo\\bar\\baz'},
        {'foo\\bar\\baz', 'foo\\bar\\baz', 'foo\\bar\\baz'},
    }

    for _, c in ipairs(test_cases) do
        local res = M.w32_path(c[1])
        local ans = (os.type ~= 'windows') and c[2] or c[3]

        if res ~= ans then
            printf('w32_path(%q) should return %q but returns %q',
                c[1], ans, res)
            ok = false
        end
    end
end

-- M.path_parent
do
    local test_cases = {
        -- {<arg>, <result on non-windows>, <result on windows>}
        {'foo/bar', 'foo', 'foo'},
        {'foo/bar/baz', 'foo/bar', 'foo/bar'},
        {'foo\\bar', '', 'foo'},
        {'foo\\bar\\baz', '', 'foo\\bar'},
    }

    for _, c in ipairs(test_cases) do
        local res = M.path_parent(c[1]) or ''
        local ans = (os.type ~= 'windows') and c[2] or c[3]

        if res ~= ans then
            printf('path_parent(%q) should return %q but returns %q',
                c[1], ans, res)
            ok = false
        end
    end
end

-- M.parse_zip
--do
--    local test_cases = {
--        -- {<arg>, <result>}
--        {'foo.zip', 'foo'},
--        {'foo.txt', 'foo.txt'},
--    }
--
--    -- pseudo config
--    texdoc.config = {zipext_list = {'zip', 'gz'}}
--
--    for _, c in ipairs(test_cases) do
--        local res = M.parse_zip(c[1])
--
--        if res ~= c[2] then
--            printf('parse_zip(%q) should return %q but returns %q',
--                c[1], c[2], res)
--            ok = false
--        end
--    end
--end

if not ok then
    os.exit(1)
end
