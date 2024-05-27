local mt = { __index = _G }

function TL(str, env, recursive)
    env = env or {}
    
    setmetatable(env, mt)

    local result = str:gsub("(%%?)%%(%b{})", function(prev, expression)
        if prev == "%" then
            return prev .. TL(expression, env)
        end

        expression = expression:sub(2, -2)
        expression = assert(loadstring("return " .. TL(expression, env, true)))
        
        setfenv(expression, env)
        
        if recursive then
            local id = "_"

            for i = 1, 5, 1 do
                id = id .. string.char(math.random() > 0.5 and math.random(65, 90) or math.random(97, 122))
            end

            env[id] = expression()

            return id
        end

        return tostring(expression())
    end)
    
    --Prevents returning excess gsub return values.
    return result
end