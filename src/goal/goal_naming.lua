SERVER.naming = 
  function (id) 
    if id % 2 == 0 then
      return "SHOOTER"
    else
      return "GOALKEEPER"
    end
  end
  
