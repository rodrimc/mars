SERVER.naming =
  function (id)
    if id % 2 ==0 then
      return "MAIN"
    else
      return "SECONDARY"
    end
  end

