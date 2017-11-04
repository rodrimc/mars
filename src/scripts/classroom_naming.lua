index = 0

function names_mapping (id) 
  if id == 1 then
    return 'TEACHER' 
  else
    local i = index
    index = index + 1
    return 'STUDENT', i
  end
end

SERVER.naming = names_mapping 
