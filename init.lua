function TL(str)
    local result = str:gsub("([^%%])%%%b{}", function(prev, expression)
        if prev == "%" then
            return prev .. TL(expression)
        end

        expression = expression:sub(2, -2)
        expression = assert(loadstring("return " .. TL(expression)))

        return tostring(expression())
    end)
    
    --Prevents returning excess gsub return values.
    return result
end