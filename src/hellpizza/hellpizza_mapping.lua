main = {}
sec = {}

MARS.onConnect = function (p)
  local interfaces = p:getInterfaces()
  local isMain = false 
  local isSec = false
  
  for i in pairs (interfaces) do
    if i == 'MAIN' then
      isMain = true
      table.insert (main, p)
    elseif i == 'SECONDARY' then
      isSec = true
      table.insert (sec, p)
    end
  end

  if isMain then
    for _, sec in ipairs (sec) do
      map (p,   'INTERACTIVITY', sec, 'SHOW_OPTIONS')
      map (sec, 'FINAL_',        p,   'USER_CHOICE')
    end
  end

  if isSec then
    for _, main in ipairs (main) do
      map (main, 'INTERACTIVITY', p,    'SHOW_OPTIONS')
      map (p,    'FINAL_',        main, 'USER_CHOICE')
    end
  end
end
