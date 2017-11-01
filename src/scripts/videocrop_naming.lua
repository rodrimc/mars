
function names_mapping (id) 
  if id == 1 then
    return 'LEFT' 
  else
    return 'RIGHT'
  end
end

SERVER.naming = names_mapping 
