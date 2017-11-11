function naming (id) 
  if id % 2 == 0 then
    return 'TV' 
  else
    return 'TABLET'
  end
end

SERVER.naming = naming 
