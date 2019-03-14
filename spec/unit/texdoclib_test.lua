-- Test script for the texdoclib

kpse.set_program_name('luatex')
local tests = {}

local function table_keys(tab)
    local res = {}
    for k, _ in pairs(tab) do
        res[k] = true
    end
    return res
end

function check_global_env(before_req, after_req)
    local ok = true

    for k, _ in pairs(after_req) do
        if not before_req[k] and not k == 'texdoc' then
            print('Added global variable: ' .. k)
            ok = false
        end
    end

    return ok
end

function check_sub_modules(texdoc)
    local ok = true

    local names = {
        'const',
        'util',
        'alias',
        'score',
        'confutil',
        'search',
        'view',
        'cli',
    }

    for _, name in pairs(names) do
        if type(texdoc[name]) ~= 'table' then
            print('Table "' .. name .. '" does not exist.')
            ok = false
        end
    end

    return ok
end

-- execute the tests
do
    local before_req = table_keys(_ENV)
    local texdoc = require('texdoclib')
    local after_req = table_keys(_ENV)

    local ok = true
    ok = check_global_env(before_req, after_req)
    ok = check_sub_modules(texdoc)

    if ok then
        os.exit(0)
    else
        os.exit(1)
    end
end
