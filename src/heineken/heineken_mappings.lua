tvs = {}
tablets = {}

function link_peers (tv, tablet)
  map (tv,     'END_',     tablet, 'KILL_APP')
  map (tv,     'QUESTION', tablet, 'SHOW_OPTIONS')
  map (tablet, 'CHOICE',   tv,     'CHOSEN_OPTION')
  map (tablet, 'ACCEPT',   tv,     'ACCEPTED_')
end

MARS.onConnect = function (p)
  local isTV, isTablet = false, false
  local interfaces = p:getInterfaces()

  for i,_ in pairs (interfaces) do
    print (i)
    print (i == 'TV')
    print (i == 'TABLET')
    if i == 'TV' then
      table.insert (tvs, p)
      isTV = true
    elseif i == 'TABLET' then
      table.insert (tablets, p)
      isTablet = true
    end
  end

  if isTV then
    print ('isTV')
    for _, tablet in ipairs (tablets) do
      link_peers (p, tablet)
    end
  end

  if isTablet then
    print ('isTablet')
    for _, tv in ipairs (tvs) do
      link_peers (tv, p)
    end
  end
end
