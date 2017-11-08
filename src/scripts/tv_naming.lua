function naming (id) 
  if id % 2 == 1 then
    return 'TV' 
  else
    return 'CONTROL'
  end
end

SERVER.naming = naming 
