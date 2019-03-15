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

-- Table texdoc is only allowed to be global
table.insert(tests, function()
    local ok = true

    local before_req = table_keys(_ENV)
    require('texdoclib')
    local after_req = table_keys(_ENV)

    for k, _ in pairs(after_req) do
        if not before_req[k] and k ~= 'texdoc' then
            print('Added global variable: ' .. k)
            ok = false
        end
    end

    return ok
end)

-- Are all submodules sucessfully loaded?
table.insert(tests, function()
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
            print('Table "texdoc.' .. name .. '" does not exist.')
            ok = false
        end
    end

    return ok
end)

-- execute the tests
local ok = true

for _, t in ipairs(tests) do
    if not t() then
        ok = false
    end
end

if not ok then
    os.exit(1)
end
