local TL, mt

mt = { __index = _G }

---Allows you to treat a string as something akin to a Javascript template literal,
---or python's fstrings. Passing in a string to the function will parse anything in
---between brackets prepended by a percent sign. So, for example, `%{5 + 5}` becomes
---10. As the result needs to be placed in a string, values will be `tostring`'d.
---The literal will also recursively iterate, so `%{"Hello " .. %{table.concat({"w","o","r","l","d"}, "")}}`
---first changes the `table.concat({"w","o","r","l","d"}, "")` into `world`, then
---and then "Hello " and "world" are concatenated together.
---
---If the string contains `%%{5 + 5}`, then the template will remove the escaping
---percent sign and return as is without evaluating. However, a second, stacked
---template *will* be evaluated. So for example, `%%{5 + 5}` will return `%{5 + 5}`,
---but `%%{5 + 5 == %{5 + 5}}` will return `%{5 + 5 == 10}.`
---@param str string The string template to evaluate.
---@param env? table An optional key/value pair table to pass in upvalues.
---@return string
---@nodiscard
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

return TL