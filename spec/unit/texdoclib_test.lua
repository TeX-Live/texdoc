#!/usr/bin/env texlua

-- texdoclib_test.lua: unit test for the entire behavior of texdoclib
--
-- This file public domain.

kpse.set_program_name('luatex')

-- testing setup
local ok = true
local function printf(fmt, ...) print(fmt:format(...)) end

-- Table texdoc is only allowed to be global
do
    local function table_keys(tab)
        local res = {}
        for k, _ in pairs(tab) do
            res[k] = true
        end
        return res
    end

    local before_req = table_keys(_ENV)
    local texdoc = require('texdoclib')
    local after_req = table_keys(_ENV)

    for k, _ in pairs(after_req) do
        if not before_req[k] then
            print('Added global variable: ' .. k)
            ok = false
        end
    end
end

-- load texdoclib for tests bellow
local texdoc = require('texdoclib')

-- Are all submodules sucessfully loaded?
do
    local names = {
        'const',
        'util',
        'alias',
        'score',
        'config',
        'search',
        'view',
        'cli',
    }

    for _, name in pairs(names) do
        if type(texdoc[name]) ~= 'table' then
            printf('Table "texdoc.%s" does not exist.', name)
            ok = false
        end
    end
end

if not ok then
    os.exit(1)
end
