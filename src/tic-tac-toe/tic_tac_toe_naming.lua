function naming (id) 
  if id % 2 == 0 then
    return 'x' 
  else
    return 'o'
  end
end

SERVER.naming = naming 
