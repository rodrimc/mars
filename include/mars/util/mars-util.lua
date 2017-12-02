--[[
    Utility functions used by the middleware
--]]

function serialize (o)
  local result = '{'
  for k,v in pairs(o) do
    local index = type(k) == 'number' and ('[' .. k .. ']') or k
    result = result .. index .. '='
    if type (v) == 'string' then
      result = result .. "'" .. v .. "',"
    elseif type(v) == 'table' then
      result = result .. serialize (v) .. ','
    else
      result = result .. tostring(v) .. ','
    end
  end
  if result:sub (-1) == ',' then
    result = result:sub (1, -2)
  end
  result = result .. '}'
  return result
end

function interfaces (T)
  MARS.__private.interfaces = type(T) == 'table' and T or nil
end

