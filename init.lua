function TL(str)
    local result = str:gsub("([^%%])%%{(.+)}", function(prev, expression)
        return prev .. tostring(assert(loadstring("return " .. expression))())
    end)
      :gsub("%%%%{(.+)}", "%%{%1}")
    
    --Prevents returning excess gsub return values.
    return result
end